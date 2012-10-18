Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:24241 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2JRHb6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Oct 2012 03:31:58 -0400
Message-ID: <507FB062.1010806@jan-o-sch.net>
Date: Thu, 18 Oct 2012 09:31:46 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: cleanup for __merge_refs
References: <1350544242-2271-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1350544242-2271-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, October 18, 2012 at 09:10 (+0200), Liu Bo wrote:
> Parents must be same after going through ref_for_same_block.

Well. We could kill that for the moment. However, ref_for_same_block wasn't
meant to check for the parent. We should do ...

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -400,8 +400,6 @@ static inline int ref_for_same_block(struct __prelim_ref *ref1,
                return 0;
        if (ref1->key_for_search.offset != ref2->key_for_search.offset)
                return 0;
-       if (ref1->parent != ref2->parent)
-               return 0;

        return 1;
 }

Those two lines were originally added while debugging. The idea was to merge
indirect (parent == 0) and shared backrefs (parent != 0) to avoid the expensive
tree search for indirect backrefs when possible.

We would need extensive testing to remove those two lines from the current
version, though...

-Jan
