Return-Path: <SRS0=KFuw=EI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9600C00A89
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Nov 2020 17:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA7820786
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Nov 2020 17:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="kGv6qQfT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgKBRFE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 12:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbgKBRFD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Nov 2020 12:05:03 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86740C061A04
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2020 09:05:03 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id s14so12060329qkg.11
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2020 09:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y38b4I8F8TzbnCJnqVcBeFa6DkdFk2BpIFLm4lvKtuQ=;
        b=kGv6qQfTyQ811LuGIIGqHI+tXnWLezncZhRnfepg3EyTd/XVYEUG6v/scvXNSkGWBG
         nz07ukkvu6uorOW8w/Qmf2RD1Ao7b2TOvGq6M205ibw4ugEipfNp55IPcTHJ9UUEkonZ
         7vumjtOYXoIFVnUnfYAeWIrNpuqFiSELotOIua7AS0AL8PHaK3sedQvRCOowEgf6NUr/
         UlwHf5GRQI5wfsm+UBNhtVDMx/Aw9sY1mjgEYrDjDjZ4bsJB/2/HY3W1iEKdhrx0p22M
         Qj9KPoBqn/dU6n/JYF+BKuNDYbXAkxqBnXrFYbGburXYR4o/MDSe6e4MOfIsiJ9WHBpJ
         EGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y38b4I8F8TzbnCJnqVcBeFa6DkdFk2BpIFLm4lvKtuQ=;
        b=dypWrQ8HzZ1LQapulf9HsKkhZmZnsPPtGY5I65pt7mN6BbBpz2PiW/l3NJGsUZfW5F
         VH1M0IFOnI0lg0Fu5uREoiGSrk7R05Cd13rM0cq6JhG7EpOo3hm5D4fuAd5AvD9+phU1
         NcUZLvDCuk//fPrLcPaDBIiDb8nGE7mbdf+Mig1hXCvAIjhHhwbQhz6gPtccPuTmaoDF
         eyw76nh5y7uHIal0bSg9lephmrXa5QTCI17TQvQr/Z5duOK5KxTvXjUqq0mBau5J+KY+
         eL1jZt62uHw/MdN0mb0uqwiWN8Hs5H8DNBLSWxaJKm7pKJOerBaGOJcpuh6OQjVf+U5c
         ii4A==
X-Gm-Message-State: AOAM531rqJTAhynaKA73xPvRj0pK5p5m2ASP+/zbX8GrdBIEKbxvptKq
        WGydnl65R3/qEpGF8Wu9MW2Bui3fKDyQcQ==
X-Google-Smtp-Source: ABdhPJzAHrmcW4bpGc+WqnnRZtd1fbVeh5ma2CvPxT2OpHWIJlO0hr+BVcKVSk0QYjPdGKmBpYST2Q==
X-Received: by 2002:a37:90c3:: with SMTP id s186mr15944818qkd.130.1604336702740;
        Mon, 02 Nov 2020 09:05:02 -0800 (PST)
Received: from ?IPv6:2620:10d:c0a8:11d9::116a? ([2620:10d:c091:480::1:f39e])
        by smtp.gmail.com with ESMTPSA id f21sm4677080qkl.131.2020.11.02.09.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 09:05:01 -0800 (PST)
Subject: Re: [PATCH v9 08/41] btrfs: disallow NODATACOW in ZONED mode
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.com
Cc:     hare@suse.com, linux-fsdevel@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <d9a0a445560db3a9eb240c6535f8dd1bbd0abd96.1604065694.git.naohiro.aota@wdc.com>
 <4129ba21e887cff5dc707b34920fb825ca1c61a4.1604065695.git.naohiro.aota@wdc.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <d61bedfe-9288-940c-e410-60c835591fe0@toxicpanda.com>
Date:   Mon, 2 Nov 2020 12:05:00 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <4129ba21e887cff5dc707b34920fb825ca1c61a4.1604065695.git.naohiro.aota@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10/30/20 9:51 AM, Naohiro Aota wrote:
> NODATACOW implies overwriting the file data on a device, which is
> impossible in sequential required zones. Disable NODATACOW globally with
> mount option and per-file NODATACOW attribute by masking FS_NOCOW_FL.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
