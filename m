Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B453AC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 18:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9303A20811
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 18:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfCSSjQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 14:39:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:46430 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726627AbfCSSjQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 14:39:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0FC86AD4E
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 18:39:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AE3FBDA8F6; Tue, 19 Mar 2019 19:40:30 +0100 (CET)
Date:   Tue, 19 Mar 2019 19:40:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Correctly free extent buffer in case
 btree_read_extent_buffer_pages fails
Message-ID: <20190319184030.GQ3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190314075235.22797-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190314075235.22797-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 09:52:35AM +0200, Nikolay Borisov wrote:
> If a an eb fails to be read for whatever reason - it's corrupted on disk
> and parent transid/key validations fail or IO for eb pages fail then
> this buffer must be removed from the buffer cache. Currently the code
> calls free_extent_buffer if an error occurs. Unfortunately this doesn't
> achieve the desired behavior since btrfs_find_create_tree_block returns
> with eb->refs == 2. On the other hand free_extent_buffer will only
> decrement the refs once leavin it added to the buffer cache radix tree.
> This enables later code to look up the buffer from the cache and utilize
> it potentially leading to a crash.
> 
> The correct way to free the buffer is call free_extent_buffer_stale.
> This function will correctly call atomic_dec explicitly for the buffer
> and subsequently call release_extent_buffer which will decrement the
> final reference thus correctly remove the invalid buffer from buffer
> cache. This change affects only newly allocated buffers since they have
> eb->refs == 2.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=202755
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Changes since v1: 
>  * Immediately remove a corrupted extent buffer from readahead_tree_block as 
>  well. 
> 
>  fs/btrfs/disk-io.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f7010312d171..9dda16c27255 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1021,9 +1021,12 @@ void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr)
>  	buf = btrfs_find_create_tree_block(fs_info, bytenr);
>  	if (IS_ERR(buf))
>  		return;
> -	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
> -				 buf, WAIT_NONE, 0);
> -	free_extent_buffer(buf);
> +
> +	if (read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
> +				 buf, WAIT_NONE, 0))

I've switched that to

	ret = read_extent_buffer_pages()
	if (ret < 0)

as this is the common style. Function calls inside the conditions should
be only predicates, the rest should store and check the return value
separately.

Otherwise ok, though the dedicated helper for this would still be nice
to have, but this cann follow later and this patch can go to stable.

Reviewed-by: David Sterba <dsterba@suse.com>
