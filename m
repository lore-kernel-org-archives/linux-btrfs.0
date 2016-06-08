Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31377 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754502AbcFHBKP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jun 2016 21:10:15 -0400
Subject: Re: btrfs: fix check_shared for fiemap ioctl
To: Dan Carpenter <dan.carpenter@oracle.com>
References: <20160607171848.GA29093@mwanda>
CC: <linux-btrfs@vger.kernel.org>
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <10073c50-9aa5-c795-30f2-2f36444c2b60@cn.fujitsu.com>
Date: Wed, 8 Jun 2016 09:10:09 +0800
MIME-Version: 1.0
In-Reply-To: <20160607171848.GA29093@mwanda>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At 06/08/2016 01:18 AM, Dan Carpenter wrote:
> Hello Lu Fengqi,
>
> The patch ac8332f0c3ac: "btrfs: fix check_shared for fiemap ioctl"
> from Jun 1, 2016, leads to the following static checker warning:
>
> 	fs/btrfs/backref.c:277 ref_tree_add()
> 	error: dereferencing freed memory 'node'
>
> fs/btrfs/backref.c
>    271          origin_count = node->ref_mod;
>    272          node->ref_mod += count;
>    273
>    274          if (!node->ref_mod)
>    275                  ref_tree_remove(ref_tree, node);
>                                                   ^^^^
> Freed here.
>
>    276
>    277          if (node->ref_mod > 0)
>                     ^^^^^^^^^^^^^
> Use after free.
>
>    278                  ref_tree->unique_refs += origin_count > 0 ? 0 : 1;
>    279          else if (node->ref_mod <= 0)
>    280                  ref_tree->unique_refs += origin_count > 0 ? -1 : 0;
>    281
>    282          return 0;
>
> regards,
> dan carpenter
>
>
Yes, this warning is right. I will update this patch to correct it.

-- 
Thanks,
Lu


