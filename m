Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51368 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3HPOFZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 10:05:25 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 617999A0404
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 08:05:24 -0600 (MDT)
Date: Fri, 16 Aug 2013 10:05:22 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: stop using GFP_ATOMIC when allocating rewind ebs
Message-ID: <20130816140522.GA3990@localhost.localdomain>
References: <1375909909-25955-1-git-send-email-jbacik@fusionio.com>
 <520E0F09.1050604@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <520E0F09.1050604@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 16, 2013 at 01:37:45PM +0200, Stefan Behrens wrote:
> On Wed, 7 Aug 2013 17:11:49 -0400, Josef Bacik wrote:
> > There is no reason we can't just set the path to blocking and then do normal
> > GFP_NOFS allocations for these extent buffers.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> You've forgotten at least one place.
> 
> static inline struct extent_buffer *
> get_old_root(struct btrfs_root *root, u64 time_seq)
> {
> ...
>         eb_root = btrfs_read_lock_root_node(root);
> ...
>         } else {
>                 eb = btrfs_clone_extent_buffer(eb_root);
>                 btrfs_tree_read_unlock(eb_root);
> 
> 
> The xfstest btrfs/004 (backref testing) discovered this issue in the
> context of ioctl(BTRFS_IOC_LOGICAL_INO).
>

Ah excellent, thanks.  I will fix this up right now.

Josef 
