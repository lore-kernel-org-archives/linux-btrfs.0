Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60307 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbcBKPOH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 10:14:07 -0500
Date: Thu, 11 Feb 2016 07:13:39 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <20160211151339.GZ13969@merlins.org>
References: <20160123170354.GA10113@merlins.org>
 <56A57C59.1040203@cn.fujitsu.com>
 <20160125205500.GK23751@merlins.org>
 <56A6C5CB.5060406@cn.fujitsu.com>
 <20160211063132.GX13969@merlins.org>
 <56BC355F.1080305@cn.fujitsu.com>
 <20160211150947.GY13969@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160211150947.GY13969@merlins.org>
Subject: Re: btrfs-image failure (btrfs-tools 4.4)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2016 at 07:09:47AM -0800, Marc MERLIN wrote:
> On Thu, Feb 11, 2016 at 03:16:47PM +0800, Qu Wenruo wrote:
> > >I started making a dump, image was growing past 3GB, and then it failed
> > >and the image got deleted:
> > >
> > >gargamel:~# btrfs-image -s -c 9 /dev/mapper/dshelf1old /mnt/dshelf1/ds1old.dump
> > >Error adding space cache blocks -5
> > 
> > It seems that btrfs-image failed to read space cache, in
> > read_data_extent() function.
> > 
> > And since there is no "Couldn't map the block XXXX" error message,
> > either some device is missing or pread64 failed to read the desired
> > data.
>  
> It's a 5 drive raid5 underneath, all drives are there.
> 
> > >Is there a 4G file size limit, or did I hit another problem?
> > 
> > For the 4G file size limit, did you mean the limit from old
> > filesystem like FAT32?
>  
> No, I wrote on btrfs, so it's not a filesystem limit, but I meant that
> maybe if there was a 32bit pointer somewhere, it could have caused this.
> I did use the 64bit version of the tools on a 64bit kernel though, so I
> don't see why it could have happened.
> 
> > I didn't think there is such limit for modern Linux filesystem, or
> > normal read/write operation won't has such limit either.
> 
> Agreed.
> 
> At this point, is there anything else I should get/do before I wipe this
> filesystem?
 
I should note that I can mount it fine and read/write to it.
I also ran fsck check --repair on it more than once.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
