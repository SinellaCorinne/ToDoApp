from rest_framework import viewsets, permissions
from .models import Task
from .serializers import TaskSerializer

class TaskViewSet(viewsets.ModelViewSet):
    serializer_class = TaskSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # retourne uniquement les tâches de l’utilisateur connecté
        return Task.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        # associe la tâche à l’utilisateur connecté
        serializer.save(user=self.request.user)
