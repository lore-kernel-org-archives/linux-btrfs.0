Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:60143 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbbF2BoI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 21:44:08 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 4E0ACEC34
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 11:44:05 +1000 (AEST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: why does df spin up disks?
Date: Mon, 29 Jun 2015 11:43:59 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201506291143.59911.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I have a mounted filesystem why doesn't the kernel store the amount of 
free space?  Why does it need to spin up a disk that had been spun down?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
