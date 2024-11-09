import pygame
import time
import csv
import sys
import tkinter as tk
from tkinter import messagebox

def start_recording():
    global recording, start_time
    recording = True
    print("音乐开始播放，记录按键时间戳。按下 Q 键结束记录并退出。")
    messagebox.showinfo("信息", "音乐开始播放，记录按键时间戳。按下 Q 键结束记录并退出。")
    pygame.mixer.music.play()
    start_time = time.time()  # 在弹窗关闭后记录开始时间

def stop_recording():
    global recording, running
    running = False
    pygame.mixer.music.stop()
    save_records()
    root.quit()

def save_records():
    csv_file = "key_records.csv"
    with open(csv_file, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["Timestamp", "Key"])
        writer.writerows(key_records)
    print(f"按键记录已保存至 {csv_file}")
    messagebox.showinfo("信息", f"按键记录已保存至 {csv_file}")

def handle_event(event):
    global recording
    if event.keysym == 'q':
        stop_recording()
    elif recording:
        current_time = time.time()
        timestamp = int((current_time - start_time) * 1000)  # 将时间戳转换为毫秒并取整
        key_name = event.keysym
        key_records.append((timestamp, key_name))
        print(f"记录：{key_name} - {timestamp} 毫秒")

# 初始化 Pygame
pygame.init()
pygame.mixer.init()

# 设置音频文件路径
audio_file = r"E:\GodotProject\project02\addin\beat\lumine.flac"
pygame.mixer.music.load(audio_file)

# 设置按键记录列表
key_records = []
recording = False
running = True

# 初始化 Tkinter
root = tk.Tk()
root.title("打谱工具")
root.geometry("400x200")

start_button = tk.Button(root, text="开始播放音乐", command=start_recording)
start_button.pack(pady=20)

# 绑定键盘事件
root.bind('<KeyPress>', handle_event)

# 运行 Tkinter 主循环
root.mainloop()

# 停止 Pygame 并退出
pygame.quit()
sys.exit()