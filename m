Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:41380 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab2GEAcR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 20:32:17 -0400
Date: Thu, 5 Jul 2012 02:32:02 +0200
From: David Sterba <dave@jikos.cz>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: dave@jikos.cz, Hugo Mills <hugo@carfax.org.uk>,
        =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS fsck apparent errors
Message-ID: <20120705003202.GQ5326@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <4FF30B55.6060205@petaramesh.org>
 <20120703152208.GA28701@carfax.org.uk>
 <CAG1y0scaAqck=LYJdfhQa02BsrnBM7=24RFG5j00pb0QSdn1LA@mail.gmail.com>
 <20120704134258.GL5326@twin.jikos.cz>
 <CAG1y0sda5EqfVp0rP7eJpTdvFFOfWv2DidJPRDDKkrycHvdJiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG1y0sda5EqfVp0rP7eJpTdvFFOfWv2DidJPRDDKkrycHvdJiQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2012 at 10:46:21PM +0700, Fajar A. Nugraha wrote:
> > Is it just mount/umount without any other activity?
> Yes
> 
> > Is the fs
> > fragmented
> Not sure how to check that quickly
> 
> > (or aged),
> Over 1 year, so yes
> 
> > almost full,
> df says 83% used, so probably yes (depending on how you define "almost")

that matches my expectation that could lead to the mount/umount
slowness due to fragmentation

> > has lots of files?
> 
> it's a "normal" 1 TB usb disk, with docs, movies, vm images, etc. No
> particular lots-of-small-files like maildir or anything like that.

So it's probably not an issue with inode_cache.

> >> # time umount /media/WD-root/
> >>
> >> real  0m22.419s
> >> user  0m0.000s
> >> sys   0m0.064s
> >>
> >> # /proc/10142/stack  <--- the PID of umount process
> >
> > The process(es) actually doing the work are the btrfs workers, usual
> > sucspects are btrfs-cache (free space cache) or btrfs-ino (inode cache)
> > that are writing the cache states back to disk.
> 
> Not sure about that, since iostat shows it's mostly read, not write.
> Will try iotop later.
> I tested also with Chris' for-linus on top of 3.4, same result (really
> long time to umount).

Would be good to verify if it's the btrfs-cache worker or not, IIRC
there were more writes than reads, so I'm not sure this is the right
direction.

The 3.5 series or 3.4+for-linus has some changes wrt free space cache
(removed the 'ideal caching mode') that caused slow mounts but has been
fixed.

I've looked again at the umount process call stack, and it's waiting
for writing the btree_inode which is the representation of the b-tree
nodes, it's quite possible that changes to the generic writeback code is
causing this. AFAIK the btree_inode does not behave as a normal file
inode regarding writeback.  The good reference point is 3.2, there were
non-trivial writeback changes merged since.

Guessing now, if the mount causes eg. atime update, then this triggers
cow, dirties the btree_inode and needs to read data from disk,
fragmentation slows this down. Number of cowed blocks is small compared
to the reads (and maybe generic readahead reads more than what's
actually needed for the cow operation ...).


david
