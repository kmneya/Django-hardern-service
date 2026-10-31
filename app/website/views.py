from django.http import HttpResponse

def home(request):
    return HttpResponse(
        "<h1>Hardened Django Service</h1>"
        "<p>Public interface. Admin login available at a non-default URL.</p>"
    )