Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45887 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaKHDyR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Nov 2014 22:54:17 -0500
Received: by mail-ob0-f174.google.com with SMTP id uz6so3549546obc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Nov 2014 19:54:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGkb5vdYb480oYV1_KFfyPHxm_S0p4SD436=smFWKWHdtWkV0Q@mail.gmail.com>
References: <CAGkb5vdYb480oYV1_KFfyPHxm_S0p4SD436=smFWKWHdtWkV0Q@mail.gmail.com>
Date: Sat, 8 Nov 2014 03:54:17 +0000
Message-ID: <CAGkb5vfKhqZaK5WUyk-YSD81nXDe8E3pn6MCiKAoRLmmg__mvQ@mail.gmail.com>
Subject: Re: Cannot mount volume after device replace locked up
From: James Hogarth <james.hogarth@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 November 2014 02:55, James Hogarth <james.hogarth@gmail.com> wrote:
> Hi,
>
> I have a F20 system with BTRFS on a 4 disk RAID1 profile
>
> One of the disks failed the other day and when I was replacing it
> today I think a scheduled snapshot was attempted - the following
> appeared in the logs and any btrfs commands locked up.
>
> I don't know if the snapshot was relate dor not but the timing is suspicious.
>
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: BUG: unable to
> handle kernel NULL pointer dereference at 0000000000000088
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: IP:
> [<ffffffffa0579bd1>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: PGD 2055bf067
> PUD 2055be067 PMD 0
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Oops: 0000 [#1] SMP
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Modules linked
> in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat ip6t_REJECT
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: CPU: 1 PID: 1104
> Comm: btrfs Not tainted 3.16.6-203.fc20.x86_64 #1
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Hardware name:
> HP ProLiant MicroServer, BIOS O41     10/01/2013
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: task:
> ffff880212929da0 ti: ffff8802057a8000 task.ti: ffff8802057a8000
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RIP:
> 0010:[<ffffffffa0579bd1>]  [<ffffffffa0579bd1>]
> btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RSP:
> 0018:ffff8802057abc80  EFLAGS: 00010286
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RAX:
> 0000000000000000 RBX: 0000000000000000 RCX: 5647b8799aa1b898
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RDX:
> ffff8802139bb410 RSI: ffff8802139bd200 RDI: ffff88020f10c580
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RBP:
> ffff8802057abc88 R08: ffff8802139bb410 R09: 00000000000004c1
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: R10:
> 0000000000000000 R11: ffff8802057ab99e R12: ffff8800d3062dc8
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: R13:
> ffff8800d2dbe800 R14: ffff8802139bd200 R15: ffff8802095d3000
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: FS:
> 00007f8d272e2880(0000) GS:ffff88021fc80000(0000)
> knlGS:0000000000000000
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: CS:  0010 DS:
> 0000 ES: 0000 CR0: 000000008005003b
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: CR2:
> 0000000000000088 CR3: 00000002055c0000 CR4: 00000000000007e0
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Stack:
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> ffff8800d3062000 ffff8802057abd08 ffffffffa05d1475 ffff8800d3062100
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> ffff8800d3062e38 00000a38cca60000 00ff8800d3062660 0000000000000000
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> ffff880212929da0 0000000000000000 ffff8800d3062000 00000000e6a67ce4
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Call Trace:
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffffa05d1475>] btrfs_dev_replace_finishing+0x325/0x5c0 [btrfs]
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffffa05d1a92>] btrfs_dev_replace_start+0x382/0x450 [btrfs]
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffffa059aca1>] btrfs_ioctl+0x1d71/0x2ad0 [btrfs]
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffff811ad459>] ? handle_mm_fault+0x7d9/0x1070
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffff81059d6c>] ? __do_page_fault+0x21c/0x540
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffff81206c20>] do_vfs_ioctl+0x2e0/0x4a0
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffff81206e61>] SyS_ioctl+0x81/0xa0
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffff8170f5a9>] system_call_fastpath+0x16/0x1b
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Code: 5f 5d c3
> 0f 1f 80 00 00 00 00 66 66 66 66 90 55 48 89 e5 53 48 8b bf f0 09 00
> 00 48 85 ff 74 20 31 db 48 85
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RIP
> [<ffffffffa0579bd1>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> Nov 07 23:06:39 server.purley.hogarthuk.local kernel:  RSP <ffff8802057abc80>
> Nov 07 23:06:39 server.purley.hogarthuk.local kernel: CR2: 0000000000000088
> Nov 07 23:06:39 server.purley.hogarthuk.local kernel: ---[ end trace
> 84e1717f2e9518e5 ]---
>
> Powered off and back on the system and btrfs fi sh appears to be
> showing the four disks and doesn't say device missing.
>
> Trying to mount the volume (with or without the recovery option) results in:
>
> [  160.449018] BTRFS info (device sdb1): disk space caching is enabled
> [  160.449963] BTRFS: failed to read the system array on sdb1
> [  160.465334] BTRFS: open_ctree failed
>
> A btrfs check showed:
>
> warning, device 3 is missing
> warning devid 3 not found already
>
> checking free space cache
> Error reading 7661077725184, -1
> failed to load free space cache for block group 7606532177920
> Error reading 7889999429632, -1
> failed to load free space cache for block group 7607605919744
> Error reading 9100062818304, -1
> failed to load free space cache for block group 7626933272576
>
> ... (lots of these) ...
>
> checking csums
> There are no extents for csum range 8242406531072-8242407579648
> Csum exists for 8242406531072-8242407579648 but there is no extent record
> There are no extents for csum range 8242408103936-8242413346816
> Csum exists for 8242408103936-8242413346816 but there is no extent record
> There are no extents for csum range 8242413871104-8242416492544
> Csum exists for 8242413871104-8242416492544 but there is no extent record
> There are no extents for csum range 8242417016832-8242424881152
> Csum exists for 8242417016832-8242424881152 but there is no extent record
> There are no extents for csum range 8242425929728-8242433794048
> Csum exists for 8242425929728-8242433794048 but there is no extent record
> There are no extents for csum range 8242434318336-8242439036928
>
> ... (lots of these) ...
>
> found 336915598309 bytes used err is 3401
> total csum bytes: 3550868116
> total tree bytes: 4758843392
> total fs tree bytes: 605634560
> total extent tree bytes: 249384960
> btree space waste bytes: 357846512
> file data blocks allocated: 149934014087168
>  referenced 4822013419520
> Btrfs v3.16.2
>
> If I try to mount the volume with degraded,recovery it mounts and says
> this in the logs:
>
> Nov 08 02:45:03 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): allowing degraded mounts
> Nov 08 02:45:03 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): enabling auto recovery
> Nov 08 02:45:03 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): disk space caching is enabled
> Nov 08 02:45:03 server.purley.hogarthuk.local kernel: BTRFS: bdev
> (null) errs: wr 7191592, rd 6079105, flush 0, corrupt 0, gen 0
> Nov 08 02:45:22 server.purley.hogarthuk.local kernel: BTRFS:
> continuing dev_replace from <missing disk> (devid 3) to /dev/sda1 @89%
> Nov 08 02:45:22 server.purley.hogarthuk.local kernel: SELinux:
> initialized (dev sdb1, type btrfs), uses xattr
> Nov 08 02:45:28 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7743971131392) is invalid.
> skip it
> Nov 08 02:45:28 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7746118615040) is invalid.
> skip it
> Nov 08 02:45:28 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7751487324160) is invalid.
> skip it
> Nov 08 02:45:28 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7754708549632) is invalid.
> skip it
> Nov 08 02:45:28 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7757929775104) is invalid.
> skip it
> Nov 08 02:45:28 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7760077258752) is invalid.
> skip it
> Nov 08 02:45:28 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7761151000576) is invalid.
> skip it
> Nov 08 02:45:28 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7766519709696) is invalid.
> skip it
> Nov 08 02:45:28 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7804100673536) is invalid.
> skip it
> Nov 08 02:45:28 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7830944219136) is invalid.
> skip it
> Nov 08 02:45:29 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7853492797440) is invalid.
> skip it
> Nov 08 02:45:30 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7893221244928) is invalid.
> skip it
> Nov 08 02:45:30 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7894294986752) is invalid.
> skip it
> Nov 08 02:45:30 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7920064790528) is invalid.
> skip it
> Nov 08 02:45:30 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (7924359757824) is invalid.
> skip it
> Nov 08 02:45:31 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8097232191488) is invalid.
> skip it
> Nov 08 02:45:31 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8098305933312) is invalid.
> skip it
> Nov 08 02:45:31 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8100453416960) is invalid.
> skip it
> Nov 08 02:45:31 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8103674642432) is invalid.
> skip it
> Nov 08 02:45:31 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8116559544320) is invalid.
> skip it
> Nov 08 02:45:31 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8119780769792) is invalid.
> skip it
> Nov 08 02:45:31 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8177762828288) is invalid.
> skip it
> Nov 08 02:45:31 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8178836570112) is invalid.
> skip it
> Nov 08 02:45:31 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8194942697472) is invalid.
> skip it
> Nov 08 02:45:32 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8240039854080) is invalid.
> skip it
> Nov 08 02:45:32 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8264735916032) is invalid.
> skip it
> Nov 08 02:45:33 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8431165898752) is invalid.
> skip it
> Nov 08 02:45:33 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8453714477056) is invalid.
> skip it
> Nov 08 02:45:34 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (8498811633664) is invalid.
> skip it
> Nov 08 02:45:36 server.purley.hogarthuk.local kernel: BTRFS info
> (device sdb1): The free space cache file (9018502676480) is invalid.
> skip it
> Nov 08 02:45:52 server.purley.hogarthuk.local kernel: BTRFS:
> dev_replace from <missing disk> (devid 3) to /dev/sda1) finished
>
>
> After that there is the following stack trace:
>
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: BUG: unable to
> handle kernel NULL pointer dereference at 0000000000000088
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: IP:
> [<ffffffffa0579bd1>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: PGD 2055bf067
> PUD 2055be067 PMD 0
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Oops: 0000 [#1] SMP
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Modules linked
> in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat ip6t_REJECT
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: CPU: 1 PID: 1104
> Comm: btrfs Not tainted 3.16.6-203.fc20.x86_64 #1
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Hardware name:
> HP ProLiant MicroServer, BIOS O41     10/01/2013
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: task:
> ffff880212929da0 ti: ffff8802057a8000 task.ti: ffff8802057a8000
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RIP:
> 0010:[<ffffffffa0579bd1>]  [<ffffffffa0579bd1>]
> btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RSP:
> 0018:ffff8802057abc80  EFLAGS: 00010286
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RAX:
> 0000000000000000 RBX: 0000000000000000 RCX: 5647b8799aa1b898
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RDX:
> ffff8802139bb410 RSI: ffff8802139bd200 RDI: ffff88020f10c580
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RBP:
> ffff8802057abc88 R08: ffff8802139bb410 R09: 00000000000004c1
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: R10:
> 0000000000000000 R11: ffff8802057ab99e R12: ffff8800d3062dc8
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: R13:
> ffff8800d2dbe800 R14: ffff8802139bd200 R15: ffff8802095d3000
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: FS:
> 00007f8d272e2880(0000) GS:ffff88021fc80000(0000)
> knlGS:0000000000000000
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: CS:  0010 DS:
> 0000 ES: 0000 CR0: 000000008005003b
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: CR2:
> 0000000000000088 CR3: 00000002055c0000 CR4: 00000000000007e0
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Stack:
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> ffff8800d3062000 ffff8802057abd08 ffffffffa05d1475 ffff8800d3062100
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> ffff8800d3062e38 00000a38cca60000 00ff8800d3062660 0000000000000000
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> ffff880212929da0 0000000000000000 ffff8800d3062000 00000000e6a67ce4
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Call Trace:
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffffa05d1475>] btrfs_dev_replace_finishing+0x325/0x5c0 [btrfs]
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffffa05d1a92>] btrfs_dev_replace_start+0x382/0x450 [btrfs]
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffffa059aca1>] btrfs_ioctl+0x1d71/0x2ad0 [btrfs]
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffff811ad459>] ? handle_mm_fault+0x7d9/0x1070
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffff81059d6c>] ? __do_page_fault+0x21c/0x540
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffff81206c20>] do_vfs_ioctl+0x2e0/0x4a0
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffff81206e61>] SyS_ioctl+0x81/0xa0
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel:
> [<ffffffff8170f5a9>] system_call_fastpath+0x16/0x1b
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: Code: 5f 5d c3
> 0f 1f 80 00 00 00 00 66 66 66 66 90 55 48 89 e5 53 48 8b bf f0 09 00
> 00 48 85 ff 74 20 31 db 48 85
> Nov 07 23:06:38 server.purley.hogarthuk.local kernel: RIP
> [<ffffffffa0579bd1>] btrfs_kobj_rm_device+0x21/0x40 [btrfs]
> Nov 07 23:06:39 server.purley.hogarthuk.local kernel:  RSP <ffff8802057abc80>
> Nov 07 23:06:39 server.purley.hogarthuk.local kernel: CR2: 0000000000000088
> Nov 07 23:06:39 server.purley.hogarthuk.local kernel: ---[ end trace
> 84e1717f2e9518e5 ]---
>
> mount, df, etc all hang after this with top showing 100% wait on one of the cpus
>
> the fedora 20 kernel is 3.16.6-203.fc20.x86_64 and btrfsprogs is
> btrfs-progs-3.16.2-1.fc20.x86_64
>
> Could you please provide some guidance to try and recover from this situation?
>
> Thanks,
>
> James


