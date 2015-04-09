Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:49423 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbbDIAjh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 20:39:37 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 92146EB9E
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2015 10:39:34 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: snapshot space use
Date: Thu, 9 Apr 2015 10:39:33 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201504091039.33442.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

# zfs list -t snapshot
NAME                        USED  AVAIL  REFER  MOUNTPOINT
hetz0/be0-mail@2015-03-10  2.88G      -   387G  -
hetz0/be0-mail@2015-03-11  1.12G      -   388G  -
hetz0/be0-mail@2015-03-12  1.11G      -   388G  -
hetz0/be0-mail@2015-03-13  1.19G      -   388G  -
hetz0/be0-mail@2015-03-14  1.02G      -   388G  -
hetz0/be0-mail@2015-03-15   989M      -   386G  -

Is there any way to do something similar to the above ZFS command?  It's handy 
to know which snapshots are taking up the most space, especially when multiple 
subvols are being snapshotted.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
