Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A193EC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 13:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CAD42173C
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 13:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfC1NwS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 09:52:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:54312 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbfC1NwS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 09:52:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E60BEAF2F;
        Thu, 28 Mar 2019 13:52:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E2216DA8D8; Thu, 28 Mar 2019 14:53:28 +0100 (CET)
Date:   Thu, 28 Mar 2019 14:53:28 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCh v2 9/9] btrfs: inode: Verify inode mode to avoid NULL
 pointer dereference
Message-ID: <20190328135328.GE29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-10-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320063717.31770-10-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 02:37:17PM +0800, Qu Wenruo wrote:
> @@ -5726,18 +5734,29 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry)
>  	struct btrfs_root *root = BTRFS_I(dir)->root;
>  	struct btrfs_root *sub_root = root;
>  	struct btrfs_key location;
> +	u8 di_type = 0;
>  	int index;
>  	int ret = 0;
>  
>  	if (dentry->d_name.len > BTRFS_NAME_LEN)
>  		return ERR_PTR(-ENAMETOOLONG);
>  
> -	ret = btrfs_inode_by_name(dir, dentry, &location);
> +	ret = btrfs_inode_by_name(dir, dentry, &location, &di_type);
>  	if (ret < 0)
>  		return ERR_PTR(ret);
>  
>  	if (location.type == BTRFS_INODE_ITEM_KEY) {
>  		inode = btrfs_iget(dir->i_sb, &location, root, NULL);
> +
> +		/* Do extra check against inode mode with di_type */
> +		if (btrfs_inode_type(inode) != di_type) {
> +			btrfs_crit(fs_info,
> +"inode mode mismatch with dir: inode mode=0%o btrfs type=%u dir type=%u",
> +				  inode->i_mode, btrfs_inode_type(inode),
> +				  di_type);
> +			iput(inode);

The iput here seems suspicious.

> +			return ERR_PTR(-EUCLEAN);
> +		}
>  		return inode;
>  	}

5792         index = srcu_read_lock(&fs_info->subvol_srcu);
5793         ret = fixup_tree_root_location(fs_info, dir, dentry,
5794                                        &location, &sub_root);
5795         if (ret < 0) {
5796                 if (ret != -ENOENT)
5797                         inode = ERR_PTR(ret);
5798                 else
5799                         inode = new_simple_dir(dir->i_sb, &location, sub_root);
5800         } else {
5801                 inode = btrfs_iget(dir->i_sb, &location, sub_root, NULL);
5802         }

The iget happens after this block so either there's another one in the caller
to pair, or the above iput is wrong.
