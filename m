Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727013AbeINS3C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 14:29:02 -0400
Date: Fri, 14 Sep 2018 15:14:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove wait_ordered_range in btrfs_evict_inode
Message-ID: <20180914131433.GD5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1536703587-94565-3-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536703587-94565-3-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 06:06:22AM +0800, Liu Bo wrote:
> As VFS has called ->invalidatepage() to get all ordered extents done
> and truncated all page cache pages, wait_ordered_range() is just a
> noop.

Agreed, though looking up the exact points when there are no pages to be
waited for took me some time. More references and hints in the changelog
would be good. I'll add the patch to misc-next so it can be tested, but
please send me an update if you have idea how to rephrase the changelog.
Thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
