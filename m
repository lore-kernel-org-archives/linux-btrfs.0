From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] Btrfs: silence a compiler warning
Date: Wed, 22 Feb 2012 22:41:57 +0300
Message-ID: <20120222194157.GA4045@mwanda>
References: <20120222073055.GB7389@elgon.mountain>
 <20120222162926.GA25392@davidb.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: David Brown <davidb@davidb.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120222162926.GA25392@davidb.org>
List-ID: <linux-btrfs.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Gcc warns that "ret" can be used uninitialized.  It can't actually be
used uninitialized because btrfs_num_copies() always returns 1 or more.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: use the uninitialized_var() macro instead of initializing to 0.

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 064b29b..3bb3853 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -643,7 +643,7 @@ static struct btrfsic_dev_state *btrfsic_dev_state_hashtable_lookup(
 static int btrfsic_process_superblock(struct btrfsic_state *state,
 				      struct btrfs_fs_devices *fs_devices)
 {
-	int ret;
+	int uninitialized_var(ret);
 	struct btrfs_super_block *selected_super;
 	struct list_head *dev_head = &fs_devices->devices;
 	struct btrfs_device *device;

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRUUFAAoJEOnZkXI/YHqR9EIP/02ATU3/+sF52aqOp5MVbP3N
kmLB18IKs+9xNeimBtF4bXe1mZnPO0xgUOdP9skiLt+j2yS5mryirrZAOfEPzoKo
VDcaDD8IgNYFqebZn7werluAZQkwxXN2AuER2zpmbGrcHWlPuCUg24EIqTMyiGg9
YxtZEfCaH9hpgDan8tnOfc/xgNW0NX6F4M5EYLG4/bb0Qvym3lhObq2g4ItgmVM1
KVz6AXusFshWSY4gf6/v+KJAWJafIib1lyN+RHCRmfvMEXctuCCQdZBlyoYfVKaF
mKSULBHe98g4EAFt8Q4NlYJ0zB/7Iej5Jb5CQMdMX2LWYi/Hey1JHehmjHUiTjNs
wZsXb+d1gxRGt+54v29Gb9BZpWmPsGeNpnxpEt50JQZyNRgP3cekHdqkD4Oo5UzF
EzXyX61ETQEZTPKsSsQg32Zej9dHotAoQBvy9oObMklQ8qj90UYRcRzn5UG5U+Gu
5FvQsigh7BnbgBikhLgnMbWa82dUj64a84X+XDu4y1OsZ7lj2ZhZasBxkLhPjtf/
X76mDT42KhrfYa5c394btrJAXsRvtEKwIicd2/lCfnB0YtwjsxShOzVTUvEFqx7l
/0s34L7MSrX+mG5lwHkN1TgsFbjdbMUqNIOGmbR0rPAiMX3dCzK/4qwuqzT0oOmV
pu0NblHZnu2GWa+NCwD3
=hOjl
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
