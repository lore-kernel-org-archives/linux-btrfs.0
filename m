Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23156 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbcAZVWZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 16:22:25 -0500
Date: Tue, 26 Jan 2016 13:22:17 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs: add support for multiple csum algorithms
Message-ID: <20160126212217.GB25413@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20160125103134.GA28950@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160125103134.GA28950@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2016 at 01:31:34PM +0300, Dan Carpenter wrote:
> 
> Hello Josef Bacik,
> 
> The patch 607d432da054: "Btrfs: add support for multiple csum
> algorithms" from Dec 2, 2008, leads to the following static checker
> warning:
> 
> 	fs/btrfs/disk-io.c:320 csum_tree_block()
> 	error: __memcpy() '&found' too small (4 vs 9)
> 
> fs/btrfs/disk-io.c
>    278  static int csum_tree_block(struct btrfs_fs_info *fs_info,
>    279                             struct extent_buffer *buf,
>    280                             int verify)
>    281  {
>    282          u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
> 
> The problem here is that we wrote some incomplete stub code 8 years ago
> an never used it.  Can we delete this stuff?
> 
> btrfs_super_csum_type() always returns 0 and thus
> btrfs_super_csum_size() always returns 4.  There is a
> btrfs_set_super_csum_type() function but it is never called otherwise
> we would hit several bugs.

Hmm..since we can only choose one type from btrfs_super_csum_type, this btrfs_set_super_csum_type() is called only when we do mkfs.btrfs.

Thanks,

-liubo
> 
>    283          char *result = NULL;
>    284          unsigned long len;
>    285          unsigned long cur_len;
>    286          unsigned long offset = BTRFS_CSUM_SIZE;
>    287          char *kaddr;
>    288          unsigned long map_start;
>    289          unsigned long map_len;
>    290          int err;
>    291          u32 crc = ~(u32)0;
>    292          unsigned long inline_result;
> 
> Let's assume this is 64 bit system and inline_result is 8 bytes.
> 
>    293  
>    294          len = buf->len - offset;
>    295          while (len > 0) {
>    296                  err = map_private_extent_buffer(buf, offset, 32,
>    297                                          &kaddr, &map_start, &map_len);
>    298                  if (err)
>    299                          return 1;
>    300                  cur_len = min(len, map_len - (offset - map_start));
>    301                  crc = btrfs_csum_data(kaddr + offset - map_start,
>    302                                        crc, cur_len);
>    303                  len -= cur_len;
>    304                  offset += cur_len;
>    305          }
>    306          if (csum_size > sizeof(inline_result)) {
>    307                  result = kzalloc(csum_size, GFP_NOFS);
> 
> In the future code we would allocate 9+ bytes.
> 
>    308                  if (!result)
>    309                          return 1;
>    310          } else {
>    311                  result = (char *)&inline_result;
>    312          }
>    313  
>    314          btrfs_csum_final(crc, result);
> 
> We only ever use the first 4 bytes.  We need to add a size option to
> this function to support future code.
> 
>    315  
>    316          if (verify) {
>    317                  if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
>    318                          u32 val;
>    319                          u32 found = 0;
>    320                          memcpy(&found, result, csum_size);
> 
> If csum_size were more than 4 this would corrupt memory.
> 
>    321  
>    322                          read_extent_buffer(buf, &val, 0, csum_size);
>    323                          btrfs_warn_rl(fs_info,
>    324                                  "%s checksum verify failed on %llu wanted %X found %X "
>    325                                  "level %d",
>    326                                  fs_info->sb->s_id, buf->start,
>    327                                  val, found, btrfs_header_level(buf));
>    328                          if (result != (char *)&inline_result)
>    329                                  kfree(result);
>    330                          return 1;
>    331                  }
>    332          } else {
>    333                  write_extent_buffer(buf, result, 0, csum_size);
>    334          }
>    335          if (result != (char *)&inline_result)
>    336                  kfree(result);
>    337          return 0;
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
