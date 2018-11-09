Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CE3C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 21:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF57720825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 21:10:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="m2PhrNJb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF57720825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbeKJGxC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 01:53:02 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33542 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbeKJGxC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 01:53:02 -0500
Received: by mail-yw1-f67.google.com with SMTP id z72-v6so2226597ywa.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2018 13:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yklW8xaZI0qCLCTspv08t6iORK/1ZUknOk0qnYEjQ2E=;
        b=m2PhrNJbohuE0FOVC2G40p91ZSFdcMog7ltx/lu4fgtoWLCvEEXNnQPWCHl/5Oqehw
         5vpERlQ29WNi1SZwq5ZFpq8YLCw//EVVjEbFSuzHAVFjYPPb5B3MLac59HZ+Vv5WYQGp
         G5MklBZ63S6sjn2bCtqWh0WHB31c/l7eeeOvlluvvVvyJtMLmANrplzcooqM63VeyPTP
         fcAHT5ppvblL1hrHTDPW+TpiV/Jr3xNkqsKOIIFDYIvb3NVDOJvVKAtnhNQZTrJ1FpRX
         ijLAUQqfnKDiHGjvyziYY1u2myUJ9jz152LLpsarU5CDyCO77xCQdWePWWVFg7gsRsxA
         iS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yklW8xaZI0qCLCTspv08t6iORK/1ZUknOk0qnYEjQ2E=;
        b=giFDT91Cvv69wqzmq0TYNF0zOZlIXgvxNGXWyAn1VFGhSgvur8ofVB5DSFDV9mD4ek
         przdSbXaY9LyVm3NBJbqHZBuPZ3/Nl2JzxA/2KeXCMWZX1xEfCImvJdrtVwtUFjeGugI
         6gBtfvg6ZAkco1XBo3CTjeuZtJSdkPU+J87zzEios0g/z9T8EB82tF4G+FYRNEWT2r5M
         vGF2QtvQwbf66DJqxvx5eo3u0z2EOH4Rj2S7Ej6hptuMdXoCV8Uc0p9BksSZNQMg1+Zv
         tHW83dej6uKxJnORFNHT/FuxzHs0tE4oqf6aLjUIcTBtWSGwUQv8AqwjSEnLDjdPQYu7
         Z+zA==
X-Gm-Message-State: AGRZ1gJ7voGVlq2DlDJL3dl0fk9viWkQ3+B5o0Y0JgjBABs+q75HlkBY
        61+Qgy/L6n99KSr5QPkWd06TOQ==
X-Google-Smtp-Source: AJdET5fKZDng0O7JkAL25FNkkQQLFtI0emCXOta009z8rCiVEiWpu2WjKhcUEga96xzq7p7J+pURSA==
X-Received: by 2002:a81:4502:: with SMTP id s2-v6mr10161213ywa.363.1541797842133;
        Fri, 09 Nov 2018 13:10:42 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:42b3])
        by smtp.gmail.com with ESMTPSA id 207-v6sm2545552ywl.50.2018.11.09.13.10.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 13:10:41 -0800 (PST)
Date:   Fri, 9 Nov 2018 16:10:40 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v15.1 01/13] btrfs: dedupe: Introduce dedupe framework
 and its header
Message-ID: <20181109211040.qxich5ecxzbbgdao@macbook-pro-91.dhcp.thefacebook.com>
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
 <20181106064122.6154-2-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106064122.6154-2-lufq.fnst@cn.fujitsu.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 06, 2018 at 02:41:10PM +0800, Lu Fengqi wrote:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> 
> Introduce the header for btrfs in-band(write time) de-duplication
> framework and needed header.
> 
> The new de-duplication framework is going to support 2 different dedupe
> methods and 1 dedupe hash.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.h           |   7 ++
>  fs/btrfs/dedupe.h          | 128 ++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/disk-io.c         |   1 +
>  include/uapi/linux/btrfs.h |  34 ++++++++++
>  4 files changed, 168 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 80953528572d..910050d904ef 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1118,6 +1118,13 @@ struct btrfs_fs_info {
>  	spinlock_t ref_verify_lock;
>  	struct rb_root block_tree;
>  #endif
> +
> +	/*
> +	 * Inband de-duplication related structures
> +	 */
> +	unsigned long dedupe_enabled:1;

Please use a BTRFS_FS_ flag for this.  Thanks,

Josef
