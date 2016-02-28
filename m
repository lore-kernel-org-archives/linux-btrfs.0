Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43312 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809AbcB1BEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Feb 2016 20:04:39 -0500
Date: Sat, 27 Feb 2016 17:04:36 -0800
From: Marc MERLIN <marc@merlins.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair is clean, but mount fails
Message-ID: <20160228010436.GQ19699@merlins.org>
References: <20160227023938.GB5286@merlins.org>
 <20160227024533.GB11954@localhost.localdomain>
 <20160227030304.GC5286@merlins.org>
 <20160227180606.GA27358@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160227180606.GA27358@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 27, 2016 at 10:06:06AM -0800, Liu Bo wrote:
> Can you grep this message since btrfs dev scan has a "printf("Scanning for Btrfs filesystems\n");"?
> And if a scan failed somehow, it may print an error after this message
> and we then know what was happening..

I'm not seeing anything in my console boot log outside of this posted in
my previous message:

Fri Feb 26 14:55:17 2016: raid0d1 (started)...raid0d2 (starting)...
Fri Feb 26 14:55:18 2016: raid0d2 (started)...done.

> > I'm looking at my boot:
> > [  112.063677] BTRFS: device label btrfs_space devid 1 transid 776782 /dev/mapper/raid0d1
> > [  112.090192] BTRFS info (device dm-6): disk space caching is enabled
> > [  112.111740] BTRFS: failed to read the system array on dm-6
> > [  112.160047] BTRFS: open_ctree failed
> > [  112.269710] BTRFS info (device dm-6): disk space caching is enabled
> > [  112.291430] BTRFS: failed to read the system array on dm-6
> > [  112.320104] BTRFS: open_ctree failed
> > 
> > So dm-6 is: raid0d1 -> ../dm-6

btrfs dev scan didn't output any messages from what I can tell, outside
of the dmesg stuff here.

The total messages around that time:
[  110.182362] bcache: bch_journal_replay() journal replay done, 92 keys in 6 entries, seq 8855
[  110.208992] bcache: register_cache() registered cache device dm-4
[  110.236345] bcache: register_bdev() registered backing device dm-1
[  110.316129] bcache: bch_cached_dev_attach() Caching dm-1 as bcache1 on set 0226553a-37cf-41d5-b3ce-8b1e944543a8
[  110.348350] bcache: register_bcache() error opening /dev/md5: device already registered
[  110.445200] Adding 15616764k swap on /dev/mapper/eswap1.  Priority:-1 extents:1 across:15616764k FS
[  111.585812] EXT4-fs (md11): mounted filesystem with ordered data mode. Opts: (null)
[  112.063677] BTRFS: device label btrfs_space devid 1 transid 776782 /dev/mapper/raid0d1
[  112.090192] BTRFS info (device dm-6): disk space caching is enabled
[  112.111740] BTRFS: failed to read the system array on dm-6
[  112.160047] BTRFS: open_ctree failed
[  112.269710] BTRFS info (device dm-6): disk space caching is enabled
[  112.291430] BTRFS: failed to read the system array on dm-6
[  112.320104] BTRFS: open_ctree failed
[  112.332567] BTRFS: device label dshelf1 devid 1 transid 25903 /dev/bcache1
[  112.333076] BTRFS info (device bcache1): disk space caching is enabled
[  112.333077] BTRFS: has skinny extents
[  115.185582] BTRFS: detected SSD devices, enabling SSD mode
[  115.216381] BTRFS: device label dshelf2 devid 1 transid 444834 /dev/mapper/dshelf2
[  115.241607] BTRFS info (device dm-2): disk space caching is enabled
[  115.591923] BTRFS info (device dm-2): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0, flush 0, corrupt 65, gen 0

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
