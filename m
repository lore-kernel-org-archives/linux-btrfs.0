Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49881 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab3KGSI3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Nov 2013 13:08:29 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 62B637C0682
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Nov 2013 11:08:29 -0700 (MST)
Date: Thu, 7 Nov 2013 13:08:26 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 02/17] btrfs: Added btrfs_workqueue_struct implemented
 ordered execution based on kernel workqueue
Message-ID: <20131107180826.GI27784@localhost.localdomain>
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1383803527-23736-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1383803527-23736-3-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 07, 2013 at 01:51:52PM +0800, Qu Wenruo wrote:
> Use kernel workqueue to implement a new btrfs_workqueue_struct, which
> has the ordering execution feature like the btrfs_worker.
> 
> The func is executed in a concurrency way, and the
> ordred_func/ordered_free is executed in the sequence them are queued
> after the corresponding func is done.
> The new btrfs_workqueue use 2 workqueues to implement the original
> btrfs_worker, one for the normal work and one for ordered work.
> 
> At this patch, high priority work queue or thresholding is not added yet.
> The high priority feature and thresholding will be added in the following patches.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
