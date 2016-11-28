Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:45565 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754123AbcK1IU3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 03:20:29 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cBHAg-00029c-9i
        for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2016 09:20:18 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: mount option nodatacow for VMs on SSD?
Date: Mon, 28 Nov 2016 09:20:15 +0100
Message-ID: <20161128092015.70b75dd8@jupiter.sol.kaishome.de>
References: <20161125082840.GA32711@rus.uni-stuttgart.de>
        <20161126112710.6aca8bac@jupiter.sol.kaishome.de>
        <20161128003829.GD15348@rus.uni-stuttgart.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 28 Nov 2016 01:38:29 +0100
schrieb Ulli Horlacher <framstag@rus.uni-stuttgart.de>:

> On Sat 2016-11-26 (11:27), Kai Krakow wrote:
> 
> > > I have vmware and virtualbox VMs on btrfs SSD.  
> 
> > As a side note: I don't think you can use "nodatacow" just for one
> > subvolume while the other subvolumes of the same btrfs are mounted
> > different. The wiki is just wrong here.
> > 
> > The list of possible mount options in the wiki explicitly lists
> > "nodatacow" as not working per subvolume - just globally for the
> > whole fs.  
> 
> Thanks for pointing this out!
> I have misunderstood this, first.

You can, however, use chattr to make the subvolume root directory (that
one where it is mounted) nodatacow (chattr +C) _before_ placing any
files or directories in there. That way, newly created files and
directories will inherit the flag. Take note that this flag can only
applied to directories and empty (zero-sized) files.

That way, you get the intended benefit and your next question applies a
little less because:

> Ok, then next question :-)
> 
> What is better (for a single user workstation): using mount option
> "autodefrag" or call "btrfs filesystem defragment -r" (-t ?) via
> nightly cronjob?
> 
> So far, I use neither.

When using the above method to make your VM images nodatacow, the only
fragmentation issue you need to handle is when doing snapshots.
Snapshots are subject to copy-on-write. If you do heavy snapshotting,
you'll be getting heavy fragmentation based on the write-patterns. I
don't know if autodefrag will handle nodatacow files. You may want to
use a dedupe utility after defragmentation, like duperemove (running
it manually) or bees (a background daemon also trying to keep
fragmentation low).

If you are doing no or infrequent snapshots, I won't bother with manual
defragging at all for your VM images since you're on SSD. If you aren't
going to use snapshots at all, you even won't have to think about
autodefrag, tho I still recommend to enable it (see post from Duncan).

Manual defrag is a highly write-intensive operation, rewriting multiple
gigabytes of data. I strongly recommend against using it on a daily
basis for SSD.

-- 
Regards,
Kai

Replies to list-only preferred.

