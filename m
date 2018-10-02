Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EC9C43143
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 13:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFF372064D
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 13:48:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFF372064D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732623AbeJBUb0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 16:31:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:49082 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731738AbeJBUb0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Oct 2018 16:31:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F1CDAE54;
        Tue,  2 Oct 2018 13:47:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 56678DAD55; Tue,  2 Oct 2018 15:47:57 +0200 (CEST)
Date:   Tue, 2 Oct 2018 15:47:57 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 16/42] btrfs: loop in inode_rsv_refill
Message-ID: <20181002134756.GY3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20180928111821.24376-1-josef@toxicpanda.com>
 <20180928111821.24376-17-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180928111821.24376-17-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 07:17:55AM -0400, Josef Bacik wrote:
> With severe fragmentation we can end up with our inode rsv size being
> huge during writeout, which would cause us to need to make very large
> metadata reservations.  However we may not actually need that much once
> writeout is complete.  So instead try to make our reservation, and if we
> couldn't make it re-calculate our new reservation size and try again.
> If our reservation size doesn't change between tries then we know we are
> actually out of space and can error out.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 7a53f6a29ebc..461b8076928b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5781,10 +5781,11 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
>  {
>  	struct btrfs_root *root = inode->root;
>  	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
> -	u64 num_bytes = 0;
> +	u64 num_bytes = 0, last = 0;
>  	u64 qgroup_num_bytes = 0;
>  	int ret = -ENOSPC;
>  
> +again:

Could this be restructured so there's no new 'goto again;' pattern
added?
