Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from untroubled.org ([69.5.1.51]:43840 "HELO untroubled.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S1759875AbdAEByC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jan 2017 20:54:02 -0500
Date: Wed, 4 Jan 2017 19:46:56 -0600
From: Bruce Guenter <bruce@untroubled.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs subvolume delete --commit-after doesn't wait for deletions
Message-ID: <20170105014656.GA19542@untroubled.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


In the man page for btrfs subvolume delete, the --commit-after option
says it will "wait for transaction commit at the end of the operation".
However, the available disk space continues to increase for several
minutes after this command completes.  I am running linux kernel 4.4.35
on Gentoo Linux with btrfs-progs-4.9.

Am I misunderstanding how the --commit-after option is supposed to work?
If so, is there any other good way to wait for btrfs subvolume delete to
complete freeing space before continuing? Has this behavior changed in
recent kernels (I tried 4.8.15 before posting this, but it had unrelated
issues)?

Thanks.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYbaWQAAoJEFFRvcnBTTxnPBsP/i7Dtn2+3UmbJEQH3TlFrXGH
mkUJ7OP6lre4Tfc47XrQY73dT6GSK7RCNI3GyckdJqV3bvyoUf3FmEUb+pTo5QcW
oA9oJANBIRHk3xaiElJDbyUqWfqCXeH24LdFwOOcAXMR2MsoE2IHncXZRcL1uy0b
vZ0bgIBzQF08glRuZESGvMp2QZRaK4Q/F1TB8JgY5ph381qJ3FznBgbXIl71WDxk
bvK2pQ6hN9lkZHmLd6Hc6l24nmxsaO1AiXBLivfgCZ0FzNfe7SpjJgrXvKZHD4Hs
HAk5HUU341+2OaIu4CCi4M5k/ckRMNvXrLeHvzinWi4IDA9uwZNLh2IMGYilY8yS
Yf+/tJNEYzCgL6eY7vbimkPS5MdguTz06nJfQOkNXPkKAZ7nRyRGdjWL8MExj3Sf
gd7BM9K+Y3uCD+8OHH5LnXOzKT3wF6kJLc5EwndK8cLQQcrm5xJUd0yGjGD7b8iH
yqFatHCJMpPphdftBM/ZymjBkyiopI3Xb0owVCD5+5H9F3B/UxFEIpmqyLwAEmz6
BMMDgb3PLF9NwV20S/zPJH6UgMSgQAtcjVVBuO4TEJvPBlTFcIPdcjiRMu4sdCJ8
kRYGqLnf2jTSlLTJ1M4w/1oMRTJn81W+ymY3SS2klccoGbmaCwYYYWbwfLjDkbcL
v/xD44OHjNWZebpUr8QP
=WATH
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
