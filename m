From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: 2.6.38 defragment compression oops...
Date: Thu, 24 Mar 2011 17:00:34 +0800
Message-ID: <AANLkTin5EKNYUVwUMO+PoJyuEBVxubUuAHfu-ue4w+7n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I found that I'm able to provoke undefined behaviour with 2.6.38 with
extent defragmenting + recompression, eg:

mkfs.btrfs /dev/sdb
mount /dev/sdb /mnt
cp -xa / /mnt
find /mnt -print0 | xargs -0 btrfs filesystem defragment -vc

After a short time, I was seeing what looked like a secondary effect
[1]. Reproducing with lock instrumentation reported recursive spinlock
acquisition, probably a false-positive from the locking scheme not
being annotated, so better report it now.

Daniel

--- [1]

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffffa00e23cb>] write_extent_buffer+0xbb/0x1b0 [btrfs]
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:06:04.0/local_cpus
CPU 1
Modules linked in: microcode psmouse serio_raw ioatdma i7core_edac
joydev lp edac_core dca parport raid10 raid456 async_raid6_recov
async_pq usbhid hid raid6_pq async_xor xor async_memcpy async_tx raid1
raid0 multipath linear ahci btrfs zlib_deflate libahci e1000e
libcrc32c

Pid: 1119, comm: btrfs-delalloc- Tainted: G        W
2.6.38-020638-generic #201103151303 Supermicro X8STi/X8STi
RIP: 0010:[<ffffffffa00e23cb>]  [<ffffffffa00e23cb>]
write_extent_buffer+0xbb/0x1b0 [btrfs]
RSP: 0018:ffff880303a0bbc0  EFLAGS: 00010a86
RAX: db74000000000000 RBX: 0000000000000d26 RCX: ffff880000000000
RDX: 0000000000000000 RSI: 000000000002fa19 RDI: ffff88023c8353f8
RBP: ffff880303a0bc00 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000017 R12: db73880000000000
R13: 000000000000028c R14: ffff880303a0bfd8 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8800df480000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001a03000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-delalloc- (pid: 1119, threadinfo ffff880303a0a000, task
ffff8803046cad80)
Stack:
 ffff880280e63cc0 ffff8802fd10ad26 0000000000000001 ffff880303a0a000
 ffffea000a75ba30 0000000000000fb2 00000000000008f7 00000000000002da
 ffff880303a0bcb0 ffffffffa00c5bb0 0000002e00000001 0000000000000000
Call Trace:
 [<ffffffffa00c5bb0>] insert_inline_extent+0x330/0x350 [btrfs]
 [<ffffffffa00c5cf6>] cow_file_range_inline+0x126/0x160 [btrfs]
 [<ffffffffa00c68f0>] compress_file_range+0x3b0/0x580 [btrfs]
 [<ffffffffa00c6af5>] async_cow_start+0x35/0x50 [btrfs]
 [<ffffffffa00eac0c>] worker_loop+0xac/0x260 [btrfs]
 [<ffffffffa00eab60>] ? worker_loop+0x0/0x260 [btrfs]
 [<ffffffff81086317>] kthread+0x97/0xa0
 [<ffffffff8100ce24>] kernel_thread_helper+0x4/0x10
 [<ffffffff81086280>] ? kthread+0x0/0xa0
 [<ffffffff8100ce20>] ? kernel_thread_helper+0x0/0x10
Code: 16 00 00 48 8d 04 0a 48 b9 b7 6d db b6 6d db b6 6d 48 c1 f8 03
48 0f af c1 48 b9 00 00 00 00 00 88 ff ff 48 c1 e0 0c 4c 8d 24 08 <48>
8b 02 a8 08 0f 85 9c 00 00 00 be cb 0e 00 00 48 c7 c7 b8 7c
RIP  [<ffffffffa00e23cb>] write_extent_buffer+0xbb/0x1b0 [btrfs]
 RSP <ffff880303a0bbc0>
CR2: 0000000000000000
---[ end trace a7919e7f17c0a728 ]---
note: btrfs-delalloc-exited with preempt_count 1
-- 
Daniel J Blueman
