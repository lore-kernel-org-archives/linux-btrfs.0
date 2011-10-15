From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs still looks for not existing devices
Date: 15 Oct 2011 04:57:00 +0200
Message-ID: <BvtShQ8i1uB@helmut.hullen.de>
References: <2220463.scuNVMpFWy@venice>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2220463.scuNVMpFWy@venice>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Goffredo,

Du meintest am 14.10.11:

> You have to checkout the latest branch; so after

> 	$ git clone http://git.darksatanic.net/repo/btrfs-progs-unstable.git

> you have to perform

> 	$ cd btrfs-progs-unstable
> 	$ git checkout integration-20111012

> Hoping that that help

Bingo!

Now "btrfs filesystem show" works as desired - many thanks to Hugo!

Viele Gruesse!
Helmut
