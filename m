Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:47559 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaKZMml (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 07:42:41 -0500
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id A4D3E208FA
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 23:42:38 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: resetting device stats
Date: Wed, 26 Nov 2014 23:42:36 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201411262342.36325.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running Debian kernel version 3.16.0-4-amd64 and btrfs-tools version 
3.17-1.1 I ran a btrfs replace operation to replace a 3TB disk that was giving 
read errors with a new 4TB disk.

After the replace the "btrfs device stats" command reported that the 4TB disk 
had 16 read errors.  It appears that the device stats are copied in a replace 
operation.

I believe that this is a bug.  There is no reason to claim that the new 4TB 
disk had read errors when it was the old 3TB disk that had the errors.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
