Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF06C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 17:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDCF22083B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 17:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfBGRo3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 12:44:29 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41841 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfBGRo3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 12:44:29 -0500
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2019 12:44:28 EST
Authentication-Results: auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id A667B454C63;
        Thu,  7 Feb 2019 18:37:10 +0100 (CET)
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Stefan K <shadow_7@gmx.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs as / filesystem in RAID1
Date:   Thu, 07 Feb 2019 18:37:07 +0100
Message-ID: <2840929.O1qc6pvfHa@merkaba>
In-Reply-To: <CAJCQCtRuUBfhXQGr29hmOU1mW1wU2jSvr+dun72NAw3O28=cyA@mail.gmail.com>
References: <33679024.u47WPbL97D@t460-skr> <2159107.RxXdQBBoNF@t460-skr> <CAJCQCtRuUBfhXQGr29hmOU1mW1wU2jSvr+dun72NAw3O28=cyA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Chris Murphy - 07.02.19, 18:15:
> > So please change the normal behavior
> 
> In the case of no device loss, but device delay, with 'degraded' set
> in fstab you risk a non-deterministic degraded mount. And there is no
> automatic balance (sync) after recovering from a degraded mount. And
> as far as I know there's no automatic transition from degraded to
> normal operation upon later discovery of a previously missing device.
> It's just begging for data loss. That's why it's not the default.
> That's why it's not recommended.

Still the current behavior is not really user-friendly. And does not 
meet expectations that users usually have about how RAID 1 works. I know 
BTRFS RAID 1 is no RAID 1, although it is called like this.

I also somewhat get that with the current state of BTRFS the current 
behavior of not allowing a degraded mount may be better… however… I see 
clearly room for improvement here. And there very likely will be 
discussions like this on this list… until BTRFS acts in a more user 
friendly way here.

I faced this myself during recovery from a failure of one SSD of a dual 
SSD BTRFS RAID 1 and it caused me having to spend *hours* instead of 
what in my eyes could be minutes to recover the machine to a working 
state again. Luckily the SSDs I use do not tend to fail all that often. 
And the Intel SSD 320 that has this "Look, I am 8 MiB big and all your 
data is gone" firmware bug – even with the firmware version that was 
supposed to fix this issue – is out of service now. Although I was able 
to bring it back to a working (but blank) state with a secure erase, I 
am just not going to use such a SSD for anything serious.

Thanks,
-- 
Martin


