From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: btrfs still looks for not existing devices
Date: Fri, 14 Oct 2011 23:26:03 +0200
Message-ID: <2220463.scuNVMpFWy@venice>
References: <BvpRYk9D1uB@helmut.hullen.de>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BvpRYk9D1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 14 October, 2011 17:43:00 you wrote:
[...]
> 
> But "btrfs filesystem show" still shows lots of nonexistent devices -
> sorry.

You have to checkout the latest branch; so after

	$ git clone http://git.darksatanic.net/repo/btrfs-progs-unstable.git

you have to perform

	$ cd btrfs-progs-unstable
	$ git checkout integration-20111012

Hoping that that help
BR
G.Baroncelli



> 
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
