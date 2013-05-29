Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38124 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab3E2M7T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 08:59:19 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E2A837C041B
	for <linux-btrfs@vger.kernel.org>; Wed, 29 May 2013 06:59:18 -0600 (MDT)
Date: Wed, 29 May 2013 08:59:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: set the free space control unit properly
Message-ID: <20130529125916.GB10043@localhost.localdomain>
References: <1369767025-16263-1-git-send-email-jbacik@fusionio.com>
 <51A5794B.2030107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51A5794B.2030107@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 28, 2013 at 09:43:07PM -0600, Miao Xie wrote:
> On 	tue, 28 May 2013 14:50:25 -0400, Josef Bacik wrote:
> > Stefan pointed out that xfstests generic/013 was failing because the free space
> > cache checker was complaining with leafsize of 16k.  Turns out this is because
> > we were unconditionally using root->sectorsize as the free space ctl unit in the
> > kernel, which doesn't work out if leafsize != sectorsize.  This caused the in
> > memory free space cache to get screwed up which translated to a wrong space
> > cache on disk.  This patch fixes the problem by not carrying the sectorsize in
> > the block group since we have the ctl->unit, and we set the ctl->unit according
> > to the type of block group we are.  This made generic/013 pass with 16k
> > leafsize, whereas before it failed every single time.  Thanks,
> 
> But this patch will make the old filesystem be corrupted because one bit in it
> equals one sector(4K), not 16K.
> 

Balls you're right, I'll fix progs and think about how to fix this at some point
in the future.  Thanks,

Josef
