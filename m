Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:60919 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab2LQR7R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 12:59:17 -0500
Message-ID: <50CF5C97.9030805@inwind.it>
Date: Mon, 17 Dec 2012 18:55:35 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Alexander Block <ablock84@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH][TRIVIAL] Unvalid access check
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dear All,

I found an incorrect check in the file fs/btrfs/send.c . It was wrote
	sizeof(*arg->clone_sources * arg->clone_sources_count)
instead of
	sizeof(*arg->clone_sources) * arg->clone_sources_count

Unfortunately arg->clone_sources is a u64 pointer, so
"*arg->clone_sources * arg->clone_sources_count" is a legally product
between two u64 integer, and the compiler cannot generate any
warning/error.

Please apply


BR
G.Baroncelli

- --- old/fs/btrfs/send.c	2012-12-11 19:03:46.000000000 +0100
+++ new/fs/btrfs/send.c	2012-12-17 18:42:14.997707719 +0100
@@ -4553,8 +4553,8 @@
 	}

 	if (!access_ok(VERIFY_READ, arg->clone_sources,
- -			sizeof(*arg->clone_sources *
- -			arg->clone_sources_count))) {
+			sizeof(*arg->clone_sources) *
+			arg->clone_sources_count)) {
 		ret = -EFAULT;
 		goto out;
 	}

- -- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQz1yXAAoJEA7amzeLguC1UH8QAJozuS6LTzk94CSr0qqM70xa
QC9UgY3MjalIlFPBHqRKTcbId2uvtM0yqwk2YCHRAnKrMUAMvP1KmUlk5Fjg3ahC
odPbfX1eF3zf9ySEOky7ZmzjJEpyxsCikvf2CNaUiQSibjLn6bNYmhjjXKrIqmOR
KZAFGrEOzeK87YUREcqqaAz+oVZHCZuxHrA0OpWJ3L0ub9kC35o2zdEYJejwDUPk
zGwWmMhMr9ANvUMC/E8wNzusoZRnCya/dEt6KrN1Xzolj82orhQRHWy3TTUEtwu9
1zZjq89vVhUKNh4/CG7u0N5zl61ZhzGiXATpIEC2M/PznMf0YXmITi2Dy62fTwnT
ZvLjUmUnujmSGBMi1/zEoyYFXPmFgHfa82s0zVQCKC6V2JZcapwSbDSJaLYKjhjs
rjd6SFsjjEWkE779bFW1WHu0CV3BvXJI7yXN6PweR9rumhvU1pZ4UwonQ3Wv1tPp
d50N9jeFq2+N282yP12bdGzD7DLC7YPFRFxy8sHSbOsiM3vFIdOK0rX5BQeboIbE
NPBHPqUsxw/MsvXQdUqgW7TuFIU0Q30Mx0+jLyyhmGSvCUq9NA9ye0YmRCmqdGGY
R5X4KdL7HJxlm9tX2FxLPf6yh3hD/FyX1CQtrfahbvS0h2em5BLPQ7WrGN2iCpAd
cEcSAGaARv6qKnw+YneW
=kdsU
-----END PGP SIGNATURE-----
