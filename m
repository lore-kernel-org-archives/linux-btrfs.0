From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs balancing start - and stop?
Date: 01 Apr 2011 21:26:00 +0200
Message-ID: <Bj0jd3Ey1uB@helmut.hullen.de>
References: <1301682810.11424.5.camel@sc.lan>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301682810.11424.5.camel@sc.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Stephane,

Du meintest am 01.04.11:

>> balancing about 2 TByte needed about 20 hours.
> [...]

> I've got a balance running since Monday on a 9TB volume (3.5 of which
> are used, 3.2 allegedly free), showing no sign of finishing soon.
> Should I be worried?

> Using /proc/sys/vm/block_dump, I can see it's seeking all over the
> place, which is probably why throughput is not high. I can also see
> it writing several times to the same sectors.


Hugo has explained the limits of regarding

        dmesg | grep relocating

or (more simple) the last lines of "dmesg" and looking for the  
"relocating" lines. But: what do these lines tell now? What is the  
(pessimistic) estimation when you extrapolate the data?

(please excuse my gerlish)

Viele Gruesse!
Helmut
