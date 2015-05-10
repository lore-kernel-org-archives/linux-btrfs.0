Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49190 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbbEJQuJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 May 2015 12:50:09 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:33629 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtps
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1YrUQD-0008F1-AS
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2015 09:49:48 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1YrUQC-0003xo-BU
	for linux-btrfs@vger.kernel.org; Sun, 10 May 2015 09:49:44 -0700
Date: Sun, 10 May 2015 09:49:44 -0700
From: Marc MERLIN <marc@merlins.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <20150510164944.GI16535@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Are there plans for full btrfs filesystem backups?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I use send/receive to backup some subvolumes, but there is no good way
to back up all of my subvolumes in one swoop.
Backing up with tar/cp/rsync is of course no good since it loses all the
btrfs attributes including COW deduped blocks.

For one, my recent btrfs filesystem crash reminded me that docker
creates a boatload of subvolumes which my backups didn't cacch, so now
it's all gone.

Are there any plans for a full filesystem send/receive, not just a
subvolume send/receive?

Note that this is the same problem when you are migtrating to new drives
or bcache, and you can't play tricks with adding a virtual drive of 8TB
just to mirror to it and remove the original mirror later.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
