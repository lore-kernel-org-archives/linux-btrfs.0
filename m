Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:48487 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaEGFga (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 01:36:30 -0400
In-Reply-To: <pan$9fcd4$1023a4e5$d241126e$285ca14@cox.net>
References: <1541415.olHfkWYf4R@zafu> <pan$77cb2$eaaf65a0$d47fcc2f$d279fdb@cox.net> <3839313.LSaoXm11Qk@zafu> <pan$9fcd4$1023a4e5$d241126e$285ca14@cox.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Using noCow with snapshots ?
From: Russell Coker <russell@coker.com.au>
Date: Wed, 07 May 2014 15:36:15 +1000
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Message-ID: <16fd4391-5c16-42a6-82a2-9bd1cb988906@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How could BTRFS and a database "fight" about data recovery?

BTRFS offers similar guarantees about data durability etc to other journalled filesystems and only differs by having checksums so that while a snapshot might have half the data that was written by an app you at least know that the half will be consistent.

If you had database files on a separate subvol to the database log then you would be at risk of having problems making a any sort of consistent snapshot (the Debian approach of /var/log/mysql and /var/lib/mysql is a bad idea). But there would be no difference with LVM snapshots in that regard.
-- 
Sent from my Samsung Galaxy Note 2 with K-9 Mail.
