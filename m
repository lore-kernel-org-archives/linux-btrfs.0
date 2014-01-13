Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaAMRnq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 12:43:46 -0500
Date: Mon, 13 Jan 2014 18:43:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Remco Hosman - Yerf IT <remco@yerf-it.nl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC during balance
Message-ID: <20140113174344.GQ6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <97A7F0AC-8A96-4BFA-A6C0-DD878629FCF2@yerf-it.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <97A7F0AC-8A96-4BFA-A6C0-DD878629FCF2@yerf-it.nl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 12, 2014 at 03:49:12PM +0100, Remco Hosman - Yerf IT wrote:
> I am trying to convert my array from raid10 to 1, and its partially
> completed, but at the moment i am getting a '59366.459092] btrfs: 185
> enospc errors during balance’ when i try to balance anything more with
> `btrfs bal start -dconvert=raid1,soft /mountpoint`
> 
> I have already scanned for files with extends over 1gig gig, and there
> is at least 100gig unallocated on each of the disks, and scrub reports
> no error at all.
> Kernel is 3.13-rc7 and tools are latest from git.

By unalocated you mean from 'btrfs fi df' output "total - used = 100G"
or that the sum of all occupied space is 100G less than the device size?
So if there's some space left to allocate new 1G-chunks for balance.

How many disks does the fs contain?

> Anything else i can try ?

Run
$ btrfs balance start -dusage=0,profiles=raid10\|raid1 /mnt

if there are some chunks preallocated from previous balance runs, this
will clean them. The -musage=0 filter could also get some space.

I've experienced similar problems with conversion from raid1 to raid10,
where it's probably worse regarding the 1G-chunks, because the raid-0
level needs the chunk on each disk, while raid1 is fine with just 2.

I had done the -dusage=0 cleanup step every time the 'enospc during
balance' was hit, and it finished in the end. Not perfect, an automatic
and more intelligent chunk reclaim is among the project ideas though.

If nothing from above helps, please post the output of 'fi df' and 'fi
show' commands.


david
