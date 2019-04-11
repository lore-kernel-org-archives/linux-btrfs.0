Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECABC10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 11:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83CED2133D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 11:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfDKLDx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 07:03:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:44908 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726121AbfDKLDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 07:03:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B58D1ABAC;
        Thu, 11 Apr 2019 11:03:50 +0000 (UTC)
Subject: Re: [PATCH v3] btrfs-progs: Don't BUG_ON() when write_dev_supers()
 fails
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190411110100.20938-1-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <4c4a5376-c27e-b04c-2123-9da652585009@suse.com>
Date:   Thu, 11 Apr 2019 14:03:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190411110100.20938-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11.04.19 г. 14:01 ч., Qu Wenruo wrote:
> [BUG]
> Since commit "btrfs-progs: disk-io: Flush to ensure super block write is
> FUA" mkfs-tests/017 will fail like:
> 
>   ====== RUN MUSTFAIL /home/adam/btrfs-progs/mkfs.btrfs -K -f /dev/mapper/btrfs-progs-thin-vol
>   ERROR: failed to write super block for devid 1: flush error: Input/output error
>   disk-io.c:1810: write_all_supers: BUG_ON `ret` triggered, value -5
>   /home/adam/btrfs-progs/mkfs.btrfs(+0x1e5c1)[0x557a2c83e5c1]
>   /home/adam/btrfs-progs/mkfs.btrfs(+0x1e65f)[0x557a2c83e65f]
>   /home/adam/btrfs-progs/mkfs.btrfs(write_all_supers+0x1ce)[0x557a2c843a8a]
>   /home/adam/btrfs-progs/mkfs.btrfs(write_ctree_super+0x12d)[0x557a2c843be2]
>   /home/adam/btrfs-progs/mkfs.btrfs(btrfs_commit_transaction+0x250)[0x557a2c887c56]
>   /home/adam/btrfs-progs/mkfs.btrfs(+0xc0b1)[0x557a2c82c0b1]
>   /home/adam/btrfs-progs/mkfs.btrfs(main+0x1049)[0x557a2c82e929]
>   /usr/lib/libc.so.6(__libc_start_main+0xf3)[0x7f6689e99223]
>   /home/adam/btrfs-progs/mkfs.btrfs(_start+0x2e)[0x557a2c82b86e]
>   failed (expected): /home/adam/btrfs-progs/mkfs.btrfs -K -f /dev/mapper/btrfs-progs-thin-vol
> 
> [CAUSE]
> Just one BUG_ON() in write_all_supers().
> 
> [FIX]
> Just remove the BUG_ON(). Callers of write_all_supers() are already
> checking the return value.
> 
> Also since write_all_supers() can return error, make write_ctree_super()
> callers, btrfs_commit_transaction() and close_ctree_fs_info() to
> handle the error correctly.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

This seems more compact than the previous version.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> Changelog:
> v2:
> - Make write_ctree_super() callers to handle the error properly.
> v3:
> - Use skip_commit label to skip unnecessary super block write.
> ---
>  disk-io.c     | 9 +++++++--
>  transaction.c | 2 +-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 10550151c5bb..151eb3b5a278 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1807,7 +1807,8 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
>  		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
>  
>  		ret = write_dev_supers(fs_info, sb, dev);
> -		BUG_ON(ret);
> +		if (ret < 0)
> +			return ret;
>  	}
>  	return 0;
>  }
> @@ -1863,8 +1864,12 @@ int close_ctree_fs_info(struct btrfs_fs_info *fs_info)
>  		BUG_ON(ret);
>  		ret = __commit_transaction(trans, root);
>  		BUG_ON(ret);
> -		write_ctree_super(trans);
> +		ret = write_ctree_super(trans);
>  		kfree(trans);
> +		if (ret) {
> +			err = ret;
> +			goto skip_commit;
> +		}
>  	}
>  
>  	if (fs_info->finalize_on_close) {
> diff --git a/transaction.c b/transaction.c
> index e756db332fec..3a63988b0969 100644
> --- a/transaction.c
> +++ b/transaction.c
> @@ -197,7 +197,7 @@ commit_tree:
>  	__commit_transaction(trans, root);
>  	if (ret < 0)
>  		goto out;
> -	write_ctree_super(trans);
> +	ret = write_ctree_super(trans);
>  	btrfs_finish_extent_commit(trans, fs_info->extent_root,
>  			           &fs_info->pinned_extents);
>  	kfree(trans);
> 