For further information ...

I updated my kernel to 3.17.2 in F20 updates-testing and the
btrfs-progs  btrfs-progs-3.17-1.fc20.x86_64  and on mount -o degraded
I get:

Nov 08 03:50:09 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): allowing degraded mounts
Nov 08 03:50:09 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): disk space caching is enabled
Nov 08 03:50:10 server.purley.hogarthuk.local kernel: BTRFS: bdev
(null) errs: wr 7191592, rd 6079105, flush 0, corrupt 0, gen 0
Nov 08 03:50:28 server.purley.hogarthuk.local kernel: BTRFS:
continuing dev_replace from <missing disk> (devid 3) to /dev/sda1 @89%
Nov 08 03:50:28 server.purley.hogarthuk.local kernel: SELinux:
initialized (dev sdd1, type btrfs), uses xattr
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7743971131392) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7746118615040) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7751487324160) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7754708549632) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7757929775104) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7760077258752) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7761151000576) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7766519709696) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7804100673536) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7830944219136) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7853492797440) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7893221244928) is invalid.
skip it
Nov 08 03:50:29 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7894294986752) is invalid.
skip it
Nov 08 03:50:30 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7920064790528) is invalid.
skip it
Nov 08 03:50:30 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (7924359757824) is invalid.
skip it
Nov 08 03:50:30 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8097232191488) is invalid.
skip it
Nov 08 03:50:30 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8098305933312) is invalid.
skip it
Nov 08 03:50:30 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8100453416960) is invalid.
skip it
Nov 08 03:50:30 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8103674642432) is invalid.
skip it
Nov 08 03:50:30 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8116559544320) is invalid.
skip it
Nov 08 03:50:30 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8119780769792) is invalid.
skip it
Nov 08 03:50:31 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8177762828288) is invalid.
skip it
Nov 08 03:50:31 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8178836570112) is invalid.
skip it
Nov 08 03:50:31 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8194942697472) is invalid.
skip it
Nov 08 03:50:31 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8240039854080) is invalid.
skip it
Nov 08 03:50:31 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8264735916032) is invalid.
skip it
Nov 08 03:50:32 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8431165898752) is invalid.
skip it
Nov 08 03:50:32 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8453714477056) is invalid.
skip it
Nov 08 03:50:33 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (8498811633664) is invalid.
skip it
Nov 08 03:50:36 server.purley.hogarthuk.local kernel: BTRFS info
(device sdd1): The free space cache file (9018502676480) is invalid.
skip it
Nov 08 03:50:42 server.purley.hogarthuk.local kernel: BTRFS:
dev_replace from <missing disk> (devid 3) to /dev/sda1) finished
Nov 08 03:50:42 server.purley.hogarthuk.local kernel: ------------[
cut here ]------------
Nov 08 03:50:42 server.purley.hogarthuk.local kernel: WARNING: CPU: 1
PID: 984 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
Nov 08 03:50:42 server.purley.hogarthuk.local kernel: sysfs: cannot
create duplicate filename
'/fs/btrfs/6310c5eb-90bf-47d8-a995-87b7a5dce88b/devices/sda1'
Nov 08 03:50:42 server.purley.hogarthuk.local kernel: Modules linked
in: 8021q garp stp llc mrp ipt_MASQUERADE iptable_nat nf_nat_ipv4
nf_nat ip6t_REJECT nf_conntra...
Nov 08 03:50:42 server.purley.hogarthuk.local kernel: CPU: 1 PID: 984
Comm: btrfs-devrepl Not tainted 3.17.2-200.fc20.x86_64 #1
Nov 08 03:50:42 server.purley.hogarthuk.local kernel: Hardware name:
HP ProLiant MicroServer, BIOS O41     10/01/2013
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
0000000000000000 0000000045f1980f ffff8800cc9f3cd0 ffffffff817271cc
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
ffff8800cc9f3d18 ffff8800cc9f3d08 ffffffff81094ced ffff880206f61000
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
ffff880214364868 ffff880212865168 0000000000000001 ffffffffffffffef
Nov 08 03:50:42 server.purley.hogarthuk.local kernel: Call Trace:
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff817271cc>] dump_stack+0x45/0x56
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff81094ced>] warn_slowpath_common+0x7d/0xa0
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff81094d6c>] warn_slowpath_fmt+0x5c/0x80
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff81278878>] ? kernfs_path+0x48/0x60
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff8127bf84>] sysfs_warn_dup+0x64/0x80
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff8127c2e4>] sysfs_do_create_link_sd.isra.2+0xa4/0xb0
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff8127c315>] sysfs_create_link+0x25/0x50
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffffa037b586>] btrfs_kobj_add_device+0x76/0xc0 [btrfs]
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffffa03d3310>] btrfs_dev_replace_finishing+0x330/0x5b0 [btrfs]
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff81723615>] ? printk+0x77/0x8e
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffffa03d3af0>] ? btrfs_dev_replace_status+0x110/0x110 [btrfs]
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffffa03d3b5d>] btrfs_dev_replace_kthread+0x6d/0x130 [btrfs]
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff810b2318>] kthread+0xd8/0xf0
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff810b2240>] ? kthread_create_on_node+0x190/0x190
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff8172e7bc>] ret_from_fork+0x7c/0xb0
Nov 08 03:50:42 server.purley.hogarthuk.local kernel:
[<ffffffff810b2240>] ? kthread_create_on_node+0x190/0x190
Nov 08 03:50:42 server.purley.hogarthuk.local kernel: ---[ end trace
f8638de21f13cf39 ]---

However following on from this I could do a umount and a non-degraded
mount ... trying a scrub now and crossing fingers.
