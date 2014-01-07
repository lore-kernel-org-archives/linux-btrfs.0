Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaAGAeK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 19:34:10 -0500
Date: Tue, 7 Jan 2014 11:33:57 +1100
From: NeilBrown <neilb@suse.de>
To: Andrea Mazzoleni <amadvance@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com
Subject: Re: [RFC] lib: raid: New RAID library supporting up to six parities
Message-ID: <20140107113357.3bd67ad0@notabene.brown>
In-Reply-To: <20140106094523.GA4602@gmail.com>
References: <1388742436-3754-1-git-send-email-amadvance@gmail.com>
	<20140106111529.7bcff024@notabene.brown>
	<20140106094523.GA4602@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=Ci+F7FClBMEgb/_8_j5c+W"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/=Ci+F7FClBMEgb/_8_j5c+W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Jan 2014 10:45:23 +0100 Andrea Mazzoleni <amadvance@gmail.com>
wrote:

> Hi Neil,
>=20
> Thanks for your feedback. In the meantime I went further in developing and
> I've just sent version 2 of the patch, that contains a preliminary btrfs
> modification to use the new interface.
>=20
> Please use this one for any kind of review because it contains a modifica=
tion
> of the interface to match better the btrfs use.
> I'll now try to do something similar to the async_tx layer and to improve=
 the
> code documentation as you recommended.

Thanks.

>=20
> Anyway, a good entry point to understand the code is to start from the
> include/linux/raid/raid.h file. It contains the functions that external
> modules should call with a complete description of them.
>=20
> There is raid_par() used to compute parity, and raid_rec() to recover dam=
aged
> blocks. These two functions replace all the old xor_blocks and raid6 call=
s.
>=20
> And there is the raid_sort() you mention. It's an helper function that ca=
n be
> used to ensure that the blocks indexes are passed at the raid interface in
> proper order. In existing code I saw that the indexes are often sorted be=
fore
> calling raid6, with something like:
>=20
> 	if (faila > failb) {
> 		int tmp =3D failb;
> 		failb =3D faila;
> 		faila =3D tmp;
> 	}
>=20
> To do the same with up to six failures, it's now required some kind of so=
rt
> function.

I'm not totally convinced by this, but then I haven't played with the code
so maybe I'm wrong.
I don't see the above as "sorting" faila and failb, but rather determining
which one is first.  Once you know which one is first, the remainder follow
in order.
So I would probably just make sure we always process the block is the "righ=
t"
order.  Then sorting would be irrelevant.
But as I say, I haven't fiddled with the code, so maybe that would end up
being more complex.

Thanks,
NeilBrown


--Sig_/=Ci+F7FClBMEgb/_8_j5c+W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUstLdTnsnt1WYoG5AQKlmQ//TzKGXzAskIf3bSswe+RzUj80HmxPPgy9
PYSSQgDlNEAiNhBa2xVB6aVFLk5atsxCwVI4o8ckif+vXkDyQCdS3o7usTjYCt9W
/vFmtxzRCrCg9em5iv0KGk8Au2HV1EtF2+6mDlGGJQptoB4/zaG/k2ivMWn62v6A
ELkdOy0ZGq6Z3bRprkntCqRBq/eNmkdHKquIvJpgjNx0VxOJS29vwzhknXesO012
TwpXEFVC06MBuQ06TRmQQLSWM6ocA+1Cgzi5/5ZYySSQTd4FgSMhfhkRWfFVw2yJ
Y/npgWQhcrp6xJUaAJEhko+KnyvpkdqjhE2fPd3xXsyvoRxEaW9w1qFXC5J5d4te
vSB4iZcJ9xy5ADN2N8/gi1DUXfZzdSOPjG3rq996mYyaYiz2d6RluzcusY6/zyQK
wUSNAOuxBYuNaj8lETmrpmzb6Xh15Fj+dANYme+CqpOS6rhV/qiHcl97UVtEnGe1
ggnDwzfKiA1609edJ1uPu3QOa7ZVzEIEnjavkdL+Et01cWAt0yQI+McB7TnsKdoC
bAs9zvBcfpQovxw60LM/YrZmqsXg6dRDQIjHKM4utNgwsSB0QXrBTl1In/tj6Y7M
DMW5RDocTkCcUNl2ohmHsz46q0GhUfhuRG49ylc/BW19eWHArRVqttH6VdORqczD
InnoV3U+lkc=
=EmBH
-----END PGP SIGNATURE-----

--Sig_/=Ci+F7FClBMEgb/_8_j5c+W--
