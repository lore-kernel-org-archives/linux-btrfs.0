Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEB2C6783C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D1620868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="T3qt5fE+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41D1620868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbeJLVZp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 17:25:45 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46112 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbeJLVZo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 17:25:44 -0400
Received: by mail-qt1-f194.google.com with SMTP id d8-v6so13854624qtk.13
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 06:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N1sT4EW2jpOQmCwwHE2xJF+ETeYje2G+9lbHMVZtGUg=;
        b=T3qt5fE+hHQe7WoygCCrIxyRd/6ooNtdqVZ2eJ5jrPUbDcTuXICp7eByTHuNFxgrAt
         2WcWMR1HvTsWZuCqLxXXHIcKSPksTV+cC1z3NjsH3ikQNTlXTbvsSFzY3DvndaYxwo/N
         9AqFQv5qGEbS0/WwzHTJBeaZRIpmM2P56egxKs78RXfbrwmIU5B6EwLkhmnBnYRVh+lR
         eB6+IS2I7WilPK0SSC56YdYSG/KXUGuIUxYmpP5vKyizmKkjAe2MIomskotUMF55sum1
         OP84MCTq7XiR8A9f18+BV6PG5BLGgn4HRn+5fBYcwXoKLOIdygtig5p7Li+/kUJpjFpE
         To7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N1sT4EW2jpOQmCwwHE2xJF+ETeYje2G+9lbHMVZtGUg=;
        b=nABvhPTmsj/D15x5zDG9jkWGx8liZLH/H/D52GuJ2inTCd3a2zf9NLZB3lAiGTiB0J
         od5qvTppGukI9x7W9NirlSp/IcgsA7DNcz/S0srutR6iSoBs5RNupc699zLgLg12VaIV
         q7W8x6TA6/KtzoPpCnlWRl5ENF0fW3sBY4Y1RKc4jq4JtCfZcV6sSTznMI6k57qb7qfR
         k0kiUs85JqHZp6vkhQfxRiJho2NbPw4VJE/BxGW5j3R31QvwnFMv/3i7B6jxYOwhOmSB
         4X/FRpzp90/aKCP5rUAMX+3jn9+GBOymB1F/PXhbjEX9M1CwZeWh7+NKZ0QKWmDwm2FO
         1RZw==
X-Gm-Message-State: ABuFfojYqoa08D3/zeo92f1S9p3WlAzVi5E0vWcFi2+xGsOH9Ek2ciqU
        3fmYMvj3jOgIxW38udxrrS8cXA==
X-Google-Smtp-Source: ACcGV611WbTbOcCqpn2hfynI0PwgS7Smbl8aGd+swVW/6Ad0EptMHaBDLSKP7xP8i/L77anBVp+/GQ==
X-Received: by 2002:a0c:b178:: with SMTP id r53-v6mr5889127qvc.3.1539352391228;
        Fri, 12 Oct 2018 06:53:11 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m46-v6sm783528qtk.48.2018.10.12.06.53.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 06:53:10 -0700 (PDT)
Date:   Fri, 12 Oct 2018 09:53:09 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/4] btrfs: Refactor clustered extent allocation into
 find_free_extent_clustered()
Message-ID: <20181012135308.5cirhy2yl24jwrj5@destiny>
References: <20181012061819.19482-1-wqu@suse.com>
 <20181012061819.19482-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012061819.19482-3-wqu@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 02:18:17PM +0800, Qu Wenruo wrote:
> We have two main methods to find free extents inside a block group:
> 1) clustered allocation
> 2) unclustered allocation
> 
> This patch will extract the clustered allocation into
> find_free_extent_clustered() to make it a little easier to read.
> 
> Instead of jumping between different labels in find_free_extent(), the
> helper function will use return value to indicate different behavior.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
