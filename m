Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33456 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab2FNKRZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 06:17:25 -0400
Date: Thu, 14 Jun 2012 12:17:17 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/10 trival] Btrfs: fix typo in cow_file_range_async
Message-ID: <20120614101717.GO32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1339662206-5307-9-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1339662206-5307-9-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 14, 2012 at 04:23:24PM +0800, Liu Bo wrote:
> It should be 10 * 1024 * 1024.

Nice one :) though there's another one a few lines above

1010         if (atomic_read(&root->fs_info->async_delalloc_pages) <
1011             5 * 1042 * 1024 &&
1012             waitqueue_active(&root->fs_info->async_submit_wait))
1013                 wake_up(&root->fs_info->async_submit_wait);
1014

can you please fix both?


david
