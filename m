Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF45C43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 13:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AA26206C0
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 13:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfDYNrR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 09:47:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:46198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726452AbfDYNrR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 09:47:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 30D1AAFC5
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 13:47:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 37D62DA847; Thu, 25 Apr 2019 15:48:14 +0200 (CEST)
Date:   Thu, 25 Apr 2019 15:48:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Filip Manana <fdmanana@suse.com>
Subject: Re: [PATCH v3] btrfs: ctree: Dump the leaf before BUG_ON()
Message-ID: <20190425134812.GH20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Filip Manana <fdmanana@suse.com>
References: <20190425005553.3126-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425005553.3126-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 08:55:53AM +0800, Qu Wenruo wrote:
> We have a user reporting BUG_ON() triggered in
> btrfs_set_item_key_safe().
> 
> Let's dump the leaf content before triggering BUG_ON() so that we can
> have some clue on what's going wrong.
> The output of tree locks should help us to debug such problem.
> 
> Reviewed-by: Filip Manana <fdmanana@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Dump slot/old key/new key.
> v3:
> - Output message update, to avoid "on-disk" wording.
> - Use BUG() to replace BUG_ON(1) to make clang quite.
> 
>  fs/btrfs/ctree.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 5116c2a1f0f9..5df76c17775a 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3185,11 +3185,31 @@ void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
>  	slot = path->slots[0];
>  	if (slot > 0) {
>  		btrfs_item_key(eb, &disk_key, slot - 1);
> -		BUG_ON(comp_keys(&disk_key, new_key) >= 0);
> +		if (unlikely(comp_keys(&disk_key, new_key) >= 0)) {
> +			btrfs_crit(fs_info,
> +		"slot %u key (%llu %u %llu) new key (%llu %u %llu)",
> +				   slot, btrfs_disk_key_objectid(&disk_key),
> +				   btrfs_disk_key_type(&disk_key),
> +				   btrfs_disk_key_offset(&disk_key),
> +				   new_key->objectid, new_key->type,
> +				   new_key->offset);
> +			btrfs_print_leaf(eb);
> +			BUG();

This is going to produce a lot of lines, with the stacktrace at the end.
We'll understand what's wrong just by seeing the stack, though the
contents of the leaf will be only in the logs and not on screen. This
hopefully will be available for analysis. I've seen this bug too and
will be able to provide the logs eventually.
