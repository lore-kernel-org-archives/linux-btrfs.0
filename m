Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51381 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaIRIQR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 04:16:17 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: Zooko Wilcox-OHearn <zooko@leastauthority.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: fs corruption report
Date: Thu, 18 Sep 2014 10:16:09 +0200
Message-ID: <5786662.mcQW9aUYte@fb07-iapwap2>
In-Reply-To: <1411011561.22018.3.camel@localhost.localdomain>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com> <CAM_a8Jy3kwxtDvJ36T0hVrGRBbOK34MOEqZY0GhUUyAUHJMnCw@mail.gmail.com> <1411011561.22018.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1462941.YWT6pRoA0m"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1462941.YWT6pRoA0m
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Am Donnerstag, 18. September 2014, 11:39:21 schrieb Gui Hecheng:
> On Mon, 2014-09-01 at 15:25 +0000, Zooko Wilcox-OHearn wrote:
> > I'm more than happy to try out patches and even focus my own brain on
> > diagnosing it, if I can. I'm hoping to regain access to some of my
> > files on my btrfs partition, and also I would enjoy helping get this
> > improved. :-)
> > 
> > So if you want me to try an experiment, just email me. Unfortunately I
> > can't just give you a copy of the partition, since it has confidential
> > information on it.
> > 
> > Regards,
> > 
> > Zooko
> 
> Hi, Zooko, Marc,
> I'm glad that I could send some feedbacks,
> The following piece deals with the lzo decompress problem with restore
> 
> https://patchwork.kernel.org/patch/4928831/
> 
> Hope that it helps.

Thanks for finding this issue, Gui! I just started a restore.

Marc

--nextPart1462941.YWT6pRoA0m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJUGpTJAAoJEKyeR39HFBtoT2IIAIRaFTKIe9VB5t0atlqDfuKp
2yazRm4cAlrSNDRU3aYeOpUQoaCwMCiA3bDG2jFdE1fY6vWU08YRbUbVx+D/zRvf
jDlA2jeNSUzKWd41i8hG7SGjifc89crRrwOzZaJFXG+zmCUq8AZP/t+GkXnQoEs3
Wka+lSZNXJT5Tkq/7bi+Olqu2XzSv3md3EDdd6gWwW018tsL/xMg1weAPtM7tOy2
z/qATooMlklYrpiaajmAGA2i4O23icmemmjqXb+M1xcPp7lNuvbnAEi0p2fr3EXB
kSWxEBesnVT4R0uL8AXispaglFaLjCKX2SS4LAzqHo8tKElZpKa7yhkUo0xbWQQ=
=FHuf
-----END PGP SIGNATURE-----

--nextPart1462941.YWT6pRoA0m--

