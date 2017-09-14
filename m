Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52906 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbdINPYo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 11:24:44 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dsW0H-00071c-Sk
        for linux-btrfs@vger.kernel.org; Thu, 14 Sep 2017 17:24:33 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: defragmenting best practice?
Date: Thu, 14 Sep 2017 17:24:34 +0200
Message-ID: <20170914172434.39eae89d@jupiter.sol.kaishome.de>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170912162843.GA32233@rus.uni-stuttgart.de>
        <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
        <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 14 Sep 2017 14:31:48 +0100
schrieb Tomasz Kłoczko <kloczko.tomasz@gmail.com>:

> On 14 September 2017 at 12:38, Kai Krakow <hurikhan77@gmail.com>
> wrote: [..]
> >
> > I suggest you only ever defragment parts of your main subvolume or
> > rely on autodefrag, and let bees do optimizing the snapshots.

Please read that again including the parts you omitted.


> > Also, I experimented with adding btrfs support to shake, still
> > working on better integration but currently lacking time... :-(
> >
> > Shake is an adaptive defragger which rewrites files. With my current
> > patches it clones each file, and then rewrites it to its original
> > location. This approach is currently not optimal as it simply bails
> > out if some other process is accessing the file and leaves you with
> > an (intact) temporary copy you need to move back in place
> > manually.  
> 
> If you really want to have real and *ideal* distribution of the data
> across physical disk first you need to build time travel device. This
> device will allow you to put all blocks which needs to be read in
> perfect order (to read all data only sequentially without seek).
> However it will be working only in case of spindles because in case of
> SSDs there is no seek time.
> Please let us know when you will write drivers/timetravel/ Linux
> kernel driver. When such driver will be available I promise I'll
> write all necessary btrfs code by myself in matter of few days (it
> will be piece of cake compare to build such device).
> 
> But seriously ..

Seriously: Defragmentation on spindles is IMHO not about getting the
perfect continuous allocation but providing better spatial layout of
the files you work with.

Getting e.g. boot files into read order or at least nearby improves
boot time a lot. Similar for loading applications. Shake tries to
improve this by rewriting the files - and this works because file
systems (given enough free space) already do a very good job at doing
this. But constant system updates degrade this order over time.

It really doesn't matter if some big file is laid out in 1 allocation
of 1 GB or in 250 allocations of 4MB: It really doesn't make a big
difference.

Recombining extents into bigger once, tho, can make a big difference in
an aging btrfs, even on SSDs.

Bees is, btw, not about defragmentation: I have some OS containers
running and I want to deduplicate data after updates. It seems to do a
good job here, better than other deduplicators I found. And if some
defrag tools destroyed your snapshot reflinks, bees can also help here.
On its way it may recombine extents so it may improve fragmentation.
But usually it probably defragments because it needs to split extents
that a defragger combined.

But well, I think getting 100% continuous allocation is really not the
achievement you want to get, especially when reflinks are a primary
concern.


> Only context/scenario when you may want to lower defragmentation is
> when you are something needs to allocate continuous area lower than
> free space and larger than largest free chunk. Something like this
> happens only when volume is working on almost 100% allocated space.
> In such scenario even you bees cannot do to much as it may be not
> enough free space to move some other data in larger chunks to
> defragment FS physical space.

Bees does not do that.


> If your workload will be still writing
> new data to FS such defragmentation may give you (maybe) few more
> seconds and just after this FS will be 100% full,
> 
> In other words if someone is thinking that such defragmentation daemon
> is solving any problems he/she may be 100% right .. such person is
> only *thinking* that this is truth.

Bees is not about that.


> kloczek
> PS. Do you know first McGyver rule? -> "If it ain't broke, don't fix
> it".

Do you know the saying "think first, then act"?


> So first show that fragmentation is hurting latency of the
> access to btrfs data and it will be possible to measurable such
> impact. Before you will start measuring this you need to learn how o
> sample for example VFS layer latency. Do you know how to do this to
> deliver such proof?

You didn't get the point. You only read "defragmentation" and your
alarm lights lid up. You even think bees would be a defragmenter. It
probably is more the opposite because it introduces more fragments in
exchange for more reflinks.


> PS2. The same "discussions" about fragmentation where in the past
> about +10 years ago after ZFS has been introduced. Just to let you
> know that after initial ZFS introduction up to now was not written
> even single line of ZFS code to handle active fragmentation and no one
> been able to prove that something about active defragmentation needs
> to be done in case of ZFS.

Btrfs has autodefrag to reduce the number of fragments by rewriting
small portions of the file being written to. This is needed, otherwise
the feature won't be there. Why? Have you tried working with 1GB files
broken into 100000+ of fragments just because of how CoW works? Try,
there's your latency.


> Why? Because all stands on the shoulders of enough cleaver *allocation
> algorithm*. Only this and nothing more.
> PS3. Please can we stop this/EOT?

Can we please not start a flame war just because you hate defrag tools?

I think the whole discussion about "defragmenting" should be stopped.
Let's call it "optimizers":

If it reduces needed storage space, it optimizes. And I need a tool for
that. Otherwise tell me how btrfs solves this in-kernel, when
applications break reflinks by rewriting data...

If you're on spindles you want files be kept spatially nearby that are
needed at around the same time. This improves boot times and application
start times. The file system already does a good job at doing this. But
for some work loads (like booting) this degrades over time and the FS
can do nothing about it because this is just not how package managers
work (or Windows updates, NTFS also uses extent allocation and as such
solves the same problems in similar way as most Linux systems). Let the
package manager reinstall all files accessed at boot and it would
probably be solved. But who wants that? Btrfs does not solve this, SSDs
do. Using bcache for that matter on my local system. Wihtout SSDs,
shake (and other tools) can solve this.

If you are on SSD and work with almost full file systems, you may get
back performance by recombining free space. Defragmentation here is not
about files but free space. This can also be called an optimizer then.


I really have no interest in defragmenting a file system to 100%
continuous allocation. That was need for FAT and small system without
enough RAM for caching all the file system infrastructure. Today
systems use extent allocations and that solves the problem where the
original idea of defragmentation came from. When I speak of
defragmentation I mean something more intelligent like optimizing file
system layout for access patterns you use.


Conclusion: The original question was about defrag best practice with
regards to reflinked snapshots. And I recommended partially against it
and instead recommended bees which restores and optimizes the reflinks
and may recombine some of the extents. From my wording, and I apologize
for that, it was probably not completely clear what this means:

[I wrote]
> You may want to try https://github.com/Zygo/bees. It is a daemon
> watching the file system generation changes, scanning the blocks and
> then recombines them. Of course, this process somewhat defeats the
> purpose of defragging in the first place as it will undo some of the
> defragmenting.

It scans for duplicate blocks and recombines them into reflinked
blocks. This is done by recombining extents. For that purpose, extents
that the file system allocated, usually need to be broken up again into
smaller chunks. But bees tries to recombine such broken extents back
into bigger ones. But it is not a defragger, seriously! It indeed
breaks extents into smaller chunks.

Later I recommended to have a look at shake which I experimented with.
And I also recommended to let the btrfs autodefrag do the work and only
ever defragment only very selected parts of the file system he feels
needing "defragmentation". My patches to shake try to avoid btrfs
shared extents so actually they reduce the effect of defragmenting the
FS, because I think keeping reflinked extents is more important. But I
see the main purpose of shake to re-layout supplied files into nearby
space. I think it is more important to improve spatial locality of
files than having them 100% continuous.

I will try to make my intent more clear next time but I guess you won't
probably read it in its entirely anyways. :,-(


-- 
Regards,
Kai

Replies to list-only preferred.


