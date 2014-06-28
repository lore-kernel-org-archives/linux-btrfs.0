Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62243 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579AbaF1AQ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 20:16:59 -0400
Message-ID: <53AE0975.1030202@fb.com>
Date: Fri, 27 Jun 2014 17:16:53 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>, <mfasheh@suse.de>
Subject: Re: [PATCH] Btrfs: make sure to use btrfs_header_owner when freeing
 tree block V2
References: <1403913903-21132-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1403913903-21132-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/27/2014 05:05 PM, Josef Bacik wrote:
> Mark noticed that his qgroup accounting for snapshot deletion wasn't working
> properly on a particular file system.  Turns out we pass the root->objectid of
> the root we are deleting to btrfs_free_extent, and use that root always when we
> call btrfs_free_tree_block.  This isn't correct, the owner must match the
> btrfs_header_owner() of the eb.  So to fix this we need to use that when we call
> btrfs_free_extent, and we also need to use btrfs_header_owner(eb) in
> btrfs_free_tree_block as the root we pass in may not be the owner in the case of
> snapshot delete (though it is for all the normal cases which is why it wasn't
> noticed before.)  With this patch on top of Mark's snapshot delete patch
> everything is working a-ok.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
> V1->V2: this one actually compiles.
>

Huh I may be completely full of crap here, let's just ignore all post 5pm Friday patches from me for now.  Thanks,

Josef

