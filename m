From: Larry Reaves <larry@yrral.net>
Subject: Re: btrfs raid1 degraded does not mount or fsck
Date: Mon, 10 Oct 2011 04:42:04 +0000 (UTC)
Message-ID: <loom.20111010T063606-854@post.gmane.org>
References: <20101029205340.GA10326@gypsyops.denof.sin> <1289943080-sup-1244@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason <at> oracle.com> writes:

> 
> Excerpts from Vladi Gergov's message of 2010-10-29 16:53:42 -0400:
> > >>> gypsyops @ /mnt > sudo mount -o degraded /dev/sdc das3/
> > Password: 
> > mount: wrong fs type, bad option, bad superblock on /dev/sdc,
> >        missing codepage or helper program, or other error
> >        In some cases useful info is found in syslog - try
> >        dmesg | tail  or so
> > 
> > [  684.577540] device label das4 devid 2 transid 107954 /dev/sdc
> > [  684.595150] btrfs: allowing degraded mounts
> > [  684.595594] btrfs: failed to read chunk root on sdb
> > [  684.604110] btrfs: open_ctree failed
> > 
> > >>> gypsyops @ /mnt > sudo btrfsck /dev/sdc
> > btrfsck: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)' failed.
> 
> Ok, I dug through this and found the bug responsible for your
> unmountable FS.  When we're mounted in degraded mode, and we don't have
> enough drives available to do raid1,10, we're can use the wrong raid
> level for new allocations.
> 
> I'm fixing the kernel side so this doesn't happen anymore, but I'll need
> to rebuild the chunk tree (and probably a few others) off your good disk to
> fix things.
> 
> I've got it reproduced here though, so I'll make an fsck that can scan
> for the correct trees and fix it for you.
> 
> Since you're basically going to be my first external fsck customer, is
> there anyway you can do a raw device based backup of the blocks?  This
> way if I do mess things up we can repeat the experiment.
> 
> -chris

I'm seeing this same error, uname -a shows:
2.6.38-11-generic
although, my fs went down a month or so ago so it could have been a slightly
earlier Ubuntu kernel.  Is this the same issue?  Is that very targeted fsck
available somewhere?  I've got my replacement disk ready to add, I just need to
get the other 3 mounted.  Data and metadata are both raid10.  I really need to
start tracking the kernel again :(.  Thanks for any help.

-Larry

