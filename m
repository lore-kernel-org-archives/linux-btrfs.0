Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52100 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753786AbaCNDhX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 23:37:23 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:61141 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WOIvx-003UwL-3P
	for linux-btrfs@vger.kernel.org; Thu, 13 Mar 2014 21:37:21 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Incremental backup for a raid1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <532257E0.9040104@benjamindsmith.com>
Date: Thu, 13 Mar 2014 21:37:20 -0600
Message-Id: <F01AA34C-45B9-4EFB-9200-40A4DB336685@colorremedies.com>
References: <1564384.fRV1HUkfCq@fuchsia> <5491122.Fap633Kp83@fuchsia> <0AD708D8-5380-465E-8119-DD6FDD1BF1BA@colorremedies.com> <2106363.nA97oxn4hn@fuchsia> <53224D57.8020308@chinilu.com> <532257E0.9040104@benjamindsmith.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 13, 2014, at 7:14 PM, Lists <lists@benjamindsmith.com> wrote:
> 
> I'm assuming that BTRFS send/receive works similar to ZFS's similarly named feature.

Similar yes but not all options are the same between them. e.g. zfs send -R replicates all descendent file systems. I don't think zfs requires volumes, filesystems, or snapshots to be read-only, whereas btrfs send only works on read only snapshot-subvolumes. There has been some suggestion of a recursive snapshot creation and recursive send for btrfs.

> So just I don't get the "backup" problem. Place btrfs' equivalent of a pool on the external drive, and use send/receive of the filesystem or snapshot(s). Does BTRFS work so differently in this regard? If so, I'd like to know what's different.

Top most thing in zfs is the pool, which on btrfs is the volume. Neither zfs send or btrfs send works on this level to send everything within a pool/volume. zfs has the file system and btrfs has the subvolume which can be snapshot. Either (or both) can be used with send. 

zfs also has the volume which is a block device that can be snapshot, there isn't yet a btrfs equivalent.

Btrfs and zfs have clones but the distinction is stronger with zfs. Like zfs snapshots can't be deleted unless its clones are deleted. Btrfs send has a -c clone-src option that I don't really understand, and also the --reflink which is a clone at the file level.

Anyway there are a lot of similarities but also quite a few differences. Basic functionality seems pretty much the same.


> 
> My primary interest in BTRFS vs ZFS is two-fold:
> 
> 1) ZFS has a couple of limitations that I find disappointing, that don't appear to be present in BTRFS.
>    A) Inability to upgrade a non-redundant ZFS pool/vdev to raidz or increase the raidz (redundancy) level after creation. (Yes, you can plan around this, but I see no good reason to HAVE to)
>    B) Inability to remove a vdev once added to a pool.
> 
> 2) Licensing: ZFS on Linux is truly great so far in all my testing, can't throw enough compliments their way, but I would really like to rely on a "first class citizen" as far as the Linux kernel is concerned.


3. On btrfs you can delete a parent subvolume and the children remain. On zfs, you can't destroy a zfs filesystem/volume unless its snapshots are deleted, and you can't delete snapshots unless their clones are deleted.


Chris Murphy

