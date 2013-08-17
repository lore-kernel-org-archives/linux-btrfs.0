Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49648 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3HQQFY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 12:05:24 -0400
Received: from mm-gw.merlins.org ([173.11.111.150]:55100 helo=gandalfthegreat.merlins.org)
	by mail1.merlins.org with esmtpa (Exim 4.80 #2)
	id 1VAihz-0003No-3H by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 08:46:31 -0700
Received: from merlin by gandalfthegreat.merlins.org with local (Exim 4.77)
	(envelope-from <merlin@gandalfthegreat.merlins.org>)
	id 1VAihv-000870-Cg
	for linux-btrfs@vger.kernel.org; Sat, 17 Aug 2013 08:46:27 -0700
Date: Sat, 17 Aug 2013 08:46:27 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs raid5 recovery with >1 half failed drive, or multiple drives
 kicked out at the same time.
Message-ID: <20130817154627.GG12805@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I know the raid5 code is still new and being worked on, but I was
curious.

With md raid5, I can do this:
mdadm /dev/md7 --replace /dev/sde1

This is cool because it lets you replace a drive with bad sectors where
at least one other drive in the array has bad sectors, and the md layer
will read all drives for each stripe and write to a new drive.
The nice part is that it'll take the working parts of each drive, and as
long as no 2 drives have an unreadable sector for the same stripe, it
can recover.

I was curious, how does btrfs handle this situation, and more generally
drive failures, spurious multiple drive failures due to a bus blip where
you force the drives back online, and so forth?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
