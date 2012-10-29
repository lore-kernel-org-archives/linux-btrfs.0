Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46042 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab2J2Rtw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 13:49:52 -0400
Date: Mon, 29 Oct 2012 10:48:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Need help mounting laptop corrupted root btrfs. Kernel BUG at
 fs/btrfs/volumes.c:3707 - FIXED
Message-ID: <20121029174802.GB7796@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121029154713.GF8019@merlins.org>
 <B19885DE-6AED-4B8B-B1CA-891878B43C8C@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First, I used another tool to see how the FS looked like, and maybe in
the hopes of having a list of subvolumes without mounting it:

gandalfthegreat:~# btrfs-calc-size /dev/mapper/bootdsk
Calculating size of root tree
	180.00KB total size, 0.00 inline data, 1 nodes, 44 leaves, 2 levels
Calculating size of extent tree
	387.90MB total size, 0.00 inline data, 1423 nodes, 97879 leaves, 4 levels
Calculating size of csum tree
	440.88MB total size, 0.00 inline data, 1425 nodes, 111441 leaves, 4 levels
Calculatin' size of fs tree
	20.00KB total size, 0.00 inline data, 1 nodes, 4 leaves, 2 levels

Then, I figured, I'd try mounting all the active snapshots one per one,
and they worked:

[330514.202529] device label btrfs_pool2 devid 1 transid 39698 /dev/dm-0
[330514.203337] device label btrfs_pool1 devid 1 transid 145479 /dev/dm-1
[330629.438572] device label btrfs_pool1 devid 1 transid 145479 /dev/mapper/bootdsk
[330629.439208] btrfs: use lzo compression
[330629.439213] btrfs: not using ssd allocation scheme
[330629.439216] btrfs: disk space caching is enabled
[330653.208718] device label btrfs_pool1 devid 1 transid 145479 /dev/mapper/bootdsk
[330658.854162] device label btrfs_pool1 devid 1 transid 145479 /dev/mapper/bootdsk
[330661.786204] btrfs: unlinked 25 orphans
[330708.314984] device label btrfs_pool1 devid 1 transid 145480 /dev/mapper/bootdsk
[330708.675443] btrfs: unlinked 165 orphans
[330721.558581] device label btrfs_pool1 devid 1 transid 145480 /dev/mapper/bootdsk
[330721.583214] btrfs: unlinked 9 orphans

After that, I was able to mount the root (volid 0) without a crash and
my filesystem looks fine again.

So as far as I can tell, my filesystem is not badly corrupted, and there
was just a small bit that triggered a bug in the mounting code.
Somehow mounting subvolumes separately cleared the state that triggered
the bug, which I can't quite explain.

If someone cares, I made a dd image of the FS to a file on a backup
server, but if not, I'll just delete it.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
