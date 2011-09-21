From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2299
Date: Wed, 21 Sep 2011 04:14:53 +0200
Message-ID: <1316571299.2459.1.camel@picard>
References: <1314582311.2724.4.camel@picard>
	 <4E5C82E8.9090400@cn.fujitsu.com> <1316393087.5713.1.camel@picard>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-ehb/WtbLrH8YOBCMBEa8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316393087.5713.1.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>


--=-ehb/WtbLrH8YOBCMBEa8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-09-19 at 02:44 +0200, Maciej Marcin Piechotka wrote:
> On Tue, 2011-08-30 at 14:27 +0800, Miao Xie wrote:
> > >=20
> > > Unfortunately it results in freeze of system and I cannot give more
> > > details. Sometimes it happens not from fcron but then it does not res=
ult
> > > in freeze (???).
> >=20
> > Could you give me the method to reproduce it?
> >=20
> > Thanks
> > Miao
>=20
> Sorry for spamming in this thread but I'm trying to post my findings in
> hope that somebody will understand what's going on.
>=20
> Recent crash gave some valuable information IMHO:
>=20
>  1. I started the autocompletion of path in zsh
>  2. At some point the zsh hanged. In ps the process was listed as
> runnable
>  3. Any access to root volume (the one that zsh was trying to readdir)
> finished in hang.
>  4. I was able to access the child volume (/home)
>  5. After some time the bug is hit. At this time strange things happens
> (screen freeze etc.). I guess that there is some strange interaction
> between KMS, X and now-hanged composite manager
>=20
> Next time it happend (also during listing root directory of volume 0) I
> observed the following thing - I can log out and unmount home but the
> volume 0 remains busy and cannot be unmounted.
>=20
> Things to consider:
>=20
>  - It is not enabled/disabled by any mount option
>  - Is it triggered when the parent volume (say volume 0) and child
> volume are both mounted?

I cannot reproduce it when the parent volume is not mounted (snapshots
are to subvolume)

>  - Which case is it failing (I've tried to add printk but I cannot find
> the option in printk to print u64)
>  - Why it happens only during night?
>=20
> Regards

Regards

--=-ehb/WtbLrH8YOBCMBEa8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOeUijAAoJEJIdee2Vr4aP/a4QAK5KTCWHTALLf7WgEl5cu+vv
YHWoIwIL2fbSQcnpqCEbzBC2vc8DtGlPq3jlWYgqNz9Lklhl0ijGBlXYptlnT2JO
R5BdLaqgIQR9I4F0zmUj5SmvIFdtvmu/Jpg7dkLV2/u3wi5LHqLg35p8dmDqi9xe
Da6mQyj/LjhHysQcA5kMJIMJBDbg6q2J1opYFnCklzZdxFVI0JYw7cxIXvD8XN/d
m8+yX70Cfefbrcx2gbCkUz3SPb4x0+/G+QLzS/Ft+3bm/KIctTpRYayAnCATzR14
9IDgC93S9QY9ebmelqXi927psGoXaY0V9ssGXZ4LUHrVmgpObP2bsaj0SSQntQah
0YIFUq0aho3G2po8hs5BONSozaXnrxlZuYrR79y5hPfZkpIQVTRgXu286opCGbmC
GJ8mqu110oDxmMcxuwWQBTNpONYy9th4eabXga+u3rzOZImGFGlpSoXFB/4I1Gba
xodprC2pVmDa98hjzgsXN6Rrr65fz7rUrD9cyx97QtOYrAUTMXqSchLMxjQOuEbr
2a76Ilh000rt1nTLqp2sCvOnrKmaimbxeKjLrh+GssNZGXFij3R5BmRG6kKhrsJK
EDz0d47j5m8z6jfb/C/Sg1y7ITpDuG3WPWIWXUiQUepA+j5luvIb1AxtPnqzZbym
fhjaIuj/MxinX2+tnXOM
=V4oH
-----END PGP SIGNATURE-----

--=-ehb/WtbLrH8YOBCMBEa8--


