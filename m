From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: graceful handling of removing a plugable storage device that is being written to
Date: Sun, 11 Sep 2011 21:06:17 +0200
Message-ID: <201109112106.17705.Martin@lichtvoll.de>
References: <1315751507.52552.YahooMailClassic@web29517.mail.ird.yahoo.com> <201109111853.20530.Martin@lichtvoll.de> <CAMuHMdUC0bR+SF0oLHb3JYQLyg2y_imak5Ns7pksqvXVha8X6A@mail.gmail.com> (sfid-20110911_210415_171129_50324A7B)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUC0bR+SF0oLHb3JYQLyg2y_imak5Ns7pksqvXVha8X6A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 11. September 2011 schrieb Geert Uytterhoeven:
> On Sun, Sep 11, 2011 at 18:53, Martin Steigerwald <Martin@lichtvoll.d=
e>=20
wrote:
> > Frankly, I never tried this on AmigaOS. I know that AmigaOS expects
> > the exact same floppy disk to be inserted again. Only the same name
> > isn=C2=B4t enough. But I have no idea, what AmigaOS would have done=
, when
> > I inserted
>=20
> Are you sure the volume name wasn't enough?
> For most things, it relied on the volume name, that's how you could m=
ap
> floppy names to hard drive directories using assigns.

Yes, I am pretty sure I tried that back then. Difficult to repeat at th=
e=20
moment, since I think at least the high density disk drive in my A4000 =
is=20
toast since quite a while.

Anyway, if Linux implements something like that it should not only depe=
nd=20
on a volume name ;).

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
