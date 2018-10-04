Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EBCC64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 10:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48DFD20652
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 10:02:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48DFD20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbeJDQyx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 12:54:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:60642 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727311AbeJDQyx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Oct 2018 12:54:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 857BFAE8B;
        Thu,  4 Oct 2018 10:02:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 35781DA82D; Thu,  4 Oct 2018 12:02:20 +0200 (CEST)
Date:   Thu, 4 Oct 2018 12:02:20 +0200
From:   David Sterba <dsterba@suse.cz>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     dsterba@suse.cz, osandov@osandov.com, dsterba@suse.com,
        jbacik@fb.com, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] btrfs: list usage cleanup
Message-ID: <20181004100220.GA29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, zhong jiang <zhongjiang@huawei.com>,
        osandov@osandov.com, dsterba@suse.com, jbacik@fb.com, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1538628507-32593-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538628507-32593-1-git-send-email-zhongjiang@huawei.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 12:48:27PM +0800, zhong jiang wrote:
> Trival cleanup, list_move_tail will implement the same function that
> list_del() + list_add_tail() will do. hence just replace them.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  fs/btrfs/send.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 094cc144..30e7e12 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2075,8 +2075,8 @@ static struct name_cache_entry *name_cache_search(struct send_ctx *sctx,
>   */
>  static void name_cache_used(struct send_ctx *sctx, struct name_cache_entry *nce)
>  {
> -	list_del(&nce->list);
> -	list_add_tail(&nce->list, &sctx->name_cache_list);
> +	/* delete from sctx->name_cache_list and add as its tail */
> +	list_move_tail(&nce->list, &sctx->name_cache_list);

The suggestion was to drop name_cache_used and replace it with
list_move_tail(...), the comment as you wrote it does not bring much
information as it merely repeats how list_move_tail is implemeted. A
useful comment explains something that's not obvious.
