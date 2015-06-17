Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:60959 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbbFQNNY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 09:13:24 -0400
Received: from smtp12.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp12.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 0860C38028B
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:13:23 -0400 (EDT)
Received: from smtp12.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp12.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id D86BC38029E
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:13:23 -0400 (EDT)
Received: by smtp12.relay.ord1c.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id BBB0638028B
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:13:16 -0400 (EDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: RAID10 Balancing Request for Comments and Advices
From: Vincent Olivier <vincent@up4.com>
In-Reply-To: <CAJCQCtRGxCr4GaVwkA0QpK8dYjhaBS0-rmi=ymPxycQiGUa_fg@mail.gmail.com>
Date: Wed, 17 Jun 2015 09:13:08 -0400
Message-Id: <80BA2964-3B67-430B-99BE-62A348C5DBED@up4.com>
References: <1434456557.89597618@apps.rackspace.com> <20150616122545.GI9850@carfax.org.uk> <61CBE6C4-0D06-4F16-B522-4DBB756FBC31@up4.com> <pan$966fb$92ec2f1c$291706f7$cf1b6c68@cox.net> <CAJCQCtRGxCr4GaVwkA0QpK8dYjhaBS0-rmi=ymPxycQiGUa_fg@mail.gmail.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Jun 16, 2015, at 8:14 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> On Tue, Jun 16, 2015 at 5:58 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> On a current kernel unlike older ones, btrfs actually automates entirely
>> empty chunk reclaim, so this problem doesn't occur anything close to near
>> as often as it used to.  However, it's still possible to have mostly but
>> not entirely empty chunks that btrfs won't automatically reclaim.  A
>> balance can be used to rewrite and combine these mostly empty chunks,
>> reclaiming the space saved.  This is what Hugo was recommending.
> 
> Yes, as little as a -dusage=5 (data chunks that are 5% or less full)
> can clear the problem and is very fast, seconds. Possibly a bit
> longer, many seconds o single digit minutes is -dusage=15. I haven't
> done a full balance in forever.


Yes, on this 80% full 6x4TB RAID10 -dusage=15 took 2 seconds and relocated "0 out of 3026 chunks”.

Out of curiosity, I had to use -dusage=90 to have it relocate only 1 chunk and it took les than 30 seconds.

So I put a -dusage=25 in the weekly cron just before the scrub.

FYI.

Thanks for your help.