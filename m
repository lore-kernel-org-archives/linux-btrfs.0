Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50942 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbeIOAcj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 20:32:39 -0400
Date: Fri, 14 Sep 2018 12:16:44 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove wait_ordered_range in btrfs_evict_inode
Message-ID: <20180914191643.tsxkyh2jvkymiie2@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1536703587-94565-3-git-send-email-bo.liu@linux.alibaba.com>
 <20180914131433.GD5847@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180914131433.GD5847@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2018 at 03:14:33PM +0200, David Sterba wrote:
> On Wed, Sep 12, 2018 at 06:06:22AM +0800, Liu Bo wrote:
> > As VFS has called ->invalidatepage() to get all ordered extents done
> > and truncated all page cache pages, wait_ordered_range() is just a
> > noop.
> 
> Agreed, though looking up the exact points when there are no pages to be
> waited for took me some time. More references and hints in the changelog
> would be good. I'll add the patch to misc-next so it can be tested, but
> please send me an update if you have idea how to rephrase the changelog.
> Thanks.
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

OK, I'll add some call stack, hopefully can make it better.

thanks,
-liubo
