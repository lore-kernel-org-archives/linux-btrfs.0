Return-Path: <SRS0=ilb6=O5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FROM,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0089C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 12:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A22C52176F
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 12:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SFE8kxV8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbeLTMH6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:07:58 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:40632 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbeLTMH5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Dec 2018 07:07:57 -0500
Received: by mail-oi1-f178.google.com with SMTP id t204so1483450oie.7
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Dec 2018 04:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wuJ68EgCOGmNawkNjtzwGoYF8BkuCiSMV6RRKwELgN8=;
        b=SFE8kxV8BtVK+5SGsfqXYX9H4nVHaoCIgQv7SSZqB6i6DAeWw9X27sDvsypJKsBiPb
         6Akr+Xkhs1gWkrgPln/Uli637xPfcID7ezchVmrBOX4JCqFJm5/LGy83qbNdI8Qj/THm
         IbqV1pyModcjTc3oM3iVJsedqAaRGcKYd4fix3GM6gZGuTWikqexG1F9ZGzS/PM4LQQS
         QK3HDRtqC3XMnkBd3OAnuUS9pe1wQiWZKjzNsNFGcq8kfSPYAwnN32fGE8d1UNRv6TNQ
         JFQz0WXieD2rKvyLI693ftLZU8FQzHSQBxa573R3fCoc/bCeVqzj2vy6GOBv8O5W3jOM
         mGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wuJ68EgCOGmNawkNjtzwGoYF8BkuCiSMV6RRKwELgN8=;
        b=BXzYFc0irjy1rVm18LAF/8MnrRfuDO+f8wge6PZOfnVka7pibQOa4SBcVW2vXua4G1
         04lHoXkAuVacK2+rYjhS00XPg8Au9POeli1IfqvUSubI3efu7/uFKKMOZuXI1dLiz5Zc
         /4dk84f/V6lDm4s6z4zSsZSpVF0TJaGBFWlNVad5xmM2QhS/a6fHhaB0+/0sUDaLytqk
         nkN6zdTK/6Of+PQ1Ax0SeNqYIiqmGwYrceKeBNfesT3PJ9xVvrnJF6w5kMJ6bKl/zUD5
         dgS2WEZ7oTgOXjlgJmIBjaMLqC8yrw10X/u/LeVvumRKPQkfitElPA4ww0d3X0W76+R0
         dqvA==
X-Gm-Message-State: AA+aEWZod3P34DRjdwEyX1jLPl/DCw5QBjnMDD4JAEhjLl0fHua/VcSs
        Gk5cm+euaEOQVSMV69trzYuyYMRM1DHn5w==
X-Google-Smtp-Source: AFSGD/XzYF1RaGnEx0C6NJCyrTGQ45pG7E1oNpoyWCeWz2B0EIZ0ZVF8a+Cmj9JrIcutI58IXH8BOw==
X-Received: by 2002:aca:f0d5:: with SMTP id o204mr2040118oih.359.1545307676192;
        Thu, 20 Dec 2018 04:07:56 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id s13sm11936418otc.40.2018.12.20.04.07.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Dec 2018 04:07:55 -0800 (PST)
Subject: Re: compress-force not really forcing compression?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, devzero@web.de,
        linux-btrfs@vger.kernel.org
References: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>
 <79977718-ac8f-3a62-529d-e9046c8066b2@gmx.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e97b9cc6-cb8d-9068-1e7e-8aaee7f48aa9@gmail.com>
Date:   Thu, 20 Dec 2018 07:07:48 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <79977718-ac8f-3a62-529d-e9046c8066b2@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/19/2018 7:57 PM, Qu Wenruo wrote:
> 
> 
> On 2018/12/19 下午11:41, devzero@web.de wrote:
>> does compress-force really force compression?
> 
> It should.
> 
> The only exception is block size.
> 
> If the file is smaller than the sector size (4K for x86_64), then no
> compression no matter whatever the mount options are.
> 
>>
>> for me (found via compsize - see https://github.com/kilobyte/compsize/issues/24 )  it looks it is problably forcing compression check for every block of a file (while compress= makes btrfs skip compression check after first block) and if some block is incompressible, apparently it's being stored uncompressed.
> 
> Any reproducer for this unexpected behavior?

Not a reproducer, but this appears to be how it's been behaving on my 
systems since I started using BTRFS.

It's also arguably far more useful to behave this way than to just 
unconditionally compress everything, it wastes essentially zero time 
compared to that, and gets you better space utilization (which is big, 
since the size of the blocks we're compressing can mean that 
incompressible data expands significantly when we compress it).

