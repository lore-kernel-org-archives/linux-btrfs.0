Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46003 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836AbaFSBwu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:52:50 -0400
Message-ID: <1403142759.23472.28.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [v3.10.y][v3.11.y][v3.12.y][v3.13.y][v3.14.y][PATCH 1/1][V2]
 ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while
 DEBUG not defined
From: Ben Hutchings <ben@decadent.org.uk>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: greg@kroah.com, kamal.mostafa@canonical.com, luis.henriques@canonical.com,
        jslaby@suse.cz, clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 19 Jun 2014 02:52:39 +0100
In-Reply-To: <a377cdb51b1a98e9fa6bffaa124502fc15c47903.1403113867.git.joseph.salisbury@canonical.com>
References: <cover.1403113867.git.joseph.salisbury@canonical.com>
	 <a377cdb51b1a98e9fa6bffaa124502fc15c47903.1403113867.git.joseph.salisbury@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rfKhpCXDhdrQQySBsrG1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-rfKhpCXDhdrQQySBsrG1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-06-18 at 14:32 -0400, Joseph Salisbury wrote:
> From: Sander Eikelenboom <linux@eikelenboom.it>
>=20
> BugLink: http://bugs.launchpad.net/bugs/1319457
>=20
> This (widely used) construction:
>=20
> if(printk_ratelimit())
> 	dev_dbg()
>=20
> Causes the ratelimiting to spam the kernel log with the "callbacks suppre=
ssed"
> message below, even while the dev_dbg it is supposed to rate limit wouldn=
't
> print anything because DEBUG is not defined for this device.
>=20
> [  533.803964] retire_playback_urb: 852 callbacks suppressed
> [  538.807930] retire_playback_urb: 852 callbacks suppressed
> [  543.811897] retire_playback_urb: 852 callbacks suppressed
> [  548.815745] retire_playback_urb: 852 callbacks suppressed
> [  553.819826] retire_playback_urb: 852 callbacks suppressed
>=20
> So use dev_dbg_ratelimited() instead of this construction.
>=20
> Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> (backported from commit b7a7723513dc89f83d6df13206df55d4dc26e825)
> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>

It looks like you have combined the commit identified here with the
preceding:

commit a5065eb6da55b226661456e6a7435f605df98111
Author: Tim Gardner <tim.gardner@canonical.com>
Date:   Wed Apr 9 11:30:44 2014 -0600

    ALSA: usb-audio: Suppress repetitive debug messages from retire_playbac=
k_urb()

They should not be squashed together like this.

Ben.

> ---
>  sound/usb/pcm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
> index ca3256d..ede4b92 100644
> --- a/sound/usb/pcm.c
> +++ b/sound/usb/pcm.c
> @@ -1488,7 +1488,8 @@ static void retire_playback_urb(struct snd_usb_subs=
tream *subs,
>  	 * on two reads of a counter updated every ms.
>  	 */
>  	if (abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
> -		snd_printk(KERN_DEBUG "delay: estimated %d, actual %d\n",
> +		dev_dbg_ratelimited(&subs->dev->dev,
> +			"delay: estimated %d, actual %d\n",
>  			est_delay, subs->last_delay);
> =20
>  	if (!subs->running) {

--=20
Ben Hutchings
It's easier to fight for one's principles than to live up to them.

--=-rfKhpCXDhdrQQySBsrG1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU6JCbOe/yOyVhhEJAQrOHhAAiAL1eg7YjhaP7MsLbQyxRjA829nBeXFf
2Xw5it1ndXE2XxgtIs9JVJ/jscDDzWuOcKy1INuaH6FFWOCm4BLbrcdOinE6yZvl
+tIdUFmIZC6chylGmfpSnjVFimWeKGR7K0c5Xwclo9+FyTmF039wfwLZixO/O1P3
cu/35cgeoBZlF2cv7Jzq1T5RZWniQqtgt/um1U2dctJQQ10BXwRHtCD19tuPyszU
XoGU4qeLhBluCuBuSfWAaxzw+s5bTZfr32MnazKGOia1GPm7ICaDEJZ2Zs0V1aFK
3HuT4u8Wyb2NloHoC/091awEXQgoPy10Zk2/FYQLPcCnUGphXgo3R1GXsYkjWYxL
ItPgUobkmH74/MnQ4VIWq1KOvj7RRSbVLPi/Mxk/wmUDVli/Fnitc9SIWDbSmuZ7
gI4Kq9jowsW3wrC1CNuJyT5/Zr19m/phpo+0W0OX98PhJsjhyV1d+gNyxQys4uJ+
J/qEfjEpzWkoHotzcBPt4nE6gdPKl012CA35NZz7yNecPF+cf7F1JJqhvrnp/Qs7
kYd4es2Us0NFCtCAiia9RqpbvFdURd4q5mMQZojMKFYEIJbO/MLPm/NMJmS/8gFV
P4g/kBsdHxjjLHaC6H2FOcXYBSaDjsjtCnlEWnV+06YyPt2hKhBEnA8mHFRyKpEJ
LJnjpsKGR20=
=1V3l
-----END PGP SIGNATURE-----

--=-rfKhpCXDhdrQQySBsrG1--
