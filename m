Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58041 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaA2Hu0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 02:50:26 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1W8Puj-0003YE-IJ
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2014 23:50:25 -0800
Date: Tue, 28 Jan 2014 23:50:25 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Can you keep reflink relationship during a copy/backup to another filesystem?
Message-ID: <20140129075025.GM14998@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I used to use hardlinks to do historical backups of the same filesystem
but I know it's preferable to use refllink with btrfs to avoid having too
many hardlinks.

But if I need to backup this filesystem to another one some other way than
btrfs send/receive (let's say cp -a, tar, or rsync), is it correct to say
that reflink relationships will be lost and my data will take more space?

That is unless the target filesytem can do deduplication like btrs now can?
(I haven't tried it yet, but it's about time that I do)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
