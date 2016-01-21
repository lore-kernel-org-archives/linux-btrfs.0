Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56519 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957AbcAUExD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 23:53:03 -0500
Date: Wed, 20 Jan 2016 20:52:39 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: bdev /dev/mapper/dshelf1 errs: wr 2970, rd 848, flush 0,
 corrupt 189, gen 0
Message-ID: <20160121045239.GQ17679@merlins.org>
References: <20160118124533.GU422@carfax.org.uk>
 <pan$6d745$1ec4d122$7401737e$1adc2b07@cox.net>
 <20160118233943.GF17679@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160118233943.GF17679@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 18, 2016 at 03:39:43PM -0800, Marc MERLIN wrote:
> Thanks for that other hint.
> It was created quite a while ago (1y+), and ran ok until I had an
> unexpected crash.
> If I have to rebuild it, I will, but that will take 2 days+ due to the 
> size and getting the backup back (well also, I'm not home for a week, so
> restoring backups remotely isn't going to be fun).
> 
> But sure enough, while it ran perfectly fine for a long time, after check --repair,
> my machine is now crashing every hour or so, with the crash below.

I ran check --repair a few more times on it but it does not seem to converge.
The bad extent stuff, I understand cannot be fixed (although it's not obvious from check
--repair that they are not getting fixed).

But how about 
root 45940 inode 204450 errors 1000, some csum missing
Are those getting fixed by check --repair or are they unfixable too?
 
(...)
bad extent [8697338126336, 8697338130432), type mismatch with chunk
bad extent [8697338130432, 8697338134528), type mismatch with chunk
repaired damaged extent references

Fixed 0 roots.
cache and super generation don't match, space cache will be invalidated
rootk262 inodeo204450 errors 1000, some csum missing
root 262 inode 204452 errors 1000, some csum missing
(...)
root 45940 inode 204450 errors 1000, some csum missing
root 45940 inode 204452 errors 1000, some csum missing
root 45944 inode 204450 errors 1000, some csum missing
root 45944 inode 204452 errors 1000, some csum missing
root 45948 inode 204450 errors 1000, some csum missing
root 45948 inode 204452 errors 1000, some csum missing
checking fs roots [o]
checking csums
checking root refs
found 9826295305149 bytes used err is 0
total csum bytes: 9584154948
total tree bytes: 12201304064
total fs tree bytes: 330776576
total extent tree bytes: 498921472
btree space waste bytes: 1373183541
file data blocks allocated: 9953275256832
 referenced 9964596801536
btrfs-progs v4.3


Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
