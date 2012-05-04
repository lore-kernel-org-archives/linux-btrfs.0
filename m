From: Arne Jansen <sensille@gmx.net>
Subject: Re: btrfs scrub  BUG: unable to handle kernel NULL pointer dereference
Date: Fri, 04 May 2012 08:00:59 +0200
Message-ID: <4FA3709B.5080409@gmx.net>
References: <4FA34AD7.3000008@intellasoft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mark Murawski <markm-lists@intellasoft.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA34AD7.3000008@intellasoft.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 04.05.2012 05:19, Mark Murawski wrote:
> I think I have some failing hard drives, they are disconnected for now.
> 
> stan {~} root# btrfs filesystem show
> Label: none  uuid: d71404d4-468e-47d5-8f06-3b65fa7776aa
>         Total devices 2 FS bytes used 6.27GB
>         devid    1 size 9.31GB used 8.16GB path /dev/sde6
>         *** Some devices missing
> 
> Label: none  uuid: b142f575-df1c-4a57-8846-a43b979e2e09
>         Total devices 8 FS bytes used 1.35TB
>         devid    3 size 149.05GB used 119.01GB path /dev/sdf
>         devid    6 size 920.34GB used 408.00GB path /dev/sde7
>         devid    7 size 1.36TB used 885.00GB path /dev/sdd
>         devid    4 size 149.05GB used 119.01GB path /dev/sdc
>         devid    2 size 465.76GB used 435.00GB path /dev/sdb
>         devid    8 size 1.36TB used 885.00GB path /dev/sda
>         *** Some devices missing
> 
> 
> stan {~} root# btrfs scrub status /storage
> Killed

This is probably the same issue this patch fixes:

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16302

It is included in a recent RC.

--Arne

> 
> May  4 07:07:12 stan kernel: btrfs: allowing degraded mounts
> May  4 07:07:12 stan kernel: btrfs: disk space caching is enabled
> May  4 07:07:12 stan kernel: warning devid 5 missing
> May  4 07:07:33 stan kernel: BUG: unable to handle kernel NULL pointer
> dereference at           (null)
> May  4 07:07:33 stan kernel: IP: [<ffffffff812b21f0>] strncpy+0x10/0x30
> May  4 07:07:33 stan kernel: PGD 76a1f067 PUD 76a21067 PMD 0
> May  4 07:07:33 stan kernel: Oops: 0000 [#1] PREEMPT SMP
> May  4 07:07:33 stan kernel: CPU 0
> May  4 07:07:33 stan kernel: Modules linked in:
> May  4 07:07:33 stan kernel:
> May  4 07:07:33 stan kernel: Pid: 3283, comm: btrfs Not tainted 3.3.0 #10 To Be
> Filled By O.E.M. To Be Filled By O.E.M./A770DE+
> May  4 07:07:33 stan kernel: RIP: 0010:[<ffffffff812b21f0>] [<ffffffff812b21f0>]
> strncpy+0x10/0x30
> May  4 07:07:33 stan kernel: RSP: 0018:ffff88007d2e7e10  EFLAGS: 00010206
> May  4 07:07:33 stan kernel: RAX: ffff88007c243c00 RBX: ffff88007bef0600 RCX:
> ffff88007c243c00
> May  4 07:07:33 stan kernel: RDX: 0000000000000400 RSI: 0000000000000000 RDI:
> ffff88007c243c00
> May  4 07:07:33 stan kernel: RBP: 000000000062e920 R08: 0000000000000000 R09:
> 0000000000000000
> May  4 07:07:33 stan kernel: R10: 0000000000000000 R11: 0000000000000246 R12:
> ffff88007c243000
> May  4 07:07:33 stan kernel: R13: ffff88007b8fc7d8 R14: ffff88007c243008 R15:
> ffffffffffffffed
> May  4 07:07:33 stan kernel: FS:  00007fa9d7ac7760(0000)
> GS:ffff88007fc00000(0000) knlGS:0000000000000000
> May  4 07:07:33 stan kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> May  4 07:07:33 stan kernel: CR2: 0000000000000000 CR3: 0000000076a28000 CR4:
> 00000000000006f0
> May  4 07:07:33 stan kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> May  4 07:07:33 stan kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> May  4 07:07:33 stan kernel: Process btrfs (pid: 3283, threadinfo
> ffff88007d2e6000, task ffff88007c83d6a0)
> May  4 07:07:33 stan kernel: Stack:
> May  4 07:07:33 stan kernel: ffffffff8125c3e0 0000000738e62f87 000000000040504c
> 0000000000000028
> May  4 07:07:33 stan kernel: 0000000000000014 ffff88007bc82700 ffff88007b25a930
> ffff88007c83d6a0
> May  4 07:07:33 stan kernel: ffffffff81020eb9 00ff88007bc82760 0000000000000000
> ff00000000000000
> May  4 07:07:33 stan kernel: Call Trace:
> May  4 07:07:33 stan kernel: [<ffffffff8125c3e0>] ? btrfs_ioctl+0x1000/0x11e0
> May  4 07:07:33 stan kernel: [<ffffffff81020eb9>] ? do_page_fault+0x199/0x420
> May  4 07:07:33 stan kernel: [<ffffffff810d3cce>] ? do_vfs_ioctl+0x8e/0x4f0
> May  4 07:07:33 stan kernel: [<ffffffff810c0f6c>] ? fd_install+0x3c/0x80
> May  4 07:07:33 stan kernel: [<ffffffff810d4179>] ? sys_ioctl+0x49/0x90
> May  4 07:07:33 stan kernel: [<ffffffff816b4f22>] ? system_call_fastpath+0x16/0x1b
> May  4 07:07:33 stan kernel: Code: 0f 1f 00 0f b6 0c 16 88 0c 10 48 ff c2 84 c9
> 75 f2 f3 c3 0f 1f 84 00 00 00 00 00 48 85 d2 48 89 f8 74 1e 48 89 f9 0f 1f 44 00
> 00 <0f> b6 3e 40 80 ff 01 40 88 39 48 83 de ff 48 ff c1 48 ff ca 75
> May  4 07:07:33 stan kernel: RIP  [<ffffffff812b21f0>] strncpy+0x10/0x30
> May  4 07:07:33 stan kernel: RSP <ffff88007d2e7e10>
> May  4 07:07:33 stan kernel: CR2: 0000000000000000
> May  4 07:07:33 stan kernel: ---[ end trace 64dfc95061520f57 ]---
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

