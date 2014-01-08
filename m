Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63245 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaAHPJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2014 10:09:08 -0500
Received: by mail-pb0-f48.google.com with SMTP id md12so1679623pbc.21
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jan 2014 07:09:08 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v2 1/4] Btrfs: fix wrong send_in_progress accounting
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20140108121609.GF6498@suse.cz>
Date: Wed, 8 Jan 2014 23:09:02 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-Id: <FBF55D09-2D04-4ACF-A159-2DDD3D896C3A@gmail.com>
References: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140108121609.GF6498@suse.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello David,

> On Tue, Jan 07, 2014 at 05:25:18PM +0800, Wang Shilong wrote:
>> Steps to reproduce:
>> # mkfs.btrfs -f /dev/sda8
>> # mount /dev/sda8 /mnt
>> # btrfs sub snapshot -r /mnt /mnt/snap1
>> # btrfs sub snapshot -r /mnt /mnt/snap2
>> # btrfs send /mnt/snap1 -p /mnt/snap2 -f /mnt/1
>> # dmesg
>> 
>> The problem is that we will sort clone roots(include @send_root), it
>> might push @send_root before thus @send_root's @send_in_progress will
>> be decreased twice.
> 
> Of course, the sort(). I think your fix adds some complexity that's not
> necessary. Whether the clone_roots array is sorted is not important, we
> just have to process each root once.
> 
> send_root becomes a clone_root member, so the missing part is to account
> in the rollback counter:
> 
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -4937,6 +4937,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>         * for possible clone sources.
>         */
>        sctx->clone_roots[sctx->clone_roots_cnt++].root = sctx->send_root;
> +       clone_sources_to_rollback++;

Not really, If we fail to come here, we still need decrease @send_root.
Please correct me if i miss something here.^_^

Thanks,
Wang
> 
>        /* We do a bsearch later */
>        sort(sctx->clone_roots, sctx->clone_roots_cnt,
> @@ -4961,7 +4962,6 @@ out:
>                btrfs_root_dec_send_in_progress(sctx->clone_roots[i].root);
>        if (sctx && !IS_ERR_OR_NULL(sctx->parent_root))
>                btrfs_root_dec_send_in_progress(sctx->parent_root);
> -       btrfs_root_dec_send_in_progress(send_root);

> 
>        kfree(arg);
>        vfree(clone_sources_tmp);
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

