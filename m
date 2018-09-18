Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:34787 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbeIRXoS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 19:44:18 -0400
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LgNGi-1fPudf04Zg-00nggb for
 <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 20:10:31 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Move data and mount point to subvolume
Date: Tue, 18 Sep 2018 20:10:23 +0200
Message-ID: <2062209.NsJ275U7B3@thetick>
In-Reply-To: <7fade1e9-7eb2-d416-6a3d-452cbca3bbe5@mendix.com>
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net> <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com> <7fade1e9-7eb2-d416-6a3d-452cbca3bbe5@mendix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3793936.85ONBepJOp"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3793936.85ONBepJOp
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Sonntag, 16. September 2018, 14:50:04 CEST schrieb Hans van Kranenburg:
> The last example, where you make a subvolume and move everything into
> it, will not do what you want. Since a subvolume is a separate new
> directoty/file hierarchy, mv will turn into a cp and rm operation
> (without warning you) probably destroying information about data shared
> between files.

I thought that wasn't true anymore.  The NEWS file to coreutils contains this 
(for version 8.24):

  mv will try a reflink before falling back to a standard copy, which is
  more efficient when moving files across BTRFS subvolume boundaries.

-- 
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--nextPart3793936.85ONBepJOp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAluhP48ACgkQv9DmhiyI
ePSBgQ//RLnrG/0r3JyHr0g/SOHecu7Q1pdbDq8dwslWL2WFu9WBCNcABjR1/TGC
JK+qzpxmi2OMYbE5AlF1IA2jX3ns4zapWe0vpCO4913gQqcG5Qz7oUcqLyor4bsn
JvkqbP1/pzvnYOrQcrbJaKZERn07qxsYu8q2+vKxVdYa4pVooUWS+xcjeh77FBqk
+wJW9cSUME44ZHhLJgHJMgVX89k8AUm8GPzrpIkSv4vUu/fFmx7r6J1SwC2gJ9JB
56bjn2HBCo2YSC6z9IVBySCiLzTDf1297t9FEkXns55gnRjkd1YjBSmlUpuS8692
f7Eon1MZOVUDhxVhSvza1K7RJNsWa7bme7lLs47E4/Q5dnmEX4mVLFu/5U9Y2ftd
UjdJd1x924wU1EVAkhZC7J3NoMrWx59DIBldUKuNW8o4H3cUkE2vsDU4cZGq8+AK
OULwnhTouR5d8gQ5U9GI524Je72p++XMfGYbAgXDyFj1LAGycqlGhI13i+1qYrFY
49HBsaVMCdL55gL8wOhjFWpd9JhQyoF0ukdWJdhizHyr6ZwxoSwfwEWOhBY3U3mE
q4cO2I+Jxlfq2G3nrpqNYhirkF6k41nzYJ4hWeVX1cKzeeVvM0YjX0LpHv4QZpyR
md6XeZGvKGEtF5Lpx8e1fXznnDUHl9gviHKT9v6O7fQhJ9Vczjk=
=ktTI
-----END PGP SIGNATURE-----

--nextPart3793936.85ONBepJOp--
