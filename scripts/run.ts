import { chromium } from "playwright";

async function connectToRemoteChrome() {
  try {
    console.log("Connecting to remote Chrome debugger...");

    // Connect to the Chrome instance running in Docker
    const browser = await chromium.connectOverCDP("http://localhost:9222");
    console.log("Connected successfully!");

    // Use the default context
    const context = browser.contexts()[0];

    // Get existing page or create a new one
    let page = context.pages()[0];
    if (!page) {
      console.log("Creating new page...");
      page = await context.newPage();
    } else {
      console.log("Using existing page...");
    }

    // Navigate to a website
    console.log("Navigating to example.com...");
    await page.goto("https://example.com");

    // Wait for the content to ensure page is loaded
    await page.waitForSelector("h1");

    // Get the page title
    const title = await page.title();
    console.log(`Page title: ${title}`);

    // Take a screenshot
    console.log("Taking screenshot...");
    await page.screenshot({ path: "screenshot.png" });
    console.log("Screenshot saved to screenshot.png");

    // Fill a search input on a different site
    console.log("Navigating to Wikipedia...");
    await page.goto("https://www.wikipedia.org");
    await page.waitForSelector("#searchInput");
    await page.fill("#searchInput", "Playwright automation");
    await page.click('button[type="submit"]');

    // Wait for search results
    await page.waitForLoadState("networkidle");
    console.log("Search completed!");

    // Take another screenshot
    await page.screenshot({ path: "wikipedia-search.png" });
    console.log("Search results screenshot saved to wikipedia-search.png");

    // Close the browser
    await browser.close();
    console.log("Browser closed.");
  } catch (error) {
    console.error("Error occurred:", error);
  }
}

// Run the function
connectToRemoteChrome();
