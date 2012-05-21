Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40277 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2EUFWU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 May 2012 01:22:20 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1SWL4W-0005uC-5Y
	for <linux-btrfs@vger.kernel.org>; Sun, 20 May 2012 22:22:20 -0700
Date: Sun, 20 May 2012 22:22:20 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Which kernel is safe to upgrade to for btrfs?
Message-ID: <20120521052220.GD15765@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I upgraded to 3.3.x lately and had no end of problems with btrfs saying my
disk was full when it was not.

I read that btrfs in 3.3.x had issue and got the recommendation to
downgrade, so I went back to 3.2.16 which works for me.

Of course, I need a newer kernel for other reasons and I can't tell which
branch is safe to upgrade to for btrfs.

Have the free space problems been fixed in 3.3.x or is the 3.4.x branch
better or should I stay with 3.2.x for safety?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
