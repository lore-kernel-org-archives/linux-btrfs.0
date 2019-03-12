Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D329BC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 08:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A365214AF
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 08:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfCLI2U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:28:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:46502 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbfCLI2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 04:28:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 01037B14A;
        Tue, 12 Mar 2019 08:28:16 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Check the first key and level for cached extent
 buffer
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190312074558.32393-1-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f7d7989b-cb5c-3148-f9be-874abfe1c1c8@suse.com>
Date:   Tue, 12 Mar 2019 10:28:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190312074558.32393-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12.03.19 г. 9:45 ч., Qu Wenruo wrote:
> [BUG]
> When reading a file from a fuzzed image, kernel can panic like:
>   BTRFS warning (device loop0): csum failed root 5 ino 270 off 0 csum 0x98f94189 expected csum 0x00000000 mirror 1
>   assertion failed: !memcmp_extent_buffer(b, &disk_key, offsetof(struct btrfs_leaf, items[0].key), sizeof(disk_key)), file: fs/btrfs/ctree.c, line: 2544
>   ------------[ cut here ]------------
>   kernel BUG at fs/btrfs/ctree.h:3500!
>   invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>   RIP: 0010:btrfs_search_slot.cold.24+0x61/0x63 [btrfs]
>   Call Trace:
>    btrfs_lookup_csum+0x52/0x150 [btrfs]
>    __btrfs_lookup_bio_sums+0x209/0x640 [btrfs]
>    btrfs_submit_bio_hook+0x103/0x170 [btrfs]
>    submit_one_bio+0x59/0x80 [btrfs]
>    extent_read_full_page+0x58/0x80 [btrfs]
>    generic_file_read_iter+0x2f6/0x9d0
>    __vfs_read+0x14d/0x1a0
>    vfs_read+0x8d/0x140
>    ksys_read+0x52/0xc0
>    do_syscall_64+0x60/0x210
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> [CAUSE]
> The fuzzed image has a corrupted leaf whose first key doesn't match with its parent:
>   checksum tree key (CSUM_TREE ROOT_ITEM 0)
>   node 29741056 level 1 items 14 free 107 generation 19 owner CSUM_TREE
>   fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
>   chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
>   	...
>           key (EXTENT_CSUM EXTENT_CSUM 79691776) block 29761536 gen 19
> 
>   leaf 29761536 items 1 free space 1726 generation 19 owner CSUM_TREE
>   leaf 29761536 flags 0x1(WRITTEN) backref revision 1
>   fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
>   chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
>           item 0 key (EXTENT_CSUM EXTENT_CSUM 8798638964736) itemoff 1751 itemsize 2244
>                   range start 8798638964736 end 8798641262592 length 2297856
> 
> For the first time tree read, it will not pass verify_level_key() check.
> But the extent buffer will still be cached.
> 
> Also there is a pitfall in read_block_for_search(), where a cached
> extent buffer will not be checked for its level and first key.
> 
> There are context where we read tree block without verifying its
> first key, such as scrub.
> 
> So in that case, a corrupted leaf can sneak in and screw up the kernel.
> 
> [FIX]
> Export verify_level_key() as btrfs_verify_level_key() and call it in
> read_block_for_search() to fill the hole.
> 
> Please note, this will cause a lot of extra error message if we have a
> bad tree block in any hot tree, but it's still much better to trigger
> the final safe net in key_search_validate().
> 
> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202755
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202757
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202759
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202761
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202767
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202769
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Additionally which of those 6 issues contain the image which triggers
this problem or all of them ?

> ---
> There is one remaining report where I can't get any kernel message
> before the VM completely lost reponse.
> https://bugzilla.kernel.org/show_bug.cgi?id=202763
> (out-of-bound access in end_bio_extent_readpage() when mounting and operating a crafted btrfs image)
> 
> And the above case can't be fixed by this patch. Still trying to get a
> good idea of what's going wrong (AKA good kernel message).
> 
> There is also another report, which doesn't provide the fuzzed image.
> https://bugzilla.kernel.org/show_bug.cgi?id=202765
> (NULL pointer dereference when mounting a crafted btrfs image)
> ---
>  fs/btrfs/ctree.c   | 10 ++++++++++
>  fs/btrfs/disk-io.c | 10 +++++-----
>  fs/btrfs/disk-io.h |  3 +++
>  3 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 5a6c39b44c84..37447a7c5b4d 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2401,6 +2401,16 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
>  	if (tmp) {
>  		/* first we do an atomic uptodate check */
>  		if (btrfs_buffer_uptodate(tmp, gen, 1) > 0) {
> +			/*
> +			 * Do extra check for first_key, as it's possible the
> +			 * eb is read from the context without first_key
> +			 * requirement
> +			 */
> +			if (btrfs_verify_level_key(fs_info, tmp,
> +					parent_level - 1, &first_key, gen)) {
> +				free_extent_buffer(tmp);
> +				return -EUCLEAN;
> +			}
>  			*eb_ret = tmp;
>  			return 0;
>  		}
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 298b34721bc0..e2a0cb362d28 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -423,9 +423,9 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  	return ret;
>  }
>  
> -static int verify_level_key(struct btrfs_fs_info *fs_info,
> -			    struct extent_buffer *eb, int level,
> -			    struct btrfs_key *first_key, u64 parent_transid)
> +int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
> +			   struct extent_buffer *eb, int level,
> +			   struct btrfs_key *first_key, u64 parent_transid)
>  {
>  	int found_level;
>  	struct btrfs_key found_key;
> @@ -500,8 +500,8 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
>  			if (verify_parent_transid(io_tree, eb,
>  						   parent_transid, 0))
>  				ret = -EIO;
> -			else if (verify_level_key(fs_info, eb, level,
> -						  first_key, parent_transid))
> +			else if (btrfs_verify_level_key(fs_info, eb, level,
> +						first_key, parent_transid))
>  				ret = -EUCLEAN;
>  			else
>  				break;
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 987a64bc0c66..67a9fe2d29c7 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -39,6 +39,9 @@ static inline u64 btrfs_sb_offset(int mirror)
>  struct btrfs_device;
>  struct btrfs_fs_devices;
>  
> +int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
> +			   struct extent_buffer *eb, int level,
> +			   struct btrfs_key *first_key, u64 parent_transid);
>  struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
>  				      u64 parent_transid, int level,
>  				      struct btrfs_key *first_key);
> 
