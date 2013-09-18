Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57433 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3IRUxJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 16:53:09 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A0D627C067F
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 14:53:08 -0600 (MDT)
Date: Wed, 18 Sep 2013 16:53:04 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jeff.liu@oracle.com>
Subject: Re: [PATCH] Btrfs: export btrfs space shared info to userspace
Message-ID: <20130918205304.GA1615@localhost.localdomain>
References: <1379317212-20246-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1379317212-20246-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 03:40:12PM +0800, Liu Bo wrote:
> Similar to ocfs2, btrfs also supports that extents can be shared by
> different inodes, and there are some userspace tools requesting
> for this kind of 'space shared infomation'.[1]
> 
> ocfs2 uses flag FIEMAP_EXTENT_SHARED, so does btrfs.
> 
> [1]: http://thr3ads.net/ocfs2-devel/2010/09/489052-PATCH-3-3-shared-du-using-fiemap-to-figure-up-the-shared-extents-per-file-and-the-footprint-in
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> RFC->PATCH: use type 'unsigned long' instead of 'int', as David suggested.

This broke any xfstest that used fiemap, so generic/255, generic/316 and
shared/218.  Thanks,

Josef
