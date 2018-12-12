Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59297C04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 12:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D1A20849
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 12:53:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25D1A20849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbeLLMxL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 07:53:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:38116 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727159AbeLLMxK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 07:53:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42CD5AFB2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 12:53:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 46E5CDA7E5; Wed, 12 Dec 2018 13:52:46 +0100 (CET)
Date:   Wed, 12 Dec 2018 13:52:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] btrfs: improve error handling of btrfs_add_link()
Message-ID: <20181212125245.GT23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181211150315.18414-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211150315.18414-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 11, 2018 at 04:03:15PM +0100, Johannes Thumshirn wrote:
> err holds the return value of either btrfs_del_root_ref() or
> btrfs_del_inode_ref() but it hasn't been checked since it's
> introduction with commit fe66a05a0679 (Btrfs: improve error handling
> for btrfs_insert_dir_item callers) in 2012.
> 
> To quote David:
> 
> "If the error handling in the error handling fails, there's not much left to do
> and the abort either happened earlier in the callees or is necessary here."
> 
> So if one of btrfs_del_root_ref() or btrfs_del_inode_ref() failed, abort the
> transaction.
> 
> Link: https://lore.kernel.org/linux-btrfs/20181126183759.GJ2842@twin.jikos.cz/
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  fs/btrfs/inode.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index c5c27d5457cc..c9457d2580c0 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6311,6 +6311,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
>  	struct btrfs_root *root = parent_inode->root;
>  	u64 ino = btrfs_ino(inode);
>  	u64 parent_ino = btrfs_ino(parent_inode);
> +	int err = 0;
>  
>  	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
>  		memcpy(&key, &inode->root->root_key, sizeof(key));
> @@ -6355,18 +6356,21 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
>  fail_dir_item:
>  	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
>  		u64 local_index;
> -		int err;
> +
>  		err = btrfs_del_root_ref(trans, key.objectid,
>  					 root->root_key.objectid, parent_ino,
>  					 &local_index, name, name_len);
>  
>  	} else if (add_backref) {
>  		u64 local_index;
> -		int err;
>  
>  		err = btrfs_del_inode_ref(trans, root, name, name_len,
>  					  ino, parent_ino, &local_index);
>  	}
> +
> +	if (err)
> +		btrfs_abort_transaction(trans, err);
> +
>  	return ret;
>  }

What I wanted is this:

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6360,12 +6360,16 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
                                         root->root_key.objectid, parent_ino,
                                         &local_index, name, name_len);
 
+               if (err)
+                       btrrfs_abort_transaction(trans, err);
        } else if (add_backref) {
                u64 local_index;
                int err;
 
                err = btrfs_del_inode_ref(trans, root, name, name_len,
                                          ino, parent_ino, &local_index);
+               if (err)
+                       btrrfs_abort_transaction(trans, err);
        }
        return ret;
 }

Ie. each error has its own transaction abort that are not merged to one point.
I believe I said this during the previous reviews.
