Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965029AbaKNO5M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 09:57:12 -0500
Date: Fri, 14 Nov 2014 15:57:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH 1/9] Btrfs: remove noused bbio_ret in __btrfs_map_block
 in condition
Message-ID: <20141114145711.GI30713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
 <1415973061-8643-2-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415973061-8643-2-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 14, 2014 at 09:50:53PM +0800, Miao Xie wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> bbio_ret in this condition is always !NULL because previous code
> already have a check-and-skip:
> 4908 if (!bbio_ret)
> 4909     goto out;
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
