import subprocess
from fastapi import FastAPI, BackgroundTasks
from pydantic import BaseModel

app = FastAPI(title="Strix Security Agent API")

class ScanRequest(BaseModel):
    target_url: str

def run_strix_scan(target_url: str):
    # Executes Strix CLI scan in background
    cmd = ["python", "-m", "strix", "--target", target_url]
    subprocess.run(cmd)

@app.get("/")
def health_check():
    return {"status": "strix_agent_active"}

@app.post("/api/v1/scan")
def start_scan(request: ScanRequest, background_tasks: BackgroundTasks):
    background_tasks.add_task(run_strix_scan, request.target_url)
    return {
        "status": "initiated",
        "target": request.target_url,
        "message": "Strix security scan started in background"
    }