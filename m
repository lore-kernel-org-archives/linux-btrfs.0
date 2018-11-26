Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0429EC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 14:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA99620663
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 14:12:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="DpkDHJxZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA99620663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbeK0BGa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 20:06:30 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:46395 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbeK0BGa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 20:06:30 -0500
Received: by mail-yb1-f196.google.com with SMTP id i17-v6so7493691ybp.13
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 06:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BfDCTXkbrorc9Xlbed04LQZF++jhLILbanF5CCDkVOk=;
        b=DpkDHJxZoDNre2ssqsPO8oSHtdPRKjIoS/DGoklJgPWnhLnOhzn9Vlk47Ebv+7iT4s
         M6WHlxtQA8PLP7+lide3tFt3K0bWAk+NFqG3qug/bse2P2GFkquR46EIgC+WvoKcQxHu
         my4e+Oyu3SQjt+K8Pn0tjqY4bsSrxUPORyHFlBVLBXlUTHMuc7k5KGvoBj7SQTwjGIqx
         td5A1FtZlEcMc/UFgnvvE8Hi3FxMCmkQd9vo7gmJz1TjZQDorAlQT11cKV17pMLKLH6h
         81FurR8D831shQJipb0zOQTbUtvoVJ4JX7JixMQHPCuPBXGWhcTpoyWWIfVRonfe0Dq7
         hVkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BfDCTXkbrorc9Xlbed04LQZF++jhLILbanF5CCDkVOk=;
        b=Ujo8qTdq8fmergIOUIb2+ErNNh6slSIv3ZEidmEnsjLCqi8odGcaZII1RuROolemjj
         aAwcscaA0de3CbaJ6Ll3siDDu2179C+7fKKkpMxDuaX2vKx6iS4fY0fWlPTgl1I3BLwn
         8K0FjTO99KfThETejf45tL6pOEUd3yaGyp9Z/qxuEHOkArHV4CpJWwaRXXd/iamTy6jw
         TXeqefgr4SdzobD66Oc3sIhlHhCPifC5JOE8yIp5sTs8GrU2uxrtkIb36NN590309gtc
         0awOc3XatoK70d55BJ/7sNRXTW+X92ZUCVKvGi/zpudcn3Gy8K9naD3bKAi0+wBHQ+gS
         RJ2w==
X-Gm-Message-State: AA+aEWatuMBCGx1fT2TQSr0SPEFT9A0DrgU6eQJzvlhKe7gNiaBfr1ba
        FeDyLmUot5SeBNVnreD1OCtW19JOU+k=
X-Google-Smtp-Source: AFSGD/Vk9d4k0EBSG70dm+QP+x6kzuOJWeJeXKNE0RoXCF+LDgDAago98PlB0KNf0LkmGSrSB/ia1A==
X-Received: by 2002:a25:9c47:: with SMTP id x7-v6mr27602237ybo.316.1543241535201;
        Mon, 26 Nov 2018 06:12:15 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id z74sm128877ywz.51.2018.11.26.06.12.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Nov 2018 06:12:14 -0800 (PST)
Date:   Mon, 26 Nov 2018 09:12:29 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: Remove unnecessary code from __btrfs_rebalance
Message-ID: <20181126141228.57zdmhnlsmmkxrcb@MacBook-Pro-91.local>
References: <20181122081733.26082-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122081733.26082-1-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 10:17:33AM +0200, Nikolay Borisov wrote:
> The first step fo the rebalance process, ensuring there is 1mb free on
> each device. This number seems rather small. And in fact when talking
> to the original authors their opinions were:
> 
> "man that's a little bonkers"
> "i don't think we even need that code anymore"
> "I think it was there to make sure we had room for the blank 1M at the
> beginning. I bet it goes all the way back to v0"
> "we just don't need any of that tho, i say we just delete it"
> 
> Clearly, this piece of code has lost its original intent throughout
> the years. It doesn't really bring any real practical benefits to the
> relocation process. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Suggested-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
