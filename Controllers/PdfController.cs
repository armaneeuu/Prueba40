using Microsoft.AspNetCore.Mvc;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

public class PdfController : Controller
{
    public IActionResult Index()
    {
        return View();
    }
    public IActionResult GeneratePdf()
    {
        var pdfDocument = Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(PageSizes.A4);
                page.Margin(2, Unit.Centimetre);
                page.Content().Column(column =>
                {
                    column.Item().Text("Reporte PDF").FontSize(24).Bold();
                    column.Item().Text("Generado usando QuestPDF en un proyecto .NET 8 MVC.");
                    column.Item().Text("Ejemplo de contenido en el PDF.");
                });
            });
        });

        byte[] pdfBytes = pdfDocument.GeneratePdf();
        
        return File(pdfBytes, "application/pdf", "Reporte.pdf");
    }
}
