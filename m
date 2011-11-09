From: Chris Mason <chris.mason@oracle.com>
Subject: Re: How to remount btrfs without compression?
Date: Wed, 9 Nov 2011 08:01:34 -0500
Message-ID: <20111109130134.GL4149@shiny>
References: <4EB87E01.1040704@parallels.com>
 <4EB880A0.1030304@gmail.com>
 <CAG1y0seMUUNwXCY6-=JehE+rrd4PRF55MZoHEUB_9+jDm6N_rA@mail.gmail.com>
 <4EB88BC9.7020509@gmail.com>
 <4EB88D4A.5050908@parallels.com>
 <20111108150151.GA4954@shiny>
 <20111108151208.GB4954@shiny>
 <4EB9D0D9.1000009@parallels.com>
 <j9db98$gbt$1@dough.gmane.org>
 <CAG1y0scE__f0BDyZz82z97jCX7DvzhDgXeh7Kh5pm31eXB=Wpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lubos Kolouch <lubos.kolouch@gmail.com>,
	linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0scE__f0BDyZz82z97jCX7DvzhDgXeh7Kh5pm31eXB=Wpg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 09, 2011 at 03:04:01PM +0700, Fajar A. Nugraha wrote:
> On Wed, Nov 9, 2011 at 2:48 PM, Lubos Kolouch <lubos.kolouch@gmail.com> wrote:
> > Sorry for possibly OT question - when I have historical btrfs system
> > mounted with zlib compression,
> >
> > can I remount it with lzo ?
> 
> yes
> 
> > What will happen? Will the COW be broken
> > and the files taking duplicate space? Or will the Universe explode and
> > be replaced with something even more bizzare?
> 
> New written block/extents will use lzo compression (if it's
> compressible, or if it's mounted with compress-force). Old, unmodified
> block/extents will remain unchanged, using zlib or uncompressed.

This is correct, your old stuff will be zlib and your new stuff lzo.
The compression type is recorded on a per-extent basis and the global
switch just decides what type of compression to use for new writes.

-chris

