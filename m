Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57353 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753186AbcIFPM3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Sep 2016 11:12:29 -0400
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Zhao Lei <zhaolei@cn.fujitsu.com>, "'Sean Fu'" <fxinrong@gmail.com>,
        clm@fb.com, anand.jain@oracle.com, Filipe Manana <FdManana@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
 <57CE326C.8000105@suse.com> <57CE3464.7090107@suse.com>
 <20160906095858.GA16983@suse.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <61eeb5da-c537-2392-74e4-eac77eda6264@suse.com>
Date: Tue, 6 Sep 2016 11:12:20 -0400
MIME-Version: 1.0
In-Reply-To: <20160906095858.GA16983@suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="H18KIeq6Og3bThiTtpgReNAaQB7oB66uB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--H18KIeq6Og3bThiTtpgReNAaQB7oB66uB
Content-Type: multipart/mixed; boundary="vKQoa7uoMn2P0NFFmNp4wT82URjhuEubh";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
 Zhao Lei <zhaolei@cn.fujitsu.com>, 'Sean Fu' <fxinrong@gmail.com>,
 clm@fb.com, anand.jain@oracle.com, Filipe Manana <FdManana@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <61eeb5da-c537-2392-74e4-eac77eda6264@suse.com>
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
 <57CE326C.8000105@suse.com> <57CE3464.7090107@suse.com>
 <20160906095858.GA16983@suse.cz>
In-Reply-To: <20160906095858.GA16983@suse.cz>

--vKQoa7uoMn2P0NFFmNp4wT82URjhuEubh
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/6/16 5:58 AM, David Sterba wrote:
> On Mon, Sep 05, 2016 at 11:13:40PM -0400, Jeff Mahoney wrote:
>>>> Since root is only used to get fs_info->chunk_root, why not use fs_i=
nfo
>>>> directly?
>>>
>>> Weird.  Exactly this was a part of my fs_info patchset.  I guess I ne=
ed
>>> to go back and check what else is missing.
>>
>> Actually, most of this didn't land.  Pretty much anything that's a roo=
t
>> ->fs_info conversion is in there.
>=20
> Only half of the patchset has been merged so far because it did not pas=
s
> testing, so I bisected to some point. I was about to let you know once
> most of 4.9 patches are prepared so there are less merge conflicts.

Ok, thanks.  I was going to start the rebase today but I'll hold off
until you're set for 4.9.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--vKQoa7uoMn2P0NFFmNp4wT82URjhuEubh--

--H18KIeq6Og3bThiTtpgReNAaQB7oB66uB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXztzUAAoJEB57S2MheeWyPMgP/2caczxYLttd+zPldn7dtL+H
2Hzgtub4JiR0nZyPxdJzRqPWts2OOmj3fAsS4cTc2kF8Evnp4x5hSqSWisT22pIu
MgMjr4Mxk2Fw/Druu0N7c7BaahI3CDVaBHKJNUrvckEziOXEN6sDGpECBwkm0M3E
o5zmm021Izi4pJEFPahifWyHRp2YpFrm+cWmu8GkZ7KnzGE1NryPD65AQ52Q0UGd
8DTa6x7YTbkE2GTEi/1JsOxr48uUXpDaYtUu6DzdfwZYHA4X6UNOlwpT/COv1AsG
jZlCrtYZaouTAJ5syKQB/0O1TnD6Op8eHSkn+Kql0F+ntv21sTicKKY31vwMjEKB
wamUFknPjI3xFnLxv0zejos/wO8fcPpHW5D3vjI5y1OPsNCgATLXKuezGU9dRGiM
C8AReimmecpdnRsxPXpBH0/VF4akC5ybddrqC4k//bf0ihdxcxwLGW23zdl8+uAB
ih3N+OuEUEWMWoY/eAccy5FaP3E5YcYJCseEnJpiUguOTI/9Qct+pi/2snlgPPlt
/J9rts1WhdJQ6NnVPbIopFgEtLk774vDDBmC73ygs/9BWeWDWwHk1JYDvhu+cBK5
gAicRdb4wQKbE0mU2TDYlMAtyqd18ksYnltpVFdf2uYQDEjUYeXkC3Z8+r30OI/l
gEK8wKBTgOfoP+JY+YUN
=W+0B
-----END PGP SIGNATURE-----

--H18KIeq6Og3bThiTtpgReNAaQB7oB66uB--
