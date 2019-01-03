Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFBDC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB13D2073D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="McogTato"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbfACI36 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:29:58 -0500
Received: from mail.virtall.com ([46.4.129.203]:36026 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728823AbfACI35 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 03:29:57 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id BDA86376D25;
        Thu,  3 Jan 2019 08:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1546504195;
        bh=vibHbgr4Imj2j4XebJ06LmQUcWCfGnh9QCK+H1RGA+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=McogTato77gie9u5l1BClNNzNuWpx+NzR820Z6RDoaeSzeR+Igdcx+aqk5k3zPv6c
         dGQJ+/9lXngfZkpYatNoObUsoFxmuc+Bn8aSzmbzOesDvuygLQ2K6lqKAZ4sAsVxMR
         yvBzZlHGoQxgOtXYrh2gnpS6cKUq5UpJGHiikd7MYW32SACK3Ayw29MbZNJ2ovIwOL
         jIl15sAecJRnvB5gLrtV6cQB+aXDCRGTBq+7qFy9p2NUA3E7gyhEUtrQQdH+6WVcQs
         a2vKm8RNxE4r2wiggDvtx9LgbL7d4FOyXXHI2vgwv9zobxQBtUn1OAm67pZPPXTWKl
         ZJLrVjWXLyjUw==
X-Fuglu-Suspect: 8f79a9742f2d4011ae6c26cbba727c5e
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA;
        Thu,  3 Jan 2019 08:29:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Jan 2019 17:29:51 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Andrea Gelmini <andrea.gelmini@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        b11g <b11g@protonmail.com>
Subject: Re: BTRFS corruption: open_ctree failed
In-Reply-To: <20190103082213.GA74697@glet>
References: <155a0e09f60a0605802c459a6e119b36@virtall.com>
 <20190103072740.GA64625@glet> <b5df9ec049da6ecd9a4b3617d39d795f@virtall.com>
 <20190103082213.GA74697@glet>
Message-ID: <ec02023516764c490fdb2fad5f409da5@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-01-03 17:22, Andrea Gelmini wrote:
> On Thu, Jan 03, 2019 at 04:43:20PM +0900, Tomasz Chmielewski wrote:
>> > And it's not a default/usual configuration.
>> 
>> Still - it is a default configuration for some distributions. I.e. 
>> Ubuntu
>> "ppa" kernels[1] have this enabled by default (at least 4.19.x and 
>> 4.20.x).
> 
> a) he is not using Ubuntu;
> b) I use this PPA;
> c) if you look at the config, you see the default scheduler is not 
> "none", also
>    the mq is compiled as module and - anyway - on release with the bug
> you have to
>    force the kernel to use it with boot parameter.

Hmmm, is it the case?

# uname -r
4.20.0-042000-generic

# cat /sys/block/sda/queue/scheduler
[none]

# cat /sys/block/sdb/queue/scheduler
[none]


I could see filesystem corruption on every system using with PPA 4.19 
lower than .8. Didn't do any kernel boot parameter changes when 
upgrading from 4.18.
