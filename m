Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.mailbox.org ([80.241.60.215]:33319 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1039967AbdDUNrc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 09:47:32 -0400
Date: Fri, 21 Apr 2017 15:39:57 +0200
From: Christian Brauner <christian.brauner@canonical.com>
To: linux-btrfs@vger.kernel.org
Cc: Christian Brauner <christian.brauner@ubuntu.com>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>
Subject: Prevent escaping btrfs quota
Message-ID: <20170421133957.7kax2ktwhh43nnq2@mailbox.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="56w3m6pnehfpexqt"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--56w3m6pnehfpexqt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi guys,

If a qgroup is created for a btrfs subvolume /some/path and limits are set and
a new btrfs subvolume /some/path/bla is created it does not inherit the parent
subvolume's /some/path qgroup and limits. The only way to achieve something
similar is to create a common "parent" qgroup and assign both, the parent btrfs
subvolume /some/path and the child subvolume /some/path/bla to this qgroup.
This seems unintuitive and actually proves to be a problem. For example, when
creating a container that uses a btrfs subvolume as storage backend and then
allowing users to create additional subvolumes in another container they can
easily escape the qgroup and its limits and even with the common qgroup nothing
seems to prevent them from simply removing themselves from this qgroup. What is
the proper way to deal with this case such that:
a) the subvolume automatically gets the same qgroup as the parent
b) cannot escape the qgroup

where b) is the more pressing concern.

Thanks!
Christian

--56w3m6pnehfpexqt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJY+gutAAoJEI6wVtU+7LEtasUQAIxeh/eJbhHII40LXFIL5QK7
t29Cg9mxX/qQjzvieZt3zm9TTMht2Ra4n4a1uM2mwL5owso014bI2AACmEVcz7ih
O1+Y2NR/aTnZWJ3O8Un4lMJvk023bmeSbHLIEVu48KixsC91d+TWv52dNuoIwbq3
OWc3sP7n7XkdAOlfQplHAGNEkaM657i03l5s1RWIlQUBTXMYvaECa8gJtczEa3g7
5nka5RqMtcZGuIstRKwU9OkCT2R/rrTfBATng2zGwaAtxsNkLLVAnWQTmzef93q6
GQRYecTvmpjzqKMzy4JfmORA/HHt05DDIJN1fNjGWv4QwC8O5+Rby0lK/L3DG7Y9
GIfCC5CSjgjIRdItf76wso5gFKVaicDeNNdiA0k7NRyiN2gm+58ko6TQvCvOaM1q
rEzPwoBtR5R56lo2xaKMhMtoaCcLgcubcOSpxq8qfLsMCVzF/dv8grplCgpEKJmA
Jh/YuticrWM8MB90XdT0cuptC3D9JW6XsYYztHVl9U21NnB9A+hS61OQAHihxq8W
LsTLR2aNWnJSQg7eHjaUvbNIQWQ8pyJ8gp5ikDB/8R0K6txbvKXPSXD+/XwyP+t+
I0GnKMrT70xELVzVrL/FUAeiYR3Rqccbkce0dnKiLgkKm/wspXRZ3/cn8pTqdhZ9
+NKNVBMKg3wW5VZUMwlT
=trNy
-----END PGP SIGNATURE-----

--56w3m6pnehfpexqt--
