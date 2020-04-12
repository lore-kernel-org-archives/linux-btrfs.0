Return-Path: <SRS0=KIno=54=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89176C2BB85
	for <linux-btrfs@archiver.kernel.org>; Sun, 12 Apr 2020 03:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63E8420842
	for <linux-btrfs@archiver.kernel.org>; Sun, 12 Apr 2020 03:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgDLDUD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:20:03 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:5393 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgDLDUD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Apr 2020 23:20:03 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.17]) by rmmx-syy-dmz-app10-12010 (RichMail) with SMTP id 2eea5e9288cd600-1c81a; Sun, 12 Apr 2020 11:19:41 +0800 (CST)
X-RM-TRANSID: 2eea5e9288cd600-1c81a
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [192.168.0.106] (unknown[112.1.172.56])
        by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee95e9288cca75-41b3c;
        Sun, 12 Apr 2020 11:19:41 +0800 (CST)
X-RM-TRANSID: 2ee95e9288cca75-41b3c
Subject: Re: [PATCH] btrfs: Fix backref.c selftest compilation warning
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, clm@fb.com,
        josef@toxicpanda.com, dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200411154915.9408-1-tangbin@cmss.chinamobile.com>
 <ea85377e-4648-c174-2827-53173587777c@gmx.com>
From:   Tang Bin <tangbin@cmss.chinamobile.com>
Message-ID: <4b1e57b3-ca0d-f3e0-f4c4-72cdfe943d7a@cmss.chinamobile.com>
Date:   Sun, 12 Apr 2020 11:21:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ea85377e-4648-c174-2827-53173587777c@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu:

On 2020/4/12 8:52, Qu Wenruo wrote:
>
> On 2020/4/11 下午11:49, Tang Bin wrote:
>> Fix missing braces compilation warning in the ARM
>> compiler environment:
>>      fs/btrfs/backref.c: In function ‘is_shared_data_backref’:
>>      fs/btrfs/backref.c:394:9: warning: missing braces around initializer [-Wmissing-braces]
>>        struct prelim_ref target = {0};
>>      fs/btrfs/backref.c:394:9: warning: (near initialization for ‘target.rbnode’) [-Wmissing-braces]
> GCC version please.
>
> It looks like you're using an older GCC, as it's pretty common certain
> prebuild tool chain is still using outdated GCC.
>
> In my environment with GCC 9.2.0 natively (on aarch64) it's completely fine.
> Thus personally I recommend to build your own tool chain using
> buildroot, or run it natively, other than rely on prebuilt one.

My environment:

   PC : Ubuntu 16.04

   Hardware : I.MX6ULL

   Tool Chain : arm-linux-gnueabihf-gcc (Linaro GCC 4.9-2017.01) 4.9.4

>
> In fact your fix could cause problem, as the original code is
> initializing all members to 0, but now it's uninitialized.
>
> You need to locate the root cause other than blindly follow the warning.

In hardware experiment, this approach is feasible.

Thanks.

Tang Bin

>
>


