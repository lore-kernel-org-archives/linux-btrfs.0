Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751143AbdBBSTH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Feb 2017 13:19:07 -0500
Date: Thu, 2 Feb 2017 19:18:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: kill trans in run_delalloc_nocow and
 btrfs_cross_ref_exist
Message-ID: <20170202181837.GD16723@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1485807928-17351-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485807928-17351-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2017 at 12:25:28PM -0800, Liu Bo wrote:
> run_delalloc_nocow has used trans in two places where they don't actually need
> @trans.
> 
> For btrfs_lookup_file_extent, we search for file extents without COWing
> anything, and for btrfs_cross_ref_exist, the only place where we need @trans is
> deferencing it in order to get running_transaction which we could easily get
> from the global fs_info.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Removing the transaction is ok, backed by some patch archeology.
