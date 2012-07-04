Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:2176 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2GDH5Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 03:57:24 -0400
Message-ID: <4FF3F740.3070601@huawei.com>
Date: Wed, 4 Jul 2012 15:56:48 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: chandan r <chandanrmail@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: Add code to support file creation time.
References: <87ipe43sgg.fsf@gmail.com>
In-Reply-To: <87ipe43sgg.fsf@gmail.com>
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012/7/4 15:18, chandan r wrote:

> This patch adds a new member to the 'struct btrfs_inode' structure to hold
> the file creation time.
> 


Well, how do users use this file creation time? There's no syscall and there's
no ioctl that exports this information. That xstat syscall hasn't been accepted,
so you can revise and repost the patch when you see it happens.
