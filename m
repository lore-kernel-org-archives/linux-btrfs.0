Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:59572 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbcCMRYs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 13:24:48 -0400
Date: Sun, 13 Mar 2016 22:24:42 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: parent transid verify failed on snapshot deletion
Message-ID: <20160313222442.1fa22a57@natsu>
In-Reply-To: <pan$a52ce$b1beae3d$57f5b99c$a796a0ec@cox.net>
References: <20160312204847.2092f3f3@natsu>
	<20160312221524.646e1a66@natsu>
	<20160313142428.377b51b8@natsu>
	<pan$a52ce$b1beae3d$57f5b99c$a796a0ec@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/YwWVbQLtJ.1fbbq5AStpuc."; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/YwWVbQLtJ.1fbbq5AStpuc.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 13 Mar 2016 17:03:54 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> With backups I'd try it, if only for the personal experience value and to=
=20
> see what the result was.  But that's certainly more intensive "surgery"=20
> on the filesystem than --repair, and I'd only do it either for that=20
> experience value or if I was seriously desperate to recover files, as I'd=
=20
> not trust the filesystem's health after that intensive a surgery, and=20
> would blow the filesystem away after I recovered what I needed, even if=20
> it did appear to work successfully.

"Blowing away" a 6TB filesystem just because some block randomly went "bad",
without any explanation why, or guarantees that this won't happen again, is=
 not
the best outcome. Sure there might be no way to "guarantee" anything, but l=
et's
at least figure out a robust way to recover from this failure state.

I'm running --init-extent-tree right now in a "what if" mode, using
the copy-on-write feature of 'nbd-server' (this way the original block devi=
ce
is not modified, and all changes are saved in a separate file). It's been
running for a good 8 hours now, with 100% CPU use of btrfsck and very little
disk access. Unless I'm mistaken and something went majorly wrong, these
messages (100 MB worth of them by now) seem to indicate it indeed proceeds =
in
recreating the extent tree.

adding new data backref on 3282190336 parent 4315246948352 owner 0 offset 0=
 found 1
Backref 3282190336 root 256 owner 1187677 offset 4096 num_refs 0 not found =
in extent tree
Incorrect local backref count on 3282190336 root 256 owner 1187677 offset 4=
096 found 1 wanted 0 back 0x23496e40
Backref 3282190336 parent 4315038240768 owner 0 offset 0 num_refs 0 not fou=
nd in extent tree
Incorrect local backref count on 3282190336 parent 4315038240768 owner 0 of=
fset 0 found 1 wanted 0 back 0x4b29f3a0
Backref 3282190336 parent 4315246948352 owner 0 offset 0 num_refs 0 not fou=
nd in extent tree
Incorrect local backref count on 3282190336 parent 4315246948352 owner 0 of=
fset 0 found 1 wanted 0 back 0x4c330f60
backpointer mismatch on [3282190336 4096]
ref mismatch on [3282194432 32768] extent item 0, found 1
adding new data backref on 3282194432 parent 4309109956608 owner 0 offset 0=
 found 1
Backref 3282194432 parent 4309109956608 owner 0 offset 0 num_refs 0 not fou=
nd in extent tree
Incorrect local backref count on 3282194432 parent 4309109956608 owner 0 of=
fset 0 found 1 wanted 0 back 0x52903a20
backpointer mismatch on [3282194432 32768]
ref mismatch on [3282227200 4096] extent item 0, found 1

As it finishes I'll check if files are present and not corrupted, then will
have to run it once more, this time "for real". Unfortunately this also see=
ms
to be an O(n) operation (if I'm using the term correctly), as the rate at w=
hich
new log messages appear has been slowing down considerably as it progresses.

--=20
With respect,
Roman

--Sig_/YwWVbQLtJ.1fbbq5AStpuc.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlblol0ACgkQTLKSvz+PZwjtkgCfW/O+B3QKD2yFXKxqPMbP0N5I
ic8AnRgQVwLNFSHX0WmbtrxPAGMzNy+4
=Jkp6
-----END PGP SIGNATURE-----

--Sig_/YwWVbQLtJ.1fbbq5AStpuc.--
