Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372AEC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF84C2084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:11:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF84C2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbeLENLT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 08:11:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:58622 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727025AbeLENLS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 08:11:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95C45AF41
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 13:11:15 +0000 (UTC)
Subject: Re: [PATCH 02/10] btrfs: basic dax read
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
References: <20181205122835.19290-1-rgoldwyn@suse.de>
 <20181205122835.19290-3-rgoldwyn@suse.de>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <b240dbde-6890-3f33-f662-e30e08cefda9@suse.com>
Date:   Wed, 5 Dec 2018 15:11:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181205122835.19290-3-rgoldwyn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 5.12.18 г. 14:28 ч., Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/Makefile |  1 +
>  fs/btrfs/ctree.h  |  5 ++++
>  fs/btrfs/dax.c    | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/file.c   | 13 ++++++++++-
>  4 files changed, 86 insertions(+), 1 deletion(-)
>  create mode 100644 fs/btrfs/dax.c
> 
> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
> index ca693dd554e9..1fa77b875ae9 100644
> --- a/fs/btrfs/Makefile
> +++ b/fs/btrfs/Makefile
> @@ -12,6 +12,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
>  	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
>  	   uuid-tree.o props.o free-space-tree.o tree-checker.o
>  
> +btrfs-$(CONFIG_FS_DAX) += dax.o
>  btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
>  btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
>  btrfs-$(CONFIG_BTRFS_FS_REF_VERIFY) += ref-verify.o
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 5cc470fa6a40..038d64ecebe5 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3685,6 +3685,11 @@ int btrfs_reada_wait(void *handle);
>  void btrfs_reada_detach(void *handle);
>  int btree_readahead_hook(struct extent_buffer *eb, int err);
>  
> +#ifdef CONFIG_FS_DAX
> +/* dax.c */
> +ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
> +#endif /* CONFIG_FS_DAX */
> +
>  static inline int is_fstree(u64 rootid)
>  {
>  	if (rootid == BTRFS_FS_TREE_OBJECTID ||
> diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
> new file mode 100644
> index 000000000000..d614bf73bf8e
> --- /dev/null
> +++ b/fs/btrfs/dax.c
> @@ -0,0 +1,68 @@
> +#include <linux/dax.h>
> +#include <linux/uio.h>
> +#include "ctree.h"
> +#include "btrfs_inode.h"
> +
> +static ssize_t em_dax_rw(struct inode *inode, struct extent_map *em, u64 pos,
> +		u64 len, struct iov_iter *iter)
> +{
> +        struct dax_device *dax_dev = fs_dax_get_by_bdev(em->bdev);
> +        ssize_t map_len;
> +        pgoff_t blk_pg;
> +        void *kaddr;
> +        sector_t blk_start;
> +        unsigned offset = pos & (PAGE_SIZE - 1);

offset = offset_in_page(pos)

> +
> +        len = min(len + offset, em->len - (pos - em->start));
> +        len = ALIGN(len, PAGE_SIZE);

len = PAGE_ALIGN(len);

> +        blk_start = (get_start_sect(em->bdev) << 9) + (em->block_start + (pos - em->start));
> +        blk_pg = blk_start - offset;
> +        map_len = dax_direct_access(dax_dev, PHYS_PFN(blk_pg), PHYS_PFN(len), &kaddr, NULL);
> +        map_len = PFN_PHYS(map_len)> +        kaddr += offset;
> +        map_len -= offset;
> +        if (map_len > len)
> +                map_len = len;

map_len = min(map_len, len);

> +        if (iov_iter_rw(iter) == WRITE)
> +                return dax_copy_from_iter(dax_dev, blk_pg, kaddr, map_len, iter);
> +        else
> +                return dax_copy_to_iter(dax_dev, blk_pg, kaddr, map_len, iter);

Have you looked at the implementation of dax_iomap_actor where they have
pretty similar code. In case of either of those returning 0 they set ret
to EFAULT, should the same be done in btrfs_file_dax_read? IMO it will
be good of you can follow dax_iomap_actor's logic as much as possible
since this code has been used for quite some time and is deemed robust.

> +}
> +
> +ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to)
> +{
> +        size_t ret = 0, done = 0, count = iov_iter_count(to);
> +        struct extent_map *em;
> +        u64 pos = iocb->ki_pos;
> +        u64 end = pos + count;
> +        struct inode *inode = file_inode(iocb->ki_filp);
> +
> +        if (!count)
> +                return 0;
> +
> +        end = i_size_read(inode) < end ? i_size_read(inode) : end;

end = min(i_size_read(inode), end)

> +
> +        while (pos < end) {
> +                u64 len = end - pos;
> +
> +                em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, len, 0);
> +                if (IS_ERR(em)) {
> +                        if (!ret)
> +                                ret = PTR_ERR(em);
> +                        goto out;
> +                }
> +
> +                BUG_ON(em->flags & EXTENT_FLAG_FS_MAPPING);

I think this can never trigger, because EXTENT_FLAG_FS_MAPPING is set
for extents that map chunk and those are housed in the chunk tree at
fs_info->mapping_tree. Since the write call back is only ever called for
file inodes I'd say this BUG_ON can be eliminated. Did you manage to
trigger it during development?


> +
> +                ret = em_dax_rw(inode, em, pos, len, to);
> +                if (ret < 0)
> +                        goto out;
> +                pos += ret;
> +                done += ret;
> +        }
> +
> +out:
> +        iocb->ki_pos += done;
> +        return done ? done : ret;
> +}
> +
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 58e93bce3036..ef6ed93f44d1 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3308,9 +3308,20 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
>  	return generic_file_open(inode, filp);
>  }
>  
> +static ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
> +{
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +
> +#ifdef CONFIG_FS_DAX
> +	if (IS_DAX(inode))
> +		return btrfs_file_dax_read(iocb, to);
> +#endif
> +	return generic_file_read_iter(iocb, to);
> +}
> +
>  const struct file_operations btrfs_file_operations = {
>  	.llseek		= btrfs_file_llseek,
> -	.read_iter      = generic_file_read_iter,
> +	.read_iter      = btrfs_file_read_iter,
>  	.splice_read	= generic_file_splice_read,
>  	.write_iter	= btrfs_file_write_iter,
>  	.mmap		= btrfs_file_mmap,
> 
