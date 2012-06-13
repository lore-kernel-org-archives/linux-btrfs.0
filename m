Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lulu.zabbo.net ([69.168.54.52]:35158 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2FMQHi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 12:07:38 -0400
Message-ID: <4FD8BAC9.2020108@zabbo.net>
Date: Wed, 13 Jun 2012 09:07:37 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: use radix tree for checksum
References: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com> <1339582751-32029-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339582751-32029-2-git-send-email-liubo2009@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>   int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
>   {
[...]
> +	ret = radix_tree_insert(&tree->csum, (unsigned long)start,
> +			       (void *)((unsigned long)private<<  1));

Will this fail for 64bit files on 32bit hosts?

> +	BUG_ON(ret);

I wonder if we can patch BUG_ON() to break the build if its only
argument is "ret".

- z
