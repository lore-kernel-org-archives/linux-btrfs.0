Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB005C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 13:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F81320883
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 13:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbfDBN3Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:29:24 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:51048 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfDBN3Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 09:29:24 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1hBJTc-0007EZ-Cl; Tue, 02 Apr 2019 13:29:20 +0000
Date:   Tue, 2 Apr 2019 13:29:20 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "Nik." <btrfs@avgustinov.eu>, linux-btrfs@vger.kernel.org
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
Message-ID: <20190402132920.GA29117@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, "Nik." <btrfs@avgustinov.eu>,
        linux-btrfs@vger.kernel.org
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 02, 2019 at 09:24:03PM +0800, Qu Wenruo wrote:
>=20
>=20
> On 2019/4/2 =E4=B8=8B=E5=8D=889:06, Nik. wrote:
[snip]
> > On the larger file system only "btrfs check --repair --readonly ..." was
> > attempted (without success; most command executions were documented, so
> > the results can be made available), no writing commands were issued.
>=20
> --repair will cause write, unless it even failed to open the filesystem.

   If btrfs check accepted both --repair and --readonly without
complaining, then that's a regression and a bug. --readonly should be
mutually exclusive with any option that might write to the FS, and if
it isn't any more, then it's been broken and needs fixing.

   Hugo.

--=20
Hugo Mills             | Great films about cricket: Interview with the Umpi=
re
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJco2OwAAoJEFheFHXiqx3ks8gQAJepAh51RMjUgfgc1ghwuMTf
L71jRrlis4fBXQlZoFcIVtNDPSh4AG1wDsgybcLGr9MJ+zJRx5KKholas6/7kNZw
NnRlt7akcW+jo9P67mz1x1HZrc4OQh8Mq+pbXcrAzie/Vs8yR9P0kA00kTwuiGZg
MoB6GtDR5wvff2hdX/vq1FAh7jXwONWY8FAzW7Y0gpmQj9Ofr08T7UI4gsBWTysn
ShEbrVgc5nK1yUxvDn/THgpvKfMXNH3hJExh2p2NXsJYBYIZb+1Uy25mxebzGOZ5
rZI1oIb+hrd9B226MLmGxutH/98vMlBwi1yJDoBNqXq8dVtqwXIdNw51byJTg9Qf
cPFw6RvalnHLm2Zpvw21yAv/l8AkutWlGpl87qIwNr05yW+geX8eJj7eM0WKobta
OFE7133K5SzLT6ka7cDW+ROT2fuqiqJA2WQDo4it/vt4RguJ1uX+HhdlBWVBIQvi
dIGsERaKdJUmHX8YjdqpG7g+R9+0NcyrBO/+zBYDcEqDWRIbVskwQ3IF+W/BFYrI
MAynyQcTm7zh1Y5W2fM6RjjZVqY78Xba+w6kjZJhlXXiNWwW4zfsm+BqNOuckEOG
+SJpAVyP+WOnEW9voIizG9oRKlZH46w9mDZYaj4YA9fPX84Hw1fCfWws0iuPKNaQ
twFardh3TAXc+iwykQKi
=m7CP
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
