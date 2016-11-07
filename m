Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:36269 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933476AbcKGTBw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 14:01:52 -0500
Received: by mail-lf0-f48.google.com with SMTP id t196so121965405lff.3
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Nov 2016 11:01:51 -0800 (PST)
MIME-Version: 1.0
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
Date: Mon, 7 Nov 2016 20:01:49 +0100
Message-ID: <CAC+fKQW+GQpj2FbtQpchMVZ=yC14gH_uLbn6Pf3aF=YT3Yo=KA@mail.gmail.com>
Subject: kernel BUG at fs/btrfs/delayed-inode.c
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, today I got this bug after a power failure.

One file that was being written during the power failure, appeared
after reboot as:

$ ls -la data/0/3833
?---------. 1 root root 0 ene  1  1970 data/0/3833

I decided to delete it, but I got this bug after a few seconds and the
system halted, I had to reboot it with the magic SysRq keys.

After the reboot, I saw this file as:

# ls -la
ls: no se puede acceder a '3833': No such file or directory
total 0
drwx------. 1 backup backup 4 nov  7 19:48 .
drwx------. 1 backup backup 2 nov  7 09:05 ..
-?????????? ? ?      ?      ?            ? 3833

I've already deleted the affected subvolume, and I have not detected
any more problems. Should I worry?

My versions are:

# uname -a
Linux xenon 4.8.6-300.fc25.x86_64 #1 SMP Tue Nov 1 12:36:38 UTC 2016
x86_64 x86_64 x86_64 GNU/Linux
# rpm -q btrfs-progs
btrfs-progs-4.8.2-2.fc25.x86_64

I've also reported the bug in the Fedora bugzilla:

https://bugzilla.redhat.com/show_bug.cgi?id=1392557


nov 07 19:24:43 xenon kernel: BTRFS error (device sdb7): err add
delayed dir index item(index: 50) into the deletion tree of the
delayed node(root id: 28557, inode id: 265, errno: -17)
nov 07 19:24:43 xenon kernel: ------------[ cut here ]------------
nov 07 19:24:43 xenon kernel: kernel BUG at fs/btrfs/delayed-inode.c:1561!
nov 07 19:24:43 xenon kernel: invalid opcode: 0000 [#1] SMP
nov 07 19:24:43 xenon kernel: Modules linked in: xfs libcrc32c rfcomm
fuse xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun xt_set
xt_multiport ip_set_hash_ip nf_conntrack_netbios_ns
nf_conntrack_broadcast
nov 07 19:24:43 xenon kernel:  intel_cstate intel_uncore xor
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi
intel_rapl_perf snd_hda_intel snd_hda_codec uvcvideo snd_usb_audio
snd_hda_core snd_usb
nov 07 19:24:43 xenon kernel: CPU: 0 PID: 10691 Comm: rm Not tainted
4.8.6-300.fc25.x86_64 #1
nov 07 19:24:43 xenon kernel: Hardware name: System manufacturer
System Product Name/P8Z68-V LE, BIOS 4102 09/09/2013
nov 07 19:24:43 xenon kernel: task: ffff94ccac7a3d00 task.stack:
ffff94cc0bf14000
nov 07 19:24:43 xenon kernel: RIP: 0010:[<ffffffffc0d80a92>]
[<ffffffffc0d80a92>] btrfs_delete_delayed_dir_index+0x222/0x2c0
[btrfs]
nov 07 19:24:43 xenon kernel: RSP: 0018:ffff94cc0bf17d18  EFLAGS: 00010282
nov 07 19:24:43 xenon kernel: RAX: 0000000000000000 RBX:
ffff94ccba0dbdb0 RCX: 0000000000000000
nov 07 19:24:43 xenon kernel: RDX: 0000000000000000 RSI:
ffff94cd1ec0e048 RDI: ffff94cd1ec0e048
nov 07 19:24:43 xenon kernel: RBP: ffff94cc0bf17d88 R08:
0000000000098b7f R09: 0000000000000005
nov 07 19:24:43 xenon kernel: R10: ffff94cd0703c400 R11:
0000000000000483 R12: ffff94ccba0dbdf8
nov 07 19:24:43 xenon kernel: R13: ffff94cd071b2800 R14:
0000000000000032 R15: 0000000000000000
nov 07 19:24:43 xenon kernel: FS:  00007fb8228b5700(0000)
GS:ffff94cd1ec00000(0000) knlGS:0000000000000000
nov 07 19:24:43 xenon kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
nov 07 19:24:43 xenon kernel: CR2: 00007f512fa32000 CR3:
000000030bd31000 CR4: 00000000000406f0
nov 07 19:24:43 xenon kernel: Stack:
nov 07 19:24:43 xenon kernel:  ffff94cd0ac81a20 ffff94cc0bf17d58
0000000000040000 ffff94cd0703c400
nov 07 19:24:43 xenon kernel:  ffff94cd0703c400 0900000000000000
6000000000000001 0000000000000032
nov 07 19:24:43 xenon kernel:  000000006dbfa5b9 ffff94cc4266da88
ffff94cc6c073d00 0000000000003272
nov 07 19:24:43 xenon kernel: Call Trace:
nov 07 19:24:43 xenon kernel:  [<ffffffffc0d28db1>]
__btrfs_unlink_inode+0x1b1/0x4b0 [btrfs]
nov 07 19:24:43 xenon kernel:  [<ffffffffc0d2ca1c>]
btrfs_unlink_inode+0x1c/0x40 [btrfs]
nov 07 19:24:43 xenon kernel:  [<ffffffffc0d2caab>]
btrfs_unlink+0x6b/0xc0 [btrfs]
nov 07 19:24:43 xenon kernel:  [<ffffffff8725d188>] vfs_unlink+0x108/0x190
nov 07 19:24:43 xenon kernel:  [<ffffffff872618b7>] do_unlinkat+0x277/0x2f0
nov 07 19:24:43 xenon kernel:  [<ffffffff872623fb>] SyS_unlinkat+0x1b/0x30
nov 07 19:24:43 xenon kernel:  [<ffffffff87802572>]
entry_SYSCALL_64_fastpath+0x1a/0xa4
nov 07 19:24:43 xenon kernel: Code: eb fe ff ff 48 8b 53 10 49 8b bd
f0 01 00 00 41 89 c1 4c 8b 03 48 c7 c6 d0 1b db c0 48 8b 8a 48 03 00
00 4c 89 f2 e8 fe f5 f6 ff <0f> 0b 65 8b 05 8d 96 28 3f 89 c0 48 0f a3
05
nov 07 19:24:43 xenon kernel: RIP  [<ffffffffc0d80a92>]
btrfs_delete_delayed_dir_index+0x222/0x2c0 [btrfs]
nov 07 19:24:43 xenon kernel:  RSP <ffff94cc0bf17d18>
nov 07 19:24:43 xenon kernel: ---[ end trace fb2b0363e7e89d6e ]---


-- 
Juan Orti
https://apuntesderootblog.wordpress.com/
GPG: 61F0 8272 6882 BCA6 3A35  88F6 B630 4B72 DEEB D08B
