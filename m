Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49447 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbaILMfZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 08:35:25 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: Zooko Wilcox-OHearn <zooko@leastauthority.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fs corruption report
Date: Fri, 12 Sep 2014 14:35:21 +0200
Message-ID: <3754179.WO5PRvrZZr@fb07-iapwap2>
In-Reply-To: <3487607.QJCBo4siRK@fb07-iapwap2>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com> <1409799655.13046.16.camel@localhost.localdomain> <3487607.QJCBo4siRK@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2790381.5tHbBdh01T"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2790381.5tHbBdh01T
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Hello Guy,

Am Donnerstag, 4. September 2014, 11:50:14 schrieb Marc Dietrich:
> Am Donnerstag, 4. September 2014, 11:00:55 schrieb Gui Hecheng:
> > Hi Zooko, Marc,
> > 
> > Firstly, thanks for your backtrace info, Marc.
> > Sorry to reply late, since I'm offline these days.
> > For the restore problem, I'm sure that the lzo decompress routine lacks
> > the ability to handle some specific extent pattern.
> > 
> > Here is my test result:
> > I'm using a specific file for test
> > /usr/lib/modules/$(uname -r)/kernel/net/irda/irda.ko.
> > You can get it easily on your own box.
> > 
> > 	# mkfs -t btrfs <dev>
> > 	# mount -o compress-force=lzo <dev> <mnt>
> > 	# cp irda.ko <mnt>
> > 	# umount <dev>
> > 	# btrfs restore -v <dev> <restore_dir>
> > 
> > report:
> > 	# bad compress length
> > 	# failed to inflate
> 
> uh, that's really odd. I don't use force compress, but I guess it will also
> happen with non-forced one if the file is big enough.
> 
> > btrfs-progs version: v3.16.x
> > 
> > With the same file under no-compress & zlib-compress,
> > the restore will output a correct copy of irda.ko.
> > 
> > I'm not sure whether the problem above has something to do with your
> > problem. Hope that the messages above are helpful.
> 
> I also get lot's of "bad compress length", so it might be indeed related.
> 
> I'm not a programmer, but is it possible that we are just skipping the lzo
> header (magic + header len + rest of header)?

I'm able to reproduce it. Any improved insight into this problem?

Marc

--nextPart2790381.5tHbBdh01T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJUEuiJAAoJEKyeR39HFBtoW4EIAKNPdvBjUtePWGQg26YE82uB
AvSkRUoaadqvDZtMpwacJLTwNA9m5m3VdgoJzkN+X7RtY4/1FnHkkaGlxPlP80RX
uv6PeFedG2xgYwt7TcqkJGZASaeCTfSKugKFsPSf+G2c4hayGrYGpMTHd67Y+CKy
VwFL2TIcv+KxFUesfxOHyOrYOh3wO0Cl2mrFesXEv1QzDLlg1y/i7x5JBTe6bhZB
U1tGCwglhvtq39dHkWL4rOG9n4irsTaFYCNXmYFyIw/UiLdzVJZHfDrJFQalXA+F
kGraEmUF6l8D9M5lOuNnT0hLj8nQDqBHNfWItdArux507GxwZcGaj8fsPxjAwEA=
=tF75
-----END PGP SIGNATURE-----

--nextPart2790381.5tHbBdh01T--

