From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: Magic numbers in a couple of btrfs source files
Date: Mon, 30 Jan 2012 12:39:16 +0000
Message-ID: <B83EEE8B-082C-43E4-812A-1F102E57CA2F@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-4--419877544"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-4--419877544
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=iso-8859-1

Hi folks,


I've been reading through the delayed references code, and have stumbled
across a couple of numeric values about which I have no idea whatsoever.

I was hoping someone could enlighten me on what they are for, and why
they are used in spite of any other particular value.

For instance, in delayed-ref.c one can read

int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
			   struct list_head *cluster, u64 start)
{
[...]
again:
	while (node && count < 32) {
		ref =3D rb_entry(node, struct btrfs_delayed_ref_node, =
rb_node);
[...]
}

and in transaction.c one can read
static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
			  struct btrfs_root *root, int throttle, int =
lock)
{
[...]

	while (count < 4) {
		unsigned long cur =3D trans->delayed_ref_updates;
		trans->delayed_ref_updates =3D 0;
		if (cur &&
		    trans->transaction->delayed_refs.num_heads_ready > =
64) {
			trans->delayed_ref_updates =3D 0;
[...]
}

I've been wondering about what the 32 and the 64 mean. These values seem
far too round to be random, and I'm sure there is a purpose behind them, =
but if
it is obvious I'm certainly missing the point.

The 'count < 4' also throws me off, but I'm assuming it is someway to =
guarantee
everything gets flushed.

Any help would be appreciated.


Cheers,
Joao

---
Jo=E3o Eduardo Lu=EDs
gpg key: 477C26E5 from pool.keyserver.eu=20






--Apple-Mail-4--419877544
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.16 (Darwin)

iQEcBAEBAgAGBQJPJo95AAoJEJ9vvxhHfCblmxwH+wRfej6UW4ExTrVdzVJORNrt
/EaMt1pImv3jMef9dtPtjY2MPwk5h2s6lt/8YlHpmcHGj5UgEPw+HF02jPg4Iuyi
p7C3wPom6iIM66H1a+rbfzchUd9uWiMeH1sygN5i+lTDUIjEeLs5X5YUZCqdMvF+
S7d8quyisYxWoKkkb675QMDKdEkcRidBA8LVmt1PM3tvuzfFwEQVAvxfr3a3h9s4
kZ4fpZvl2IEseGdbTMPPxNFF7LI/UjIe6Q3qRUjzl8LBmUebA5DIJVD0yytQbbHd
iAHGDMmrQDiAIHVQygvcJSZElS7f8AMHH6yVtYCLLb0gjBumrqFf790p2J3qhyQ=
=trhq
-----END PGP SIGNATURE-----

--Apple-Mail-4--419877544--
