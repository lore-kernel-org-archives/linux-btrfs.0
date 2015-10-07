Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbbJGIrD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 04:47:03 -0400
Date: Wed, 7 Oct 2015 10:45:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: fix qgroup sanity tests
Message-ID: <20151007084556.GB7734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444057388-10949-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444057388-10949-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 05, 2015 at 11:03:08AM -0400, Josef Bacik wrote:
> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
> +	if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state))) {
> +		srcu_read_unlock(&fs_info->subvol_srcu, index);
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +#endif

The inline ifdefs are not necessary, please use the helper

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -362,13 +362,12 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
                goto out;
        }

-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-       if (unlikely(test_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state))) {
+       if (btrfs_test_is_dummy_root(root)) {
                srcu_read_unlock(&fs_info->subvol_srcu, index);
                ret = -ENOENT;
                goto out;
        }
-#endif
+
        if (path->search_commit_root)
                root_level = btrfs_header_level(root->commit_root);
        else if (time_seq == (u64)-1)

