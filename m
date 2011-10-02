From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: Regression in btrfs-next: BUG at fs/btrfs/super.c:984!
Date: Sun, 02 Oct 2011 23:15:33 +0200
Message-ID: <1317590133.3354.1.camel@picard>
References: <1317505390.2071.4.camel@picard>
	 <20111002173910.GL22205@twin.jikos.cz>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-M00M3fImEm4Y/ZVMrg52"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111002173910.GL22205@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--=-M00M3fImEm4Y/ZVMrg52
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-10-02 at 19:39 +0200, David Sterba wrote:
> On Sat, Oct 01, 2011 at 11:43:10PM +0200, Maciej Marcin Piechotka wrote:
> > PS. It might happened that it was caused by parition mounted read-only
> > on read-only block device.
>   ^^^
>=20
> This is the key information!
>=20
> super.c: btrfs_calc_avail_data_space()
>  983         nr_devices =3D fs_info->fs_devices->rw_devices;
>  984         BUG_ON(!nr_devices);
>=20
>=20
> If there are no writable devices, this BUGON fires, although this case
> in connection with RO mount is handled elsewhere properly.
>=20
> This is called through sysfs and just tries to obtain available free
> space information to print it. I think the BUG_ON is not necessary here
> and the function can take a short track returning 0 as available free
> space:
>=20
> if (!nr_devices) {
> 	*free_bytes =3D 0;
> 	return 0;
> }
>=20
> I could be possible to actually read the free space even from a RO
> device (be it RO mount or not), but I don't see much benefit which would
> justify the work.
>=20
> Can you please test the fix and let us know if the statfs number look
> reasonable?
>=20
>=20
> david

Well - it shows size 50G, used 29G and avail 0G in df -h.

Regards

--=-M00M3fImEm4Y/ZVMrg52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOiNR8AAoJEJIdee2Vr4aP/N4P/1ndgWF3eshDhkd0m34NUzfT
+iycMbSbAUs8z3I/UaG02H3QvGT22fR22gI4RmUSS2+1wumqSLfampa8Nd9kI5dI
WXdqd7W5o1CHkv6ZVFO/Iz7+6MRQd9x2jMHyMM9CGH4jkCvefpKRuJKg7BrJSoNR
O62H0UzYEb4jqe+BCIDdsU2sQtEbQQfc7IXOS/kIqgDE7O3AfaLjqcfc3n7RLDdG
h+AD8e9yz8tkTxcWSVEWJ0tHOzE0OSv+1e3IKUsuvTuDEUUJH+QKxqH+ZMfQrh7z
rdUmK94zWXhWXc/1M0GEvuqw1jcc6ZQd1+I4tX3V8ygtaJ84G4Vd4wipUeOP2Tvo
3SSPl9B4FB0qc4SjKtyUt3AKSObBKqYVGMJASCK5o8RLFUv91SuTuNbOXTo3TaCQ
iftI5LnQj8qOkqzozDP6qHaGPaHT0Q/da0bnZH6sI22W2jLO2aIp4zPq5mbJ2F9o
cUbNsu9fI/BLwihJVDxBsj3a+AgBfvolbJoaqFL/VPX0G2GJfwOHKJkd19//soz5
LmJ5U3Ne5FNtkOafiCWBUjKabAD2wobL3j/mshs61vd4D8Vh6xhOv2oDW6y4nYy1
RTiHT/UXqUCIc8y6qAioszGhNCnRN9bP+JoS7Pfdd28Clu4z5mpKSxFBPrwckWPx
R1/XZTK9dlcjJENNesAC
=vCbp
-----END PGP SIGNATURE-----

--=-M00M3fImEm4Y/ZVMrg52--


