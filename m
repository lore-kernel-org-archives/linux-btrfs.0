Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbaFWOze (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 10:55:34 -0400
Date: Mon, 23 Jun 2014 16:55:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: Add minimum device size check.
Message-ID: <20140623145533.GJ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403234021-17518-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403234021-17518-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 20, 2014 at 11:13:41AM +0800, Qu Wenruo wrote:
> Btrfs has global block reservation, so even mkfs.btrfs can execute
> without problem, there is still a possibility that the filesystem can't
> be mounted.
> For example when mkfs.btrfs on a 8M file on x86_64 platform, kernel will
> refuse to mount due to ENOSPC, since system block group takes 4M and
> mixed block group takes 4M, and global block reservation will takes all
> the 4M from mixed block group, which makes btrfs unable to create uuid
> tree.
> 
> This patch will add minimum device size check before actually mkfs.
> The minimum size calculation uses a simplified one:
> minimum_size_for_each_dev = 2 * (system block group + global block rsv)
> and global block rsv = leafsize << 10
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> changelog:
> v2: Use leafsize to get consistent with kernel global_block_rsv
> calculation.

Oh sorry, I should really fix my patch queue scanning workflow so I
don't send comments to obsolete patches. I see you've fixed the global
block reserve size, the rest of the comments under v1 still applies.
