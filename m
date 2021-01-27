Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A779EC433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Jan 2021 16:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E9164D9E
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Jan 2021 16:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhA0Qst (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 11:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbhA0Qsl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jan 2021 11:48:41 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC73C061574
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2021 08:48:01 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id v3so1858899qtw.4
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2021 08:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fn163KSjdiR2JS0xYCvv068nEb+kJDfD8b+eJ6Z5U8k=;
        b=x941nDCEg+9Jf4KBE60co6Dro7GlPEBiYYNFU4Hbr0cIlzPlkDcQI/FfiVn22nmHDp
         LV+N8yjpNfsfT/dnM4xNltPQvJDLo5Dq9VbCN20W32CM3JWELVSIlkfPdoUoIS/ykey/
         bcRoXz0FPPskXIDvvy9RftQW5D0eHRqfxzip6gqJsLeXg3wWbgzYIEO6D3J6PgwdefGP
         A6/v/WRb84gZcJKDthV8p/a4T5rObZCuviSVDV++mWdjUcvloGtg5UNNUxNTUP3bEDT6
         +cp0X42nJj58RvGZVZbEaBEcVNawDs2/yjuKwMexZZJLxH9R0aoRT+5WPs/YP7kW8MfH
         VVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fn163KSjdiR2JS0xYCvv068nEb+kJDfD8b+eJ6Z5U8k=;
        b=pxtbzXn4x9tUH1gagX+Jc4AEMAsYA8bpZoO3UMJ+Uvs/XPw5xfYonC/dik874hEmSu
         aK03TVokHQZd0XONbb5LPMhtZq7OquNMuXOe297vZzT6Q1XXynVqAuPcRRJdxgsmyLF8
         eC1/BvAdREMOwhGH4fd/9z3vsaimXRs0cNTy/dV5Ep8uN6mDOC6Af0GffbLZngurGBCF
         CAXsGABREpGHZsxhxQydqkhfpdmzvOlh4IMr4nkEQt2ozayFdOPpPJ5l6q2Kiuff2g3N
         qO2kbk3tB2BgThXqSM0vTPlw8NllA/1UixzCcTN/MYWC7XC1vy1KgbxP45GSLrZkL9uX
         jf5w==
X-Gm-Message-State: AOAM533ud9GaG+nPx6X7lASiP79bKZhGVBDx+gv+DQ8VyghfBlk7xoEc
        WExVCeWf5TH6pLEIhsdv+i/S1YqRtFAnjTCj
X-Google-Smtp-Source: ABdhPJxG7+9VgGV57T4lVmFSTI82s80UFwW3Yh4tJJNue5lajBHa12jXwfngCDQ/SN49eFVAMflL9w==
X-Received: by 2002:ac8:57ca:: with SMTP id w10mr10353103qta.12.1611766080413;
        Wed, 27 Jan 2021 08:48:00 -0800 (PST)
Received: from [192.168.1.45] (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id b13sm1580639qto.43.2021.01.27.08.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 08:47:59 -0800 (PST)
Subject: Re: [PATCH v5 15/18] btrfs: introduce subpage metadata validation
 check
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
References: <20210126083402.142577-1-wqu@suse.com>
 <20210126083402.142577-16-wqu@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <190dd9ef-799c-6dbd-794d-5b5167351721@toxicpanda.com>
Date:   Wed, 27 Jan 2021 11:47:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126083402.142577-16-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 1/26/21 3:33 AM, Qu Wenruo wrote:
> For subpage metadata validation check, there are some differences:
> 
> - Read must finish in one bvec
>    Since we're just reading one subpage range in one page, it should
>    never be split into two bios nor two bvecs.
> 
> - How to grab the existing eb
>    Instead of grabbing eb using page->private, we have to go search radix
>    tree as we don't have any direct pointer at hand.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
