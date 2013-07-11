Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51589 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3GKO3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 10:29:23 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1F45D9A0681
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 08:29:23 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
 <1373520339-13870-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1373520339-13870-3-git-send-email-miaox@cn.fujitsu.com>
Message-ID: <20130711142920.12026.77064@localhost.localdomain>
Subject: Re: [PATCH 3/5] Btrfs: don't cache the csum value into the extent state tree
Date: Thu, 11 Jul 2013 10:29:20 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Miao Xie (2013-07-11 01:25:38)
> Before applying this patch, we cached the csum value into the extent state
> tree when reading some data from the disk, this operation increased the lock
> contention of the state tree.
> 
> Now, we just store the csum value into the bio structure or other unshared
> structure, so we can reduce the lock contention.

Perfect, this is a great way to use the extra bio struct.

-chris
