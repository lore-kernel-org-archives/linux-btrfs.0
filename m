Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34675 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbcATORs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 09:17:48 -0500
Received: by mail-wm0-f51.google.com with SMTP id u188so186562367wmu.1
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 06:17:48 -0800 (PST)
Received: from [10.3.28.25] ([155.210.218.230])
        by smtp.gmail.com with ESMTPSA id q75sm25426182wmd.6.2016.01.20.06.17.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 20 Jan 2016 06:17:46 -0800 (PST)
Subject: Re: raid1 vs raid5
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <568BEE3F.4060402@gmail.com>
From: Psalle <psalleetsile@gmail.com>
Message-ID: <569F9709.4090608@gmail.com>
Date: Wed, 20 Jan 2016 15:17:45 +0100
MIME-Version: 1.0
In-Reply-To: <568BEE3F.4060402@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had forgotten about this post and on rethinking about it I realized 
the kind of brain fart I was having. So thanks for the merciful silence ;-)

On 05/01/16 17:24, Psalle wrote:
> Hello all and excuse me if this is a silly question. I looked around 
> in the wiki and list archives but couldn't find any in-depth 
> discussion about this:
>
> I just realized that, since raid1 in btrfs is special (meaning only 
> two copies in different devices), the effect in terms of resilience 
> achieved with raid1 and raid5 are the same: you can lose one drive and 
> not lose data.
>
> So!, presuming that raid5 were at the same level of maturity, what 
> would be the pros/cons of each mode?
>
> As a corollary, I guess that if raid1 is considered a good compromise, 
> then functional equivalents to raid6 and beyond could simply be 
> implemented as "storing n copies in different devices", dropping any 
> complex parity computations and making this mode entirely generic. 
> Since this seems pretty obvious, I'd welcome your insights on what are 
> the things I'm missing, since it doesn't exist (and it isn't planned 
> to be this way, AFAIK). I can foresee consistency difficulties, but 
> that seems hardly insurmountable if its being done for raid1?
>
> Thanks in advance,
> Psalle.

