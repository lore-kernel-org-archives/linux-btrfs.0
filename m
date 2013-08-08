Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966823Ab3HHW57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 18:57:59 -0400
Date: Fri, 9 Aug 2013 00:57:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [v2 2/8] Btrfs-progs: add missing man information for
 btrfs-debug-tree
Message-ID: <20130808225756.GF5284@suse.cz>
Reply-To: dsterba@suse.cz
References: <1375854849-15224-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1375854849-15224-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375854849-15224-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for updating the license. One comment that's applicable to all
patches:

On Wed, Aug 07, 2013 at 01:54:03PM +0800, Wang Shilong wrote:
> +.SH AVAILABILITY
> +.B btrfs-debug-tree
> +is part of btrfs-progs. Btrfs is currently under heavy development,
> +and not suitable for any uses other than benchmarking and review.

That's (arguably) not true anymore and I'd rather see it removed or
updated closer to current status.

> +Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
> +further details.
