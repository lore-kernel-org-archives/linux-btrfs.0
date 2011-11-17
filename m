From: "Thomas Schmidt" <Schmidt-T@gmx.de>
Subject: Re: [RFC] improve space utilization on off-sized raid devices
Date: Thu, 17 Nov 2011 15:06:25 +0100
Message-ID: <20111117140625.279050@gmx.net>
References: <20111117002734.70530@gmx.net> <4EC4BAF8.1000407@gmx.net>
 <20111117115323.262060@gmx.net> <4EC5052E.4040709@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC5052E.4040709@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

-------- Original-Nachricht --------
> Datum: Thu, 17 Nov 2011 13:59:26 +0100
> Von: Arne Jansen <sensille@gmx.net>
> An: Thomas Schmidt <Schmidt-T@gmx.de>
> CC: linux-btrfs@vger.kernel.org
> Betreff: Re: [RFC] improve space utilization on off-sized raid devices

> Right you are. So you want to sacrifice stripe size for space efficiency.
> Why don't you just use RAID1?
> Instead of reducing the stripe size for the majority of writes, I'd prefer
> to allow RAID10 to go down to 2 disks. This should also solve it.

Yes, that's my trade.
With my patch I still have striping across 6 devices for meta (6-7 for
data) which is faster then the 2 raid1 would give me. Since 6 drives
allready saturate my bus it's a very good trade in my case.

While implementing your "degenerated raid0/10" would somewhat lessen the
problem (and fix it for me), it would not fix it in general.
But implementing it might is still be a good idea.

Consider a 4 dev setup: 3 1TB drives and 1 2TB using -m raid1
-d raid0: 80% capacity striped 4 way.
-d single: 100% but no striping.
My patch: 100% striped 3 way, a good trade imho.

I don't think such a setup is unlikely enough to ignore, a home user will
simply buy the drive with the best space/cost whenever he needs space,
leading exactly to the described situation. Adding a newly bought 2T drive
to my 3x1T setup, only to see that only half of it can be used would really
piss me off.

Note that if the (optional) first "if" is removed I only reduce width if it
is required to reach 100% capacity. At least thats the intention, it might
need some tweaking.
According to the (hackish) simulator I used to test this, typically the
average stripe width sacrificed on setups of 5+ unmatched devices is below
2
-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
