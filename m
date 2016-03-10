Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36857 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbcCJFBW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 00:01:22 -0500
Received: by mail-io0-f181.google.com with SMTP id z76so92960909iof.3
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Mar 2016 21:01:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$9dde$acf9ba51$bb837cb8$8c954a04@cox.net>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<20160310023627.2e915667@natsu>
	<pan$9dde$acf9ba51$bb837cb8$8c954a04@cox.net>
Date: Wed, 9 Mar 2016 22:01:21 -0700
Message-ID: <CAJCQCtRXEcCJQdSLYfRXrU992jn8VPuGTFpSetaANHkES0Q+7g@mail.gmail.com>
Subject: Re: dstat shows unexpected result for two disk RAID1
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 9, 2016 at 9:06 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Tho hopefully all the really tough problems they would have hit with N-
> way-mirroring were hit and resolved with raid56, and N-way-mirroring will
> thus be relatively simple, so hopefully it's less than the four years
> it's taking raid56.  But I don't expect to see it for another year or
> two, and don't expect to be actually use it as intended (as a more
> failure resistant raid1) for some time after that as the bugs get worked
> out, so realistically, 2-3 years.
>
> If multi-device scheduling optimization is done in say 6 months after
> that... that means we're looking at 2.5-3.5 years, perhaps longer, for
> it.  So it's a known issue, yes, and on the roadmap, yes, but don't
> expect to see anything in the near (-2-year) future, more like
> intermediate (3-5) year future.  In all honesty I don't seriously expect
> it to be long-term future, beyond 5 years, but it's possible.

Meh, encryption RFC patches arrived 8 days ago and I wasn't expecting
that to happen for a couple years. So I think our expectations have
almost no bearing on feature or fix arrival. For all we know n-way
could appear in 4.6.

-- 
Chris Murphy
