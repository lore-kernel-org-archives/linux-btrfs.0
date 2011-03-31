From: Chris Mason <chris.mason@oracle.com>
Subject: Re: checkpoints to often
Date: Thu, 31 Mar 2011 10:35:51 -0400
Message-ID: <1301582070-sup-5170@think>
References: <AANLkTinr4G=F6msPF=oVDrCU1uz2b-q8Do4f5htzP=ep@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "krzf83@gmail.com" <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTinr4G=F6msPF=oVDrCU1uz2b-q8Do4f5htzP=ep@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from krzf83@gmail.com's message of 2011-03-31 10:30:51 -0400:
> There should be a way to make automatic checkpoints less frequent. On
> the busy ssd I have about 7 cp every second. If it were for example
> once every 5 minutes then one could set garbage removal every few
> days.
> Also garbage removal should have option to clean only if like 90% of
> drive is used. there is no need to remove cp-s when there is still
> many GB of space left.

I'm wondering how you're measuring check points?  Btrfs does a
transaction commit ever 30 seconds, so finding 7 commits per second
seems strange.

We do have a lighter weight commit that is done for fsyncs, but this is
not a full check point.

There's no garbage removal in btrfs, we use reference counting instead
of a traditional log structured design.

-chris
