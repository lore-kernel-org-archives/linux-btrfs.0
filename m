Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33337 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3JVU6v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 16:58:51 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 601FF9A0403
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Oct 2013 14:58:51 -0600 (MDT)
Date: Tue, 22 Oct 2013 16:58:49 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v7 02/13] Btrfs: improve the delayed refs process in rm
 case
Message-ID: <20131022205849.GB10632@localhost.localdomain>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
 <1381726796-27191-3-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1381726796-27191-3-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 14, 2013 at 12:59:44PM +0800, Liu Bo wrote:
> While removing a file with dedup extents, we could have a great number of
> delayed refs pending to process, and these refs refer to droping
> a ref of the extent, which is of BTRFS_DROP_DELAYED_REF type.
> 
> But in order to prevent an extent's ref count from going down to zero when
> there still are pending delayed refs, we first select those "adding a ref"
> ones, which is of BTRFS_ADD_DELAYED_REF type.
> 
> So in removing case, all of our delayed refs are of BTRFS_DROP_DELAYED_REF type,
> but we have to walk all the refs issued to the extent to find any
> BTRFS_ADD_DELAYED_REF types and end up there is no such thing, and then start
> over again to find BTRFS_DROP_DELAYED_REF.
> 
> This is really unnecessary, we can improve this by tracking how many
> BTRFS_ADD_DELAYED_REF refs we have and search by the right type.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
