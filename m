Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34682 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaEDHra (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 03:47:30 -0400
Received: from i118-21-136-4.s30.a048.ap.plala.or.jp ([118.21.136.4]:12285 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1Wgr8z-0002yX-Sn by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 04 May 2014 00:47:30 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1Wgr8n-0004Rl-HY
	for linux-btrfs@vger.kernel.org; Sun, 04 May 2014 00:47:17 -0700
Date: Sun, 4 May 2014 00:47:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs on top of multiple dmcrypted devices howto
Message-ID: <20140504074712.GL9061@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've just updated
https://btrfs.wiki.kernel.org/index.php/FAQ#Does_Btrfs_work_on_top_of_dm-crypt.3F
to point to
http://marc.merlins.org/perso/btrfs/post_2014-04-27_Btrfs-Multi-Device-Dmcrypt.html
where I give this script:
http://marc.merlins.org/linux/scripts/start-btrfs-dmcrypt
which shows one way to bring up a btrfs filesystem based off multiple
dm-crypted devices.

Hope this helps someone.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
