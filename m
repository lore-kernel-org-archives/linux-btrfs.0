From: Arne Jansen <sensille@gmx.net>
Subject: Re: [RFC] improve space utilization on off-sized raid devices
Date: Thu, 01 Dec 2011 09:55:27 +0100
Message-ID: <4ED740FF.1010304@gmx.net>
References: <20111117002734.70530@gmx.net> <4EC4BAF8.1000407@gmx.net> <20111117115323.262060@gmx.net> <4EC5052E.4040709@gmx.net> <20111117140625.279050@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Thomas Schmidt <Schmidt-T@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111117140625.279050@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 17.11.2011 15:06, Thomas Schmidt wrote:
> -------- Original-Nachricht --------
>> Datum: Thu, 17 Nov 2011 13:59:26 +0100
>> Von: Arne Jansen <sensille@gmx.net>
>> An: Thomas Schmidt <Schmidt-T@gmx.de>
>> CC: linux-btrfs@vger.kernel.org
>> Betreff: Re: [RFC] improve space utilization on off-sized raid devices
> 
> 
> Consider a 4 dev setup: 3 1TB drives and 1 2TB using -m raid1
> -d raid0: 80% capacity striped 4 way.
> -d single: 100% but no striping.
> My patch: 100% striped 3 way, a good trade imho.
> 
> I don't think such a setup is unlikely enough to ignore, a home user will
> simply buy the drive with the best space/cost whenever he needs space,
> leading exactly to the described situation. Adding a newly bought 2T drive
> to my 3x1T setup, only to see that only half of it can be used would really
> piss me off.
> 
> Note that if the (optional) first "if" is removed I only reduce width if it
> is required to reach 100% capacity. At least thats the intention, it might
> need some tweaking.
> According to the (hackish) simulator I used to test this, typically the
> average stripe width sacrificed on setups of 5+ unmatched devices is below
> 2

As RAID0 is already not a strict 'all disks or none', I like the idea to
have it even more dynamic to reach full optimization. But I'd like to see
some properties conserved:
 a) In case of even size disks, the stripes should always be full size, not
   n - 1
 b) Minor variations in the used space per disk due to metadata chunks should
   not lead to deviation from a)
 c) The algorithms should not give weird results under unconventional setups.
    Some theoretical background would be nice :)

It might well be that your algorithm is already close :)

-Arne
