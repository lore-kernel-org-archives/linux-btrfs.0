Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41574 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaEEBqY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 21:46:24 -0400
Received: from [172.56.6.57] (port=49017 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1Wh7z2-0006fu-45 by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 04 May 2014 18:46:23 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1Wh7Aa-0003K0-6Q
	for linux-btrfs@vger.kernel.org; Sun, 04 May 2014 17:54:12 -0700
Date: Sun, 4 May 2014 17:54:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: How does "btrfs fi show" show full?
Message-ID: <20140505005412.GS9061@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

More slides, more questions, sorry :)
(thanks for the other answers, I'm still going through them)

If I have:
gandalfthegreat:~# btrfs fi show
Label: 'btrfs_pool1'  uuid: 873d526c-e911-4234-af1b-239889cd143d
	Total devices 1 FS bytes used 214.44GB
	devid    1 size 231.02GB used 231.02GB path /dev/dm-0

I'm a bit confused.

It tells me
1) FS uses 214GB out of 231GB
2) Device uses 231GB out of 231GB

I understand how the device can use less than the FS if you have
multiple devices that share a filesystem.
But I'm not sure how a filesystem can use less than what's being used on
a single device.

Similarly, my current laptop shows:
legolas:~# btrfs fi show
Label: btrfs_pool1  uuid: 4850ee22-bf32-4131-a841-02abdb4a5ba6
	Total devices 1 FS bytes used 442.17GiB
	devid    1 size 865.01GiB used 751.04GiB path /dev/mapper/cryptroot

So, am I 100GB from being full, or am I really only using 442GB out of 865GB?

If so, what does the device used value really mean if it can be that
much higher than the filesystem used value?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
