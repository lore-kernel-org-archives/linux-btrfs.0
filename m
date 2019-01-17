Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F53BC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 13:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 446E120652
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 13:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfAQNyy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:54:54 -0500
Received: from wp158.webpack.hosteurope.de ([80.237.132.165]:55682 "EHLO
        wp158.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726990AbfAQNyy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 08:54:54 -0500
Received: from ip5b41acd8.dynamic.kabel-deutschland.de ([91.65.172.216] helo=[192.168.0.31]); authenticated
        by wp158.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1gk88B-0003mv-UR; Thu, 17 Jan 2019 14:54:51 +0100
Subject: Re: issue mounting volume
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
 <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
 <3e1fd623-651e-9f48-0a79-2d1194b3d42d@ch-sc.de>
 <bd849a01-708d-2d4a-2f50-50b6967edf6c@gmx.com>
From:   Christian Schneider <christian@ch-sc.de>
Message-ID: <2c7c5f67-94f7-c9c7-4d9f-a76ef5dc81d0@ch-sc.de>
Date:   Thu, 17 Jan 2019 14:54:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <bd849a01-708d-2d4a-2f50-50b6967edf6c@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;christian@ch-sc.de;1547733293;e19a41cc;
X-HE-SMSGID: 1gk88B-0003mv-UR
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

>>
>> Do you know, which kernel is needed as base for the patch? Can I apply
>> it to 4.19 or do I need more recent? If you don't know, I can just try
>> it out.
> 
> My base is v5.0-rc1.
> 
> Although I think there shouldn't be too many conflicts for older kernels.
> 
I could apply the patch on 4.19, but compilation failed. So I went 
straight to master, where it worked, and I could even mount the fs now.

Your patch also has a positive impact on free space:

  df -h /home
Filesystem      Size  Used Avail Use% Mounted on
/dev/md42       7.3T  1.9T  1.8P   1% /home

1.8PB available space should be enough for the next few years :D

Thank you very much so far!!!

So, for further steps: As far as I understood, no possibility to repair 
the fs? I just get the data I can and create it new?

BR, CHristian
