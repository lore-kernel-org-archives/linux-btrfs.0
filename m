Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:54703 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3GaVUa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 17:20:30 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id EC2EA9A069B
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:20:29 -0600 (MDT)
Date: Wed, 31 Jul 2013 17:20:27 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH v5 0/5] Online data deduplication
Message-ID: <20130731212027.GD2372@localhost.localdomain>
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 11:37:40PM +0800, Liu Bo wrote:
> Data deduplication is a specialized data compression technique for eliminating
> duplicate copies of repeating data.[1]
> 
> This patch set is also related to "Content based storage" in project ideas[2].
> 
> PATCH 1 is a hang fix with deduplication on, but it's also useful without
> dedup in practice use.
> 
> PATCH 2 and 3 are targetting delayed refs' scalability problems, which are
> uncovered by the dedup feature.
> 
> PATCH 4 is a speed-up improvement, which is about dedup and quota.
> 
> PATCH 5 is full of real things, all details about implementation of dedup.
> 
> Plus, there is also a btrfs-progs patch which helps to enable/disable dedup
> feature.
> 
> TODO:
> * a bit-to-bit comparison callback.

Didn't pass my BUG_ON() search test, try again.

Josef
