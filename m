Return-Path: <SRS0=SmLw=EK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53E3C2D0A3
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Nov 2020 20:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E0EA207BB
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Nov 2020 20:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="d5EbSv64"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbgKDUyZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 Nov 2020 15:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732350AbgKDUyZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Nov 2020 15:54:25 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF52C0613D3
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2020 12:54:24 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id y197so241987qkb.7
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2020 12:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bYmxg7/0DpnPGj0kSzBVfoZYp1Qe4N7rqTtThpXBMgY=;
        b=d5EbSv64AB0yGqG4W7Sl8eK+kooxnMh2hlC8twkvrHnD0E7pLeAnvIunkN2kIow6fH
         bGZxvBFajOydFE2UbuiQ63ccHrAvfBTrLYtEVCJcPwwZ9C47xxLNCdEA2bOov1IPZiW1
         zCT6N8C9/90QN1iWFI1Iwc2Qh7hln1459KVF/mASJNVZdOfutaAAjgd+fZs+2sBc3psX
         kde7A34FtKcCVz1fzsDCVKF34HRBgQZ19fNCl/pSk3Mb1E1327WxpiuwZ3iXxvL+mp6x
         IgeD9OkuI4qFhOVLuBTJseZkDws2bIJnxmrQI3ltA58sLHuCqY5QcRVHPZXCbG+tpXs7
         k76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bYmxg7/0DpnPGj0kSzBVfoZYp1Qe4N7rqTtThpXBMgY=;
        b=YRGieaLzzC3JM3k8pQKz76rGoYrz5QU6oSQ7HVI8gGD7XdwmxqU3o1iSynCa802qQq
         jKqBYXh/whMkWwKPv2GpjlZYoT+wouWPBobsyyCw+5cftKWHVQptxfUWO38y1X7/IemZ
         QrQGxfjmHjrPWyUPn/NWiCWf5VhA6h/Upy4h4813ujO3jKLuewR3qtuwcDNqyd832gjz
         XBddi39mjEj6fUxc7MKdVHbZwFo5Il+QvQARw6jo3hHv9kIqdVSU5UrhjsaBn0YXctW1
         umRd0nBTDBcoZ/Easy0hbC2mydSwwgX+YARCcZ3FXuvPih9YhB4tEcSEefixSDLVMETa
         JXTg==
X-Gm-Message-State: AOAM53047H/a2KHzGOEbxbqvtQFm9XEehRY6d0+To38DFEHs5OQYxCaP
        xp4nY65HHSPxBOqA7qr5UV1Y1o74FfQGiA==
X-Google-Smtp-Source: ABdhPJwfidywMCofpwsxN9UB8RMV9+LNywKSyk58uzBiHrEBlO0BwzUbX9iIQbmUyo74nXkAwHIHlQ==
X-Received: by 2002:a05:620a:150b:: with SMTP id i11mr67168qkk.46.1604523262903;
        Wed, 04 Nov 2020 12:54:22 -0800 (PST)
Received: from ?IPv6:2620:10d:c0a8:11c1::1180? ([2620:10d:c091:480::1:8f29])
        by smtp.gmail.com with ESMTPSA id l16sm1023163qtr.21.2020.11.04.12.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 12:54:22 -0800 (PST)
Subject: Re: [PATCH 2/4] btrfs: discard: save discard delay as ns not jiffy
To:     Pavel Begunkov <asml.silence@gmail.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1604444952.git.asml.silence@gmail.com>
 <5be2ccce4a6ebe7c96274f63091a04aeba9af9d8.1604444952.git.asml.silence@gmail.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <f98d4d0a-e48f-1482-7afa-8062ce6c9125@toxicpanda.com>
Date:   Wed, 4 Nov 2020 15:54:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <5be2ccce4a6ebe7c96274f63091a04aeba9af9d8.1604444952.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/4/20 4:45 AM, Pavel Begunkov wrote:
> Most of calculations are done in ns or ms, so store discard_ctl->delay
> in ms and convert the final delay to jiffies only in the end.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
