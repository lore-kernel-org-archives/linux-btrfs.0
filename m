Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34577 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221Ab3HHNUg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 09:20:36 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E3EFA9A067F
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Aug 2013 07:20:35 -0600 (MDT)
Date: Thu, 8 Aug 2013 09:20:33 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, <sensille@gmx.net>, <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 1/3] Btrfs: fix oops when writing dirty qgroups to disk
Message-ID: <20130808132033.GD16712@localhost.localdomain>
References: <1375852351-11919-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1375852351-11919-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 01:12:29PM +0800, Wang Shilong wrote:
> When disabling quota, we should clear out list 'dirty_qgroups',otherwise,
> we will get oops if enabling quota again. Fix this by abstracting similar
> code from del_qgroup_rb().
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

Can we get an xfstest for this, or at the very least a generic xfstest to
exercise qgroups in general so I can be sure all these qgroup patches I take
don't cause regressions?  Thanks,

Josef
