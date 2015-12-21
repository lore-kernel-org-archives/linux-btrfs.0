Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52454 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbbLUIOe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 03:14:34 -0500
Date: Mon, 21 Dec 2015 08:14:32 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: defrag vs autodefrag
Message-ID: <20151221081432.GR26782@carfax.org.uk>
References: <CAC=t97A1S6599aHWCCin7KnFWARs_ebfK6GptAXZQbFnSio7eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7UIJfHqpdi+oBJdT"
In-Reply-To: <CAC=t97A1S6599aHWCCin7KnFWARs_ebfK6GptAXZQbFnSio7eA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7UIJfHqpdi+oBJdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 20, 2015 at 07:26:07PM -0600, Donald Pearson wrote:
> I read an implication in a different thread that defrag and autodefrag
> behave differently in that autodefrag is more snapshot friendly for
> COW data.
> 
> Did I understand that correctly?  I have not been doing defrag on my
> virtual machine image directory because I do use a snapshot schedule
> and the way I understood things, a defrag would basically decouple the
> live data from the snapshots and greatly increase utilization.
> 
> It sounded like autodefrag does not have this problem?

   Correct.

> If that's true, is there any case where it would not be best practice
> to mount with autodefrag enabled?

   When you are already tight on I/O bandwidth for your application.
autodefrag increases the amount of I/O the disks do (because it's
rewriting parts of the file near each write, as well as just the piece
that's being written by userspace).

   Hugo.

-- 
Hugo Mills             | UNIX: Japanese brand of food containers
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--7UIJfHqpdi+oBJdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWd7ToAAoJEFheFHXiqx3k/9MP/R2IQZtqs0ouwrr1gDXK4R2q
9fWZRAZlgfNP5VVhC7E0hvjmdvSUM06WZsW0T3z2PCCi703RoCTvpdxZcJHUU4W/
lk3wPvfSOEkGFwmyrVbiURfnvRmeZXW2Qw+UIczN2cWoS4fQOwLuX77JXKnr/th7
xiFTXHRtH/0wR/lTzhe5ARjVzcrjffWgjgA2MxKgSstNAXdL356CFnLMuTMpjASJ
sdlmGpebcGjuWUktwwUhmtJNEFSB8+ZOrRs5Qo2ch2uji8KKeu1C1NXH/nfnHoRc
K9jH8bGqHPYGfcfyj13zcFlyxe2YHsYLlAIIW/rG3KdMHjfGnFdazgvOD7YK2L57
+FRktDju+F8LxywS5abnWrBm0guoochSV0209exwpCP3inhackaa3GS0jmGNNNC8
/ij5fMASXGdpBX1NxgCnviYxIsUJLNzDr0mZtiO2m9OVGcBpbFgM33LoNLvjF2sc
9SZupVErH1G/3Do7DxGBrTIGMCIVYm+h0HkgV/IT/3ZbSkh3qLZzewNBvjRMNgfk
YLwd6wu+mtsPlVvCAWlX6YU2duZTni3kCKh23Ii6h5sgPwANPcbkh/u/V7WsvYSz
nZHhm3M9eqqakbDU9+BLcQ3vlp7RDaqRj+jwP8DYSgF2o5rOTVkan+yQr/Q/Yyiw
uO3LzWRommrf5F3Cnz6m
=869a
-----END PGP SIGNATURE-----

--7UIJfHqpdi+oBJdT--
