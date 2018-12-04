Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEAAC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E468B20878
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fosvd2Ua"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E468B20878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbeLDMio (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 07:38:44 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40835 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbeLDMio (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 07:38:44 -0500
Received: by mail-io1-f65.google.com with SMTP id n9so13459999ioh.7
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Dec 2018 04:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jzBalv5q1STN9E6EgFkzMyPkte8Tt6vJGfT4i6jo/1Q=;
        b=Fosvd2Ua2/5gYPVQTBg9d5o9Pzt/2xg406iMUtNvm8BT4wRWH5c6z7U53ix/Npbwgd
         Aac6rqXv2YOBhEaHuwYKYZ4FF0B4SL8VA+Dlq48TYR6K5hzS+ejCxeinB2+xVmb/GhCN
         CBocOctQYNHyiAc6CMxbv4RodriDxc5Mtfky0CuGUWulQBfgsRLt848PsD2hkYYQ8toI
         wwAu9OxEuG90CluTZopaWb9ioi2yc0YHYOuQx9MPpqpg+DdA9XxTKNCVE9MwU6a4LgZB
         Z9WM06bAerTGQkww4zVBKY2EbXWDBXlR8Wyxt/U7R1JxSVMQ/xdYpsDY/GGHGMYufZVk
         FWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jzBalv5q1STN9E6EgFkzMyPkte8Tt6vJGfT4i6jo/1Q=;
        b=JWWJeh4SD02+8WR0RIYAvqRLTWr+kZE0fzO5JWy8b2bWWT5W/dJi5byObcNao+bQFF
         ysn1an1Ku/0bLu6/yIo3/Hpmfu5e0oAAseYHBnRxzCBKCikIefs57CyAxwTQQ38aXBIM
         KGARmbBKdkN2E+XOTSjqjaJ7vqWHtdEq9EFhxGRXT+yiaDoMrAbJ31MdjSv5rwbp+O2Z
         WwYwzaPq5HD22Gy6ndTZEyLYTn4xjpfTi7Ik4HFqAFojacgkNhwT4TeUqVyx41XIMNCj
         dmzqA5ooWO6FtR3v/ssPUsdWf93VQvhP//S/qP1r7KRBr+CQUFyHgFpe/CxEpLpFrWO2
         fqTQ==
X-Gm-Message-State: AA+aEWZdcPiXgh8pRAlVS55MOz5B0PtNYuAXUZn3xqJvbYWG3TtP4FtK
        m4u8h1qOTFpmwkHm85UYd54wah1Z2b8=
X-Google-Smtp-Source: AFSGD/V4PS57b6JQhCGt24kRrsWj5BHGL/5rQrJ3HbJoFfw1PaUHYxRLWtQQovldGYnBEeoNt6a2/w==
X-Received: by 2002:a5d:9602:: with SMTP id w2mr6254841iol.86.1543927122598;
        Tue, 04 Dec 2018 04:38:42 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id i78sm5485468itb.6.2018.12.04.04.38.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Dec 2018 04:38:41 -0800 (PST)
Subject: Re: experiences running btrfs on external USB disks?
To:     Tomasz Chmielewski <mangoo@wpkg.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e94da83b0a57c01663ad1e40fa6b9b5e@wpkg.org>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7c8a85c7-52d8-202b-5bc7-0fa0c5c6e502@gmail.com>
Date:   Tue, 4 Dec 2018 07:38:38 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <e94da83b0a57c01663ad1e40fa6b9b5e@wpkg.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-12-04 00:37, Tomasz Chmielewski wrote:
> I'm trying to use btrfs on an external USB drive, without much success.
> 
> When the drive is connected for 2-3+ days, the filesystem gets remounted 
> readonly, with BTRFS saying "IO failure":
> 
> [77760.444607] BTRFS error (device sdb1): bad tree block start, want 
> 378372096 have 0
> [77760.550933] BTRFS error (device sdb1): bad tree block start, want 
> 378372096 have 0
> [77760.550972] BTRFS: error (device sdb1) in __btrfs_free_extent:6804: 
> errno=-5 IO failure
> [77760.550979] BTRFS info (device sdb1): forced readonly
> [77760.551003] BTRFS: error (device sdb1) in 
> btrfs_run_delayed_refs:2935: errno=-5 IO failure
> [77760.553223] BTRFS error (device sdb1): pending csums is 4096
> 
> 
> Note that there are no other kernel messages (i.e. that would indicate a 
> problem with disk, cable disconnection etc.).
> 
> The load on the drive itself can be quite heavy at times (i.e. 100% IO 
> for 1-2 h and more) - can it contribute to the problem (i.e. btrfs 
> thinks there is some timeout somewhere)?
> 
> Running 4.19.6 right now, but was experiencing the issue also with 4.18 
> kernels.
> 
> 
> 
> # btrfs device stats /data
> [/dev/sda1].write_io_errs    0
> [/dev/sda1].read_io_errs     0
> [/dev/sda1].flush_io_errs    0
> [/dev/sda1].corruption_errs  0
> [/dev/sda1].generation_errs  0
It looks to me like the typical USB issues that are present with almost 
all filesystems but only seem to be noticed by BTRFS because it does 
more rigorous checking of data.

In short, USB is _crap_ for fixed storage, don't use it like that, even 
if you are using filesystems which don't appear to complain.
