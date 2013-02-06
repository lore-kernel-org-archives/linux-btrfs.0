Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:37009 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3BFMNY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 07:13:24 -0500
Message-ID: <5112491F.3080100@die-jansens.de>
Date: Wed, 06 Feb 2013 13:14:23 +0100
From: Arne Jansen <lists@die-jansens.de>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>, Arne Jansen <sensille@gmx.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Lev Vainblat <lev@zadarastorage.com>, miaox <miaox@cn.fujitsu.com>
Subject: Re: Leaking btrfs_qgroup_inherit on snapshot creation?
References: <CAOcd+r2V_Na-hn10GnV04MqjM=CcdrXTQrWSbKbp6S=mxKaTew@mail.gmail.com>
In-Reply-To: <CAOcd+r2V_Na-hn10GnV04MqjM=CcdrXTQrWSbKbp6S=mxKaTew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On 02/06/13 12:18, Alex Lyakas wrote:
> Hi Jan, Arne,
> I see this code in create_snapshot:
> 
> 	if (inherit) {
> 		pending_snapshot->inherit = *inherit;
> 		*inherit = NULL;	/* take responsibility to free it */
> 	}
> 
> So, first thing I think it should be:
> if (*inherit)
> because in btrfs_ioctl_snap_create_v2() we have:
> struct btrfs_qgroup_inherit *inherit = NULL;
> ...
> btrfs_ioctl_snap_create_transid(..., &inherit)
> 
> so the current check is very unlikely to be NULL.

But in btrfs_ioctl_snap_create it is called with NULL, so *inherit would
dereference a NULL pointer.

> 
> Second, I don't see anybody freeing pending_snapshot->inherit. I guess
> it should be freed after callin btrfs_qgroup_inherit() and also in
> btrfs_destroy_pending_snapshots().

You're right. In our original version (6f72c7e20dbaea5) it was still
there, in transaction.c. It has been removed in 6fa9700e734:

commit 6fa9700e734275de2acbcb0e99414bd7ddfc60f1
Author: Miao Xie <miaox@cn.fujitsu.com>
Date:   Thu Sep 6 04:00:32 2012 -0600

    Btrfs: fix error path in create_pending_snapshot()

    This patch fixes the following problem:
    - If we failed to deal with the delayed dir items, we should abort
transaction,
      just as its comment said. Fix it.
    - If root reference or root back reference insertion failed, we should
      abort transaction. Fix it.
    - Fix the double free problem of pending->inherit.
    - Do not restore the trans->rsv if we doesn't change it.
    - make the error path more clearly.

    Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Miao, can you please explain where you see a double free?

-Arne


> Thanks,
> Alex.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

