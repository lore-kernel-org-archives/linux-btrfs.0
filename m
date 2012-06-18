Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:38928 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab2FRQrR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 12:47:17 -0400
Message-ID: <4FDF5B99.1000000@inwind.it>
Date: Mon, 18 Jun 2012 18:47:21 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: rupert THURNER <rupert.thurner@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: cannot remove files: "rm" gives "no space left on device", 3.2.0-24,
 ubuntu
References: <CAJs9aZ9gsM-hcH-YJpgN6f_YEHrcdJfm808TuCLRKWd1qEGXwg@mail.gmail.com> <20120616145704.039809d2@sf.home> <CAJs9aZ-9EK2HUuvBDuiPSG2O5J16seO6Hp3=wJLYAJBi9KDL+Q@mail.gmail.com> <CAJs9aZ_C5CzyuudeUg585M4SifunchrmVDg5rXQoo7kDAsOMpw@mail.gmail.com> <1339910379.1538.4.camel@ierdnac-hp> <CAJs9aZ-bTEPyJBiLxQozu71-atP958wp95HhyfFgTb+2y2kLLA@mail.gmail.com> <CAKcLGm-uBVR4U+=LoMQjUbJEwZ-+FDOdLNmgc+P=gKQzC6G=jQ@mail.gmail.com> <CAJs9aZ94RcRR9MYC0bT81VfMuURDqA2-R2iiN3=Y_8sz7caHpw@mail.gmail.com> <4FDEC23F.3050704@libero.it> <CAJs9aZ-GHtO3JsvNqLip9CRXxg_J8RUDM=F7GLfdSqCt-zvB3w@mail.gmail.com>
In-Reply-To: <CAJs9aZ-GHtO3JsvNqLip9CRXxg_J8RUDM=F7GLfdSqCt-zvB3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/18/2012 08:40 AM, rupert THURNER wrote:
> On Mon, Jun 18, 2012 at 7:53 AM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>> On 06/17/2012 09:54 PM, rupert THURNER wrote:
>>> displays the additional free space. that it displays 30% of metadata
>>> seems strange to me, or it counts the still existing ext4 snapshot
>>> from the conversion somehow into it?
>>>
>>> root@tv:~# btrfs filesystem df /media/388gb-data
>>> Data: total=260.59GB, used=251.51GB
>>> System: total=32.00MB, used=24.00KB
>>> Metadata: total=128.00GB, used=120.00GB
>>>
> .
>>> what would you recommend to do for "normal" usage? one should not
>>> always use the "nodatacow" option, isn't it?
>>
>> No, it shouldn't. On my system
>>
>>  ghigo@venice:~$ sudo btrfs fi df /
>>  Data: total=17.01GB, used=12.82GB
>>  System, DUP: total=40.00MB, used=4.00KB
>>  System: total=4.00MB, used=0.00
>>  Metadata, DUP: total=2.00GB, used=813.80MB
>>  Metadata: total=8.00MB, used=0.00
>>
>> So the ratio metadata:data it is about 1:20
>>
>> How many files are stored in your hard disk ? Which is a typical file
>> size ? If a lot of files are less than 4K, these are stored as metadata.
>> How big was the original ext4 filesystem ?
> 
> 370 files with ~1GB, and 10000 small. 

I am a bit confused: 370 files of about ~1GB is about a total of
300-400GB; instead you reported

>>> root@tv:~# btrfs filesystem df /media/388gb-data
>>> Data: total=260.59GB, used=251.51GB

My idea is that you converted an old ext4 filesystem (about 300-400GB of
data), and also you updated the greatest part of these files.
Updating an ext4 converted file means a lot of copy-on-write (the
original one is still on the disk and unaffected by the change, an I
think that the consumed space it is not showed), and it might justify
the high metadata usage. But this is only a my guess.

How big is the disk ? As empirical rule, all the file-systems work well
when they are used at 50%. I supposed that the disk it is used nearly 100%.

Is it doable to remove the old ext4 image ? Have you a backup ?


> they are in 1600 directories. i
> converted it from ext4 when it was nearly full, removed maybe 20 big
> files and added again 30 big files. i had the feeling that btrfs was
> able to store more big files than ext4, but i did not count the files
> before.
> 
> # du --max-depth=0 videos* | awk '{sum = sum + $1 ; print} END {print sum}'
> ..
> 364315724
> 
> root@tv:/media/388gb-data# du -sh .
> 724G	.
> 
> root@tv:/media/388gb-data# ls -l ext2_saved/
> total 381793680
> -r-------- 1 root root 417276612608 Jan  1  1970 image
> .
> 

