Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbbJUJrq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 05:47:46 -0400
Date: Wed, 21 Oct 2015 11:46:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix possible leak in btrfs_ioctl_balance()
Message-ID: <20151021094625.GB13624@suse.cz>
Reply-To: dsterba@suse.cz
References: <1445381406-13475-1-git-send-email-cengelma@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445381406-13475-1-git-send-email-cengelma@gmx.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 21, 2015 at 12:50:06AM +0200, Christian Engelmayer wrote:
> Commit 8eb934591f8b ("btrfs: check unsupported filters in balance
> arguments") adds a jump to exit label out_bargs in case the argument
> check fails. At this point in addition to the bargs memory, the
> memory for struct btrfs_balance_control has already been allocated.
> Ownership of bctl is passed to btrfs_balance() in the good case,
> thus the memory is not freed due to the introduced jump. Make sure
> that the memory gets freed in any case as necessary. Detected by
> Coverity CID 1328378.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
Reviewed-by: David Sterba <dsterba@suse.com>

Thanks for fixig it.
