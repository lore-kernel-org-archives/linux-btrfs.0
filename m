From: Tomas Carnecky <tomas.carnecky@gmail.com>
Subject: Bug in btrfs_rename (kernel BUG at fs/btrfs/inode.c:5595!)
Date: Wed, 13 Jan 2010 20:09:17 +0100
Message-ID: <4B4E1A5D.1070203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

  I was running v2.6.33-rc2-187-g08d869a and everything was ok. Today I 
decided to update the kernel (to v2.6.33-rc4) and a minute or two after 
logging into the gnome desktop this kernel bug appeared in dmesg. I then 
went back to the old kernel but the bug didn't disappear, not even after 
running btrfsck on the filesystem.

tom

------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:5595!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
CPU 1
Pid: 2462, comm: gconfd-2 Not tainted 2.6.33-rc2-00202-g63ebcc6 #12 
776295G/776295G
RIP: 0010:[<ffffffff8132e518>]  [<ffffffff8132e518>] 
btrfs_rename+0x4c8/0x590
RSP: 0018:ffff88007a17dc78  EFLAGS: 00010282
RAX: 00000000ffffffef RBX: 0000000025fa67f8 RCX: ffff8800258b91b0
RDX: ffff880001d11c80 RSI: ffff8800258b9090 RDI: ffff8800258b9090
RBP: ffff88007a17dd38 R08: ffff880000000000 R09: 0000160000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 000000004b4e1863
R13: ffff880071086060 R14: 0000000000000000 R15: ffff88007105b300
FS:  00007f468759e700(0000) GS:ffff880001d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006d9c90 CR3: 000000007b15e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process gconfd-2 (pid: 2462, threadinfo ffff88007a17c000, task 
ffff88007c3e5840)
Stack:
  00000000000000fb ffff88007c3e5840 00000a897c3e5840 00000a8a00000a00
<0> 010000af7a17dcb8 ffff88000ba0e000 ffff880071086438 ffff88007219d000
<0> ffff88007219d000 ffff8800701d41a0 ffff8800288e2d80 ffff880071086060
Call Trace:
  [<ffffffff8112b56a>] vfs_rename+0x3da/0x420
  [<ffffffff8112d07e>] sys_renameat+0x23e/0x270
  [<ffffffff8139529b>] ? _atomic_dec_and_lock+0x6b/0x90
  [<ffffffff8113ac14>] ? mntput_no_expire+0x24/0xf0
  [<ffffffff8111f448>] ? sys_fchmodat+0x78/0x100
  [<ffffffff8112a19c>] ? path_put+0x2c/0x40
  [<ffffffff8112d0c6>] sys_rename+0x16/0x20
  [<ffffffff81035e6b>] system_call_fastpath+0x16/0x1b
Code: 00 00 48 81 c7 b8 1a 00 00 e8 85 da d6 ff e9 56 fd ff ff 49 8b 77 
10 48 8b bd 68 ff ff ff e8 80 fa ff ff 85 c0 0f 84 03 ff ff ff <0f> 0b 
eb fe 48 8b 75 80 48 8b bd 68 ff ff ff e8 24 15 01 00 e9
RIP  [<ffffffff8132e518>] btrfs_rename+0x4c8/0x590
  RSP <ffff88007a17dc78>
---[ end trace 613e6e60575556d3 ]---
