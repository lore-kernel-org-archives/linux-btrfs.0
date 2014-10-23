Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([37.187.97.211]:59760 "EHLO rin.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178AbaJWOYP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 10:24:15 -0400
Received: from natsu (unknown [IPv6:fd39::a60:6eff:fef3:b5b3])
	by rin.romanrm.net (Postfix) with SMTP id 6A1AA6515A
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Oct 2014 14:24:12 +0000 (UTC)
Date: Thu, 23 Oct 2014 20:24:11 +0600
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: "Transaction commit" in btrfs sub del
Message-ID: <20141023202411.701bd1f3@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I was under impression that the "Transaction commit:" setting in 'btrfs sub
del' finally allows us to make it not return until all free space from the
snapshots that are being deleted, is completely freed up.

However that does not seem to be the case at all, deleting 14 snapshots with a
heavy write-load occuring at the same time (Btrfs v3.14.1, kernel 3.14.22),
with "Transaction commit: at the end", the 'btrfs' utility exited, and I still
observe no change in free space numbers. It got finally freed only a couple of
minutes later, i.e. as it usually would, without any commit options.

So what is the purpose of these options, if they do not seem to have an effect?

-- 
With respect,
Roman
