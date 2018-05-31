Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:36741 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750714AbeEaXhV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 19:37:21 -0400
Subject: Re: [PATCH 0/1] btrfs-progs: dump-tree: allow -b multiple times
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180406061202.6529-1-wqu@suse.com>
 <20180531120310.GT3539@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f8308a83-f17b-b571-4a32-89ba03cb9fa8@gmx.com>
Date: Fri, 1 Jun 2018 07:37:02 +0800
MIME-Version: 1.0
In-Reply-To: <20180531120310.GT3539@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="t7TGXFsGb7PoYXdP1twjsVCQqzvIQDkLV"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--t7TGXFsGb7PoYXdP1twjsVCQqzvIQDkLV
Content-Type: multipart/mixed; boundary="EDFsmPygjx5UAv72BqkJforssVVZxfmWF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <f8308a83-f17b-b571-4a32-89ba03cb9fa8@gmx.com>
Subject: Re: [PATCH 0/1] btrfs-progs: dump-tree: allow -b multiple times
References: <20180406061202.6529-1-wqu@suse.com>
 <20180531120310.GT3539@twin.jikos.cz>
In-Reply-To: <20180531120310.GT3539@twin.jikos.cz>

--EDFsmPygjx5UAv72BqkJforssVVZxfmWF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8831=E6=97=A5 20:03, David Sterba wrote:
> On Fri, Apr 06, 2018 at 02:12:01PM +0800, Qu Wenruo wrote:
>> Although just one patch, it needs the extent buffer cleanup code as
>> basis, so please fetch it from my github repo:
>> https://github.com/adam900710/btrfs-progs/tree/dump_tree_multi_blocks
>=20
> Could you please refresh the patch on a recent devel? The branches have=

> diverged too much over time, sorry.

Not a problem at all.

For such case just ask and I'll handle it.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--EDFsmPygjx5UAv72BqkJforssVVZxfmWF--

--t7TGXFsGb7PoYXdP1twjsVCQqzvIQDkLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsQhx4ACgkQwj2R86El
/qiR6AgAox+kPNYcaBGCYEIVd73TPlISI/HB9h0gSiF7Si27TilgzzOlG7BQarIz
ya+oyUWqxiu4Unw47qdMhi68zs3wd6YGAxyXw/7jfNerYtfh+vOLDB0d70mAzBzM
ohYofy1o+HT/os4h7NzKidGd/bCHtesgQFkhzaz1LxfeEyczeZlFcL51cYIW2+71
/pDVXGHB3re8E4oxOaByyljRas0SFoy8H0t8W2rt9Y/6wF7ChjAIdATrmmDSd8ZX
XKZDDeSGNSLZs8wH5cZCPIni6Ttb8EegQwh1oXRboEBgmiGMLv821IJyhCqT+H4q
45ttMcXaLgf46hJVUJX8X/XEF9908Q==
=rFKZ
-----END PGP SIGNATURE-----

--t7TGXFsGb7PoYXdP1twjsVCQqzvIQDkLV--
