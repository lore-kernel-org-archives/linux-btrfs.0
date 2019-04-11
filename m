Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0384FC282CE
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 15:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C698E20818
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 15:07:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="Q2jELVK5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfDKPH3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 11:07:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44590 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbfDKPH3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 11:07:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id g12so3530929pll.11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2019 08:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=g5Ru/rgY38nq5GSjSyaqeF8D/1tI3TdnCfYTKWCj5T8=;
        b=Q2jELVK5Tg3gjA5LLWWrRg6y8XJkM/qc7nxtoYZ9TP18eW29OtM5nujeOMa7BLGF6e
         rm3d1aNpR3jUlTZJG54zH6Y43fD+FlCjOBjuUQ6iEl3sqrtx85O88umqna26zWCUxdmL
         hA9L1b4+Qug6bsnQqKTvij+X4cZi84ps+5eksvbRFz/gQ9RtzHVlofuQENxoJ5wFmoNe
         VIuXiEQVYYYnEQ1J8P4MW0r2qxp0EaJqfvwjaiPrOdrIPRlmuLYaijvmQdkdj3QOtH99
         uNznu08fzFa+vaTrOMRCSOBef7UQ/SEBLz0VBrE0ntbhP7NTnBSjAFvcmW8f+miRUCUR
         7YKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g5Ru/rgY38nq5GSjSyaqeF8D/1tI3TdnCfYTKWCj5T8=;
        b=MdmgtNnsd8CVFTHrZtR/ngRDKdS+FBOBpGqV0RhxXJifb/FQcfn5lCe+k8H1hWIdLf
         +svR6ibdxwzk1Fz7AzDWIAz4MRdSpEW18MEKJgy3msFhUkmbpoQ1ydcIpO/A2lo3tGKL
         QHxiI77K3pvt4k3msoYDsGTAC+MEgrAzIZ0BsnXC8q7FsBpfJ+uKZBjJ8vi/0c9LNX5V
         V8RsHY3nqBKJURY3IoaB52Xsgxmj+kSScEn8Hg1Ui7fk48z4YfxYCwOyFqgG+nkrldhJ
         EqzXqCcRJLvm/AOMVUIXnpvrqYxyZmCJKtjqJ4G8+W+GS7FMQ2m7lrpvL1CfGm/WJWBC
         5qzw==
X-Gm-Message-State: APjAAAUrpPMVEdBBtS5XQ8rgl9IXz9tY2UBCpekIMOn64gLccuhVjMTC
        7Ki4Gvp8hTS59ZSK/3cCtGPNZw==
X-Google-Smtp-Source: APXvYqxXRKZEVZK0jmdgq0VIbLZQ6OyERWJlqzGYibrl/GVpWrDMHAzI2wwmctasqH4EVce86YiA2g==
X-Received: by 2002:a17:902:8349:: with SMTP id z9mr48874086pln.144.1554995248339;
        Thu, 11 Apr 2019 08:07:28 -0700 (PDT)
Received: from [192.168.1.121] (66.29.188.166.static.utbb.net. [66.29.188.166])
        by smtp.gmail.com with ESMTPSA id g4sm8487333pfc.75.2019.04.11.08.07.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 08:07:27 -0700 (PDT)
Subject: Re: [PATCH V3] block: don't use for-inside-for in
 bio_for_each_segment_all
To:     dsterba@suse.cz, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>
References: <20190408110238.30478-1-ming.lei@redhat.com>
 <b55becef-d644-6f6d-428b-e25216016218@kernel.dk>
 <20190411132652.GP29086@twin.jikos.cz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5c317eff-32bb-8f9f-defd-fc707b65316f@kernel.dk>
Date:   Thu, 11 Apr 2019 09:07:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190411132652.GP29086@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 4/11/19 7:26 AM, David Sterba wrote:
> On Mon, Apr 08, 2019 at 08:19:59AM -0600, Jens Axboe wrote:
>> On 4/8/19 5:02 AM, Ming Lei wrote:
>>> Commit 6dc4f100c175 ("block: allow bio_for_each_segment_all() to
>>> iterate over multi-page bvec") changes bio_for_each_segment_all()
>>> to use for-inside-for.
>>>
>>> This way breaks all bio_for_each_segment_all() call with error out
>>> branch via 'break', since now 'break' can only break from the inner
>>> loop.
>>>
>>> Fixes this issue by implementing bio_for_each_segment_all() via
>>> single 'for' loop, and now the logic is very similar with normal
>>> bvec iterator.
>>
>> Applied, thanks Ming.
> 
> What's the merge target please? This affects btrfs testing so I wonder
> if we should start adding workarounds or just wait for the next rc.
> Thanks.

It's queued up in my for-linus, so it's for this series. It'll go
upstream tomorrow.


-- 
Jens Axboe

