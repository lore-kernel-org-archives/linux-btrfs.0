Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab3KELpV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 06:45:21 -0500
Date: Tue, 5 Nov 2013 12:45:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] Btrfs: remove unnecessary initialization and memory
 barrior in shrink_delalloc()
Message-ID: <20131105114516.GG16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
 <1383578006-22691-2-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383578006-22691-2-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 04, 2013 at 11:13:20PM +0800, Miao Xie wrote:
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

Would be nice to say why it's safe to remove the barrier. The percpu
counters do not need it, they use a spinlock. The barrier was there due
to access to fs_info->delalloc_bytes that was removed in commit
963d678b0f764930 that introduced the percpu counters.
