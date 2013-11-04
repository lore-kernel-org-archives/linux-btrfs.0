Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42642 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KDRmd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 12:42:33 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A98A17C06A5
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Nov 2013 10:42:32 -0700 (MST)
Date: Mon, 4 Nov 2013 12:42:30 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <dustymabe@gmail.com>
Subject: Re: [PATCH] Btrfs: fix negative qgroup tracking from owner
 accounting (bug #61951)
Message-ID: <20131104174230.GK16855@localhost.localdomain>
References: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 24, 2013 at 03:22:06PM +0200, Jan Schmidt wrote:
> btrfs_dec_ref() queued a delayed ref for owner of a tree block. The qgroup
> tracking is based on delayed refs. The owner of a tree block is set when a
> tree block is allocated, it is never updated.
> 
> When you allocate a tree block and then remove the subvolume that did the
> allocation, the qgroup accounting for that removal is correct. However, the
> removal was accounted again for each subvolume deletion that also referenced
> the tree block, because accounting was erroneously based on the owner.
> 
> Instead of queueing delayed refs for the non-existent owner, we now
> queue delayed refs for the root being removed. This fixes the qgroup
> accounting.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> Tested-by: <dustymabe@gmail.com>

This breaks btrfs/003, I'm kicking it out.

Josef
