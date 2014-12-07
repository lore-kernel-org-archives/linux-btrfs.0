Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43301 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaLGPdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 10:33:45 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
Date: Sun, 07 Dec 2014 16:33:37 +0100
Message-ID: <44320137.fRRuR6EFMP@merkaba>
In-Reply-To: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Shriramana!

Am Sonntag, 7. Dezember 2014, 20:45:59 schrieb Shriramana Sharma:
> IIUC:
> 
> 1) btrfs fi df already shows the alloc-ed space and the space used out of
> that.
> 
> 2) Despite snapshots, CoW and compression, the tree knows how many
> extents of data and metadata there are, and how many bytes on disk
> these occcupy, no matter what is the total (uncompressed,
> "unsnapshotted") size of all the directories and files on the disk.
> 
> So this means that btrfs fi df actually shows the real on-disk usage.
> In this case, why do we hear people saying it's not possible to know
> the actual on-disk usage and when a btrfs-formatted disk (or
> partition) will go out of space?

I never read that the actual disk usage is unknown. But I read that the actual 
what is free is unknown. And there are several reasons for that:

1) On a compressed filesystem you cannot know, but only estimate the 
compression ratio for future data.

2) On a compressed filesystem you can choose to have parts of it uncompressed 
by file / directory attributes, I think. BTRFS can´t know how much of the 
future data you are going to store compressed or uncompressed.

3) From what I gathered it is planned to allow different raid / redundancy 
levels for different subvolumes. BTRFS can´t know beforehand where applications 
request to save future data, i.e. in which subvolume.

4) Even on a convential filesystem the free space is an estimate, cause it can 
not predict the activity of other processes writing to the filesystem. You may 
have 10 GiB free at some point, but if another process is currently writing 
another 5 GiB at the time your process is writing it will continue to have 
less and less than the estimated 10 GiB free and if it wanted to write 10 GiB 
it will not be able to.

What might be possible but still has the limitation of the fourth point above, 
would be a query: How much free space do you have *right* know, on this 
directory path, if I write with standard settings.

But the only guarantee you can ever get is to pre-allocate your files with 
fallocate. When the fallocate file succeeded, you get a guarantee that you can 
write to the amount of allocated space into the file. Whether BTRFS can hold to 
that guarantee in any case? That depends on how bug free it is in that regard 
with its free space handling.

And in case you do not need all the fallocated space, other processes may not 
be able to write data anymore even if there would be free space in your 
fallocated files.

So you either overprovision or underprovision… :)

That written: Filling up a filesystem 100% will limit the performance of any 
filesystem that is non to me considerably and ask for further troubel. So 
better have at least 10-20% of the space free, except maybe for very large 
filesystem, but on the other hand I saw recommendations on the XFS mailing list 
that in heavy random I/O on lots of file case it is even better to leave 40-50% 
free in case you want to delay slowing down of the filesystem and want to have 
a well structured filesystem after 10 years of heavy usage. BTRFS can rebalance 
things, but I have yet to see that this rebalancing really optimizes things. 
It may not, or at least not in all cases.

So welcome to the challenges of filesystem development, especially for copy on 
write filesystem with the feature set BTRFS provides.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
