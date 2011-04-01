From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs balancing start - and stop?
Date: 01 Apr 2011 15:36:00 +0200
Message-ID: <Bj0iubBi1uB@helmut.hullen.de>
References: <4D95D19F.7060101@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D95D19F.7060101@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Konstantinos,

Du meintest am 01.04.11:

>> "dmesg" counts down the number of remaining "jobs".

> are you sure? here is a snippet of dmesg from a balance i did
> yesterday (2.6.38.1)

> btrfs: relocating block group 15338569728 flags 9
> btrfs: found 17296 extents
> btrfs: found 17296 extents
> btrfs: relocating block group 13191086080 flags 9
> btrfs: found 21029 extents
> btrfs: found 21029 extents
> btrfs: relocating block group 11043602432 flags 9
> btrfs: found 4728 extents
> btrfs: found 4728 extents

Yes - there I look how long the balancing job may still work. You see  
that the "relocating" line counts down: 15 13 11 ...

Viele Gruesse!
Helmut
