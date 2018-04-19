Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52305 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751879AbeDSM5r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 08:57:47 -0400
Subject: Re: [PATCH 1/2] btrfs: print-tree: output enhancement
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180411090813.19495-1-wqu@suse.com>
 <20180419124919.GB21272@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5946b8b7-b1d9-647b-e3c1-3238db716859@gmx.com>
Date: Thu, 19 Apr 2018 20:57:30 +0800
MIME-Version: 1.0
In-Reply-To: <20180419124919.GB21272@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3zmefsVVdCu33QnbjQPmNgMHLeZENeyrv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3zmefsVVdCu33QnbjQPmNgMHLeZENeyrv
Content-Type: multipart/mixed; boundary="Q2CeapTfZGlz815IwoKQeNow0mvMHVC2x";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <5946b8b7-b1d9-647b-e3c1-3238db716859@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: print-tree: output enhancement
References: <20180411090813.19495-1-wqu@suse.com>
 <20180419124919.GB21272@twin.jikos.cz>
In-Reply-To: <20180419124919.GB21272@twin.jikos.cz>

--Q2CeapTfZGlz815IwoKQeNow0mvMHVC2x
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8819=E6=97=A5 20:49, David Sterba wrote:
> On Wed, Apr 11, 2018 at 05:08:12PM +0800, Qu Wenruo wrote:
>> This patch enhance the following things:
>>
>> - tree block header
>>   * add generation and owner output for node and leaf
>> - node pointer generation output
>> - allow btrfs_print_tree() to not follow nodes
>>   * just like btrfs-progs
>>
>> Please note that, although function btrfs_print_tree() is not called b=
y
>> anyone right now, it's still a pretty useful function to debug kernel.=

>> So that function is still kept for later use.
>=20
> It will stay of course, code deletionists have no chance removing usefu=
l
> debugging stuff.
>=20
> Reviewed-by: David Sterba <dsterba@suse.com>
>=20
> Some time ago I improved the progs output of print-tree, this would be
> also good to port to kernel and we can then keep the files in 1:1.

Definitely!
The current kernel print-tree is just better than no output, far from
human readable output.
I can't wait to port btrfs-progs print-tree to kernel, but that's over
1000 lines for debug facility.

If that's OK, I could start the port any time.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Q2CeapTfZGlz815IwoKQeNow0mvMHVC2x--

--3zmefsVVdCu33QnbjQPmNgMHLeZENeyrv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrYkjoACgkQwj2R86El
/qisbwgApkDjhuLvLJkG4VQeEWFOELTUcZ+Hpd1uG2YZPIs57uy2P19UGOmrisUV
In6NXBuQiumlBrvvod6uRzFh0A37Lm8tF9vZ/UAAPedYDIzeM73yeRmqR/isH/pM
Q/sNKWgHNPAq5b8NMfd6VL/ysTILawZX5NooZkZSKP1Bye+NHkmf4IIhqxyqd8jz
Qv53oyruR8C/tmaAde/YLIJceD94sBH1RUWecGZQmMKXz5IU4aK1foZqCTkZgWnh
MiJBkpM4NF9YZnkCusiF4PNjGEqy8K7Tm4hskO9WcDMurzvtGtEcM2KyuhP7ShUq
6oQDgKunfHdNfCabi6NVsEw0IjXefw==
=fItI
-----END PGP SIGNATURE-----

--3zmefsVVdCu33QnbjQPmNgMHLeZENeyrv--
