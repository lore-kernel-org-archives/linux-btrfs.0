Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38415 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752396AbeA3OHG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 09:07:06 -0500
Date: Tue, 30 Jan 2018 15:04:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: Ignore errors from
 btrfs_qgroup_trace_extent_post
Message-ID: <20180130140453.GF19355@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1517211848-13324-1-git-send-email-nborisov@suse.com>
 <1517233981-31889-1-git-send-email-nborisov@suse.com>
 <3e753bcf-415e-ad94-ee5f-28cf1c9ca477@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <3e753bcf-415e-ad94-ee5f-28cf1c9ca477@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 10:06:52PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年01月29日 21:53, Nikolay Borisov wrote:
> > Running generic/019 with qgroups on the scratch device enabled is
> > almost guaranteed to trigger the BUG_ON in btrfs_free_tree_block. It's
> > supposed to trigger only on -ENOMEM, in reality, however, it's possible
> > to get -EIO from btrfs_qgroup_trace_extent_post. This function just
> > finds the roots of the extent being tracked and sets the qrecord->old_roots
> > list. If this operation fails nothing critical happens except the
> > quota accounting can be considered wrong. In such case just set the
> > INCONSISTENT flag for the quota and print a warning, rather than
> > killing off the system. Additionally, it's possible to trigger a BUG_ON
> > in btrfs_truncate_inode_items as well.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Added to next, thanks.
