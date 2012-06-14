Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55206 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755023Ab2FNLDe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 07:03:34 -0400
Message-ID: <4FD9C6C4.8080702@cn.fujitsu.com>
Date: Thu, 14 Jun 2012 19:11:00 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/10 trival] Btrfs: fix typo in cow_file_range_async
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com> <1339662206-5307-9-git-send-email-liubo2009@cn.fujitsu.com> <20120614101717.GO32402@twin.jikos.cz>
In-Reply-To: <20120614101717.GO32402@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/14/2012 06:17 PM, David Sterba wrote:

> On Thu, Jun 14, 2012 at 04:23:24PM +0800, Liu Bo wrote:
>> It should be 10 * 1024 * 1024.
> 
> Nice one :) though there's another one a few lines above
> 
> 1010         if (atomic_read(&root->fs_info->async_delalloc_pages) <
> 1011             5 * 1042 * 1024 &&
> 1012             waitqueue_active(&root->fs_info->async_submit_wait))
> 1013                 wake_up(&root->fs_info->async_submit_wait);
> 1014
> 
> can you please fix both?
> 


Sure, will update it.

thanks,
liubo

> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


