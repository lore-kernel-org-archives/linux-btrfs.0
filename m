Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:45375 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388156AbeG1AZz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Jul 2018 20:25:55 -0400
Subject: Re: A list of new findings when fuzzing Linux btrfs module
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <011B0D79-F8E6-46F1-9D82-8D60A4F3E925@gatech.edu>
 <20180710111359.GQ3126@twin.jikos.cz>
 <5DBB03A9-2660-4837-87F5-871077299651@gatech.edu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <79171cb2-e3c7-1d25-157f-8ac0cba7bed2@gmx.com>
Date: Sat, 28 Jul 2018 07:01:31 +0800
MIME-Version: 1.0
In-Reply-To: <5DBB03A9-2660-4837-87F5-871077299651@gatech.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xe160Ts7KsVg91Rl4nMu4PTnzDGklRip7"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xe160Ts7KsVg91Rl4nMu4PTnzDGklRip7
Content-Type: multipart/mixed; boundary="AZ1cVOWiDBRJQBIxDyjYF42fw3W5c9UVt";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: "jbacik@fb.com" <jbacik@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <79171cb2-e3c7-1d25-157f-8ac0cba7bed2@gmx.com>
Subject: Re: A list of new findings when fuzzing Linux btrfs module
References: <011B0D79-F8E6-46F1-9D82-8D60A4F3E925@gatech.edu>
 <20180710111359.GQ3126@twin.jikos.cz>
 <5DBB03A9-2660-4837-87F5-871077299651@gatech.edu>
In-Reply-To: <5DBB03A9-2660-4837-87F5-871077299651@gatech.edu>

--AZ1cVOWiDBRJQBIxDyjYF42fw3W5c9UVt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8828=E6=97=A5 03:02, Xu, Wen wrote:
> Hi Wenruo,
>=20
> Is there any update or handling with these issues?

Yes, 4 of all 5 newly reported images can be handled with new patches:

[PATCH 0/5] Enhancement for block group/chunk verification
[PATCH 0/2] btrfs: chunk and dev-extent related error handler enhancement=

[PATCH] btrfs: tree-checker: Add DATA_RELOC tree to essential non-empty
tree list

However, one special case, "Potential deadlock in btrfs_tree_lock() when
perform writing to btrfs filesystem" is stepping into the deadzone of
extent tree, I tried one patch but it will screw up other code.

I'm still looking into better solution for it.

Thanks,
Qu

>=20
> Thanks,
> Wen
>=20
>> On Jul 10, 2018, at 7:13 AM, David Sterba <dsterba@suse.cz> wrote:
>>
>> On Wed, Jul 04, 2018 at 05:54:56PM +0000, Xu, Wen wrote:
>>> Hi BTRFS developers,
>>>
>>> Here are a list of new issues I found:
>>
>> Thanks for sending the list to the list, hopefully this will make the
>> bugs more visible as bugzilla gets low attention otherwise.
>=20


--AZ1cVOWiDBRJQBIxDyjYF42fw3W5c9UVt--

--xe160Ts7KsVg91Rl4nMu4PTnzDGklRip7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltbpEsACgkQwj2R86El
/qgToAf/VO5eVNSU6hcyIJN985NyLTlWu2tJRJr31zmklzHTw1kkktoPOIY0Al5y
TsiN8dme44ZLF1D883r5/8V2TZQmBgGDkc2jqkljkVxDHduAYMSCuk7t/VFwTZ/p
0Bf+ZkhWJAlALmrp5wrA8ejwwiIowNvb6LmRkGupDmKMo5lrVO8KgL1pgMaiku95
jFLX4lu+N5TAHjvUJUalQNRqCSoX1j8JzMx/hico5Yd3ASBKx13WooA45ElihJ7O
M84xHeSpVIDpbXSRr6qA78zklzf0tkGFk7vxTNuJxpwzePPbydMpoYBbTvCxCIxf
GtzWi5ZqG/0HduEIyjQMyuTTk8Xp2w==
=WMC0
-----END PGP SIGNATURE-----

--xe160Ts7KsVg91Rl4nMu4PTnzDGklRip7--
