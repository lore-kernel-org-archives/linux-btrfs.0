Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:60055 "EHLO
        smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752066AbdFUGvp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 02:51:45 -0400
Received: from smtp11.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp11.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 7963053E8
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 02:51:44 -0400 (EDT)
Received: by smtp11.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id 2A9985211
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 02:51:43 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id 4EA22BF08
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 06:51:42 +0000 (UTC)
From: Marat Khalili <mkh@rqc.ru>
Subject: Re: Exactly what is wrong with RAID5/6
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <20170620232525.GF7140@carfax.org.uk>
 <CAJCQCtSMGjsrZ7N0gWQE744w_au7g1nUMXb1wL2nTa9kgmzYrA@mail.gmail.com>
Message-ID: <a88f7896-5693-ad90-383e-a24c61110e8a@rqc.ru>
Date: Wed, 21 Jun 2017 09:51:42 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSMGjsrZ7N0gWQE744w_au7g1nUMXb1wL2nTa9kgmzYrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/06/17 06:48, Chris Murphy wrote:
> Another possibility is to ensure a new write is written to a new*not*
> full stripe, i.e. dynamic stripe size. So if the modification is a 50K
> file on a 4 disk raid5; instead of writing 3 64K data strips + 1 64K
> parity strip (a full stripe write); write out 1 64K data strip + 1 64K
> parity strip. In effect, a 4 disk raid5 would quickly get not just 3
> data + 1 parity strip Btrfs block groups; but 1 data + 1 parity, and 2
> data + 1 parity chunks, and direct those write to the proper chunk
> based on size. Anyway that's beyond my ability to assess how much
> allocator work that is. Balance I'd expect to rewrite everything to
> max data strips possible; the optimization would only apply to normal
> operation COW.
This will make some filesystems mostly RAID1, negating all space savings 
of RAID5, won't it?

Isn't it easier to recalculate parity block based using previous state 
of two rewritten strips, parity and data? I don't understand all 
performance implications, but it might scale better with number of devices.

--

With Best Regards,
Marat Khalili
