From: Niklas Schnelle <niklas@komani.de>
Subject: Re: cant mount degraded (it worked in kernel 2.6.38.8)
Date: Tue, 16 Aug 2011 09:47:28 +0200
Message-ID: <1313480854.2029.2.camel@pluto>
References: <CAJ1PRSnLKGkmbx3EY=DdSvont_3hUTmSzmmXpL4gi4Aw0KY4pQ@mail.gmail.com>
	 <4E49E330.6060402@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-h5UPFOoCrbNVNG635KD6"
Cc: "krzf83@gmail.com" <krzf83@gmail.com>, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E49E330.6060402@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


--=-h5UPFOoCrbNVNG635KD6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-08-16 at 11:25 +0800, Li Zefan wrote:
> krzf83@gmail.com wrote:
> > # uname -a
> > Linux dhcppc1 3.0.1-xxxx-std-ipv6-64 #1 SMP Sun Aug 14 17:06:21 CEST
> > 2011 x86_64 x86_64 x86_64 GNU/Linux
> >=20
> > mkdir test5
> > cd test5
> > dd if=3D/dev/null of=3Dimg5 bs=3D1 seek=3D2G
> > dd if=3D/dev/null of=3Dimg6 bs=3D1 seek=3D2G
> > losetup /dev/loop2 img5
> > losetup /dev/loop3 img6
> > mkfs.btrfs -d raid1 -m raid1 /dev/loop2 /dev/loop3
> > btrfs device scan
> > btrfs filesystem show
> >=20
> > Label: none  uuid: d7ba6c4e-04ed-49f5-88cd-8432c948e822
> >         Total devices 2 FS bytes used 28.00KB
> >         devid    1 size 2.00GB used 437.50MB path /dev/loop4
> >         devid    2 size 2.00GB used 417.50MB path /dev/loop5
> >=20
> > mkdir dir
> > mount -t btrfs /dev/loop2 dir
> > umount dir
> > losetup -d /dev/loop3
> > mount -t btrfs -o degraded /dev/loop2 dir
> >=20
> > mount: wrong fs type, bad option, bad superblock on /dev/loop2,
> >        missing codepage or other error
> >        In some cases useful info is found in syslog - try
> >        dmesg | tail  or so
>=20
> It works on latest kernel (3.1.0-rc2)
>=20
> --
> Li Zefan

Shouldn't we really really have some test case for this in the test
suite? I mean it's kinda uaccepabtle even for an experimental system to
brake this way in a release, also will there be backports?=20
That would be helpful especially since some of the big distros will be
stuck with 3.0 for months to come and this will (rightfully so) make
btrfs look really bad!

Greetings Nik

--=-h5UPFOoCrbNVNG635KD6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJOSiCQAAoJEBlEkMMdTRx5+wsP/0N68Sk5dzKuz5borfpzuRxU
CMtR7Iv63zCCHzW05+7AMBeeqPVseE7pEW8gix5Crl+NjU9Ud5jbpONk3HOJMA6V
o5JgY9uTvo9cwsu0h8xJaQvZJ4rQi0EUi8aWJALEIE9z2FB4Az+YjN1ECdEzYMfj
5Fq44N/9sWunonhjPp8bv1gJByqbQJ9tkdfGs7CVpZKkLRbRV3jM/dogvvmqTG6v
NQ0NRUGgnyoE2rQNjxX2vyp+8yRY3ORBwsRF7TgjSqruyVqVAEjaiZTjkm8y/1P2
ph4+Bk+cuXT9GEfIR88zGD7COt0crypyNGpOGyHd/e3Z8bOzmb9OdzM9RyzNjcWb
n5o62/FdiUUAyyjqGNafS6PwIzee8ZGpd/jJyrr4jB5AJ2XIOSJv8+YYcFi/hmeP
mkvPI9j2XsqAJBcJf4YxBgtBUWXHyI4G1B8yK9gaQl5gntjvRrAmxuNABBb0AUAu
RYPy6mC1LIC4VYpB4DwMUfASgLwLrufE3hDa2dBe5mX0iI6dZLeAv+dnI6q9WpAV
q8JRN3CYBIpfjMXoncpP1LsTcAPePqGF6+NPbs1GossLmXuTV94jA5NBECeB7mML
NL7EsC/yS4LV9NZXAjl+8NqBEFBNnfzezcrXCx/f5G2Xf4hnMl/ikFzEC7bqaFSJ
cEIAwDzp3f3QQR9I4wv2
=Bqbd
-----END PGP SIGNATURE-----

--=-h5UPFOoCrbNVNG635KD6--

