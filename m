Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:53988 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbbBDBBg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Feb 2015 20:01:36 -0500
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 0FF4FEBAF
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2015 12:01:32 +1100 (AEDT)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: single GlobalReserve
Date: Wed, 4 Feb 2015 12:01:28 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201502041201.28917.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

# btrfs fi df /big
Data, RAID1: total=2.56TiB, used=2.56TiB
System, RAID1: total=32.00MiB, used=388.00KiB
Metadata, RAID1: total=19.25GiB, used=14.06GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Why is GlobalReserve single?  That filesystem has been RAID-1 for ages (since 
long before the default leaf size became 16K).  When GlobalReserve was added 
it should have taken the same allocation policy as metadata.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
