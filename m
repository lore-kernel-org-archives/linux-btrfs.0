Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31470C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC865204FD
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="Xw3qulsb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC865204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbeK1LcJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 06:32:09 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:51720 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeK1LcJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 06:32:09 -0500
Received: by mail-it1-f195.google.com with SMTP id x19so1655218itl.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uF8RGJtXquII2vLqiQ+G32o6C7XMa46chQNWWHdB2K0=;
        b=Xw3qulsbYTKR2BtAxVyMqiGm5PgDK0VO1HRzCNGNAZdK3nC1pOqmossK4oXwpQZ4CG
         L+Mn+XhzRS9zrgephpQPMRMGjMvfJhG+jDGjPGUkZ5+kCzKFOLFg1GydOo23oL1ZHpcI
         aE6fjryOSV2d/Fc7VrrvWJfzvjWCciBgrMgdJwONS1iMmCmFnQ7rGZ3dNhQ/e4cR+zIh
         EvzaU02SGE4G5pP5ED1Q4aX4YX7MubTkOJlb/k45NxW2/qBBmqCZ+VCK4nCp4H0nB8t8
         a2FEmsLeZboHyDNZMaYmuTvIn2APvz8TTKRuwbvbbVvzNMrn6YsduLkzIB8pfa4+Ifb2
         j0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uF8RGJtXquII2vLqiQ+G32o6C7XMa46chQNWWHdB2K0=;
        b=RS+Fg5uX4JWf2mRLZVhFuTdM+ahiwBOOA//fW9uie3L6boxkhcgfYlD3ass0KA5Trn
         tPGzGo6u9jttetDyBv60y8oXWe2VYktqnSRg4wkXDi2uTBvvGtbeqyaH2NBKNecJBPV2
         rgJdUQCsG07I09JmpjmqKbn2T9K8EyLLg5f5v2vZpSv/1ZV8ukPtpfMKftb6EZALqms4
         ahzJqQDe5RZmE4zAVswOBYSYAH8XJqnDDNuHwG+lPkaFAVPbE3EnyeRev23xKN3SgqXv
         pYXMl7a5z5C6Q1pFUMj6wGZcfNnxjY5eNzLbILQvCk88QaD8u0B4WkrrMUyAEnHuusTH
         /Q8g==
X-Gm-Message-State: AA+aEWbDP4Q5tWXleqVO9GjMsRIgcex3kW6CFAlHZFotLG5Z7u7RDnQk
        SqleOCWaLwEEIta0K9ZYx+IVfjfFcK8=
X-Google-Smtp-Source: AFSGD/XxyL5Bt5VVGoP1aOR30psnTHbNiEUTvPp0DddmBpmyfb9+mJUaGM2O4wLNmg6e9JQ6hkgguA==
X-Received: by 2002:a02:960e:: with SMTP id c14mr18860878jai.84.1543365149029;
        Tue, 27 Nov 2018 16:32:29 -0800 (PST)
Received: from vader ([2620:10d:c090:200::5:71bd])
        by smtp.gmail.com with ESMTPSA id g24sm1724197ioc.54.2018.11.27.16.32.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 16:32:28 -0800 (PST)
Date:   Tue, 27 Nov 2018 16:32:27 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/9] btrfs: switch EXTENT_FLAG_* to enums
Message-ID: <20181128003227.GN846@vader>
References: <cover.1543348078.git.dsterba@suse.com>
 <782a5658022cf91415f8ef168d57616ebab276f0.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <782a5658022cf91415f8ef168d57616ebab276f0.1543348078.git.dsterba@suse.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 08:53:52PM +0100, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> extent map flags.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_map.h | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
> index 31977ffd6190..ef05a0121652 100644
> --- a/fs/btrfs/extent_map.h
> +++ b/fs/btrfs/extent_map.h
> @@ -11,13 +11,20 @@
>  #define EXTENT_MAP_INLINE ((u64)-2)
>  #define EXTENT_MAP_DELALLOC ((u64)-1)
>  
> -/* bits for the flags field */
> -#define EXTENT_FLAG_PINNED 0 /* this entry not yet on disk, don't free it */
> -#define EXTENT_FLAG_COMPRESSED 1
> -#define EXTENT_FLAG_PREALLOC 3 /* pre-allocated extent */
> -#define EXTENT_FLAG_LOGGING 4 /* Logging this extent */
> -#define EXTENT_FLAG_FILLING 5 /* Filling in a preallocated extent */
> -#define EXTENT_FLAG_FS_MAPPING 6 /* filesystem extent mapping type */
> +/* bits for the extent_map::flags field */
> +enum {
> +	/* this entry not yet on disk, don't free it */
> +	EXTENT_FLAG_PINNED,
> +	EXTENT_FLAG_COMPRESSED,
> +	/* pre-allocated extent */
> +	EXTENT_FLAG_PREALLOC,
> +	/* Logging this extent */
> +	EXTENT_FLAG_LOGGING,
> +	/* Filling in a preallocated extent */
> +	EXTENT_FLAG_FILLING,
> +	/* filesystem extent mapping type */
> +	EXTENT_FLAG_FS_MAPPING,
> +};
>  
>  struct extent_map {
>  	struct rb_node rb_node;
> -- 
> 2.19.1
> 
