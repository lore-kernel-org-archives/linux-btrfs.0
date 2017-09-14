Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43361 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdINLie (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 07:38:34 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dsSTQ-0007UW-SR
        for linux-btrfs@vger.kernel.org; Thu, 14 Sep 2017 13:38:24 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: defragmenting best practice?
Date: Thu, 14 Sep 2017 13:38:24 +0200
Message-ID: <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170912162843.GA32233@rus.uni-stuttgart.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 12 Sep 2017 18:28:43 +0200
schrieb Ulli Horlacher <framstag@rus.uni-stuttgart.de>:

> On Thu 2017-08-31 (09:05), Ulli Horlacher wrote:
> > When I do a 
> > btrfs filesystem defragment -r /directory
> > does it defragment really all files in this directory tree, even if
> > it contains subvolumes?
> > The man page does not mention subvolumes on this topic.  
> 
> No answer so far :-(
> 
> But I found another problem in the man-page:
> 
>   Defragmenting with Linux kernel versions < 3.9 or >= 3.14-rc2 as
> well as with Linux stable kernel versions >= 3.10.31, >= 3.12.12 or
> >= 3.13.4 will break up the ref-links of COW data (for example files
> >copied with
>   cp --reflink, snapshots or de-duplicated data). This may cause
>   considerable increase of space usage depending on the broken up
>   ref-links.
> 
> I am running Ubuntu 16.04 with Linux kernel 4.10 and I have several
> snapshots.
> Therefore, I better should avoid calling "btrfs filesystem defragment
> -r"?
> 
> What is the defragmenting best practice?
> Avoid it completly?

You may want to try https://github.com/Zygo/bees. It is a daemon
watching the file system generation changes, scanning the blocks and
then recombines them. Of course, this process somewhat defeats the
purpose of defragging in the first place as it will undo some of the
defragmenting.

I suggest you only ever defragment parts of your main subvolume or rely
on autodefrag, and let bees do optimizing the snapshots.

Also, I experimented with adding btrfs support to shake, still working
on better integration but currently lacking time... :-(

Shake is an adaptive defragger which rewrites files. With my current
patches it clones each file, and then rewrites it to its original
location. This approach is currently not optimal as it simply bails out
if some other process is accessing the file and leaves you with an
(intact) temporary copy you need to move back in place manually.

Shake works very well with the idea of detecting how defragmented, how
old, and how far away from an "ideal" position a file is and exploits
standard Linux file systems behavior to optimally placing files by
rewriting them. It then records its status per file in extended
attributes. It also works with non-btrfs file systems. My patches try
to avoid defragging files with shared extents, so this may help your
situation. However, it will still shuffle files around if they are too
far from their ideal position, thus destroying shared extents. A future
patch could use extent recombining and skip shared extents in that
process. But first I'd like to clean out some of the rough edges
together with the original author of shake.

Look here: https://github.com/unbrice/shake and also check out the pull
requests and comments there. You shouldn't currently run shake
unattended and only on specific parts of your FS you feel need
defragmenting.


-- 
Regards,
Kai

Replies to list-only preferred.

