Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52797 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbbKMUCY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 15:02:24 -0500
Date: Fri, 13 Nov 2015 12:01:58 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20151113200158.GA18943@merlins.org>
References: <20151113174101.GC19249@merlins.org>
 <pan$d16ba$8434e942$7cc09c55$439d7a74@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$d16ba$8434e942$7cc09c55$439d7a74@cox.net>
Subject: Re: Where is the disk space?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 13, 2015 at 07:45:21PM +0000, Duncan wrote:
> Marc MERLIN posted on Fri, 13 Nov 2015 09:41:01 -0800 as excerpted:
> 
> > Any ideas?
> 
> Without addressing the main question, a couple targets of opportunity:
> 
> 1) A quick balance with -mprofiles=single should kill those unused single 
> metadata and system mkfs.btrfs legacies so you don't have to see them in 
> fi df.
> 
> 2) While fi df reports the data total vs. used spread being close enough 
> that it's unsurprising a balance -dusage=80 didn't give you anything 
> back, the spread on metadata is rather higher, dup, 6.0 gig total, less 
> than 1 gig used, so a balance -musage=50 or 80 should return a few gigs, 
> 4-5 I'd guess, leaving you 1-2 gig metadata total.

Well, -musage helped, I didn't know about that one, thanks:
root@polgara:/mnt/btrfs_root# btrfs fi show .
Label: 'btrfs_root'  uuid: a2a1ed7b-6bfe-4e83-bc10-727126ed17bf
        Total devices 1 FS bytes used 39.09GiB
        devid    1 size 55.88GiB used 51.88GiB path /dev/sdb5

btrfs-progs v4.0-dirty
root@polgara:/mnt/btrfs_root# btrfs balance start -musage=80 -v /mnt/btrfs_root
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=80
  SYSTEM (flags 0x2): balancing, usage=80
Done, had to relocate 14 out of 55 chunks
root@polgara:/mnt/btrfs_root# btrfs fi show .
Label: 'btrfs_root'  uuid: a2a1ed7b-6bfe-4e83-bc10-727126ed17bf
        Total devices 1 FS bytes used 39.75GiB
        devid    1 size 55.88GiB used 41.91GiB path /dev/sdb5

btrfs-progs v4.0-dirty
root@polgara:/mnt/btrfs_root# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb5        56G   41G   15G  74% /mnt/btrfs_root

I'm still seeing 39GB used for 28GB of actual data, but I definitely
fixed one bit already thanks to you.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
