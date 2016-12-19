Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47682 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751180AbcLSUJv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 15:09:51 -0500
To: Chris Mason <clm@fb.com>, David Sterba <DSterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: Btrfs: don't WARN() in btrfs_transaction_abort() for IO errors
Message-ID: <2b857413-77b2-56c3-4748-786ae2c3ea14@suse.com>
Date: Mon, 19 Dec 2016 15:09:46 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TN5Cgp5lr3iwjanJWmkOj4t1sbf8vpD27"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TN5Cgp5lr3iwjanJWmkOj4t1sbf8vpD27
Content-Type: multipart/mixed; boundary="spiGmoswqAQmkxqmQNLGwulDgHeTuO2Cc";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Mason <clm@fb.com>, David Sterba <DSterba@suse.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <2b857413-77b2-56c3-4748-786ae2c3ea14@suse.com>
Subject: Re: Btrfs: don't WARN() in btrfs_transaction_abort() for IO errors

--spiGmoswqAQmkxqmQNLGwulDgHeTuO2Cc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

commit e5d6b12fe14e89ea1c494585c47b1dfb31d71183
Author: Chris Mason <clm@fb.com>
Date:   Fri Dec 9 05:56:33 2016 -0800

    Btrfs: don't WARN() in btrfs_transaction_abort() for IO errors

    btrfs_transaction_abort() has a WARN() to help us nail down whatever
    problem lead to the abort.  But most of the time, we're aborting for =
EIO,
    and the warning just adds noise.

    Signed-off-by: Chris Mason <clm@fb.com>

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fc1864a..50bcfb8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3445,9 +3445,14 @@ do {                                              =
               \
        /* Report first abort since mount */                    \
        if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,     \
                        &((trans)->fs_info->fs_state))) {       \
-               WARN(1, KERN_DEBUG                              \
-               "BTRFS: Transaction aborted (error %d)\n",      \
-               (errno));                                       \
+               if ((errno) !=3D -EIO) {                          \
+                       WARN(1, KERN_DEBUG                              \=

+                       "BTRFS: Transaction aborted (error %d)\n",      \=

+                       (errno));                                       \=

+               } else {                                                \=

+                       pr_debug("BTRFS: Transaction aborted (error %d)\n=
", \
+                                 (errno));                     \
+               }                                               \
        }                                                       \
        __btrfs_abort_transaction((trans), __func__,            \
                                  __LINE__, (errno));           \


Can we use btrfs_debug here instead?  There are a few naked pr_* calls le=
ft
but most of them are either continuing prior lines or don't have an fsinf=
o available.

Thanks,

-Jeff
--=20
Jeff Mahoney
SUSE Labs


--spiGmoswqAQmkxqmQNLGwulDgHeTuO2Cc--

--TN5Cgp5lr3iwjanJWmkOj4t1sbf8vpD27
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYWD6LAAoJEB57S2MheeWy5/kP/2uUDvJUAO3XEKx35AzBvyGI
IcuKmVnGPDUe9Mzn+B/8LELzCKq8o2aqkRtLyJfmsdlmMsOh+irK2M3/DtdI3vYr
9MG5PDF4KacegAzRG3GoJcC6k756GuOKec3SpOp77uZjdxsKvQJE0V696ToSAjO8
7dvXuH33sUmgcms3ClVHz/E7zJJbhG6xGAdKLOfHFwj8bSDI+QtpizCucJUXaXpt
Jxpo/21Lo4VC0Gyi2VuGyzD4+ppHSnt8kip05InTTLPV4geFEilFbQFP6fQJejFZ
HJywJFibjlFyET5xYuIljpnNtpQiIZdEXh88H3Wdiz0XBdK785RGF5knjrJ0SFRR
8gqrnsohydBitQkYoGfYb4DOK0RqSDWzn0OwXegbNkMb8rRy8IWqGEq6IV4e/YM9
3j65vUITKKLtmiA/GN0c6u5G3/P2DFyQ0H0Tte2vLRndWFVWPLXQGbULOMvlLugQ
lbkhsP+RJyXN8Js9r73iSmAOwMhDAPdr5tuCdotlnM+/VDEyKCEVzyEscJ7jjKp6
zU5+HXbvXKNBuV2Urd4CH7KSsRgvbx/7grNzXyVndl/FrkkcxfQMf/SyHipPaopj
1Pef57HaHXJskM4tbnMH/S5m+EGlbOnQph8xhNJImGUKg+/99hUQEwV6qkuY5zMm
OFC61mZ0P1mjmw8Zlsor
=KnhU
-----END PGP SIGNATURE-----

--TN5Cgp5lr3iwjanJWmkOj4t1sbf8vpD27--
