Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33873 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaEDFqa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 01:46:30 -0400
Received: from i118-21-136-4.s30.a048.ap.plala.or.jp ([118.21.136.4]:31718 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WgpFt-0000am-MH by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 22:46:30 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1Wgkab-0005Dx-Pe
	for linux-btrfs@vger.kernel.org; Sat, 03 May 2014 17:47:33 -0700
Date: Sat, 3 May 2014 17:47:32 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Using mount -o bind vs mount -o subvol=vol
Message-ID: <20140504004732.GE9061@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is there any functional difference between 

mount -o subvol=usr /dev/sda1 /usr
and
mount /dev/sda1 /mnt/btrfs_pool
mount -o bind /mnt/btrfs_pool/usr /usr

?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
