Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37626 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab2LOWYU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Dec 2012 17:24:20 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so4758691oag.19
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 14:24:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50CCD247.3090701@friedels.name>
References: <50BFB3B2.8040405@friedels.name>
	<CAKcLGm_44rjGwyKox0xO1SqWP1SkY-z8vpST6n99Q4g6eN9Lrw@mail.gmail.com>
	<50C4E152.2000102@friedels.name>
	<CAKcLGm8wm1Gfe0ESCubGusqe_zojJp=7JORLXuq_EUdY22JOWA@mail.gmail.com>
	<50CCD247.3090701@friedels.name>
Date: Sat, 15 Dec 2012 16:24:18 -0600
Message-ID: <CAKcLGm-bwUriSBzoM2FTV9Rv1=dYp=5H_me8VZX6vygtXEhADg@mail.gmail.com>
Subject: Re: segmentation-fault in btrfsck (git-version)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 15, 2012 at 1:40 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello Mitch, hello all,
>
>
>> Since btrfs has significant improvements and fixes in each kernel
>>
>> release, and since very few of these changes are backported, it is
>> recommended to use the latest kernels available.
>
>
> Ok, it's 3.7 now.
>
>
>> The "root ### inode ##### errors 400" are an indication that there is
>> an inconsistency in the inode size.  There was a patch included in the
>> 3.1 or 3.2 kernel to address this issue
>>
>> (http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=f70a9a6b94af86fca069a7552ab672c31b457786).
>>   But I don't believe this patch fixed existing occurrences of this
>> error.
>
>
> Apparently not. It's still there.
>
>
>> At this point, the quickest solution for you may be to rebuild and
>> reformat this RAID assembly, and restore this data from backups.
>
>
> Yepp, I did that. But in fact, some data is missing. It is not essential,
> but nice to have.
>
>
>> If you don't have a backup of this data, and since your array seems to
>> be working pretty well in a degraded state, this would be a really
>> good time to look at a strategy of getting a backup of this data
>> before doing many more attempts at rescue.
>
>
> Done. It's all save on another ext4 drive.
>
> So, let's play ;-)
> Could you please help me trying to restore the missing Data?
>
> What I tried sofar was:
> ./btrfs-restore /dev/sdc1 /mnt/restore/
>
> It worked, in a way that it restored what I already had.
> What's odd aswell is, that btrfs scrub did run through without errors.
> So, the missing data could have been (accidentally) deleted by me. But I
> don't think... nevertheless I cannot exclude.
>
> What I know is the (original) Path of the Data.
>

You could try btrfs-debug-tree, and search for any traces of your
file.  However, be ready to sift through a massive amount of output.
