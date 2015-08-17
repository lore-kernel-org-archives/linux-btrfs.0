Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41092 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752385AbbHQCrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Aug 2015 22:47:15 -0400
Subject: Re: weird qgroup behavior, possible bug? btrfs-progs 4.1.2 and 4.1.5
 kernel.
To: Suman Chakravartula <suman@rockstor.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAPF83mvrEWSSRZhfXczHRtG2fW7tdE7OMysns_T6b=d5ZoPTMw@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55D14B28.1010502@cn.fujitsu.com>
Date: Mon, 17 Aug 2015 10:47:04 +0800
MIME-Version: 1.0
In-Reply-To: <CAPF83mvrEWSSRZhfXczHRtG2fW7tdE7OMysns_T6b=d5ZoPTMw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Suman Chakravartula wrote on 2015/08/13 11:22 -0700:
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
If you didn't mount it with compress mount option, it won't be compressed.
So, this is definitely a bug.

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
Known behavior, but still bug.
Btrfs need to reserve space for metadata COW.

But the real bug is, reserved space leaking, which needs quite a lot of 
work to fix it.

>
> I was able to reproduce this behavior with other raid profiles as well
> and recently, some of Rockstor users have also confirmed it with
> subvolume sizes small and large.
>
> I hope this is not a BTRFS bug and it's something that I am doing
> wrong. Can someone familiar with qgroups comment on this?
>
> I see that there are qgroup related patches going into 4.2. Are these
> problems addressed by them, perhaps?

4.2 will only improve the accounting number problem.
For your case, the "btrfs qg show" command should gives exact number.

But for the EQUOT error, it won't help a lot.
As the preserved space bug is a long standing bug, and I'm trying to fix 
it in next release.

So, if you don't set limit of qgroup, 4.2 should be quite good for you.
But if you set limit of qgroup, then 4.2 is still quite easy to trigger
EQUOT. To avoid it, the only method would be umount and mount again.

Thanks,
Qu
>
>
