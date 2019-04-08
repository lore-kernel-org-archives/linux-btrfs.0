Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640A0C10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 14:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31B8521473
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 14:22:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9eCPuJC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfDHOWt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 10:22:49 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:43897 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfDHOWs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2019 10:22:48 -0400
Received: by mail-io1-f52.google.com with SMTP id x3so11137269iol.10
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Apr 2019 07:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TzXd1x/KY8jh72Lpp5RcoDgSVaHLKmdspXkWosv4wHw=;
        b=I9eCPuJCfLztReZHPZdHxiEI1pMSa5nJHCA4gpfBTxv8Hcv8HKU+FaQaxoWfNyxtJe
         nb4AHFJYv2tGp81j4kijO3UMDnY8oEEKPwXD87h2T7PQdIOKKsfjS70SQta/Tebk/7RU
         TP9LbHT9sscHM482fQdK3Ynbx7/aG0fD3oOurwfAIF+Cp94jBhe0SObKmVvlY3FE5iKc
         cRTiQOY1z3MPDK/1RQYYRHhBuDii5ac37m/zyfnaZReMAkeUxNQKZASZ2Jd9Gcjhwygk
         VYtOnc8tBiiFPKkBqw3Iih+7cbOPMSKT9UO0X99VCFsra9mY4016KSFEPXahoevYhzz3
         8enA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TzXd1x/KY8jh72Lpp5RcoDgSVaHLKmdspXkWosv4wHw=;
        b=hVNADMWmB6XZACn/ZKO1sUBI3Hj1sn9z2zLumP+yvdJavSul/NZkbLu7LP3HY3qYCt
         VcikshZtNVOvr0z7nrru3fzLTCTwMUKhb+BdXji0uFiB9yuZN4UjETg2FiKvASx3mQ96
         SeaLCZcQqKkuG9mp9zm9XnRNwRPCYm1Henc/3SngWXppm1vZlmPtbwMMMcIWNxjhRldH
         yL6iZX7pmitHrQOU4on6hrM91F/48BBPR3J1Pz4GlTEFjaVFMoo3Y2yO+ChJcZfN7W+W
         A3w+Rimu6WIXEZHy9T1TJlbsINNRlV+ZXZEaR4+ug14gwf4J+kAuJhyPj73vNryhvPLa
         /Vpg==
X-Gm-Message-State: APjAAAURadQApbv/EQHqjq7IciQL8ErHFFrEFxEC6bdtHY7nhwiXu7bl
        L0lcbDL+Uw0zA1dzWNGeGSM=
X-Google-Smtp-Source: APXvYqy+3v52WzWel4PyMCoWSrmmMNvGmyNH4iSA2buNhWOdDCHD802T0BxV6DoAhl7icMLH+yvM0Q==
X-Received: by 2002:a6b:8b06:: with SMTP id n6mr5168691iod.72.1554733367618;
        Mon, 08 Apr 2019 07:22:47 -0700 (PDT)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id d143sm5404549itd.44.2019.04.08.07.22.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 07:22:46 -0700 (PDT)
Subject: Re: Cryptographically verifying a btrfs subvolume
To:     Leonid Bloch <lbloch@janustech.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc:     "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
References: <adac7db8-aed6-9573-ec09-4acd5059801e@janustech.com>
 <25abc057-4ff8-5a73-ee4b-0afda4fab16d@gmail.com>
 <15a6861e-3752-3c51-5c4f-59bebf19a235@janustech.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <04560ed0-9c98-1e61-b8f0-d035dc4b3a0f@gmail.com>
Date:   Mon, 8 Apr 2019 10:22:43 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <15a6861e-3752-3c51-5c4f-59bebf19a235@janustech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-04-08 09:30, Leonid Bloch wrote:
> On 4/8/19 3:44 PM, Austin S. Hemmelgarn wrote:
>> On 2019-04-08 07:27, Leonid Bloch wrote:
>>> Hi List,
>>>
>>> Can you suggest a way of cryptographically verifying the content of a
>>> btrfs subvolume, besides the naïve approach, of running a cryptographic
>>> hash function on the output of btrfs send?
>> Running BTRFS on top of dm-integrity and dm-crypt with them set up to
>> provide AEAD-style encryption comes to mind as an option, and would
>> actually provide a much higher level of verification than just verifying
>> the content of a subvolume (it will verify the entire filesystem).
> 
> Thanks! That's actually a good point, I would like to verify a specific
> subvolume(s), while on others the content can change.
> 
> That's a good point cause it shows that I was wrong assuming that btrfs
> scrub would help - it will scrub the entire filesystem as well, and
> compare checksums internally, which is not what I want - I want to
> compare to some external checksum. Sorry for the confusion there.
If your primary goal is to just verify that nobody has changed the 
contents of the subvolume, then even hashing the send stream may be 
problematic for your use case. Certain differences in the on-disk layout 
of the data (which could be caused by deduplication or defragmentation) 
result in changes in the send stream, but don't actually change anything 
from the perspective of userspace. Similarly, the send stream protocol 
has changed slightly over time in backwards compatible ways, and such 
changes may happen again in the future, so even if the on-disk layout is 
identical, the hash may visibly change.
