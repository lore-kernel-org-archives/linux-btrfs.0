Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35635 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbcCWTdM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 15:33:12 -0400
Received: by mail-io0-f181.google.com with SMTP id v187so30693241ioe.2
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 12:33:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F2EA25.4070004@gmail.com>
References: <56F1E7BE.1000004@gmail.com>
	<56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
	<CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
	<56F2C991.9080500@gmail.com>
	<CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
	<56F2EA25.4070004@gmail.com>
Date: Wed, 23 Mar 2016 13:33:10 -0600
Message-ID: <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
Subject: Re: RAID-1 refuses to balance large drive
From: Chris Murphy <lists@colorremedies.com>
To: Brad Templeton <bradtem@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2016 at 1:10 PM, Brad Templeton <bradtem@gmail.com> wrote:
> It is Ubuntu wily, which is 4.2 and btrfs-progs 0.4.  I will upgrade to
> Xenial in April but probably not before, I don't have days to spend on
> this.   Is there a fairly safe ppa to pull 4.4 or 4.5?

I'm not sure.


 In olden days, I
> would patch and build my kernels from source but I just don't have time
> for all the long-term sysadmin burden that creates any more.
>
> Also, I presume if this is a bug, it's in btrfsprogs, though the new one
> presumably needs a newer kernel too.

No you can mix and match progs and kernel versions. You just don't get
new features if you don't have a new kernel.

But the issue is the balance code is all in the kernel. It's activated
by user space tools but it's all actually done by kernel code.



> I am surprised to hear it said that having the mixed sizes is an odd
> case.

Not odd as in wrong, just uncommon compared to other arrangements being tested.

>  That was actually one of the more compelling features of btrfs
> that made me switch from mdadm, lvm and the rest.   I presumed most
> people were the same. You need more space, you go out and buy a new
> drive and of course the new drive is bigger than the old drives you
> bought because they always get bigger.

Of course and I'm not saying it shouldn't work. The central problem
here is we don't even know what the problem really is; we only know
the manifestation of the problem isn't the desired or expected
outcome. And how to find out the cause is different than how to fix
it.



> Under mdadm the bigger drive
> still helped, because it replaced at smaller drive, the one that was
> holding the RAID back, but you didn't get to use all the big drive until
> a year later when you had upgraded them all.  In the meantime you used
> the extra space in other RAIDs.  (For example, a raid-5 plus a raid-1 on
> the 2 bigger drives) Or you used the extra space as non-RAID space, ie.
> space for static stuff that has offline backups.  In fact, most of my
> storage is of that class (photo archives, reciprocal backups of other
> systems) where RAID is not needed.
>
> So the long story is, I think most home users are likely to always have
> different sizes and want their FS to treat it well.

Yes of course. And at the expense of getting a frownie face....

"Btrfs is under heavy development, and is not suitable for
any uses other than benchmarking and review."
https://www.kernel.org/doc/Documentation/filesystems/btrfs.txt

Despite that disclosure, what you're describing is not what I'd expect
and not what I've previously experienced. But I haven't had three
different sized drives, and they weren't particularly full, and I
don't know if you started with three from the outset at mkfs time or
if this is the result of two drives with a third added on later, etc.
So the nature of file systems is actually really complicated and it's
normal for there to be regressions - and maybe this is a regression,
hard to say with available information.



> Since 6TB is a relatively new size, I wonder if that plays a role.  More
> than 4TB of free space to balance into, could that confuse it?

Seems unlikely.


-- 
Chris Murphy
