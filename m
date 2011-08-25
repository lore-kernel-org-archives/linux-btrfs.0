From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: BTRFS and power loss ~= corruption?
Date: Thu, 25 Aug 2011 23:16:47 +0100
Message-ID: <1314310608.3448.8.camel@picard>
References: <4E54F884.9090004@cyberwizzard.nl>
	 <CAKcLGm8wYKKZ-yEX3_A612MJPLND3DnM-7+N_hw3LUxwQe837w@mail.gmail.com>
	 <4E55C217.4080203@oracle.com>
	 (sfid-20110825_102450_021619_3DA8F0D1) <201108251955.35283.Martin@lichtvoll.de>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-g/TdbyLooeSSDTLBfS/d"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201108251955.35283.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>


--=-g/TdbyLooeSSDTLBfS/d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-08-25 at 19:55 +0200, Martin Steigerwald wrote:
> That said I also do not have any issues with BTRFS on a ThinkPad T23
> for /=20
> and /home. But then the machine has an hibernate-to-disk-and-resume
> uptime=20
> of almost 120 days, so it didn=C2=B4t see a power loss for a long time.
> Thats=20
> still with 2.6.38.4.
>=20

Which method of hibernation are you using?

I got enormous problems with btrfs+toi including:

 - Freezes resulting in umountable partition (twice so far, 2 results in
google including one message I sent to list)
 - Sometimes a random program (Skype, Firefox) cannot be frozen and
stacktracke includes btrfs AIO.

regards

--=-g/TdbyLooeSSDTLBfS/d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOVsnQAAoJEJIdee2Vr4aPnDIP/3cm+icd6xI3kUXgosVzC7oq
zu90AQUTG5uxtWZWVRhj/MQQL5kfbAEVALi/8RlaOzFr7KAlS8GGDMkUNpFLi5sV
bboUqnjROLS0rUu4LtlGb1V6VtZoHhppWGjjDsoe5cPD05AlEqChQhdnpUWbRuqn
xNWDO2GG9SRZ5Exg8ggpuk4iAUuwnEtAFktcSns5Y6q444qJFENsx7Cj7ibDTN6u
VFcUXQt/w1R3YC0ZQSz6Iwhu0G3OShx0F/Iz8DprvFyQe6N5vQh6uZahPj3BAayC
Ed0eRJKj+Og5chHnABrC1o75O+DbSbdJzn+7IJRssHg8pYNbrLtae0V0/RLjEZzl
yHwGEIVM1EWSHksY99ze/luRF4bmJxNYTKobnfPMvks28nT7P5QhF5lUpVJ8IuUk
RIEBvR2I3vIGyxkJTk3ETQJxlZZ04hlhlaqfRuazD9qoI29gvZ/3tZ+R+AJ8I2PH
wH8dOHivqdctky3lRYmSiKFIIjL7BGx6HypIyFFPcfT5AxkuFDf4DYs1Q17xmCSX
lvOtfImM7QnydxCKwcYnnocBX3iXCuMKxWs1Z+6lZ8nbkawXJ2MD9NyPJzHLVPfo
7PuHlix3NIw2B+pplxdumwTVZADGFAa2trkxpZq8z1lbvDCPolV4LOfVabHCi1xx
EbHfWv5KfiL9L4KmbAAr
=dNL4
-----END PGP SIGNATURE-----

--=-g/TdbyLooeSSDTLBfS/d--


