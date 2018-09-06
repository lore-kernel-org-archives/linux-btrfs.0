Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:41457 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbeIFGOV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 02:14:21 -0400
Subject: Re: [PATCH] btrfs: qgroup: Don't trace subtree if we're dropping tree
 reloc tree
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180905050339.5356-1-wqu@suse.com>
 <20180905131146.GX24025@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c0767f62-5356-af80-c5b4-2e97be62e730@gmx.com>
Date: Thu, 6 Sep 2018 09:41:14 +0800
MIME-Version: 1.0
In-Reply-To: <20180905131146.GX24025@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2xMnhtLDF7O9ZmGpSr4JMkZAUV6B5R4ae"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2xMnhtLDF7O9ZmGpSr4JMkZAUV6B5R4ae
Content-Type: multipart/mixed; boundary="OSanG9Il9VcixXWvZuMN2D8WFB50FQJDh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <c0767f62-5356-af80-c5b4-2e97be62e730@gmx.com>
Subject: Re: [PATCH] btrfs: qgroup: Don't trace subtree if we're dropping tree
 reloc tree
References: <20180905050339.5356-1-wqu@suse.com>
 <20180905131146.GX24025@twin.jikos.cz>
In-Reply-To: <20180905131146.GX24025@twin.jikos.cz>

--OSanG9Il9VcixXWvZuMN2D8WFB50FQJDh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/5 =E4=B8=8B=E5=8D=889:11, David Sterba wrote:
> On Wed, Sep 05, 2018 at 01:03:39PM +0800, Qu Wenruo wrote:
>> Tree reloc tree doesn't contribute to qgroup numbers, as we have
>=20
> I think you can call it just 'reloc tree', I'm fixing that in all
> changelogs and comments anyway.

But there is another tree called data reloc tree.
That why I'm sticking to tree reloc tree to distinguish from data reloc
tree.

>=20
>> accounted them at balance time (check replace_path()).
>>
>> Skip such unneeded subtree trace should reduce some performance
>> overhead.
>=20
> Please provide some numbers or description of the improvement. There ar=
e
> several performance problems caused by qgroups so it would be good to
> get a better idea how much this patch is going to help. Thanks.

That's the problem.
For my internal test, with 3000+ tree blocks, metadata balance could
save about 1~2%.
But according to dump-tree, the tree layout is almost the worst case
scenario, just one metadata block group owns all the tree blocks.

To get a real world scenario, I need a file with hundreds GB or even
several TB and populate it with a good amount of inline files and enough
CoW to fragment the metadata usage.
Which I don't have such free space.

Anyone who is still struggling with balance + quota, any test data is
appreciated.

Thanks,
Qu


--OSanG9Il9VcixXWvZuMN2D8WFB50FQJDh--

--2xMnhtLDF7O9ZmGpSr4JMkZAUV6B5R4ae
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluQhboACgkQwj2R86El
/qimEwf/YssP0+t9SrwM3/v9HgMTn5Y6Cj+18gwDo0eScolNTO1EiWflF+2M5BxO
mnzKb36IPFwjqtXShd88o3J/KUIxqLt2HE/DW+Ap6ejGRbX9P/DdtcNcMg6uOUwq
ooFWxyJS0303spHj7CvnwtVnFTejwWH/84YQV7z5T6COoTHqKrPcsq4SX+3AVkR7
I2JO4cb65DDNqZW9r3oP7PU5fZr5L1Rd1MjHfi0k8g4mw/hKd9hYHzMLgLKrtMrf
8v+FsscJ3ntQmSPgrV1N+z/RfWwomuaHIZfyVXgxq1LqS1bRDMDxxNin4Q3S0j+q
ULkMoGDvcH1XmqP2G5RFIxWSETElJQ==
=51q/
-----END PGP SIGNATURE-----

--2xMnhtLDF7O9ZmGpSr4JMkZAUV6B5R4ae--
