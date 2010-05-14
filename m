From: Martin Bueger <mbuerger@edu.uni-klu.ac.at>
Subject: Bug when resizing FS
Date: Fri, 14 May 2010 18:23:44 +0200
Message-ID: <201005141823.44910.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

when I try to resize the FS with btrfsctl -r it works using + or -, hence, 
extending or shrinking the FS but when I want to set it to a certain size I 
always hit the follwing bug:

------------[ cut here ]------------
        
invalid opcode: 0000 [#1] SMP
last sysfs file: 
/sys/devices/pci0000:00/0000:00:10.0/host2/target2:0:1/2:0:1:0/block/sdb/size
Modules linked in: sr_mod i2c_piix4 cdrom processor container thermal ac 
button i2c_core

Pid: 4044, comm: btrfs-delalloc- Not tainted 2.6.33-zen2 #1 440BX Desktop 
Reference Platform/VMware Virtual Platform
EIP: 0060:[<c12545a8>] EFLAGS: 00010286 CPU: 0
EIP is at cow_file_range+0x638/0x650
EAX: ffffffe4 EBX: 1b5cb000 ECX: 00003d3d EDX: 00000001
ESI: 00000000 EDI: 00000000 EBP: cd22a034 ESP: caa4de40
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process btrfs-delalloc- (pid: 4044, ti=caa4c000 task=de0d0b10 
task.ti=caa4c000)
Stack:
 00001000 00000000 00001000 00000000 00000000 00000000 1b5cb000 00000000
<0> ffffffff ffffffff caa4debf 00000001 00000000 c1a4d1a0 cd22a12c 00001000
<0> cd22a038 de032800 cb25a180 00001000 00000000 caa4dea8 00000000 00001000
Call Trace:
 [<c12bbe1a>] ? __prop_inc_single+0x3a/0x50
 [<c1255580>] ? submit_compressed_extents+0x260/0x4f0
 [<c127b10e>] ? run_ordered_completions+0x5e/0xb0
 [<c127b85b>] ? worker_loop+0x12b/0x410
 [<c127b730>] ? worker_loop+0x0/0x410
 [<c103e994>] ? kthread+0x74/0x80
 [<c103e920>] ? kthread+0x0/0x80
 [<c10030b6>] ? kernel_thread_helper+0x6/0x10
Code: 8b 94 24 b8 00 00 00 83 d6 00 0f ac f3 0c 01 1a 8b 84 24 b4 00 00 00 c7 
00 01 00 00 00 e9 23 fe ff ff 0f 0b eb fe 90 8d 74 26 00 <0f> 0b eb fe 8d 74 26 
00 31 db 31 f6 e9 a1 fb ff ff 0f 0b eb fe
EIP: [<c12545a8>] cow_file_range+0x638/0x650 SS:ESP 0068:caa4de40
---[ end trace 31b4672bb84c5cec ]---

The command I ran: btrfsctl -r 1g /mnt/point


Kind regards,
Martin
