From: Arne Jansen <sensille@gmx.net>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: Mon, 11 Apr 2011 09:56:10 +0200
Message-ID: <4DA2B41A.30200@gmx.net>
References: <BjW+GU4y1uB@helmut.hullen.de> <20110409091141.GE5301@carfax.org.uk> <4DA182DF.6010703@cn.fujitsu.com> <chaz20110411072946.GA5587@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Hugo Mills <hugo-lkml@carfax.org.uk>, helmut@hullen.de,
	linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110411072946.GA5587@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11.04.2011 09:29, Stephane Chazelas wrote:
> 2011-04-10 18:13:51 +0800, Miao Xie:
> [...]

> 
> What's the implication of having disks of differing sizes? Does
> that mean that the extra space on larger disks is lost?

Yes. Currently the allocator cannot handle different sizes well,
especially when mirroring is involved. I sent a patch for this
to the list some weeks ago (see quasi-round-robin), but it hasn't
been merged yet.

-Arne

> 
> Thanks,
> Stephane
