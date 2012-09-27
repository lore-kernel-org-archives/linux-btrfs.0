Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50235 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab2I0Q4a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 12:56:30 -0400
Received: by wibhr7 with SMTP id hr7so2302785wib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2012 09:56:29 -0700 (PDT)
Date: Thu, 27 Sep 2012 19:56:24 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 1/2] Btrfs: cleanup duplicated division functions
Message-ID: <20120927165624.GA2024@zambezi.lan>
References: <5051BAB8.7080200@cn.fujitsu.com>
 <505A8632.10101@cn.fujitsu.com>
 <505C2E62.2000400@cn.fujitsu.com>
 <5064284E.9020504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5064284E.9020504@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

You haven't addressed any of my concerns with v3.

On Thu, Sep 27, 2012 at 06:19:58PM +0800, Miao Xie wrote:

(snipped)

> the parameters are right. So besides the code cleanup, this patch also
> add a check for the usage of the space balance, it is the only place that
> we need add check to make sure the parameters of div_factor are right till
> now. Besides that, the old kernel may hold the wrong usage value, so we
> must rectify it.

Cleaning up/unifying duplicated functions and changing the existing
logic are two very different things.  If you, in the course of writing
this patch, became unhappy with the way balancing ioctl deals with
"invalid" input, please send a separate patch.

Before your patch, volumes.c had its own copy of div_factor_fine():

static u64 div_factor_fine(u64 num, int factor)
{
	if (factor <= 0)
		return 0;
	if (factor >= 100)
		return num;

	num *= factor;
	do_div(num, 100);
	return num;
}

which was called from chunk_usage_filter() on unvalidated user input.
As far as the cleanup part of your patch goes, you've dropped
factor <= 0 / factor >= 100 logic, merged volumes.c's copy with
extent-tree.c's copy and renamed div_factor_fine() to div_factor().  To
make chunk_usage_filter() happy again, it's enough to move the dropped
logic directly to the call site:

static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
			      struct btrfs_balance_args *bargs)
{
	...

-	user_thresh = div_factor_fine(cache->key.offset, bargs->usage);
+	if (bargs->usage == 0)
+		user_thresh = 0;
+	else if (bargs->usage >= 100)
+		user_thresh = cache->key.offset;
+	else
+		user_thresh = div_factor(cache->key.offset, bargs->usage);

	...
}

So I would suggest you drop all hunks related to changing the way
balancing ioctl works and make the above change to chunk_usage_filter()
instead.  Once again, if you are unhappy with usage filter argument
handling, send a separate patch.

Thanks,

		Ilya
