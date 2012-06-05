Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54387 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab2FEDBF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 23:01:05 -0400
Received: from [186.101.14.83] (port=51936 helo=gandalfthegreat.merlins.org)
	by mail1.merlins.org with esmtpa (Exim 4.77 #2)
	id 1Sbk12-0008DK-0i by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 20:01:04 -0700
Received: from merlin by gandalfthegreat.merlins.org with local (Exim 4.77)
	(envelope-from <merlin@gandalfthegreat.merlins.org>)
	id 1Sbk0y-000566-Qp
	for linux-btrfs@vger.kernel.org; Mon, 04 Jun 2012 20:01:00 -0700
Date: Mon, 4 Jun 2012 20:01:00 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Recovering a file from a snapshot without duplicating its blocks
 (--reflink across devs?)
Message-ID: <20120605030100.GA7572@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit a problem on my laptop, I had about 40GB free, and I screwed up a
36GB virtualbox image.
No biggie, I have netapp style snapshots, so I deleted my messed up VM
image, and figured I only had to copy the last image from my hourly
snapshot.

First I though, I sure would be nice if I could take btrfs to reference
the same blocks from the snapshot to my current image.
But, --reflink failed across devices nodes, so I was forced to
copy/duplicate the blocks (36GB).

Then, by getting down to less than 10GB free, I got into the dark
corners of the btrfs code where writes would just hang, or take 10H to
copy an extra 1GB, while copiously hanging the system.

In the end, I never was able to recover the system without copying the
snapshot VM image to 3rd party storage, deleting the snapshot, then
getting enough blocks of free space, and finally being able to copy my
36GB image back on my /home partition.

This was very slow and painful and required power cycle my laptop more
than once while it was very close to being fully hung (in real life, it
was just unusable and stuck on disk IO but not fully hung).
Was there a better way?

I had 3.2.16 at the time and now have 3.4.0.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
