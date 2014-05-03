Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33876 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaEDFqd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 01:46:33 -0400
Received: from i118-21-136-4.s30.a048.ap.plala.or.jp ([118.21.136.4]:31718 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WgpFw-0000am-P3 by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 22:46:32 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WgjKj-0002R2-R8
	for linux-btrfs@vger.kernel.org; Sat, 03 May 2014 16:27:05 -0700
Date: Sat, 3 May 2014 16:27:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Is metadata redundant over more than one drive with raid0 too?
Message-ID: <20140503232702.GC9061@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, I was thinking. In the past, I've done this:
mkfs.btrfs -d raid0 -m raid1 -L btrfs_raid0 /dev/mapper/raid0d*

My rationale at the time was that if I lose a drive, I'll still have
full metadata for the entire filesystem and only missing files.
If I have raid1 with 2 drives, I should end up with 4 copies of each
file's metadata, right?

But now I have 2 questions
1) btrfs has two copies of all metadata on even a single drive, correct?
If so, and I have a -d raid0 -m raid0 filesystem, are both copies of the
metadata on the same drive or is btrfs smart enough to spread out
metadata copies so that they're not on the same drive?

2) does btrfs lay out files on raid0 so that files aren't striped across
more than one drive, so that if I lose a drive, I only lose whole files,
but not little chunks of all my files, making my entire FS toast?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
