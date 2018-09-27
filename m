Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1F4C004D5
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A3F0216FA
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:47:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="P+lnyYD+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A3F0216FA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbeI1BGo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 21:06:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38981 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727621AbeI1BGn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 21:06:43 -0400
Received: by mail-pf1-f195.google.com with SMTP id j8-v6so2527425pff.6
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 11:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T8gGTefPliVXuB3MK0oV0l1+/Y8rrKEEYTUbzCEqKSo=;
        b=P+lnyYD+zP37fltMY+MH51bNITdkTdKOIZMK0IPiAJhMiSwPnMs/zhjXm9JifB9b1W
         wLg4HE0HAjAOQYJiSI16oA0eH7pHW6k8G2y3dxwiO61n935Z3dHYtzfDH5vUxbEEmj/W
         O5JjRtHOVGEBvbCX5ctprLd7QRNu+YVchAPUNrZcZAz6fwT1Iu6nHOpjFbtPk0Znvcgt
         RDvwRyjupjdMUWmZVxrJk6bKUuOJHA+8w5F7evEgRTEoLaxESyiU2cgERPgMng1CUCJI
         JNrW2cE4fO+5DCXfuiZ6qz6v3LQiupWf/fzYvd2usoNdS680PUnpG4Z3fRRM9ngvh/1Y
         tlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T8gGTefPliVXuB3MK0oV0l1+/Y8rrKEEYTUbzCEqKSo=;
        b=XhSp/Qs/IG+875n/QupcFY/lGK4z3GHvY4m8kZBpxhmekffyAqSmW7XL6P9dCGFejk
         KkDRFM06alLzGHerUocgH1k9EfUH5VMc5/m0RC8j3lxH/tNgkurrM8Ef/GO466IqIjgE
         tade6upLoAyLVdxFSkFHSkb42SiIhJp+fu3KKbo5cFyrS8KEW6sU0zP4ftN6xkaK3Utm
         lHEZd4yrEKISpMGYe+xhbUsoY9JJ8Tf7qZe3DPpFZg9k+RHbZ2AwIhbzISFCHwAtBoOU
         hsOHPgW+5BiC3p3bKMw8ipeNB/hh5GnEoFAWKrq7IYT9/+yPKPkXllJE3w2kwMQSg6G9
         f+fw==
X-Gm-Message-State: ABuFfoi1Zur6u5Ta/s28HsHBa4Gk6iKn8U2xp7yKSRS3KS2yZxGEpoOS
        NIO5t7E5w1n43rzBtP2iomS3VQ==
X-Google-Smtp-Source: ACcGV60fAtqrIukR4ErbrTxtK8YDaqNYogDNrpBusrEU/q2A+APnKBjUlrgsZ2FEfXxp72166bKuzA==
X-Received: by 2002:aa7:881a:: with SMTP id c26-v6mr12728116pfo.82.1538074025590;
        Thu, 27 Sep 2018 11:47:05 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::5:3e64])
        by smtp.gmail.com with ESMTPSA id t85-v6sm5561876pfi.73.2018.09.27.11.47.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 11:47:05 -0700 (PDT)
Date:   Thu, 27 Sep 2018 11:47:04 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     dsterba@suse.com, jbacik@fb.com, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: list usage cleanup
Message-ID: <20180927184704.GA29754@vader>
References: <1537950945-5627-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537950945-5627-1-git-send-email-zhongjiang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 26, 2018 at 04:35:45PM +0800, zhong jiang wrote:
> Trival cleanup, list_move_tail will implement the same function that
> list_del() + list_add_tail() will do. hence just replace them.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  fs/btrfs/send.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 094cc144..d87f416 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2075,8 +2075,7 @@ static struct name_cache_entry *name_cache_search(struct send_ctx *sctx,
>   */
>  static void name_cache_used(struct send_ctx *sctx, struct name_cache_entry *nce)
>  {
> -	list_del(&nce->list);
> -	list_add_tail(&nce->list, &sctx->name_cache_list);
> +	list_move_tail(&nce->list, &sctx->name_cache_list);
>  }

At that point do we even need such a trivial helper, considering that
this is only called in one place?
