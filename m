Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49252 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbaGDNWU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 09:22:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X33RQ-0004nq-S8
	for linux-btrfs@vger.kernel.org; Fri, 04 Jul 2014 15:22:16 +0200
Received: from p5b0045d7.dip0.t-ipconnect.de ([91.0.69.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Jul 2014 15:22:16 +0200
Received: from holger.hoffstaette by p5b0045d7.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Jul 2014 15:22:16 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: More candidates for 3.14 longterm fixes?
Date: Fri, 4 Jul 2014 13:22:02 +0000 (UTC)
Message-ID: <pan.2014.07.04.13.22.02@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

As Greg announced that 3.14 will be longterm I was wondering if we
can find a few more candidates for backported fixes.

So far I've had a couple handpicked and in (admittedly light) use
without problems, which apply cleanly to 3.14.10. 

Can we/should we find more?

My candidates so far:

Fix hang on error (such as ENOSPC) when writing extent pages:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/btrfs?id=61391d562229ed94899ed4b4973dc2f0c015292a

Ensure btrfs_prev_leaf doesn't miss 1 item:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/btrfs?id=337c6f6830a5ceb650eaf10d38ed8e8f496c8f61

Fix leaf corruption after __btrfs_drop_extents:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/btrfs?id=0b43e04f700bce8eecf3581612e9d3e15bf258bc

There may be more, but these are ones I picked off the list and
managed to apply without fixing up.

Since 3.14 will see continued use I think it would be great to
get a few more known knowns into a release that works reasonably well,
unlike (say) 3.15 so far.. :/

Any other suggestions or is this a terrible idea? :)

thanks
Holger

