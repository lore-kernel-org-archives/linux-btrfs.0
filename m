Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54561 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbaIRP1d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 11:27:33 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:50817 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1XUdcA-0001FP-W1 by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Sep 2014 08:27:33 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1XUdc6-0008BQ-Oo
	for linux-btrfs@vger.kernel.org; Thu, 18 Sep 2014 08:27:18 -0700
Date: Thu, 18 Sep 2014 08:27:18 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140918152718.GA27983@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: btrfs receive: could not find parent subvolume
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While debugging a btrfs send/receive slow problem, I now getting this:
legolas:/mnt/btrfs_pool1# btrfs send -p tmp_ggm_daily_ro.20140917_06:29:58 tmp_ggm_daily_ro.20140918_02:48:24 | ssh gargamel btrfs receive -v /mnt/btrfs_pool2/backup/debian64/legolas
At subvol tmp_ggm_daily_ro.20140918_02:48:24
At snapshot tmp_ggm_daily_ro.20140918_02:48:24
receiving snapshot tmp_ggm_daily_ro.20140918_02:48:24 uuid=5d1f0454-1be3-b648-9ea5-dc427cd62d98, ctransid=310713 parent_uuid=d86e69bf-e17f-7f4c-bfb7-e571d5824687, parent_ctransid=308332
ERROR: could not find parent subvolume

The parent is there on the other side, but UUID is different:
gargamel:/mnt/btrfs_pool2/backup/debian64/legolas# btrfs subvolume show tmp_ggm_daily_ro.20140917_06:29:58
/mnt/btrfs_pool2/backup/debian64/legolas/tmp_ggm_daily_ro.20140917_06:29:58
        Name:                   tmp_ggm_daily_ro.20140917_06:29:58
        uuid:                   3d424a2b-69da-244c-bfcc-c283f9cc1f34
        Parent uuid:            05d3b9be-bfe2-bb4a-9f6a-64b9d44896c7
        Creation time:          2014-09-17 06:30:01
        Object ID:              7873
        Generation (Gen):       83621
        Gen at creation:        83476
        Parent:                 263
        Top Level:              263
        Flags:                  -
        Snapshot(s):

Now it seems that the UUID is different on all my snapshots created by
btrfs send, so maybe it doesn't match UUID?

Given that, what is btrfs receive using to get a match?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
