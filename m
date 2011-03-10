From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS fsck tool
Date: Thu, 10 Mar 2011 12:41:21 -0500
Message-ID: <1299778786-sup-8805@think>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com> <4D7591CC.6060301@shiftmail.org> <AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com> <20110308065255.24100.qmail@stuge.se> <1299762048-sup-3940@think> <AANLkTimK8LD50ga=uJuJYJ84Y37KoZPRieGmDHt6HncG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Peter Stuge <peter@stuge.se>, Spelic <spelic@shiftmail.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Alexey A Nikitin <moonwalker@syrius.us>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTimK8LD50ga=uJuJYJ84Y37KoZPRieGmDHt6HncG@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Alexey A Nikitin's message of 2011-03-10 12:30:54 -0500:
> 2011/3/10 Chris Mason <chris.mason@oracle.com>
> >
> > Which kernel were you on? =C2=A0Was btrfs directly accessing the di=
sks or
> > were things like LVM in use?
> > Recent kernels (.37 and higher) have improved support for barriers =
in
> > LVM and friends, but btrfs directly using the disks should have bee=
n
> > safe for a long time.
>=20
> Now that's funny. I'm using  2.6.32-5-amd64 from Debian Wheezy and
> while btrfs on top of LVM works perfectly stable I have now trouble
> with FS that is directly on partition. Does it make difference
> stability-wise if partition table on disk is GPT rather than
> old-school MS-DOS? Because all my disks, LVM and non-LVM, are set wit=
h
> GPT.

LVM is very reliable, the only time you run into trouble is if you have
a drive with writeback cache enabled (99.99% of sata drives) and LVM
isn't passing the barriers through.  GPT vs MS-DOS isn't crucial, its
just important that if you have a writeback cache,  you either get the
barriers down to the drive or you turn off the writeback cache.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
