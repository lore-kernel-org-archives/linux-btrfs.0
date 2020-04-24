Return-Path: <SRS0=HG8U=6I=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC294C54FCB
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Apr 2020 19:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF2CB20857
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Apr 2020 19:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgDXTYm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 15:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725970AbgDXTYm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Apr 2020 15:24:42 -0400
Received: from wp558.webpack.hosteurope.de (wp558.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8250::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29D7C09B048
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2020 12:24:41 -0700 (PDT)
Received: from mail1.i-concept.de ([130.180.70.237] helo=[192.168.122.235]); authenticated
        by wp558.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1jS3wF-0006uY-Iv; Fri, 24 Apr 2020 21:24:39 +0200
Subject: Re: Recommended Partitioning & Subvolume Layout | Newbie Question
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <03fdc397-4fca-335f-03d8-f93a96d92105@peter-speer.de>
 <CAJCQCtTnA6Dro2XwEm0S7ohUnf_CMGb7giHsBfh4_KtWE4vR6g@mail.gmail.com>
 <7019baf9-5064-4d16-a09a-5dc5672672de@peter-speer.de>
 <CAJCQCtRnRnvBkpoa+x4GXy83eya-z6bdDj0GgMkEhTHONuF7gg@mail.gmail.com>
From:   Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Message-ID: <570e0efd-2cf1-8402-88ea-6f7f86ca90b6@peter-speer.de>
Date:   Fri, 24 Apr 2020 21:24:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRnRnvBkpoa+x4GXy83eya-z6bdDj0GgMkEhTHONuF7gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;stefanie.leisestreichler@peter-speer.de;1587756281;bb7d75e6;
X-HE-SMSGID: 1jS3wF-0006uY-Iv
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 23.04.20 22:49, Chris Murphy wrote:
> Also I usually keep /boot as a directory on the root subvolume, so it
> gets rolled back at the same time. I've messed around with separate
> boot subvolumes, and I think it's more useful for the use case where
> you don't want a persistently mounted /boot and /boot/efi for security
> reasons.

My setup will be gpt/esp/uefi. I was planing a seperate partition with 
vfat filesystem for /boot and start my kernel directly from this 
partition. I see you are using btrfs in combination with grub, I guess. 
Is this what you would recommend using instead (together with RAID 1 
which will be used also)?

I want to let you and the others know that I really appreciate it a lot 
that you are taking the time to answer my questions.

Thanks,
Steffi
