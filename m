Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:53689 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933155Ab2IFVHn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 17:07:43 -0400
Date: Thu, 6 Sep 2012 14:07:43 -0700
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: wait on async pages when shrinking delalloc
Message-ID: <20120906210743.GC15825@lenny.home.zabbo.net>
References: <1346964716-12070-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1346964716-12070-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +		if (atomic_read(&root->fs_info->async_delalloc_pages))
> +			wait_event(root->fs_info->async_submit_wait,
> +			  !atomic_read(&root->fs_info->async_delalloc_pages));

The very first thing wait_event_*() family does is test the condition.
You don't need to guard them with an inverse copy of the condition.
Just call them directly and they'll do the right thing and bail cheaply
when the condition is already true.

- z
