Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18443 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232AbaL2IRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 03:17:04 -0500
Message-ID: <54A10DFC.4060801@cn.fujitsu.com>
Date: Mon, 29 Dec 2014 16:17:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFkb3PFgmF3IEtpbnR6aQ==?= <r.kintzi@pobox.net.pl>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: Read-only filesystem
References: <20141227080109.GA1276@zeus.home.lan>
In-Reply-To: <20141227080109.GA1276@zeus.home.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Read-only filesystem
From: Radosław Kintzi <r.kintzi@pobox.net.pl>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年12月27日 16:01
> Hello
>
> The problem:
> Every time I start my browser, file system is remounted in read-only
> mode.
>
> The cause:
> I believe the problem originates from hard reset I had to do.
>
> The details:
> # uname -a
> Linux tamuz 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC 2014
> x86_64
> GNU/Linux
> # btrfs --version
> Btrfs v3.17.3
> # btrfs fi show
> Label: none  uuid: 98352bc1-7ea6-4801-92b6-944df292b3cd
> 	Total devices 1 FS bytes used 3.17GiB
> 	devid    1 size 230.88GiB used 6.04GiB path /dev/sda3
>
> Btrfs v3.17.3
> # btrfs fi df /
> Data, single: total=4.01GiB, used=3.05GiB
> System, DUP: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=1.00GiB, used=119.78MiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=48.00MiB, used=0.00B
> # btrfs scrub status /dev/sda3
> scrub status for 98352bc1-7ea6-4801-92b6-944df292b3cd
> 	scrub started at Fri Dec 26 19:47:38 2014 and finished after 49 seconds
> 	total bytes scrubbed: 3.29GiB with 1 errors
> 	error details: csum=1
> 	corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
>
> I have attached two logs: dmesg.log.gz - from recent session and
> dmesg.log.2.gz - from previous one (search for "WARNING")
> Between this two sessions I have done:
> # btrfs check --repair
Seems like checksum error.
Would you please also upload the output of btrfsck command and 'btrfsck 
--repair' command
(Although 'btrfsck --repair' won't repair it, so 'btrfsck' output is the 
important)
>
> The questions:
>
> 1. How tolerant on power loss is btrfs? Should I expect more problems
> like this. Should I expect other problems?
 From the design, btrfs should be completely tolerant to sudden power loss.
The cow feature of btrfs should keep btrfs always health if the 
superblock can be write atomicly.

However, btrfs is still under heavy development, bugs deep in the codes 
may makes things nasty anyway.
> 2. Is there a way to recover the filesystem from  these problems without
> restoring whole filesystemi from backup? How to figure out what files
> and directories are corrupted? Is it possible to remove corrupted
> files/dirs and restore only these from backup?
Hard to say yet, but IMHO it should not be hard to recovery it.
It is not a huge problem like leaf/node corruption in fs tree.

In fact, your dmesg already shows which inode is wrong:
[  282.147037] BTRFS: checksum error at logical 2985828352 on dev 
/dev/sda3, sector 7945232, root 260, inode 509, offset 0, length 4096, 
links 1 (path: radek/.config/google-chrome/Default/Web Data-journal)

Snapshot id 260, inode 509.
But I still perfer the full btrfsck output to make conclusion.

The recovery method may be one of the following:
1) Just remove the file (Web Data-journal) in snapshot 509
I haven't go through the btrfs_unlink() codes, so I'm not sure unlink 
will work or not.
Better to determine it after your btrfsck output to rule out other problems.

2) btrfsck --init-csum-tree
Just rebuild the csum tree, and use the wrong data in the corrupted file.
At least, you know which file is corrupted and you can just recovery it.
Still better to do it after your btrfsck output.

3) None of them fits, need new btrfsck repair function.
If none of above works, I will try to add repair function for btrfsck.

Thanks,
Qu
> 3. What are general recommendations on using btrfs. Currently (this is
> my first experiment with btrfs) I have single partition with subvolumes
> mounted as /{,boot,var,opt,home}. I think, it might be better to have more
> partiations, but I want to hear from you.
>
> Thaks,
> Radosław Kintzi
>

