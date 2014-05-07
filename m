Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37141 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaEGH7K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 03:59:10 -0400
Date: Wed, 7 May 2014 00:59:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does "btrfs fi show" show full?
Message-ID: <20140507075902.GL10159@merlins.org>
References: <20140505005412.GS9061@merlins.org>
 <53670F70.1010509@swiftspirit.co.za>
 <20140505055029.GM10159@merlins.org>
 <pan$1f225$3bfd5829$2b5ac65b$4bb85dc6@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$1f225$3bfd5829$2b5ac65b$4bb85dc6@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 06, 2014 at 08:10:00PM +0000, Duncan wrote:
> Marc MERLIN posted on Sun, 04 May 2014 22:50:29 -0700 as excerpted:
> 
> > In the second FS:
> >> >Label: btrfs_pool1  uuid: [...]
> >> >	Total devices 1 FS bytes used 442.17GiB
> >> >	devid    1 size 865.01GiB used 751.04GiB path [...]
> > 
> > The difference is huge between 'Total used' and 'devid used'.
> > 
> > Is btrfs going to fix this on its own, or likely not and I'm stuck doing
> > a full balance (without filters since I'm balancing data and not
> > metadata)?
> > 
> > If that helps.
> > legolas:~# btrfs fi df /mnt/btrfs_pool1
> > Data, single: total=734.01GiB, used=435.29GiB
> > System, DUP: total=8.00MiB, used=96.00KiB
> > System, single: total=4.00MiB, used=0.00
> > Metadata, DUP: total=8.50GiB, used=6.74GiB
> > Metadata, single: total=8.00MiB, used=0.00
> 
> Definitely helps.  The spread is in data.
> 
> Try
> 
> btrfs balance start -dusage=20 /mnt/btrfs_pool1

So, I had already tried -dusage=50 yesterday, and I'm now reasonable:
Label: btrfs_pool1  uuid: 4850ee22-bf32-4131-a841-02abdb4a5ba6
	Total devices 1 FS bytes used 443.22GiB
	devid    1 size 865.01GiB used 514.04GiB path /dev/mapper/cryptroot


> something like -dusage=50 or -dusage=80, likely MUCH faster, but will 
> return less chunks to unallocated, as well.  Still, your spread between 

(fewer)

> data-total and data-used is high enough, I expect -dusage=20 will give 
> you pretty good results.

So, on
On http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
I wrote
In the case above, because the filesystem is only 55% full, I can ask
balance to rewrite all chunks that are more than 55% full:
legolas:~# btrfs balance start -dusage=55 /mnt/btrfs_pool1

Did I get this right?
I'm not sure I did, since it seems the bigger the -dusage number, the
more work balance has to do.

If I asked -dsuage=85, it would do all chunks that are more than 15%
full?
So, do I need to change the text above to say "more than 45% full" ?

More generally, does it not make sense to just use the same percentage
in -dusage than the percentage of total filesytem full?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
