From: Jonathan Thackray <jthackray@gmail.com>
Subject: btrfs oops in write_all_supers+0x294/0x2b4 [btrfs]
Date: Tue, 15 Jun 2010 11:18:19 +0100
Message-ID: <20100615101819.GA7869@thackray.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been running btrfs fine on my Sheevaplug (ARMv5) for a few months.
However, last night, using kernel 2.6.34, I got repeated reboots, with
many traces like this in the logs:

   Jun 15 07:45:49 moley kernel: CPU: 0    Not tainted  (2.6.34 #3)
   Jun 15 07:45:49 moley kernel: PC is at __bug+0x18/0x24
   Jun 15 07:45:49 moley kernel: LR is at __bug+0x14/0x24
   Jun 15 07:45:49 moley kernel: pc : [<c002e6dc>]    lr : [<c002e6d8>]    psr: 60000013
   Jun 15 07:45:49 moley kernel: sp : ded6bec0  ip : 00000000  fp : 00000000
   Jun 15 07:45:49 moley kernel: r10: df5d5ad0  r9 : 00000000  r8 : df640800
   Jun 15 07:45:49 moley kernel: r7 : df6fac17  r6 : 00000000  r5 : 00000001  r4 : df5d5ad0
   Jun 15 07:45:49 moley kernel: r3 : 00000000  r2 : ded6beb4  r1 : c047a1ed  r0 : 0000002d
   Jun 15 07:45:49 moley kernel: Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
   Jun 15 07:45:49 moley kernel: Control: 0005397f  Table: 1e068000  DAC: 00000015
   Jun 15 07:45:49 moley kernel: [<c002e6dc>] (__bug+0x18/0x24) from [<bf0773b0>] (write_all_supers+0x294/0x2b4 [btrfs])
   Jun 15 07:45:49 moley kernel: [<bf0773b0>] (write_all_supers+0x294/0x2b4 [btrfs]) from [<bf07a5e8>] (btrfs_commit_transaction+0x508/0x610 [btrfs])
   Jun 15 07:45:49 moley kernel: [<bf07a5e8>] (btrfs_commit_transaction+0x508/0x610 [btrfs]) from [<c00c72ec>] (__sync_filesystem+0x80/0x9c)
   Jun 15 07:45:49 moley kernel: [<c00c72ec>] (__sync_filesystem+0x80/0x9c) from [<c00c73d8>] (sync_filesystems+0xd0/0x140)
   Jun 15 07:45:49 moley kernel: [<c00c73d8>] (sync_filesystems+0xd0/0x140) from [<c00c7494>] (sys_sync+0x1c/0x3c)
   Jun 15 07:45:49 moley kernel: [<c00c7494>] (sys_sync+0x1c/0x3c) from [<c002b9c0>] (ret_fast_syscall+0x0/0x2c)
   Jun 15 07:45:49 moley kernel: sd 3:0:0:0: [sdd] 15954944 512-byte logical blocks: (8.16 GB/7.60 GiB)
   Jun 15 07:45:49 moley kernel: sd 3:0:0:0: [sdd] Write Protect is off
   Jun 15 07:45:49 moley kernel:  sdd: sdd1
   Jun 15 07:45:49 moley kernel: sd 3:0:0:0: [sdd] Attached SCSI removable disk
   Jun 15 07:45:49 moley kernel: ---[ end trace e30bc455245b7708 ]---
   Jun 15 07:57:16 moley syslogd 1.5.0#5ubuntu3: restart.

uname -a gives:

   Linux moley 2.6.34 #3 PREEMPT Mon May 17 02:15:53 MDT 2010 armv5tel GNU/Linux

and I'm using the stock kernel from here:

   http://sheeva.with-linux.com/sheeva/2.6.34/

Not sure if this has been fixed in the recent 2.6.35 changes,
but I thought I'd report it anyway. Let me know if you want me
to run any btrfs commands for more debug information.

Many thanks,
Jonathan.
