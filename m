Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39799 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935616AbcHJT4w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 15:56:52 -0400
Date: Wed, 10 Aug 2016 15:56:06 -0400
From: Tejun Heo <htejun@fb.com>
To: Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>
Subject: Re: [PATCH 1/2] remove mapping from balance_dirty_pages*()
Message-ID: <20160810195605.GA3398@mtj.duckdns.org>
References: <1470769707-26079-1-git-send-email-jbacik@fb.com>
 <1470769707-26079-2-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1470769707-26079-2-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 09, 2016 at 03:08:26PM -0400, Josef Bacik wrote:
> The only reason we pass in the mapping is to get the inode in order to see if
> writeback cgroups is enabled, and even then it only checks the bdi and a super
> block flag.  balance_dirty_pages() doesn't even use the mapping.  Since
> balance_dirty_pages*() works on a bdi level, just pass in the bdi and super
> block directly so we can avoid using mapping.  This will allow us to still use
> balance_dirty_pages for dirty metadata pages that are not backed by an
> address_mapping.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
