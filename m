From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs still looks for not existing devices
Date: 14 Oct 2011 16:59:00 +0200
Message-ID: <BvpRQTCy1uB@helmut.hullen.de>
References: <20111014140516.GJ21931@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111014140516.GJ21931@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 14.10.11:

>    This is not a kernel issue, it's a purely userspace issue. Try the
> latest integration branch from git.darksatanic.net, which should have
> a fix for it.

I've just tried

   git clone git://git.darksatanic.net/repo/btrfs-progs-unstable.git

and got the answer

+ git clone git://git.darksatanic.net/repo/btrfs-progs-unstable.git
git.darksatanic.net[0: 212.13.194.111]: errno=Connection refused
git.darksatanic.net[0: 2001:ba8:1f1:f1d9:216:3eff:fe14:aef9]: errno=Network is unreachable
fatal: unable to connect a socket (Network is unreachable)

-----------------------------

Have I got just another typo (or user mistake), or is there another  
problem?

Viele Gruesse!
Helmut
