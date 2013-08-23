Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56363 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3HWSc2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 14:32:28 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7FF047C040A
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 12:32:28 -0600 (MDT)
Date: Fri, 23 Aug 2013 14:32:26 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4] xfstests: don't remove the two first devices from
 SCRATCH_DEV_POOL
Message-ID: <20130823183226.GE29654@localhost.localdomain>
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 23, 2013 at 03:07:10PM +0200, Stefan Behrens wrote:
> Since common/config is executed twice, if SCRATCH_DEV_POOL is configured
> via the environment, the current code removes the first device entry twice
> which means that you lose the second device for the test.
> 
> The fix is to not remove anything from SCRATCH_DEV_POOL anymore.
> That used to be done (I can only guess) to allow to pass the
> SCRATCH_DEV_POOL as an argument to _scratch_mkfs. Since _scratch_mkfs adds
> the SCRATCH_DEV, the pool mustn't contain that device anymore.
> 
> A new function _scratch_pool_mkfs is introduced that does the expected
> thing.
> 

This didn't break anything and makes sense

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
