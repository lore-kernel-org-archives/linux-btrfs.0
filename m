From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: remote mirroring in the works?
Date: Mon, 06 Sep 2010 17:04:02 -0700
Message-ID: <4C858172.3020602@noir.com>
References: <29385727.6.1283191163871.JavaMail.root@zimbra> <4C7BF51B.2070201@noir.com> <AANLkTikze-2DsoMb6h-hvz4H8CPpHgxUqx7vCaOyV7+p@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikze-2DsoMb6h-hvz4H8CPpHgxUqx7vCaOyV7+p@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  On 20100906 14:50, David Nicol wrote:
> Only off-topic if BTRFS isn't ever going to ooze into the space
> currently occupied by the likes of
>
> http://en.wikipedia.org/wiki/Global_File_System
>
> that is, file systems that have multiple nodes simultaneously
> accessing block devices and tolerating faults.

There seem to be a number of other systems looking at building fault 
tolerance and distribution over btrfs: crfs, ceph, lustre.  I'm 
convinced that will happen even if btrfs doesn't do it natively.

Btrfs could probably be built to stripe and/or mirror over several nbd 
devices now, although I haven't tried it.

--rich
