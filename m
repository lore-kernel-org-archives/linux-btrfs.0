Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36231 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab3IYSrX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 14:47:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VOu7N-0002Cx-Dj
	for linux-btrfs@vger.kernel.org; Wed, 25 Sep 2013 20:47:21 +0200
Received: from 78-32-127-104.static.enta.net ([78.32.127.104])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 20:47:21 +0200
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 20:47:21 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Plumbley-Jones <alex@bpmit.com>
Subject: Easy Q: reset space cache updated?
Date: Wed, 25 Sep 2013 18:47:02 +0000 (UTC)
Message-ID: <loom.20130925T201609-904@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I had been clearing the space cache on my btrfs vol (Debian 3.10.11-1
btrfs-tools 2013-7-5) by changing the fstab to "nospace_cache, clear_cache".

I ran btrfsck --repair and it said: 

"cache and super generation don't match, space cache will be invalidated."

Can one of the dev's please tell me whether that message means that the
space cache regeneration is now being triggered as a part this btrfsck run
(so my tinkering with fstab mount options is self-defeating)?

If no please can someone confirm that 
http://comments.gmane.org/gmane.comp.file-systems.btrfs/21256
is still the correct procedure to use to clear the cache.

Still very happy with how well btrfs is working for me.

Thank you.



Al.

PS: I think that there may be a problem with having a non-default boot
subvol with autodefrag mount option but can't consistently reproduce in
haste. I've moved to the explicit subvol=@ in the kernel load and the
eventual hang has gone.

I have a ext based /boot but the remaining system is installed to a subvol
to allow snapshots on it. Works fine (with above caveat) and is easy to do.



