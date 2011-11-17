From: "Thomas Schmidt" <Schmidt-T@gmx.de>
Subject: Re: [RFC] improve space utilization on off-sized raid devices
Date: Thu, 17 Nov 2011 12:53:23 +0100
Message-ID: <20111117115323.262060@gmx.net>
References: <20111117002734.70530@gmx.net> <4EC4BAF8.1000407@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC4BAF8.1000407@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original-Nachricht --------
> Datum: Thu, 17 Nov 2011 08:42:48 +0100
> Von: Arne Jansen <sensille@gmx.net>
> An: Thomas Schmidt <Schmidt-T@gmx.de>
> CC: linux-btrfs@vger.kernel.org
> Betreff: Re: [RFC] improve space utilization on off-sized raid devices

> On 17.11.2011 01:27, Thomas Schmidt wrote:
> > With 2.6.38 I frequently ran into a no space left error
> Did you also test with 3.0? In 3.0, the allocation strategy changed
> vastly.
> In your setup, it should stripe to all 8 devices until the 5 smaller ones
> are full, and from then on stripe to the 3 remaining devices.
> See commit
> 
> commit 73c5de0051533cbdf2bb656586c3eb21a475aa7d
> Author: Arne Jansen <sensille@gmx.net>
> Date:   Tue Apr 12 12:07:57 2011 +0200
> 
>     btrfs: quasi-round-robin for chunk allocation
> 
> Also using raid1 instead of raid10 will yield a better space utilization.

No I did not test if the problem occoured in vanilla 3.0.0.
I only did compare the code and saw no reason why behavior should have
changed (for my case).
The sorting is the base of my idea. But the order does not matter if you
allocate on all devices anyway (as with an even number of devs).

Afaik the behavior you describe is exactly the problem.
It wants to continuing with 3 devices, but according to the code raid10
requires 4.

I can't use the actual fs (or devs) the problem happened on but I will try a small scale test on some files. As I currently have my patch in use 
I will have to wait till I can reboot.
-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
