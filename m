From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: How to remount btrfs without compression?
Date: Wed, 9 Nov 2011 15:04:01 +0700
Message-ID: <CAG1y0scE__f0BDyZz82z97jCX7DvzhDgXeh7Kh5pm31eXB=Wpg@mail.gmail.com>
References: <4EB72C1B.1030702@parallels.com>
	<201111071319.14493.Martin@lichtvoll.de>
	<4EB87E01.1040704@parallels.com>
	<4EB880A0.1030304@gmail.com>
	<CAG1y0seMUUNwXCY6-=JehE+rrd4PRF55MZoHEUB_9+jDm6N_rA@mail.gmail.com>
	<4EB88BC9.7020509@gmail.com>
	<4EB88D4A.5050908@parallels.com>
	<20111108150151.GA4954@shiny>
	<20111108151208.GB4954@shiny>
	<4EB9D0D9.1000009@parallels.com>
	<j9db98$gbt$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <j9db98$gbt$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 9, 2011 at 2:48 PM, Lubos Kolouch <lubos.kolouch@gmail.com> wrote:
> Sorry for possibly OT question - when I have historical btrfs system
> mounted with zlib compression,
>
> can I remount it with lzo ?

yes

> What will happen? Will the COW be broken
> and the files taking duplicate space? Or will the Universe explode and
> be replaced with something even more bizzare?

New written block/extents will use lzo compression (if it's
compressible, or if it's mounted with compress-force). Old, unmodified
block/extents will remain unchanged, using zlib or uncompressed.

-- 
Fajar
