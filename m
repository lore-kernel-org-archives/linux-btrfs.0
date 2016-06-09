Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbcFIN1k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 09:27:40 -0400
Date: Thu, 9 Jun 2016 15:28:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2] Btrfs: check if extent buffer is aligned to sectorsize
Message-ID: <20160609132814.GK3905@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1465239683-29666-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465239683-29666-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 06, 2016 at 12:01:23PM -0700, Liu Bo wrote:
> Thanks to fuzz testing, we can pass an invalid bytenr to extent buffer
> via alloc_extent_buffer().  An unaligned eb can have more pages than it
> should have, which ends up extent buffer's leak or some corrupted content
> in extent buffer.
> 
> This adds a warning to let us quickly know what was happening.
> 
> Now that alloc_extent_buffer() no more returns NULL, this changes its
> caller and callers of its caller to match with the new error
> handling.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
