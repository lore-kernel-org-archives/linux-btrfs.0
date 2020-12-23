Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9957CC433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Dec 2020 03:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E605207AF
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Dec 2020 03:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgLWDPU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Dec 2020 22:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgLWDPT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Dec 2020 22:15:19 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088D6C0613D3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2020 19:14:39 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id a13so7036830qvv.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2020 19:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2T3/fBWcVoDG+egeRWd0x9kLfSeONfPKghxreFcgGW4=;
        b=EYXIlmydthsWaZgSj8lTaoG44bL16ldRleyHvZEBe5TShq6bBok0lJu7DbTFvEvm0k
         QBzhbaQz8UbeenuKRni/xiI7tiyqJmdO9Yc7jttX+evkYWPevL21/yQqmKpOypNBvobV
         zleEYGoZQ0l0mlI2qF3EzUFJD/i3JR0MKKhyeN3gAxDN2EDjWMXrDqiAKRiHczGp+Jb4
         O5o0N/Pbid6iUpPZZrDlGubA1HN1SJOwnlteFaD+PwltrzIbjDFrTSKHiFY0kSWEhrCk
         PGx3/otmYI1ntbrXFGqJq5ZiSRatyGBwpJ+5etl3qkyieEQlNyR66G3dgkNgCvrWQRJZ
         /jew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2T3/fBWcVoDG+egeRWd0x9kLfSeONfPKghxreFcgGW4=;
        b=Gviq3c2OLqT6OJyWP5ECmTUgSgZZcQmbGKFjA2E7WVkQw7woE9XEPCzG4BGTQaVB1o
         cRprXfEmrcYt/MbJihkQJDJNQkSMSFsaJ4MgIhh6aR3XJ1q/+OvlpPN4UEQk6C1MYchG
         CYml3eOIIZCDj66JglFZktAsh+XEzo145kBOhbkmP4CAQDnvttD07J8UXnvSHyfZB12V
         ClsfMEPTqOPwKAPU1bV2YJQQo1XOJygCzJLHf5OgLMBWZ2G/3XKTjy/2fPjBRmCYDTsd
         a1hmfO6DXq+volMYreAiw9GQmosM/kwnN34J5ZZ6vnZmjflntTUv66bkp+AUXZiyDiWO
         Wylw==
X-Gm-Message-State: AOAM533ZhiNSJ15QnFnkQk+H7AT5CpRnpqY1nz3Vm9qoxrbmDrOGMl4m
        dWrqx0Olpeat9jUVGf2E6+W4Dmb8t87BJOfc
X-Google-Smtp-Source: ABdhPJw16UZTBdd9fr3Czy949AtiDOt8oG7lVGjJfnqC7H6ipHLXhe0k3urBNGYEYRTjuhsQyIx90Q==
X-Received: by 2002:a05:6214:d05:: with SMTP id 5mr24872939qvh.54.1608693277999;
        Tue, 22 Dec 2020 19:14:37 -0800 (PST)
Received: from localhost.localdomain (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id 74sm13997257qko.59.2020.12.22.19.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 19:14:37 -0800 (PST)
Subject: Re: [BUG] 500-2000% performance regression w/ 5.10
To:     =?UTF-8?Q?Ren=c3=a9_Rebe?= <rene@exactcode.de>,
        linux-btrfs@vger.kernel.org
References: <B4BB2DCB-C438-4871-9DDD-D6FB0E6E4F1B@exactcode.de>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <862a1a08-2567-e923-4df2-b2e4fe82f99b@toxicpanda.com>
Date:   Tue, 22 Dec 2020 22:14:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <B4BB2DCB-C438-4871-9DDD-D6FB0E6E4F1B@exactcode.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/21/20 2:45 PM, René Rebe wrote:
> Hey there,
> 
> as a long time btrfs user I noticed some some things became very slow
> w/ Linux kernel 5.10. I found a very simple test case, namely extracting
> a huge tarball like:
> 
>    tar xf /usr/src/t2-clean/download/mirror/f/firefox-84.0.source.tar.zst
> 
> Why my external, USB3 road-warrior SSD on a Ryzen 5950x this
> went from ~15 seconds w/ 5.9 to nearly 5 minutes in 5.10, or 2000%
> 
> To rule out USB, I also tested a brand new PCIe 4.0 SSD, with
> a similar, albeit not as shocking regression from 5.2 seconds
> to ~34 seconds or∫~650%.
> 
> Somehow testing that in a VM did over virtio did not produce
> as different results, although it was already 35 seconds slow
> with 5.9.
> 
> # first bad commit: [38d715f494f2f1dddbf3d0c6e50aefff49519232]
>    btrfs: use btrfs_start_delalloc_roots in shrink_delalloc
> 

Eesh that's not great, I'll work it out in the morning, thanks,

Josef
