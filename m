Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.miceliux.com ([81.4.104.92]:54094 "EHLO mx2.miceliux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964935AbaD2T12 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 15:27:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx2.miceliux.com (Postfix) with ESMTP id 29651895BB
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 21:21:55 +0200 (CEST)
Received: from mx2.miceliux.com ([127.0.0.1])
	by localhost (mx2.miceliux.com [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id Qi-26g9RU7f3 for <linux-btrfs@vger.kernel.org>;
	Tue, 29 Apr 2014 21:21:53 +0200 (CEST)
Received: from xenon.miceliux.com (83.138.225.18.dyn.user.ono.com [83.138.225.18])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: juan.orti@miceliux.com)
	by mx2.miceliux.com (Postfix) with ESMTPSA id 7D2FE895B5
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 21:21:53 +0200 (CEST)
From: Juan Orti Alcaine <juan.orti@miceliux.com>
To: linux-btrfs@vger.kernel.org
Subject: File capabilities are lost when sending/receiving a btrfs subvolume
Date: Tue, 29 Apr 2014 21:21:45 +0200
Message-ID: <2199169.56ItP7JcO9@xenon.miceliux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2598426.UPXiesILaJ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2598426.UPXiesILaJ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hello, I noticed that file capabilites are lost on received subvolumes,=
 so I=20
opened the bug report #68891 [1]. I don't know if other xattrs are affe=
cted by=20
this problem.

I just like to know if fixing this issue is under the radar of the deve=
lopers.

Thank you.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D68891

=2D-=20
Juan Orti
GPG Key: DEEBD08B - http://jorti.fedorapeople.org/pubkey.asc
Blog: https://apuntesderoot.wordpress.com/
--nextPart2598426.UPXiesILaJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCgAGBQJTX/vQAAoJELYwS3Le69CLbrgP/1gDBSRa3MuG6J6OvnuYHe4a
+4Wc/q5x/5kamaSLhvX8PFJDriw8MoqFCKL9tpXDdwuNQyhb1w5s6RMQ5BKK4GGI
ZzgQCUVbH0KpZ+2E7rEnK1V/ZgxhXyyPuGqOo4puL6uqLRftMWT5vx5NSDg4aYTP
W5F0aiiO9t2kpdFu7rHdRqHJVxlpFZi5htIxkensA7lqf7k5U9cSNFT7GvXfLHU4
I2lgtpNDrZQLWFywclaLK9hG9QbIcaH7Mk0+zb5qbI1Bx7GELdjJdlSxD06qG7FJ
Tx87Zg2CBc8rzOnxDNyWxsF4tikU91Xt5Yusm2FRaJF7yUebzr/poyZ5JKdDP/G0
hTu7pJpx3lteIgE4/8UAV09imZ9adFfaOo0MimU0lLhnHvZpJ+JeO/bbgxR5DIKe
1XEp869X33WRN+pbNvCkSdHxj4Fz5tM1I6ZhhMMbn+45ccI4AUuTkjBQ1xSVUQe6
Vf/sCpdzaWXptQGZMXsDCIKPGA8Ti4w3N/ZlLta0FUxrN+tojLLa9fL5SZKKgoyW
73L0bu7fqidtt5askJUYf3bY6lPRsfLVPSsiqJEyCIPxheYlTCjiJPiU2KLCb+R6
6uv/bxIcreDdxoygcEhnYyIJQZHOESnmQes62Wa2119by5OU1nvRLTj+tIUMZ96V
p3WYp6D1edhOcBm07Lw5
=KVZ+
-----END PGP SIGNATURE-----

--nextPart2598426.UPXiesILaJ--

