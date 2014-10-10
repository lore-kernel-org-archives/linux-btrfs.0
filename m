Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaJJInZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 04:43:25 -0400
Date: Fri, 10 Oct 2014 10:43:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: repair missing dir index
Message-ID: <20141010084323.GG22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1412275839-8131-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412275839-8131-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 02, 2014 at 02:50:39PM -0400, Josef Bacik wrote:
> +static int repair_inode_backrefs(struct btrfs_root *root,
> +				 struct inode_record *rec,
> +				 struct cache_tree *inode_cache)
> +{
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_path *path;
> +	struct inode_backref *tmp, *backref;
> +	u64 root_dirid = btrfs_root_dirid(&root->root_item);
> +	int ret;

Changed to ret = 1,

> +	list_for_each_entry_safe(backref, tmp, &rec->backrefs, list) {
[...]
> +	}

gcc prints warning about possibly unitilized ret here:

> +	BUG_ON(repaired && ret); /* Poor mans transaction abort */

So it would abort in case the list_for_each loop does not execute for
some reason.
