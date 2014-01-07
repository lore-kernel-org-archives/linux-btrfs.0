Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40300 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaAGKtz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2014 05:49:55 -0500
Date: Tue, 7 Jan 2014 02:49:51 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is anyone using btrfs send/receive howto?
Message-ID: <20140107104951.GL10936@merlins.org>
References: <20131228171943.GE19863@merlins.org>
 <20131228173730.GA7234@carfax.org.uk>
 <20131228180758.GF19863@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131228180758.GF19863@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I read different howtos on the wiki and oracle docs, but I can't get it
to work:

legolas:/mnt/btrfs_pool1# btrfs subvolume snapshot -r tmp tmp_read_only_new
Create a readonly snapshot of 'tmp' in './tmp_read_only_new'
legolas:/mnt/btrfs_pool1# sync
legolas:/mnt/btrfs_pool1# btrfs send tmp_read_only_new | btrfs receive /mnt/btrfs_pool2/
At subvol tmp_read_only_new
At subvol tmp_read_only_new

# Make a new snapshot later and try to sync it:
legolas:/mnt/btrfs_pool1# mv tmp_read_only_new tmp_read_only
legolas:/mnt/btrfs_pool1# btrfs subvolume snapshot -r tmp tmp_read_only_new
Create a readonly snapshot of 'tmp' in './tmp_read_only_new'
legolas:/mnt/btrfs_pool1# btrfs send -p tmp_read_only  tmp_read_only_new | btrfs receive /mnt/btrfs_pool2/
At subvol tmp_read_only_new
At snapshot tmp_read_only_new
ERROR: creating snapshot tmp_read_only_new -> tmp_read_only_new failed. File exists

This is where I get stuck:
Obviously /mnt/btrfs_pool2/tmp_read_only_new already exists since it's the reference backup volume.

What am I doing wrong?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
