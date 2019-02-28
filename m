Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD03C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 14:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66F892133D
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 14:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbfB1OpZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 09:45:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:53480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730509AbfB1OpZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 09:45:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 21B8BAFE9;
        Thu, 28 Feb 2019 14:45:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 63606DA944; Thu, 28 Feb 2019 15:46:43 +0100 (CET)
Date:   Thu, 28 Feb 2019 15:46:43 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] btrfs: extent_io: Always return error pointer for
 extent buffer allocation failure
Message-ID: <20190228144643.GG31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20190225043801.17321-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225043801.17321-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 12:38:01PM +0800, Qu Wenruo wrote:
>  		eb_rewin = alloc_dummy_extent_buffer(fs_info, eb->start);
> -		if (!eb_rewin) {
> +		if (IS_ERR(eb_rewin)) {
>  			btrfs_tree_read_unlock_blocking(eb);
>  			free_extent_buffer(eb);
>  			return NULL;
> @@ -1384,7 +1384,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)

A possible followup patch would be to convert the callchain of
get_old_root and the __tree_mod_log_rewind functions to ERR_PTR.

>  		free_extent_buffer(eb_root);
>  	}
>  
> -	if (!eb)
> +	if (IS_ERR(eb))
>  		return NULL;
>  	btrfs_tree_read_lock(eb);
>  	if (old_root) {
> --- a/fs/btrfs/tests/extent-buffer-tests.c
> +++ b/fs/btrfs/tests/extent-buffer-tests.c
> @@ -48,12 +48,14 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
>  		goto out;
>  	}
>  
> -	path->nodes[0] = eb = alloc_dummy_extent_buffer(fs_info, nodesize);
> -	if (!eb) {
> +	eb = alloc_dummy_extent_buffer(fs_info, nodesize);
> +	if (IS_ERR(eb)) {
> +		eb = NULL;
>  		test_err("could not allocate dummy buffer");
>  		ret = -ENOMEM;

This should also return PTR_ERR(eb)

>  		goto out;
>  	}
> +	path->nodes[0] = eb;
>  	path->slots[0] = 0;
>  
>  	key.objectid = 0;
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
> index 3c46d7f23456..d1f3b727fbf2 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -396,7 +396,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
>  	}
>  
>  	eb = __alloc_dummy_extent_buffer(fs_info, 0, len);
> -	if (!eb) {
> +	if (IS_ERR(eb)) {
>  		test_err("couldn't allocate test extent buffer");
>  		kfree(bitmap);
>  		return -ENOMEM;

same

> @@ -409,7 +409,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
>  	/* Do it over again with an extent buffer which isn't page-aligned. */
>  	free_extent_buffer(eb);
>  	eb = __alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
> -	if (!eb) {
> +	if (IS_ERR(eb)) {
>  		test_err("couldn't allocate test extent buffer");
>  		kfree(bitmap);
>  		return -ENOMEM;

same

> diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
> index 89346da890cf..025fce63959a 100644
> --- a/fs/btrfs/tests/free-space-tree-tests.c
> +++ b/fs/btrfs/tests/free-space-tree-tests.c
> @@ -462,7 +462,8 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
>  	root->fs_info->tree_root = root;
>  
>  	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
> -	if (!root->node) {
> +	if (IS_ERR(root->node)) {
> +		root->node = NULL;
>  		test_err("couldn't allocate dummy buffer");
>  		ret = -ENOMEM;

same

>  		goto out;
> diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
> index af0c8e30d9e2..56a112a39211 100644
> --- a/fs/btrfs/tests/inode-tests.c
> +++ b/fs/btrfs/tests/inode-tests.c
> @@ -249,7 +249,8 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
>  	}
>  
>  	root->node = alloc_dummy_extent_buffer(fs_info, nodesize);
> -	if (!root->node) {
> +	if (IS_ERR(root->node)) {
> +		root->node = NULL;
>  		test_err("couldn't allocate dummy buffer");
>  		goto out;
>  	}
> @@ -850,7 +851,8 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
>  	}
>  
>  	root->node = alloc_dummy_extent_buffer(fs_info, nodesize);
> -	if (!root->node) {
> +	if (IS_ERR(root->node)) {
> +		root->node = NULL;
>  		test_err("couldn't allocate dummy buffer");
>  		goto out;
>  	}
> diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
> index 412b910b04cc..536600eb4d9d 100644
> --- a/fs/btrfs/tests/qgroup-tests.c
> +++ b/fs/btrfs/tests/qgroup-tests.c
> @@ -484,7 +484,8 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
>  	 * *cough*backref walking code*cough*
>  	 */
>  	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
> -	if (!root->node) {
> +	if (IS_ERR(root->node)) {
> +		root->node = NULL;
>  		test_err("couldn't allocate dummy buffer");
>  		ret = -ENOMEM;

same

>  		goto out;
