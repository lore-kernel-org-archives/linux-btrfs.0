Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D07C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 15:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B7A120664
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 15:05:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B7A120664
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504731AbeKXBuX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 20:50:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:55554 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732166AbeKXBuX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 20:50:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C88C9AB42;
        Fri, 23 Nov 2018 15:05:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7552DDA858; Fri, 23 Nov 2018 16:05:33 +0100 (CET)
Date:   Fri, 23 Nov 2018 16:05:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 3/6] btrfs: cleanup extent_op handling
Message-ID: <20181123150531.GE2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-4-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121185912.24288-4-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 01:59:09PM -0500, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> The cleanup_extent_op function actually would run the extent_op if it
> needed running, which made the name sort of a misnomer.  Change it to
> run_and_cleanup_extent_op, and move the actual cleanup work to
> cleanup_extent_op so it can be used by check_ref_cleanup() in order to
> unify the extent op handling.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e3ed3507018d..8a776dc9cb38 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2424,19 +2424,33 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
>  	btrfs_delayed_ref_unlock(head);
>  }
>  
> -static int cleanup_extent_op(struct btrfs_trans_handle *trans,
> -			     struct btrfs_delayed_ref_head *head)
> +static struct btrfs_delayed_extent_op *
> +cleanup_extent_op(struct btrfs_trans_handle *trans,
> +		  struct btrfs_delayed_ref_head *head)

Please keep the type and function name on one line, if the arguments
would overflow, then move it on the next line and un-indent as
necessary. I fix such things when merging, no need to resend.

>  {
>  	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
> -	int ret;
>  
>  	if (!extent_op)
> -		return 0;
> -	head->extent_op = NULL;
> +		return NULL;
> +
>  	if (head->must_insert_reserved) {
> +		head->extent_op = NULL;
>  		btrfs_free_delayed_extent_op(extent_op);
> -		return 0;
> +		return NULL;
>  	}
> +	return extent_op;
> +}
> +
> +static int run_and_cleanup_extent_op(struct btrfs_trans_handle *trans,
> +				     struct btrfs_delayed_ref_head *head)
> +{
> +	struct btrfs_delayed_extent_op *extent_op =
> +		cleanup_extent_op(trans, head);

I prefer to do non-trivial initializations in the statement block, it's
easy to overlook that in among the declarations. Simple variable init,
pointer dereferenes or using simple helpers is fine but cleanup_extent_op
does not seem to fit to that. It's in other patches too so I can update
that unless there are other things that would need a resend.
