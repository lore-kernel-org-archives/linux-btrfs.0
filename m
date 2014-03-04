Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37212 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaCDCSG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 21:18:06 -0500
Date: Tue, 4 Mar 2014 10:17:56 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: gHcAgree <agree.ms@hotmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: remove unused code in full_send_tree
Message-ID: <20140304021755.GA27809@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1393853463-26215-1-git-send-email-bo.li.liu@oracle.com>
 <BLU0-SMTP2745244EE7D59BA5FBAB7A38B8F0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <BLU0-SMTP2745244EE7D59BA5FBAB7A38B8F0@phx.gbl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 03, 2014 at 09:53:45PM +0800, gHcAgree wrote:
> 
> On 2014年03月03日 21:31, Liu Bo wrote:
> >It's unnecessary to update key's value, and remove it to keep code clean.
> >
> >Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >---
> >  fs/btrfs/send.c | 4 ----
> >  1 file changed, 4 deletions(-)
> >
> >diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> >index 3fe4d6e..a5f9626 100644
> >--- a/fs/btrfs/send.c
> >+++ b/fs/btrfs/send.c
> >@@ -5180,10 +5180,6 @@ static int full_send_tree(struct send_ctx *sctx)
> >  		if (ret < 0)
> >  			goto out;
> >-		key.objectid = found_key.objectid;
> >-		key.type = found_key.type;
> >-		key.offset = found_key.offset + 1;
> >-
> >  		ret = btrfs_next_item(send_root, path);
> >  		if (ret < 0)
> >  			goto out;
> Hi Liu and all,
> I think the statements may better be reserved. I noticed that there
> is an "goto join_trans" above. I think we may hit it in the next
> round and exec from the "join_trans" down, then these 3 assignments
> effect.

Yeah, I think you're right, with btrfs-next, we should keep these assignments.

-liubo
