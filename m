Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52385 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaENNvI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 09:51:08 -0400
Received: from [172.56.12.219] (port=43340 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WkZaN-00031f-8M by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 06:51:08 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WkZaH-0003cn-ST
	for linux-btrfs@vger.kernel.org; Wed, 14 May 2014 06:51:01 -0700
Date: Wed, 14 May 2014 06:50:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Can a snapshot become a parent subvolume when its parent is deleted?
Message-ID: <20140514135057.GA12849@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So, I had btrfs_pool1 that was trashed/lost as discussed here recently.

I did btrfs send btrfs_pool2/root_ro.date | btrfs receive /mnt/btrfs_pool1

Then btrfs subvolume snapshot root_ro.date root

Now, after I delete root_ro.date on btrfs_pool1, shouldn't root become a
parent subvolume?

Right now, I have:
legolas:/mnt/btrfs_pool1# btrfs subvolume list -q . 
ID 390 gen 5954 top level 5 parent_uuid faea7df8-d51a-6b4b-994b-887d55267cce path root
legolas:/mnt/btrfs_pool1# btrfs subvolume list  -u .  |grep faea7df8-d51a-6b4b-994b-887d55267cce
legolas:/mnt/btrfs_pool1#

Is it possible not to have a parent?

If so, shouldn't you become a parent at that time?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
