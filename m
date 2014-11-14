Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965012AbaKNOzu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 09:55:50 -0500
Date: Fri, 14 Nov 2014 15:55:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH 2/9] Btrfs: remove unnecessary code of stripe_index
 assignment in __btrfs_map_block
Message-ID: <20141114145549.GH30713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
 <1415973061-8643-3-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415973061-8643-3-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 14, 2014 at 09:50:54PM +0800, Miao Xie wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> stripe_index's value was set again in latter line:
> stripe_index = 0;
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
