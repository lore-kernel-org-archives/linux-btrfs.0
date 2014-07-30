Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ngcobalt08.manitu.net ([217.11.48.108]:59460 "EHLO
	ngcobalt08.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaG3LdH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 07:33:07 -0400
Received: from [192.168.100.170] (unknown [46.189.32.222])
	(Authenticated sender: jseifert)
	by ngcobalt08.manitu.net (Postfix) with ESMTPSA id 6FE153A806B
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 13:22:39 +0200 (CEST)
Message-ID: <53D8D56E.7050407@dergleichrichter.de>
Date: Wed, 30 Jul 2014 13:22:22 +0200
From: Justus Seifert <justus.seifert@dergleichrichter.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: wait until all subvolumes are cleaned
References: <1406148973-23162-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1406148973-23162-1-git-send-email-dsterba@suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="xmQvdqsiVd41HiUslqwvctvbtf7PrMNBv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xmQvdqsiVd41HiUslqwvctvbtf7PrMNBv
Content-Type: multipart/mixed;
 boundary="------------000603090805020905010406"

This is a multi-part message in MIME format.
--------------000603090805020905010406
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 23.07.2014 22:56, David Sterba wrote:
> Enhance the 'subvolume' subcommand to wait until a given list of
> subvolumes or all currently scheduled for deletion are cleaned[=85]
>
> 'wait' seemed too generic, 'sync' is not completely accurate but IMHO b=
etter,
> I'm open to other suggestions

'receipt'


--------------000603090805020905010406
Content-Type: text/x-vcard; charset=utf-8;
 name="justus_seifert.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="justus_seifert.vcf"

begin:vcard
fn:Justus Seifert
n:Seifert;Justus
adr:;;;Dresden;Saxony;;Germany
email;internet:justus.seifert@dergleichrichter.de
tel;cell:+4915730640509
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------000603090805020905010406--

--xmQvdqsiVd41HiUslqwvctvbtf7PrMNBv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJT2NVvAAoJELFJh75Z+IvIuOoQAOPSh+8uD5kPwwN/iWd5u3zX
mCko6XfFXHwdqeUkakeRlvRqspbKMGfKA8fU4YLn0WQO1BffU2Lmk1EojZpyp0rg
6Hq5P4jrZKEa52LI3NKtmXGD7lePfJj5+UAtcUAIl8tswZB7q9iFOIUIN7ag4STC
vAuRPRaEbuq0u5Sqo4evxLuPSYRYqX/vy0bAZsLT1otSJ94fCaW+yxTOsz+AQAM7
dqrNn912EhOkpNBYONkrRiCM3pN+OQn1ZJRZLsVoKtPkUHwAaNxACzNSeMwZOkqf
bUvDmRAjn5hnWdKtnupI4DKbxZvH+uFMh5u1K091Fejt+vrVPgEiMtyCmqQym3CD
IAZFflB1XpdxMmKNCprdjMDECoNSaofwzPyvf91MlIBbAvUQygZId2KNPibACd8E
x1EpdOHcu6KbyK3IMkAtxjiAVgd2r75UHG6jYB5nj75ec07RukZcQtIoHo2I05WN
gLrL1BqOJx7hfRXGgZ6bRtTH8gdi0mlg2G7ojtxvnD2HSwqYsfCSMZyNJQuvrmYk
yC1+Q9IMlZMZKobtL1Ys3l4aEpK2QkQbkwb0qy/xPCA+Ij62KsZ5zAZx5EfETxb9
GTFv8GxqYsxVBF+W72CLtYoOvnl4ucBZtIdb3HFBsW2OLFRf37XbKfNqyz0V704g
jnrDHszh2pdMZLPJdv+9
=tHGW
-----END PGP SIGNATURE-----

--xmQvdqsiVd41HiUslqwvctvbtf7PrMNBv--
