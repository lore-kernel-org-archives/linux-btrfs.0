Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FD0C0015E
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Jul 2023 11:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjGKLsD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 07:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjGKLsC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2023 07:48:02 -0400
Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E420F11D
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Jul 2023 04:48:00 -0700 (PDT)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id 3132773B772;
        Tue, 11 Jul 2023 13:47:59 +0200 (CEST)
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     linux-btrfs@vger.kernel.org, Tim Cuthbertson <ratcheer@gmail.com>,
        Qu Wenruo <wqu@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: Scrub of my nvme SSD has slowed by about 2/3
Date:   Tue, 11 Jul 2023 13:47:58 +0200
Message-ID: <2316165.ElGaqSPkdT@lichtvoll.de>
In-Reply-To: <9e05c3b9-301c-84c5-385d-6ca4bfa179f4@gmx.com>
References: <CAAKzf7=yS9vnf5zNid1CyvN19wyAgPz5o9sJP0vBqN6LReqXVg@mail.gmail.com>
 <5977988.lOV4Wx5bFT@lichtvoll.de>
 <9e05c3b9-301c-84c5-385d-6ca4bfa179f4@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Qu Wenruo - 11.07.23, 13:33:50 CEST:
> >> BTW, what's the CPU usage of v6.3 kernel? Is it higher or lower?
> >> And what about the latency?
> > 
> > CPU usage is between 600-700% on 6.3.9, Latency between 50-70 µs.
> > And
> > scrubbing speed is above 2 GiB/s, peaking at 2,27 GiB/s. Later it
> > went down a bit to 1,7 GiB/s, maybe due to background activity.
> 
> That 600~700% means btrfs is taking all its available thread_pool
> (min(nr_cpu + 2, 8)).
> 
> So although the patch doesn't work as expected, we're still limited by
> the csum verification part.
> 
> At least I have some clue now.

Well it would have an additional 800-900% of CPU time left over to use 
on this machine, those modern processors are crazy. But for that it 
would have to use more threads. However if you can make this more 
efficient CPU time wise… all the better.

> > I'd say the CPU usage to result (=scrubbing speed) ratio is much,
> > much better with 6.3. However the latencies during scrubbing are
> > pretty much the same. I even seen up to 0.2 ms.
[…]
> >> If you're interested in more testing, you can apply the following
> >> small diff, which changed the batch number of scrub.
[…]
> > No time for further testing at the moment. Maybe at a later time.
> > 
> > It might be good you put together a test setup yourself. Any
[…]
> Sure, I'll prepare a dedicated machine for this.
> 
> Thanks for all your effort!

You are welcome.

Thanks,
-- 
Martin


