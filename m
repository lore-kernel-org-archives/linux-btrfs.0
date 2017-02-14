Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49924 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752228AbdBNMxC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 07:53:02 -0500
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LeeNW-1c2Zce0Sx4-00qSIS for
 <linux-btrfs@vger.kernel.org>; Tue, 14 Feb 2017 13:52:54 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already exists
Date: Tue, 14 Feb 2017 13:52:48 +0100
Message-ID: <2424977.zeESiHcezE@thetick>
In-Reply-To: <2380483.tGrojfQH67@thetick>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de> <20170211030139.7bff427e@jupiter.sol.kaishome.de> <2380483.tGrojfQH67@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4691146.ldJAEAk9Fl"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart4691146.ldJAEAk9Fl
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi again,

so, it seems that I've solved the problem:  After having to umount/moun=
t the=20
FS several times to get btrfs-cleaner to finish, I thought of the "fail=
ed to=20
load free space [...], rebuilding it now" type errors and decided to tr=
y the=20
clear_cache mount option.  Since then, my home server has been running =
its=20
backups regularly again.  Furthermore, I was able back up my desktop ag=
ain via=20
send/recv (the rsync based backup is still running, but I expect it to=20=

succeed).  The kernel log has also stayed clean.

Kai, I'd be curious whether clear_cache will help in your case, too, if=
 you=20
haven't tried it already.

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart4691146.ldJAEAk9Fl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYov2gAAoJEL/Q5oYsiHj0eZwP/0B5ZlAqqGf62CdfrsVdgHQW
1ZKaFkTXYKftUjp7EqC4JQ/nDn3r7TuecvJvOMg4AV7AeTtM4k9So7DF7g5ypKMP
0k5J70nn4PH5xn+ftGjaIo/xhNH5moTC6qHPP/nQJxPSy4jXLL9AF6qYsO68RVOl
JC4RBPMUQKiqQcVcatzTCRbiTG93A+QeF3NeRU0VsOfV2v7XtBOMjZXI17NyIcsc
9r/igcOm8YlmnRO89XQJVV5kGauKT1XZRyY/fKOa3sw+PMYTur+8c8voGREUX9ds
1m+HrQECFXSg98hjQ8Q56BxyvDhJNKpYBDkmFLAz4h9rAJzRLv+nLaWHd7yLq0qt
cJgYK5b2UCOquGpylfg0pYDxC2Q+N/DwVjKZzgpfcAossTajcoK+Fsdqp5xyEAZn
NZ+ojZ1zxs4d03PIHa50mari2KITP5DyWIChlAyUHgcc2xADu4For7ad32O8WYz3
vWi8QCwHR5XpndZcrtkg/Tb4NWiqew+VLsuaM8uRe8tJkvEUJyqC6uDTq8SNoIsF
02FpWxB4iEUkXoRdP7vhjV/h0OdLcb8hvMD1h1BTz+13hc8Fts72Zt+CRLvjbBka
Pk7ubbVR+cR5Q4P8s5E0lu5Yt51NQ0FRpOLbnfwhBVh3zjYeLuOzK9OXMvGxrUf4
1DI5Kz1lADa5CF2m4pO1
=gPf7
-----END PGP SIGNATURE-----

--nextPart4691146.ldJAEAk9Fl--

