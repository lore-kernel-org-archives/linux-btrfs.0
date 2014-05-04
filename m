Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34763 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaEDHy3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 03:54:29 -0400
Received: from i118-21-136-4.s30.a048.ap.plala.or.jp ([118.21.136.4]:18717 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WgrFk-0003aS-RM by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 04 May 2014 00:54:29 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WgrFd-0004dH-QS
	for linux-btrfs@vger.kernel.org; Sun, 04 May 2014 00:54:21 -0700
Date: Sun, 4 May 2014 00:54:07 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs scrub will not start nor cancel howto
Message-ID: <20140504075407.GM9061@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has been asked a few times, so I ended up writing a blog entry on
it
http://marc.merlins.org/perso/btrfs/post_2014-04-26_Btrfs-Tips_-Cancel-A-Btrfs-Scrub-That-Is-Already-Stopped.html
and in the end pasted all of it in the main wiki
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#btrfs_scrub_will_not_start_nor_cancel

Of course, this is really a stopgap until the cancel tool can realize
that the scrub isn't really running anymore, and update the state file
on its own.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
