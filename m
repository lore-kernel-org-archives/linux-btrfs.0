From: Mark Rada <marada@uwaterloo.ca>
Subject: Kernel BUG?
Date: Fri, 24 Sep 2010 21:24:00 -0400
Message-ID: <7E2D587B-F58A-461C-8255-479758FE1326@mailservices.uwaterloo.ca>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've got a btrfs array that ran into some trouble today. I noticed when I found a notice in the dmesg output:

conftest[22330] trap divide error ip:400604 sp:7ffff2f1e5c8 error:0 in conftest[400000+1000]
test_6321[7033]: segfault at 0 ip 0000000000400679 sp 00007fffaf6b42e0 error 4 in test_6321[400000+1000]
bio too big device sdd1 (432 > 255)
btrfs bad tree block start 9975698740868360051 421464846336
------------[ cut here ]------------
kernel BUG at fs/btrfs/tree-log.c:3039!
invalid opcode: 0000 [#1] 
last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
CPU 0 
Modules linked in:

Pid: 26019, comm: afpd Not tainted 2.6.35-gentoo-r7-ferrous26 #1 M2A-VM/System Product Name
RIP: 0010:[<ffffffff8113ab36>]  [<ffffffff8113ab36>] 0xffffffff8113ab36
RSP: 0018:ffff88000a5d9e78  EFLAGS: 00010206
RAX: 00000000fffffffb RBX: ffff88007ad69000 RCX: dead000000200200
RDX: 000000000000001a RSI: ffff880051098f40 RDI: ffff88007da91940
RBP: ffff8800655e79c0 R08: ffff88000a5d9b18 R09: 0000000000000000
R10: ffff88007be52e28 R11: 0000000000000246 R12: ffff88001e34cd80
R13: ffff880048c1e1a0 R14: 00000000fffffffb R15: 0000000000004f49
FS:  00007f5b00a9a700(0000) GS:ffffffff813ce000(0000) knlGS:0000000055702d50
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000427830 CR3: 000000007b5ad000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process afpd (pid: 26019, threadinfo ffff88000a5d8000, task ffff88007647e7b0)
Stack:
 ffff880048c1e1a0 ffff88007ad69000 ffff880000000000 ffff88007ad691c8
<0> ffff88007cd73400 0000000081054e5c 0000000000000001 ffff88007ad69000
<0> ffff880048c1e1a0 ffff880047ef9800 ffff88005ebb50c0 0000000001c43ce0
Call Trace:
 [<ffffffff8111da55>] ? 0xffffffff8111da55
 [<ffffffff81092276>] ? 0xffffffff81092276
 [<ffffffff81092327>] ? 0xffffffff81092327
 [<ffffffff81092359>] ? 0xffffffff81092359
 [<ffffffff81002768>] ? 0xffffffff81002768
Code: 89 de 4c 89 ef e8 78 f8 ff ff 85 c0 75 0f 49 8b 44 24 28 49 39 c4 74 2f 49 89 c4 eb 9f 41 89 c6 45 85 f6 79 22 41 83 fe e4 74 04 <0f> 0b eb fe 48 8b 83 20 01 00 00 49 8b 55 00 41 be 01 00 00 00 
RIP  [<ffffffff8113ab36>] 0xffffffff8113ab36
 RSP <ffff88000a5d9e78>
---[ end trace f51e47b3ae49b500 ]---
bio too big device sdd1 (272 > 255)
bio too big device sdd1 (1024 > 255)
bio too big device sdd1 (1024 > 255)
bio too big device sdd1 (744 > 255)



Before I noticed this, I had tried to reboot the machine (but something seems to be blocking the reboot). I haven't done a hard reboot yet as I'm not sure if it would be safe.


--
Mark Rada

	