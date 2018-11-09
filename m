Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845D8C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 21:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A9BF20827
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 21:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="hW5qiYy2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A9BF20827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbeKJGnP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 01:43:15 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45374 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbeKJGnP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 01:43:15 -0500
Received: by mail-qk1-f196.google.com with SMTP id d135so4068852qkc.12
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2018 13:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RXNu527BuVoHLZwIZUTjirNOs5WS2YRL65bl9DCZWrE=;
        b=hW5qiYy2s+oFNYKlIJpUN8dwhPN5FgdgmJy5Gfz12HCr3SsLmPi1hLdfywKoTSBUUh
         45UncmFlJoLa8ImPUCio77cagBFoIp+zRgpxUjRIrD4STtIMyc96tYOinAtc7aIbGQbf
         LXbz46oZ1dYvBoy+kTVg2fUX+E8nebqTC2v//e6JyObCfEm1d+wsb066y2wm/zgLzIzp
         qQ7irUQPvHtk+y7bPqQfhZHjjAapCGRVzRtZpRh4AGTVectSvJDeTPfhIbKceTQnVSnr
         /G7S5x2Ljk5s/9J7hWsqo38JpCIon55lUSSxPpUZsN09toJx0wxAb+YS+Z4nuA31R/oA
         /ybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RXNu527BuVoHLZwIZUTjirNOs5WS2YRL65bl9DCZWrE=;
        b=axkCfIonMKb3QIk/dnUTTpzVO2xj2C4Nk5N/0Q7h70u32UBSKkjBRiQdBWJn5mDHSb
         W3KFQ7aY2aENi942om94QPsw4lpw3uuGSOKYv8f2Pi7v0oS2WDdtI5THZPBSi3M3J7jU
         60QN19VS159gsy/JW4DWSP7rB4liXnSxpTOQmtfIT3wqhSig+cxjY/Dg8ytqkRfBR8yQ
         dKV2rfWYtVp8BMX7WvVSYapMJGnvZ5glIntQyT8Z+lGEzwlS6rma7yu9mjkvolES/wSG
         bb0HpaMPiadNwVBSIqtse63Ui7wbnfNZ3ZUwCCwYW9NvYrExYlwwd2fe362/BTA2Jusa
         WXSQ==
X-Gm-Message-State: AGRZ1gKp+wh9uhqn/uYu3gCDVYK7rmP49OTbVOFZ2eLaDDDGCLVj1ws5
        8q7emUheK17Mvp9S9N6Ab+G73w==
X-Google-Smtp-Source: AJdET5cID/AMtsQ/i58YwEExe23baA7ZKrYCFlXqtMiyajBnqP1EW9s/jjnG2Q04ZOJF5FyRkmrgmQ==
X-Received: by 2002:ac8:2b42:: with SMTP id 2mr7385090qtv.255.1541797256354;
        Fri, 09 Nov 2018 13:00:56 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:42b3])
        by smtp.gmail.com with ESMTPSA id o49sm5496813qtf.60.2018.11.09.13.00.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 13:00:55 -0800 (PST)
Date:   Fri, 9 Nov 2018 16:00:54 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: simpler and more efficient cleanup of a log
 tree's extent io tree
Message-ID: <20181109210053.slxljcf5g25ra7nq@macbook-pro-91.dhcp.thefacebook.com>
References: <20181109104308.13123-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109104308.13123-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 09, 2018 at 10:43:08AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We currently are in a loop finding each range (corresponding to a btree
> node/leaf) in a log root's extent io tree and then clean it up. This is a
> waste of time since we are traversing the extent io tree's rb_tree more
> times then needed (one for a range lookup and another for cleaning it up)
> without any good reason.
> 
> We free the log trees when we are in the critical section of a transaction
> commit (the transaction state is set to TRANS_STATE_COMMIT_DOING), so it's
> of great convenience to do everything as fast as possible in order to
> reduce the time we block other tasks from starting a new transaction.
> 
> So fix this by traversing the extent io tree once and cleaning up all its
> records in one go while traversing it.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Sheesh

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
