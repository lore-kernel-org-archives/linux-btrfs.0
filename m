Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36324 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbH2UYJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Aug 2015 16:24:09 -0400
Received: by padhm10 with SMTP id hm10so40712872pad.3
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Aug 2015 13:24:08 -0700 (PDT)
Received: from ?IPv6:2601:646:202:8861:215:6dff:fe85:a43b? ([2601:646:202:8861:215:6dff:fe85:a43b])
        by smtp.googlemail.com with ESMTPSA id nv8sm9496944pdb.92.2015.08.29.13.24.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sat, 29 Aug 2015 13:24:06 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Kenneth Lakin <kennethlakin@gmail.com>
Subject: 4.1.6 gentoo-hardened: Hang during rename
Message-ID: <55E214DD.9070504@gmail.com>
Date: Sat, 29 Aug 2015 13:23:57 -0700
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MRxgSmnnhtt21EGOBKvD5ELcI9WoLlUrS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MRxgSmnnhtt21EGOBKvD5ELcI9WoLlUrS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hey. It looks like I'm being bitten by:
http://article.gmane.org/gmane.comp.file-systems.btrfs/44987/ except I'm
hitting it during rename, rather than unlink. Dmesg spew here:
http://pastebin.ca/3137198 (That pastebin post includes the -unrelated-
source of the W taint.)

I'm running on Gentoo hardened-sources 4.1.6 on x86 (rather than amd64).
The affected volume is mounted with
"rw,relatime,ssd,discard,space_cache,autodefrag" and -AFAIK- has no
subvolumes.

emerge is the blocked program and is the Gentoo package manager. This
lockup happens occasionally during the "Updating Portage cache" step of
the emerge sync operation. The emerge task is unkillable and is blocked
in D status. Attempts to re-run the cache update task have it hang at
what appears to be the same place. Only a reboot can "fix" the problem.
The rest of the system works just fine; the only thing that appears to
be blocked is the Portage cache update.

I couldn't find an open bug for this, but my Google-fu may be weak
today. Did I miss the bug report, or is this a currently unknown or
unconfirmed issue? Let me know if I can help with diagnostics.



--MRxgSmnnhtt21EGOBKvD5ELcI9WoLlUrS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJV4hTlAAoJEDpEx4ha9HUKE80P/37zMfkE8nd3w2TRP5otTmNw
8iPkBR74iTPJNxSSHvH0KnPoGu/ariRwDrlf7Y3x0LeRrz8jrYrKuP5AgidH+7DJ
xUNAP7OMQ8FaZSaJgoPqxXgCU8fJSKa3dwQJ8tgdoBNThfro+OhTSTF26D3s8cBy
fLoZ7NOXT82nvCJpVQMuZXPpiBeKJl307V+uOZIqfV0vrvQxwK1pTaFDFqyHjYgs
ZLzLeULTkOS8Hn9eatdsknGqDGXxSdxiIQlHbkCt37/9p7pbAN4+AxhljBF1rWqc
GVcLSPUWezz7d8c6bguZdaHmCPCMcNOG8FMtEmbes7JCcpwbl3tbtTDpClwVFm8O
DLetDb9G4qQj0tO/eA32cfhrCpcrsXP/FFvc24KBVPhrbI8YrsbphaAS5N5ZZBqd
H+9+qGZZPnNg1rGGJGRj+BAQyE9kf7rpRKsB43+xCEd66Gu4anlomOQqb+E0jRTx
cRp3Zf5/eYzqYwtdr1RkY+uhxFFsJRznvaT3+9S5nzYk6soxCM4adtmnZsZ69xJ4
oEWsiETaExy7Xv4Bt0jLOYrXQdqzgcPjaM30JBC6NKd4i/t1hItxkOFOgZJItQRR
LlEKEBHaYDQ7FC8h2+YZzqYfp2ws3IW7RX3p/fhA0+8iUAIRIk9JdSTSS76cvGHO
Ej8nOMg4/fWk0P4TpQac
=eYrF
-----END PGP SIGNATURE-----

--MRxgSmnnhtt21EGOBKvD5ELcI9WoLlUrS--
