Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54297 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaILFTN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 01:19:13 -0400
In-Reply-To: <6AE06E73-C89E-42F0-9A09-FA92C68DED69@colorremedies.com>
References: <84a98bc5f667c04ca74ff77b56f537d9@admin.virtall.com> <pan$2d5ba$86c3ebd8$b81abab$13e892ea@cox.net> <4A9B52AD-8104-4C31-9BA4-13D329D2F952@colorremedies.com> <pan$a2cc2$dc8ad02$d35780a0$4fefc791@cox.net> <6AE06E73-C89E-42F0-9A09-FA92C68DED69@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: how long should "btrfs device delete missing ..."  take?
From: Russell Coker <russell@coker.com.au>
Date: Fri, 12 Sep 2014 15:19:04 +1000
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <1efa888d-1695-4ad0-8e04-f6b2fe87314e@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It would be nice if a file system mounted ro counted as ro snapshots for btrfs send.

When a file system is so messed up it can't be mounted rw it should be regarded as ro for all operations.
-- 
Sent from my Samsung Galaxy Note 2 with K-9 Mail.
