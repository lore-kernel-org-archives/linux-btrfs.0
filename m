From: Niklas Schnelle <niklas@komani.de>
Subject: Re: [PATCH v3] Re: btrfs does not work on usermode linux
Date: Mon, 11 Apr 2011 21:49:39 +0200
Message-ID: <1302551379.4074.1.camel@pluto>
References: <20110410133710.0ef34cb6@sf> <20110410184249.483d8d67@sf>
	 <20110410230622.09e965ae@sf> <20110410232403.617c3b7f@sf>
	 <20110410235846.135e801e@sf> <4DA32055.2030104@redhat.com>
	 <20110411224452.4a5149da@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256"; protocol="application/pgp-signature"; boundary="=-x+uak63eQ7cYQVUTLsVB"
Cc: Josef Bacik <josef@redhat.com>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, cwillu <cwillu@cwillu.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110411224452.4a5149da@sf>
List-ID: <linux-btrfs.vger.kernel.org>


--=-x+uak63eQ7cYQVUTLsVB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I think the problem here is that memcpy beahviour changed in recent
glibc in this regard see here http://lwn.net/Articles/414467/=20

On Mon, 2011-04-11 at 22:44 +0300, Sergei Trofimovich wrote:
> > Fix data corruption caused by memcpy() usage on overlapping data.
> > I've observed it first when found out usermode linux crash on btrfs. =
=20
>=20
> Changes since v2:
> - Code style cleanup
> - 2 versions of patch: BUG_ON and WARN_ON variants,
>   _but_ see below why I prefer BUG_ON
>=20
> Changes since v1:
>=20
> >  	else
> >  		src_kaddr =3D dst_kaddr;
> > =20
> > +	BUG_ON(abs(src_off - dst_off) < len);
> >  	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len); =20
>=20
> Too eager BUG_ON. Now used only for src_page =3D=3D dst_page.
>=20
> > -	if (dst_offset < src_offset) {
> > +	if (abs(dst_offset - src_offset) >=3D len) { =20
>=20
> abs() is not a good thing to use un unsigned values. aded helper overlapp=
ing_areas.
>=20
> On Mon, 11 Apr 2011 11:37:57 -0400
> Josef Bacik <josef@redhat.com> wrote:
>=20
> > +	{
> > you will want to turn that into
> >=20
> > if (dst_page !=3D src_page) {
>=20
> done
>=20
> > Also maybe BUG_ON() is a little strong, since the kernel will do this=
=20
> > right, it just screws up UML.  So maybe just do a WARN_ON() so we notic=
e=20
> > it.  Thanks,
>=20
> I'm afaid I didn't understand this part. The commit I've found a deviatio=
n
> was linux's implementation of memcpy (UML uses it as kernel does). Why th=
e
> kernel differs to UML in that respect? Seems I don't know/understand some=
thing
> fundamental here.
> So, if data overlaps - it's a moment before data corruption, thus BUG_ON.
>=20
> Another thought is (if memcpy semantics differ from standard C's function=
):
> does linux's memcpy guarantee copying direction behaviour?
> If it does, then it's really a weird memmove and x86/memcpy_64.S is a bit=
 broken.
>=20
> Attached both patches, I personally like BUG_ON variant.
> Pick the one you like more :]
>=20
> Thanks for the feedback!
>=20


--=-x+uak63eQ7cYQVUTLsVB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJNo1tNAAoJEBlEkMMdTRx5ZuAP/RyktjlJlIgzuoXelZAGpVTe
Kzobfo94jBiDD3EKa1xLsKg2XiEmIk6qFBXdrgW2y2l+Pto/QPl7ycjqFrCz+flL
FG//vja+/Kao4854zwP98ZWtZE1kEoZuR8I50BP6kxxz/r6/lOYgW9P4w3HzC8LW
ecPPlZi5A/8rfwrwk/gtw4tqsn/rmQA34Rg2I79BMmEZTcht/EpxbDCDOC9q2aC/
qvmn0a1fKa7lg3JtVSfS+u08TYaACzkGpT75NcO+iLmoFiqEFmpmK5bnf1bCtLvv
YFhTbwGOMJUFT4Hhz+t6UjWzLoNWX3V6m9VR9PWEHIQuq0j6hRwUqiQhOeoXB8YZ
Ge7apAQrYq7QJ5H58iO4JChh4UnHYE+4j+L7E0rMcfNUQasiIfj1bETJ1d++yIMO
/wiIsrfq/JqBEVAGdqp+5jgku9ZfS26dq0dn59i+VjBBQV7KgZvSSXPX+UlmIotI
rHr8gbpuRn5/45h6kuriL10wTNStbnIUlLug1evsTixBRD2cSmhJkFeF5oknG0Tr
rqOLSAfIzeoPwt54tjDNWg46K1mDQdpZvCaO3pA0DcDFNyZKiKa5Io8TpPQ3JBL6
duDBIaj+qN/18mWt81S8xzkM4wVPMS8RYnQxJo15sgOv9sDa1uq2L0pzTbo+otVR
gYhj3iW0Ni0GiC+FoF3y
=GL+6
-----END PGP SIGNATURE-----

--=-x+uak63eQ7cYQVUTLsVB--

