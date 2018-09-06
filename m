Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:45679 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbeIFSB1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 14:01:27 -0400
Subject: Re: [PATCH 0/3] btrfs: qgroup: Deprecate unused features for
 btrfs_qgroup_inherit()
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180831022930.3465-1-wqu@suse.com>
 <20180905130030.GW24025@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6d55732f-4788-5e7c-e0a8-3f5e64ff3409@gmx.com>
Date: Thu, 6 Sep 2018 21:25:45 +0800
MIME-Version: 1.0
In-Reply-To: <20180905130030.GW24025@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SvuJYfRdU8pLWDkJVxBVyD2GMLjCN4u1s"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SvuJYfRdU8pLWDkJVxBVyD2GMLjCN4u1s
Content-Type: multipart/mixed; boundary="LvqpslaDEqgnPUSpW2bNCIvM2ezypG5fM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <6d55732f-4788-5e7c-e0a8-3f5e64ff3409@gmx.com>
Subject: Re: [PATCH 0/3] btrfs: qgroup: Deprecate unused features for
 btrfs_qgroup_inherit()
References: <20180831022930.3465-1-wqu@suse.com>
 <20180905130030.GW24025@twin.jikos.cz>
In-Reply-To: <20180905130030.GW24025@twin.jikos.cz>

--LvqpslaDEqgnPUSpW2bNCIvM2ezypG5fM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/5 =E4=B8=8B=E5=8D=889:00, David Sterba wrote:
> On Fri, Aug 31, 2018 at 10:29:27AM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/qgroup_inherit_check
>> Which is based on v4.19-rc1 tag.
>>
>> This patchset will first set btrfs_qgroup_inherit structure size limit=

>> from PAGE_SIZE to fixed SZ_4K.
>> I understand this normally will cause compatibility problem, but
>> considering how minor this feature is and no sane guy should use it fo=
r
>> over 100 qgroups, it should be fine in real world.
>=20
> Agreed, please update the changelog of 1st patch with description on
> what will stop working and under what conditions. The 4k limit sounds
> good enough, the real difference would be on architectures with larger
> page sizes where the feature would be used.

No problem.

>=20
>> The 2nd patch introduce check function for btrfs_qgroup_inherit
>> structure and deprecates the following features:
>> 1) limit set
>>    Never utilized by btrfs-progs from the beginning.
>>
>> 2) copy rfer/excl
>>    Although btrfs-progs provides support for it as a hidden,
>>    undocumented feature, it's the easiest way to screw up qgroup
>>    numbers.
>>    And we already have patches wondering around the ML to remove such
>>    support.
>=20
> The deprecation should be done in a few steps. First issue a warning
> that the feature is deprecated and will be removed in release X. Then
> wait until somebody complains (or not) and remove the code in release X=
=2E
>=20
> The X is something like 4.22, ie. at least 2 cycles after the
> deprecation warning is added.

Thanks for the deprecation progress.

However I'm wondering if the "release X" is really needed in the warning
message.
(I may forgot to submit the real deprecation patch for that release).

Thanks,
Qu


--LvqpslaDEqgnPUSpW2bNCIvM2ezypG5fM--

--SvuJYfRdU8pLWDkJVxBVyD2GMLjCN4u1s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluRKtkACgkQwj2R86El
/qgI5AgAmSLji2bpyyHYo+yLYNSEr6qpdyzbBA0LGC31ICL012C1xiQHJdfawrub
dr2qku1HrLL5OFflQLhFp7M0XqKRmXZyPYm+hNccKEic6ga042FP0tTIFbwT1cr+
UMRBrf2TXAU0RcE437Cg26dsRpVysFf7d6/3MJG9Ous6ge4kJoAw7Xj8FHHVc2yD
4Jpk0iSE3eNs0h0ztDAtukCgABosilw9+0ptDi85YiwRLRwfIQ39tDFCOJ6M++m0
bseSJVl6WR0/BUpAKlXYxp9YdLOfQcmXjrjeohB0VX+mfPhOsNz0FLywSBnRgwwY
06q2ZMwibnxBFxFBH6IFeaZLvsKqNQ==
=QytB
-----END PGP SIGNATURE-----

--SvuJYfRdU8pLWDkJVxBVyD2GMLjCN4u1s--
