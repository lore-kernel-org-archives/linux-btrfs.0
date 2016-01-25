Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:59720 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbcAYVum (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 16:50:42 -0500
Received: from moh2-ve3.go2.pl (moh2-ve3.go2.pl [193.17.41.208])
	by tur.go2.pl (Postfix) with ESMTP id 2C8C7102030A
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 22:27:46 +0100 (CET)
Received: from moh2-ve3.go2.pl (unknown [10.0.0.208])
	by moh2-ve3.go2.pl (Postfix) with ESMTP id 37452D35FA
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 22:27:44 +0100 (CET)
Received: from unknown (unknown [10.0.0.74])
	by moh2-ve3.go2.pl (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 22:27:44 +0100 (CET)
Date: Mon, 25 Jan 2016 22:27:43 +0100
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: suspected BTRFS errors resulting in file system becoming
 unrecovable
Message-ID: <20160125212743.GB6110@pontus.sran>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Sorry, forgot to ansewer on-list, but I'm forwarding my question to
William and his answer in next message.


----- Forwarded message from Piotr Szymaniak <szarpaj@grubelek.pl> -----
Date: Mon, 25 Jan 2016 17:48:49 +0100
=46rom: Piotr Szymaniak <szarpaj@grubelek.pl>
To: WillIam Thorne <will.thorne@me.com>
Subject: Re: suspected BTRFS errors resulting in file system becoming unrec=
ovable
User-Agent: Mutt/1.5.23 (2014-03-12)

On Mon, Jan 25, 2016 at 02:58:31PM +0000, WillIam Thorne wrote:
> Jan 20 09:43:18 mail kernel: [2762823.972851] blk_update_request: I/O err=
or, dev sda, sector 16198688
> Jan 20 09:43:18 mail kernel: [2762823.977052] blk_update_request: I/O err=
or, dev sda, sector 16198928
> Jan 20 09:43:18 mail kernel: [2762823.978318] blk_update_request: I/O err=
or, dev sda, sector 16199168
> Jan 20 09:43:18 mail kernel: [2762823.983304] blk_update_request: I/O err=
or, dev sda, sector 16172024
> Jan 20 09:43:18 mail kernel: [2762823.987855] blk_update_request: I/O err=
or, dev sda, sector 16172264
> Jan 20 09:43:18 mail kernel: [2762823.989193] blk_update_request: I/O err=
or, dev sda, sector 16172504

Hi,

This looks like bad sectors, not btrfs fault (on the other hand, few bad
sectors should not make fs unrecoverable).

Can you paste smartctl -x /dev/[yourdevice] output?


Best regards,
Piotr Szymaniak.
----- End forwarded message -----

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWppNPAAoJEEMpAov1cw9lkiwQAIXpQeSS+EPziXzDh8wuVWHE
R1qrOGZdg4Jo1dYTtiG7gIfpaACHZrkxA0r5ujS34kD2ZImLu9YNiUnmIL6/I5xv
Bc3mlQaMZCDN1NqR68h8VkJdyOB4+bfW2nO6nygXqJwFyA1g70EtqohrUKAitzHm
bhbpXHb9CSUwgZCuplL5lErHanbQX/hKFs1HZwePG35R5h9fIUMlsurNybANfWkH
1YOZOZzT4fVNfCavFK0mZ+fNvewmUjB2wjAtORSyPAqdm/MOn0b/YgKjnpsN663M
44iU/jkaISb1HGzIv+Yprnj0kkA8ISwMVzIy2QeBm03CMRq21vUtilMCp/GN6kWm
GjKhwdOts5/4F860s7vVo+zdPE6jCUO+TTMxbHQo+dtN9ygLc/nBB0cqJ0va59I2
PaUOMy0fSD5n2SZ5+TJogzcsSn9JZFbg4xxQmHGhUGEiquhzA7PjwMaufTA9n1up
9RsNExNudl9oZipGRhyV2SQU3evpZoDM/m9HwyInB720kVzp+xb2Q986bX4qLSch
xizvXsX81EXDXO8i0nIsPnZjEJM2pyL1yDFfH//9ZWzWUDcZPiXAtpfXa+5lIxsU
Uj2mkd4sT8ZK2Y74qxIex+hljwGYEQjLnMFKjQDiKVT+mIyx35WFs6TV2OHOdzbi
BRDjB6OdDcYG+A9UtOW+
=JIzH
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
