Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45074 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754381AbcJYSsi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 14:48:38 -0400
Date: Tue, 25 Oct 2016 14:47:52 -0400
From: Tejun Heo <htejun@fb.com>
To: Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>, <david@fromorbit.com>,
        <jack@suse.cz>, <linux-fsdevel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <hch@infradead.org>, <jweiner@fb.com>
Subject: Re: [PATCH 1/5] remove mapping from balance_dirty_pages*()
Message-ID: <20161025184751.GA13857@htj.duckdns.org>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-2-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1477420904-1399-2-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2016 at 02:41:40PM -0400, Josef Bacik wrote:
> The only reason we pass in the mapping is to get the inode in order to see if
> writeback cgroups is enabled, and even then it only checks the bdi and a super
> block flag.  balance_dirty_pages() doesn't even use the mapping.  Since
> balance_dirty_pages*() works on a bdi level, just pass in the bdi and super
> block directly so we can avoid using mapping.  This will allow us to still use
> balance_dirty_pages for dirty metadata pages that are not backed by an
> address_mapping.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
