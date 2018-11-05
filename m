Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8749C46475
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 13:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C2102081D
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 13:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ogC06UOS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C2102081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbeKEWrW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 17:47:22 -0500
Received: from mail-it1-f170.google.com ([209.85.166.170]:37903 "EHLO
        mail-it1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbeKEWrV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 17:47:21 -0500
Received: by mail-it1-f170.google.com with SMTP id k141-v6so10694349itk.3
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2018 05:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4ABC2oEY1mNun1/vsJohe7F81GHla4dz2ErEcQ9hth8=;
        b=ogC06UOSjaBTFqwdxKy8XzEC0Mnz1kkRTUlTZVnYr6DVeFCRszpPju14d930qgAVlA
         j5gPIq1nb5poG7ecti4aMnDb/dvLXcC3X216rd6LRgzOaQW8BOLxzSvkbiaGoPQNp339
         +W2ibico8Qc1tuRk1no6o6k33CeCRvJ7mvqmgDNlgUeqH8biValY3BGQJec2FRYiGHB3
         LoxC7tF5AxTiP2KOXR2A3TNLwS76lP15RUQIvNRWQx06Fx1T/+/AeDHdnWrRGluLZIm1
         SzUT7dN9SM19OsfkEjdaN+Q74yaH/OMUEnoeFMzrAN2IAMLmVX894gmcoYa9hpj8ZwZE
         4JlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ABC2oEY1mNun1/vsJohe7F81GHla4dz2ErEcQ9hth8=;
        b=TvUBOjd2wF9FV7apF5kZxGGIHpqJeG9Y+Eu+P00nrZQEHQRNQmTz7ORlokYfk7L8Gp
         +ZH/8CbUzYKaAwTKc4Sf2n56ytEnRMD5+/X9xNA8vTLCDUjv0maw49rFh0HkY5nLKmGS
         qlujGlhEkDfhsMxKVirNuqoLhTgXeV2DYg6x3DTmYaupJJpVKZ+UVC7UmIR9p1AIhwcK
         JKPvk/TD4Pri09Cv0uFhCP9uqNvj/M8tTSrRwKGRfWRYIBuX8rgmeJ6/saIIeu2RrkKX
         oMCVp9ZYQuB6RsL/4TL21QJdT+yNwUhtbp+ev92AEuVuju1lYvCos2zRgpwAytqmSWUH
         KCOQ==
X-Gm-Message-State: AGRZ1gLgaGxxNv12yOTjBZC33VIBwkMzF+LIAsPuzeIUL5nPfuSyPEwN
        uk1IQRkmHbfY4rODAfn2m4If6BQS
X-Google-Smtp-Source: AJdET5e51txVd+UNBZBjRtTaymb98qEpoY+3tUeFiQ2bixFtg4HJpYbyAw5UJiT9XzmxDdUaVZCCaA==
X-Received: by 2002:a05:660c:9c6:: with SMTP id i6mr7416431itl.25.1541424454571;
        Mon, 05 Nov 2018 05:27:34 -0800 (PST)
Received: from [191.9.209.46] (rrcs-147-0-47-180.central.biz.rr.com. [147.0.47.180])
        by smtp.gmail.com with ESMTPSA id z136-v6sm16121882iof.23.2018.11.05.05.27.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 05:27:33 -0800 (PST)
Subject: Re: BTRFS did it's job nicely (thanks!)
To:     waxhead@dirtcellar.net, Sterling Windmill <swindmill@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <d03d611b-cd2e-d267-268a-255f90348e43@dirtcellar.net>
 <CAMOu_z0879AZEKHPDFOFeGL8H4E2Uj+CzFYV6tSdqHoHF5NyNg@mail.gmail.com>
 <5c8bbcac-65e2-1787-d836-bcf4722ed0a6@dirtcellar.net>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8a70013d-6d7c-b91d-56e5-a2ce0d0bdc0f@gmail.com>
Date:   Mon, 5 Nov 2018 08:27:06 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <5c8bbcac-65e2-1787-d836-bcf4722ed0a6@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/4/2018 11:44 AM, waxhead wrote:
> Sterling Windmill wrote:
>> Out of curiosity, what led to you choosing RAID1 for data but RAID10
>> for metadata?
>>
>> I've flip flipped between these two modes myself after finding out
>> that BTRFS RAID10 doesn't work how I would've expected.
>>
>> Wondering what made you choose your configuration.
>>
>> Thanks!
>> Sure,
> 
> The "RAID"1 profile for data was chosen to maximize disk space 
> utilization since I got a lot of mixed size devices.
> 
> The "RAID"10 profile for metadata was chosen simply because it *feels* a 
> bit faster for some of my (previous) workload which was reading a lot of 
> small files (which I guess was embedded in the metadata). While I never 
> remembered that I got any measurable performance increase the system 
> simply felt smoother (which is strange since "RAID"10 should hog more 
> disks at once).
> 
> I would love to try "RAID"10 for both data and metadata, but I have to 
> delete some files first (or add yet another drive).
> 
> Would you like to elaborate a bit more yourself about how BTRFS "RAID"10 
> does not work as you expected?
> 
> As far as I know BTRFS' version of "RAID"10 means it ensure 2 copies (1 
> replica) is striped over as many disks it can (as long as there is free 
> space).
> 
> So if I am not terribly mistaking a "RAID"10 with 20 devices will stripe 
> over (20/2) x 2 and if you run out of space on 10 of the devices it will 
> continue to stripe over (5/2) x 2. So your stripe width vary with the 
> available space essentially... I may be terribly wrong about this (until 
> someones corrects me that is...)
He's probably referring to the fact that instead of there being a 
roughly 50% chance of it surviving the failure of at least 2 devices 
like classical RAID10 is technically able to do, it's currently 
functionally 100% certain it won't survive more than one device failing.

