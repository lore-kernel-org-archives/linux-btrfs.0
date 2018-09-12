Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53116 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726672AbeILRqY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 13:46:24 -0400
Date: Wed, 12 Sep 2018 14:42:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: unify error handling of btrfs_lookup_dir_item
Message-ID: <20180912124202.GL2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536703587-94565-7-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536703587-94565-7-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 06:06:26AM +0800, Liu Bo wrote:
> Unify the error handling part with IS_ERR_OR_NULL.
> 
> No functional changes.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Reviewed-by: David Sterba <dsterba@suse.com>
