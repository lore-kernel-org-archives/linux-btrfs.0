From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: graceful handling of removing a plugable storage device that is
 being written to
Date: Sun, 11 Sep 2011 21:01:16 +0200
Message-ID: <CAMuHMdUC0bR+SF0oLHb3JYQLyg2y_imak5Ns7pksqvXVha8X6A@mail.gmail.com>
References: <1315751507.52552.YahooMailClassic@web29517.mail.ird.yahoo.com>
	<201109111853.20530.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201109111853.20530.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 11, 2011 at 18:53, Martin Steigerwald <Martin@lichtvoll.de>=
 wrote:
> Frankly, I never tried this on AmigaOS. I know that AmigaOS expects t=
he
> exact same floppy disk to be inserted again. Only the same name isn=C2=
=B4t
> enough. But I have no idea, what AmigaOS would have done, when I inse=
rted

Are you sure the volume name wasn't enough?
=46or most things, it relied on the volume name, that's how you could m=
ap
floppy names to hard drive directories using assigns.

> the disk into another Amiga, did something there and then insert it i=
nto
> the Amiga with the notification and pressed "okay". Probably it would=
 have
> eaten the disk then.

Most probably.

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
