Return-Path: <SRS0=uOdT=XR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA86BC4740C
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Sep 2019 19:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF97821BE5
	for <linux-btrfs@archiver.kernel.org>; Sun, 22 Sep 2019 19:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbfIVTHL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 22 Sep 2019 15:07:11 -0400
Received: from know-smtprelay-omd-9.server.virginmedia.net ([81.104.62.41]:56589
        "EHLO know-smtprelay-omd-9.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730270AbfIVTHK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Sep 2019 15:07:10 -0400
Received: from [172.16.100.1] ([86.12.75.74])
        by cmsmtp with ESMTPA
        id C7COiYBtWVaV8C7COis8ln; Sun, 22 Sep 2019 20:07:08 +0100
X-Originating-IP: [86.12.75.74]
X-Authenticated-User: peter.chant@ntlworld.com
X-Spam: 0
X-Authority: v=2.3 cv=PcnReBpd c=1 sm=1 tr=0 a=RxXffCTTaIU9mOmmEQ6aGA==:117
 a=RxXffCTTaIU9mOmmEQ6aGA==:17 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=IkcTkHD0fZMA:10 a=e-rcKmGedyBdaeoZsHYA:9 a=QEXdDO2ut3YA:10
Subject: Re: Balance ENOSPC during balance despite additional storage added
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <94ebf95b-c8c2-e2d5-8db6-77a74c19644a@petezilla.co.uk>
 <CAJCQCtRAnJR+Z8Z8Bq91YXiMpfmwOiHK0tQ+9zAJvSVvexHnxg@mail.gmail.com>
From:   Pete <pete@petezilla.co.uk>
Message-ID: <54fa8ba3-0d02-7153-ce47-80f10732ef14@petezilla.co.uk>
Date:   Sun, 22 Sep 2019 20:06:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRAnJR+Z8Z8Bq91YXiMpfmwOiHK0tQ+9zAJvSVvexHnxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfE+n0NpXq5SmRQ5FV3LKbfstv90mTkBxPTu9jStfBQUy4yWtWwDkC21p8jyzTx5LEk2VyQEWtlYYBEIXlR2aq6LDB3MlS69z+y7mQmE4CP5uxQywjJq3
 35vlAbphXiQ1gR7MV5i19u0QIt2LMfDugoSKJKWpASqogEMnpz3a7nTdudMh56TNrK4bd36mQezipfrUqHg2JJTT309BApUs6jc=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 9/22/19 6:47 PM, Chris Murphy wrote:

>> Unfortunately I don't seem to have any more info in dmesg of the enospc
>> errors:
> 
> You need to mount with enospc_debug to get more information, it might
> be useful for a developer. This -28 error is one that has mostly gone
> away, I don't know if the cause was ever discovered, but my
> recollection is once you're hitting it, you're better off creating a
> new file system rather than chasing it.
> 
> But you could use 5.2.15 or newer, mount with enospc_debug, and do
> filtered balance. You could start with 1% increments, e.g. -dusage=1,
> -dusage=2, up to 5. And then do it in 5% increments up to 70. The idea
> of that is just to try and avoid enospc while picking off the low
> hanging fruit first (the block groups with the most free space). At
> that point I would then start a full balance, no filter. Maybe that'll
> get it back on track. I haven't ever experienced this so this strategy
> is totally a spitball method of trying to fix it. There is some degree
> of metadata rewrites that happens as part of balance, and balance is
> pretty complicated, and not entirely deterministic - meaning it's
> plausible the filtered balance followed by a full balance could fix
> it. But I don't understand it well enough.

OK, I'm building 5.2.17 now.  Keen to avoid the corruption errors I was
hit by a few weeks back...  May take a time as I'm in the middle of a
slow backup.

I note that a filtered balance, though not hitting enospc and not
reporting any errors did seemed to relocate a chunk/extent (sorry, I
forget the terminology) but running it a second, third and so on time
got the same result.  As if the balance reported doing some work, but
did not actually do it.  I also had to reboot at one point as it seemed
to get stuck in a loop but alas I can't repeat this.  With the extra
logical volume added there is certainly no lack of space relative to the
size of the filesystem.



> 
> Also I'd remove any snapshots you don't really need, it'll make the
> balance less complicated and faster.
> 
> 

There are not too many, but it does not do much harm to take a look.

