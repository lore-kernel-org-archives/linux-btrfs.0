Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbaAHMQL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 07:16:11 -0500
Date: Wed, 8 Jan 2014 13:16:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] Btrfs: fix wrong send_in_progress accounting
Message-ID: <20140108121609.GF6498@suse.cz>
Reply-To: dsterba@suse.cz
References: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 07, 2014 at 05:25:18PM +0800, Wang Shilong wrote:
> Steps to reproduce:
>  # mkfs.btrfs -f /dev/sda8
>  # mount /dev/sda8 /mnt
>  # btrfs sub snapshot -r /mnt /mnt/snap1
>  # btrfs sub snapshot -r /mnt /mnt/snap2
>  # btrfs send /mnt/snap1 -p /mnt/snap2 -f /mnt/1
>  # dmesg
> 
> The problem is that we will sort clone roots(include @send_root), it
> might push @send_root before thus @send_root's @send_in_progress will
> be decreased twice.

Of course, the sort(). I think your fix adds some complexity that's not
necessary. Whether the clone_roots array is sorted is not important, we
just have to process each root once.

send_root becomes a clone_root member, so the missing part is to account
in the rollback counter:

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4937,6 +4937,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
         * for possible clone sources.
         */
        sctx->clone_roots[sctx->clone_roots_cnt++].root = sctx->send_root;
+       clone_sources_to_rollback++;

        /* We do a bsearch later */
        sort(sctx->clone_roots, sctx->clone_roots_cnt,
@@ -4961,7 +4962,6 @@ out:
                btrfs_root_dec_send_in_progress(sctx->clone_roots[i].root);
        if (sctx && !IS_ERR_OR_NULL(sctx->parent_root))
                btrfs_root_dec_send_in_progress(sctx->parent_root);
-       btrfs_root_dec_send_in_progress(send_root);

        kfree(arg);
        vfree(clone_sources_tmp);
---
