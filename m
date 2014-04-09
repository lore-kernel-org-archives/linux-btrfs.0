Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33544 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaDIEb1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 00:31:27 -0400
Date: Tue, 8 Apr 2014 21:31:25 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Upgrade to 3.14.0 messed up raid0 array (btrfs cleaner crashes in fs/btrfs/extent-tree.c:5748 and fs/btrfs/free-space-cache.c:1183 )
Message-ID: <20140409043125.GI10789@merlins.org>
References: <20140408153609.GE23524@merlins.org> <20140408220903.GV9923@merlins.org> <53448AFA.4080601@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53448AFA.4080601@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 08, 2014 at 07:49:14PM -0400, Chris Mason wrote:
> 
> 
> On 04/08/2014 06:09 PM, Marc MERLIN wrote:
> >I forgot to add that while I'm not sure if anyone ended up looking at the
> >last image I made regarding
> >https://bugzilla.kernel.org/show_bug.cgi?id=72801
> >
> >I can generate a an image of that filesystem if that helps, or try other
> >commands which hopefully won't crash my running server :)
> >(filesystem is almost 2TB, so the image will again be big)
> >
> 
> Hi Marc,
> 
> So from the messages it looks like your space cache is corrupted.  Lets 
> start with clearing the space cache and running fsck and seeing exactly 
> what is wrong.

gargamel:~# mount  -o clear_cache /dev/dm-4 /mnt/mnt
[48132.661274] BTRFS: device label btrfs_raid0 devid 1 transid 50567 /dev/mapper/raid0d1
[48132.703063] BTRFS info (device dm-5): force clearing of disk cache
[48132.724780] BTRFS info (device dm-5): disk space caching is enabled

Mmmh, I've never had much luck with btrfsck

> An image will definitely help if you have a pipe big enough to upload it.

Mmmh, I guess I should have taken this before the clear_cache mount, but
even after that, I still got the crash, so let me take an image first

Then, what fsck options do you recommend?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
