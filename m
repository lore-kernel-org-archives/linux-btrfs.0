Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35342 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbbHMVki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 17:40:38 -0400
Received: by oiew67 with SMTP id w67so15698054oie.2
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 14:40:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPF83mvrEWSSRZhfXczHRtG2fW7tdE7OMysns_T6b=d5ZoPTMw@mail.gmail.com>
References: <CAPF83mvrEWSSRZhfXczHRtG2fW7tdE7OMysns_T6b=d5ZoPTMw@mail.gmail.com>
Date: Thu, 13 Aug 2015 14:40:37 -0700
Message-ID: <CAKgsxVRhb=2BRgLRtMX-_we1GB11FbxSKGJ4C4+cw53u_Pu6Kg@mail.gmail.com>
Subject: Re: weird qgroup behavior, possible bug? btrfs-progs 4.1.2 and 4.1.5 kernel.
From: Justin Maggard <jmaggard10@gmail.com>
To: Suman Chakravartula <suman@rockstor.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 13, 2015 at 11:22 AM, Suman Chakravartula
<suman@rockstor.com> wrote:
> Hi,
>
> I use qgroups for subvolumes in Rockstor and have been noticing this
> behavior for a while(at least from 3.18 days). The behavior is that I
> get "Disk quota exceeded" errors before even hitting 70% usage. Here's
> a simple demonstration of the problem.
>
> [root@rock-dev ~]# btrfs fi show singlepool
> Label: 'singlepool'  uuid: 77eb22bf-5f07-4f7e-83af-da183ceccd4d
> Total devices 1 FS bytes used 224.00KiB
> devid    1 size 3.00GiB used 276.00MiB path /dev/sdab
>
> btrfs-progs v4.1.2
> [root@rock-dev ~]# btrfs subvol list -p /mnt2/singlepool/
> ID 257 gen 9 parent 5 top level 5 path singleshare1
> [root@rock-dev ~]# btrfs qgroup show -pcre /mnt2/singlepool
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/257        16.00KiB     16.00KiB         none         none 2015/1  ---
> 2015/1       16.00KiB     16.00KiB      1.00GiB         none ---     0/257
>
> As you can see, the subvolume is part of the 2015/1 qgroup with a 1GiB
> max_rfer limit. Now I start writing to the it.
>
> [root@rock-dev ~]# dd if=/dev/urandom of=/mnt2/singleshare1/file.1
> bs=1M count=256; sync
> 256+0 records in
> 256+0 records out
> 268435456 bytes (268 MB) copied, 15.5902 s, 17.2 MB/s
> [root@rock-dev ~]# btrfs fi df /mnt2/singlepool/
> Data, single: total=328.00MiB, used=256.12MiB
> System, single: total=4.00MiB, used=16.00KiB
> Metadata, single: total=264.00MiB, used=432.00KiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> [root@rock-dev ~]# btrfs qgroup show -pcre /mnt2/singlepool
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/257       256.02MiB    256.02MiB         none         none 2015/1  ---
> 2015/1      256.02MiB    256.02MiB      1.00GiB         none ---     0/257
> [root@rock-dev ~]# dd if=/dev/urandom of=/mnt2/singleshare1/file.2
> bs=1M count=256; sync
> 256+0 records in
> 256+0 records out
> 268435456 bytes (268 MB) copied, 15.7899 s, 17.0 MB/s
> [root@rock-dev ~]# btrfs fi df /mnt2/singlepool/
> Data, single: total=648.00MiB, used=512.19MiB
> System, single: total=4.00MiB, used=16.00KiB
> Metadata, single: total=264.00MiB, used=688.00KiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> [root@rock-dev ~]# btrfs qgroup show -pcre /mnt2/singlepool
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/257       512.02MiB    512.02MiB         none         none 2015/1  ---
> 2015/1      512.02MiB    512.02MiB      1.00GiB         none ---     0/257
>
> Ok, so far so good. I've written 2 files, 512MiB in total and it's
> reflected accurately in the qgroup accounting. Now, I write a 3rd
> 256MiB file.
>
> [root@rock-dev ~]# dd if=/dev/urandom of=/mnt2/singleshare1/file.3
> bs=1M count=256; sync
> 256+0 records in
> 256+0 records out
> 268435456 bytes (268 MB) copied, 15.6963 s, 17.1 MB/s
> [root@rock-dev ~]# sync
> [root@rock-dev ~]# btrfs fi df /mnt2/singlepool/
> Data, single: total=968.00MiB, used=768.25MiB
> System, single: total=4.00MiB, used=16.00KiB
> Metadata, single: total=264.00MiB, used=944.00KiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> [root@rock-dev ~]# btrfs qgroup show -pcre /mnt2/singlepool
> qgroupid         rfer         excl     max_rfer     max_excl parent  child
> --------         ----         ----     --------     -------- ------  -----
> 0/5          16.00KiB     16.00KiB         none         none ---     ---
> 0/257       662.00MiB    662.00MiB         none         none 2015/1  ---
> 2015/1      662.00MiB    662.00MiB      1.00GiB         none ---     0/257
>
> I find it odd that the usage shows 662.00Mib, I was expecting to see
> 768MiB(512+256). Is this because the third 256MiB file was compressed
> to 150MiB while the first two files were not compressible? Or is it
> something else, and if so, what is it?
>
> If I attempt to write another 256MiB file, i get this error:
>
> [root@rock-dev ~]# dd if=/dev/urandom of=/mnt2/singleshare1/file.4
> bs=1M count=256; sync
> dd: failed to open ‘/mnt2/singleshare1/file.4’: Disk quota exceeded
>
> If I try to remove one of the three files written successfully, i get
> the same error:
>
> [root@rock-dev ~]# cd /mnt2/singleshare2/
> [root@rock-dev singleshare2]# ls
> file.1  file.2  file.3
> [root@rock-dev singleshare2]# ls -l
> total 786432
> -rw-r--r-- 1 root root 268435456 Aug 13 10:49 file.1
> -rw-r--r-- 1 root root 268435456 Aug 13 10:50 file.2
> -rw-r--r-- 1 root root 268435456 Aug 13 10:50 file.3
> [root@rock-dev singleshare2]# rm file.3
> rm: remove regular file ‘file.3’? y
> rm: cannot remove ‘file.3’: Disk quota exceeded
>
> I was able to reproduce this behavior with other raid profiles as well
> and recently, some of Rockstor users have also confirmed it with
> subvolume sizes small and large.
>
> I hope this is not a BTRFS bug and it's something that I am doing
> wrong. Can someone familiar with qgroups comment on this?
>

Almost certainly a bug.  Qgroups are pretty buggy all the way up to
and including 4.1.  I posted a few patches a couple months ago to fix
up several bugs I ran into; but they are not relevant for 4.2, since
qgroup support has undergone major surgery.

> I see that there are qgroup related patches going into 4.2. Are these
> problems addressed by them, perhaps?
>

Your issues are probably addressed in 4.2.  If you really want to use
qgroups with 4.1, you may want to see if those patches help in your
case. (https://patchwork.kernel.org/project/linux-btrfs/list/?submitter=59741)

-Justin
