Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42553 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbcEOMMc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 08:12:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b1uuG-0006EK-13
	for linux-btrfs@vger.kernel.org; Sun, 15 May 2016 14:12:24 +0200
Received: from 145.132.48.198 ([145.132.48.198])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 14:12:24 +0200
Received: from ftoth by 145.132.48.198 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 14:12:24 +0200
To: linux-btrfs@vger.kernel.org
From: Ferry Toth <ftoth@exalondelft.nl>
Subject: Hot data tracking / hybrid storage
Date: Sun, 15 May 2016 12:12:09 +0000 (UTC)
Message-ID: <nh9p2p$cns$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is there anything going on in this area?

We have btrfs in RAID10 using 4 HDD's for many years now with a rotating 
scheme of snapshots for easy backup. <10% files (bytes) change between 
oldest snapshot and the current state. 

However, the filesystem seems to become very slow, probably due to the 
RAID10 and the snapshots.

It would be fantastic if we could just add 4 SSD's to the pool and btrfs 
would just magically prefer to put often accessed files there and move 
older or less popular files to the HDD's.

In my simple mind this can not be done easily using bcache as that would 
require completely rebuilding the file system on top of bcache (can not 
just add a few SSD's to the pool), while implementing a cache inside btrfs 
is probably a complex thing with lots of overhead.

Simply telling the allocator to prefer new files to go to the ssd and 
move away unpopular stuff to hdd during balance should do the trick, or am 
I wrong?

Are none of the big users looking into this?

Ferry

