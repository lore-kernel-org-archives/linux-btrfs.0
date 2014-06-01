Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-6.server.virginmedia.net ([80.0.253.70]:45668
	"EHLO know-smtprelay-omc-6.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaFAUpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Jun 2014 16:45:05 -0400
Message-ID: <538B8F76.9090500@petezilla.co.uk>
Date: Sun, 01 Jun 2014 21:39:18 +0100
From: Peter Chant <pete@petezilla.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: All free space eaten during defragmenting (3.14)
References: <1703083.hLnNuPsKpY@linux-suse.hu> <pan$d1ec3$d22b3db$8681b9b1$d9742e40@cox.net>
In-Reply-To: <pan$d1ec3$d22b3db$8681b9b1$d9742e40@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a question that has arisen from reading one of Duncan's posts:

On 06/01/2014 01:56 AM, Duncan wrote:

> Here's the deal.  Due to scaling issues the original snapshot aware 
> defrag code was recently disabled, so defrag now doesn't worry about 
> snapshots, only defragging whatever is currently mounted.  If you have a 
> lot of fragmentation and are using snapshots, the defrag will copy all 
> those fragmented files in ordered to defrag them, thus duplicating their 
> blocks and doubling their required space.  Based on the title alone, 
> that's what I /thought/ happened, and given what you did /not/ say, I 
> actually still think it is the case and the below assumes that, tho I'm 
> no longer entirely sure.

The above implies to me that snapshots should not normally be mounted?
I may have misread the intent.

* * *

My thought is that I have a btrfs to hold data on my system, it contains
/home in a subvolume and also subvolumes for various other things.  I
take daily, hourly and weekly snapshots and my script does delete old
ones after a while.

I also mount the base/default btrfs file system on /mnt/data-pool.  This
means that my snapshots are available in their own subdirectory, so I
presume this means that they are mounted, if not in their own right, at
least they are as part of the default subvolume.  Given the
defragmentation discussion above should I be doing this or should my
setup ensure that they are not normally mounted?

I'm not aware of how you would create a subvolume that was outside of a
mounted part of the file system 'tree' - so if I did not want my
subvolumes mounted and I wanted snapshots then I'd have to mount the
default subvolume, make snapshots, and then unmount it?  This seems a
bit clumsy and I'm not convinced that this is a sensible plan.  I don't
think this is right, can anyone confirm or deny?

I do note I get pauses every so often for a second or two or three while
I believe btrfs is doing 'stuff'.  Although annoying I do find I am
prepared to live with this as the subvolumes and snap-shotting are
valuable to me.

Pete


-- 
Peter Chant
