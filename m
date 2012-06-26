Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2FZUJ0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 16:09:26 -0400
Message-ID: <1340741359.2226.5.camel@athena>
Subject: btrfs oops with kernel 3.5-rc4
From: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
To: linux-btrfs@vger.kernel.org
Date: Tue, 26 Jun 2012 16:09:19 -0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oops with kernel v3.5-rc4.  This error produced while:

emerge --sync &&  emerge --update --newuse --deep --with-bdeps=y @world && emerge --depclean && revdep-rebuild
and 
stress --cpu 1 --io 8 -d 8  --vm 4  -t 8h

ver_linux.sh was ran on stable v3.4.4 system.  

Linux peach.example.com 3.4.4 #2 SMP Sun Jun 24 20:38:42 EDT 2012 i686
Intel(R) Pentium(R) 4 CPU 2.80GHz GenuineIntel GNU/Linux

 Gnu C                  4.5.3
 Gnu make               3.82
 binutils               2.21.1
 util-linux             ./ver_linux: line 23: fdformat: command not found
 mount                  support
 module-init-tools      found
 quota-tools            3.17.
 Linux C Library        2.14.1
 Dynamic linker (ldd)   2.14.1
 Procps                 3.2.8
 Kbd                    1.15.3wip
 Sh-utils               8.14
 Modules Loaded         ext3 jbd ehci_hcd

---- Oops ----


Jun 25 21:49:35 peach klogd: [15110.648485] BUG: unable to handle kernel paging request at fffffedc
Jun 25 21:49:35 peach klogd: [15110.648527] IP: [<c1234292>] btrfs_finish_ordered_io+0x22/0x470
Jun 25 21:49:35 peach klogd: [15110.648545] *pde = 018b0067 *pte = 00000000
Jun 25 21:49:35 peach klogd: [15110.648558] Oops: 0000 [#1] SMP
Jun 25 21:49:35 peach klogd: [15110.648571] Modules linked in: ext3 jbd ehci_hcd
Jun 25 21:49:35 peach klogd: [15110.648584]
Jun 25 21:49:35 peach klogd: [15110.648596] Pid: 28814, comm: btrfs-endio-wri Not tainted 3.5.0-rc4 #3 HP Pavilion 061 DM170A-ABA A350N/'P4SD-LA'
Jun 25 21:49:35 peach klogd: [15110.648618] EIP: 0060:[<c1234292>] EFLAGS: 00010293 CPU: 1
Jun 25 21:49:35 peach klogd: [15110.648633] EIP is at btrfs_finish_ordered_io+0x22/0x470
Jun 25 21:49:35 peach klogd: [15110.648646] EAX: fffffedc EBX: f027ce40 ECX: f027ceb4 EDX: 00000000
Jun 25 21:49:35 peach klogd: [15110.648661] ESI: f027cea0 EDI: db42624c EBP: db42626c ESP: f057ff08
Jun 25 21:49:35 peach klogd: [15110.648676]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jun 25 21:49:35 peach klogd: [15110.648690] CR0: 8005003b CR2: fffffedc CR3: 0458b000 CR4: 000007d0
Jun 25 21:49:35 peach klogd: [15110.648706] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jun 25 21:49:35 peach klogd: [15110.648721] DR6: ffff0ff0 DR7: 00000400
Jun 25 21:49:35 peach klogd: [15110.648733] Process btrfs-endio-wri (pid: 28814, ti=f057e000 task=ca0bf2a0 task.ti=f057e000)
Jun 25 21:49:35 peach klogd: [15110.648750] Stack:
Jun 25 21:49:35 peach klogd: [15110.648764]  f057ff3c 00000286 c103a54c 00000286 f057ff3c 00e1fe18 f057ff3c c103a5b1
Jun 25 21:49:35 peach klogd: [15110.648787]  f7078000 c164c7b4 00000000 00000001 00000000 00000000 00200200 00e3d2d8
Jun 25 21:49:35 peach klogd: [15110.648810]  fffffedc c10399a0 010bf2a0 ffffffff 00000286 db426240 f027cea0 db42624c
Jun 25 21:49:35 peach klogd: [15110.648826] Call Trace: Jun 25 21:49:35 peach klogd: [15110.648841]  [<c103a54c>] ?  try_to_del_timer_sync+0x5c/0xa0
Jun 25 21:49:35 peach klogd: [15110.648857]  [<c103a5b1>] ?  del_timer_sync+0x21/0x40
Jun 25 21:49:35 peach klogd: [15110.648874]  [<c164c7b4>] ?  schedule_timeout+0x124/0x220
Jun 25 21:49:35 peach klogd: [15110.648890]  [<c10399a0>] ? cascade+0x70/0x70
Jun 25 21:49:35 peach klogd: [15110.648904]  [<c12641ce>] ?  worker_loop+0x7e/0x440
Jun 25 21:49:35 peach klogd: [15110.648921]  [<c1264150>] ?  btrfs_queue_worker+0x2b0/0x2b0
Jun 25 21:49:35 peach klogd: [15110.648937]  [<c104984c>] ? kthread+0x7c/0x90
Jun 25 21:49:35 peach klogd: [15110.648950]  [<c10497d0>] ?  kthread_worker_fn+0x100/0x100
Jun 25 21:49:35 peach klogd: [15110.648966]  [<c164f5b6>] ?  kernel_thread_helper+0x6/0xd
Jun 25 21:49:35 peach klogd: [15110.649032] Code: ff ff 8d b4 26 00 00 00 00 55 57 56 53 89 c3 83 ec 54 8b 40 34 c6 44 24 4b 01 89 44 24 30 8b 54 24 30 2d 24 01 00 00 89 44 24 40 <8b> b2 dc fe ff ff 81 ea 04 01 00 00 89 54 24 4c c7 44 24 50 00
Jun 25 21:49:35 peach klogd: [15110.649087] EIP: [<c1234292>] btrfs_finish_ordered_io+0x22/0x470 SS:ESP 0068:f057ff08
Jun 25 21:49:35 peach klogd: [15110.649121] CR2: 00000000fffffedc
Jun 25 21:49:35 peach klogd: [15110.649169] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 0)
Jun 25 21:49:35 peach klogd: [15110.666447] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga encoder (output 0)
Jun 25 21:49:35 peach klogd: [15110.666447] [drm] nouveau 0000:01:00.0: Output VGA-1 is running on CRTC 0 using output A
Jun 25 21:49:35 peach klogd: [15110.666447] ---[ end trace 676eca54f3265f4d ]---
Jun 25 21:57:58 peach klogd: [15614.172223] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 0)
Jun 25 22:51:57 peach klogd: klogd 1.4.1, log source = /proc/kmsg started.
Jun 25 22:51:57 peach klogd: Cannot find map file.

                                                                 

