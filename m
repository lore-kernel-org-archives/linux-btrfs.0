Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29620 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3HAKQV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 06:16:21 -0400
Date: Thu, 1 Aug 2013 18:16:10 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH v5 0/5] Online data deduplication
Message-ID: <20130801101609.GC20228@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
 <20130731212027.GD2372@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130731212027.GD2372@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 05:20:27PM -0400, Josef Bacik wrote:
> On Wed, Jul 31, 2013 at 11:37:40PM +0800, Liu Bo wrote:
> > Data deduplication is a specialized data compression technique for eliminating
> > duplicate copies of repeating data.[1]
> > 
> > This patch set is also related to "Content based storage" in project ideas[2].
> > 
> > PATCH 1 is a hang fix with deduplication on, but it's also useful without
> > dedup in practice use.
> > 
> > PATCH 2 and 3 are targetting delayed refs' scalability problems, which are
> > uncovered by the dedup feature.
> > 
> > PATCH 4 is a speed-up improvement, which is about dedup and quota.
> > 
> > PATCH 5 is full of real things, all details about implementation of dedup.
> > 
> > Plus, there is also a btrfs-progs patch which helps to enable/disable dedup
> > feature.
> > 
> > TODO:
> > * a bit-to-bit comparison callback.
> 
> Didn't pass my BUG_ON() search test, try again.

I'm cleaning them up :)

-liubo
