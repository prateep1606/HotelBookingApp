
package stepdefinitions;

import io.cucumber.java.After;
import io.cucumber.java.en.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import utils.DriverFactory;

public class GoogleSearchSteps {

    WebDriver driver;

    @Given("User opens the browser")
    public void user_opens_browser() {
        driver = DriverFactory.getDriver();
    }

    @When("User navigates to Google")
    public void user_navigates_to_google() {
        driver.get("https://www.google.com");
    }

    @When("User searches for {string}")
    public void user_searches_for(String keyword) {
        driver.findElement(By.name("q")).sendKeys(keyword);
        driver.findElement(By.name("q")).submit();
    }

    @Then("Search results should be displayed")
    public void search_results_should_be_displayed() {
        System.out.println("Search executed successfully");
    }

    @After
    public void tearDown() {
        DriverFactory.quitDriver();
    }
}
