From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: btrfs-control: no such device
Date: Fri, 8 Apr 2011 16:18:54 +0200
Message-ID: <20110408161854.00003bea@unknown>
References: <BjSyMGwD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BjSyMGwD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

nope. All patches to the btrfs-progs aren't yet in the git. I think
it's up to chris to push all the patches.


Regards,
Felix

Am 08 Apr 2011 14:00:00 +0200
schrieb "Helmut Hullen" <Hullen@t-online.de>:

> Hallo, linux-btrfs,
> 
> when I run "balance" or "delete" and "/dev/btrfs-control" doesn't
> exist or is nor properly designed (I don't use "udev") then the
> program shows an error message and then continiues its work; the
> result is garbage.
> 
> The programs (or program options) which use a wellformed device
> "btrfs- control" should stop working if there is "no such device".
> 
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

