Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE31C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 15:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C67AA2082C
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 15:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfCYPIS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 11:08:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:56700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726185AbfCYPIS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 11:08:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 366DDAF2D
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 15:08:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 064B0DA825; Mon, 25 Mar 2019 16:09:29 +0100 (CET)
Date:   Mon, 25 Mar 2019 16:09:28 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 03/12] btrfs: Handle pending/pinned chunks before
 blockgroup relocation during device shrink
Message-ID: <20190325150928.GF10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190325123132.27835-1-nborisov@suse.com>
 <20190325123132.27835-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325123132.27835-4-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 02:31:23PM +0200, Nikolay Borisov wrote:
> During device shrink pinned/pending chunks (i.e those which have been
> deleted/created respectively, in the current transaction and haven't
> touched disk) need to be accounted when doing device shrink. Presently
> this happens after the main relocation loop in btrfs_shrink_device,
> which could lead to making another go in the body of the function.
> 
> Since there is no hard requirement to perform pinned/pending chunks
> handling after the relocation loop, move the code before it. This leads
> to simplifying the code flow around - i.e no need to use 'goto again'.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/volumes.c | 54 ++++++++++++++++++----------------------------
>  1 file changed, 21 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3f81380265e5..b49cc5ad758e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4722,15 +4722,15 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>  	int slot;
>  	int failed = 0;
>  	bool retried = false;
> -	bool checked_pending_chunks = false;
>  	struct extent_buffer *l;
>  	struct btrfs_key key;
>  	struct btrfs_super_block *super_copy = fs_info->super_copy;
>  	u64 old_total = btrfs_super_total_bytes(super_copy);
>  	u64 old_size = btrfs_device_get_total_bytes(device);
>  	u64 diff;
> +	u64 start;
>  
> -	new_size = round_down(new_size, fs_info->sectorsize);
> +	start = new_size = round_down(new_size, fs_info->sectorsize);

Please don't do that in new code, ie. no chained initializations.
