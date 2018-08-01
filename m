Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:34577 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731999AbeHADHE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 23:07:04 -0400
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Thomas Leister <thomas.leister@mailbox.org>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <80e77411-2905-46a9-a5b1-fbbbb824dbf5@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f427597d-c51b-f563-8954-cd61f0eeb422@gmx.com>
Date: Wed, 1 Aug 2018 09:23:45 +0800
MIME-Version: 1.0
In-Reply-To: <80e77411-2905-46a9-a5b1-fbbbb824dbf5@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ztp4SIhQH3HxTEUAZoPcnW1as6UdUbW2i"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ztp4SIhQH3HxTEUAZoPcnW1as6UdUbW2i
Content-Type: multipart/mixed; boundary="e4wWR8bht5crDgjBV2IikWfNjuV3PkRrw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 Thomas Leister <thomas.leister@mailbox.org>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
Message-ID: <f427597d-c51b-f563-8954-cd61f0eeb422@gmx.com>
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <80e77411-2905-46a9-a5b1-fbbbb824dbf5@gmail.com>
In-Reply-To: <80e77411-2905-46a9-a5b1-fbbbb824dbf5@gmail.com>

--e4wWR8bht5crDgjBV2IikWfNjuV3PkRrw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B408=E6=9C=8801=E6=97=A5 00:03, Austin S. Hemmelgarn wrote:=

> On 2018-07-31 10:32, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8831=E6=97=A5 21:49, Thomas Leister wrote:
>>> Dear David,
>>> hello everyone,
>>>
>>> during a recent project of mine involving LXD and BTRFS I found out t=
hat
>>> quotas on BTRFS subvolumes are enforced, but file system usage and
>>> limits set via quotas are not reported correctly in LXC containers.
>>>
>>> I've found this discussion regarding my problem:
>>> https://github.com/lxc/lxd/issues/2180
>>
>> That's not the expected usage of btrfs qgroup/quota.
>>
>> Quota only accounts how many bytes are used exclusively or shared
>> between subvolumes at extent level.
>>
>>>
>>> There was already a proposal to introduce subvolume quota support som=
e
>>> time ago:
>>> https://marc.info/?l=3Dlinux-btrfs&m=3D147576434114415&w=3D2
>>
>> It's in fact impossible if I didn't miss something.
>>
>> There are several technical problems in the proposal:
>>
>> 1) Multi-level qgroups
>> =C2=A0=C2=A0=C2=A0 The real limit is limited by all related qgroups, i=
ncluding higher
>> =C2=A0=C2=A0=C2=A0 level qgroup.
>> =C2=A0=C2=A0=C2=A0 Such design makes it pretty hard to calculation the=
 real limit.
>>
>> 2) Different limitations on exclusive/shared bytes
>> =C2=A0=C2=A0=C2=A0 Btrfs can set different limit on exclusive/shared b=
ytes, further
>> =C2=A0=C2=A0=C2=A0 complicating the problem.
>>
>> 3) Btrfs quota only accounts data/metadata used by the subvolume
>> =C2=A0=C2=A0=C2=A0 It lacks all the shared trees (mentioned below), an=
d in fact such
>> =C2=A0=C2=A0=C2=A0 shared tree can be pretty large (especially for ext=
ent tree and csum
>> =C2=A0=C2=A0=C2=A0 tree).
>> =C2=A0=C2=A0=C2=A0 Only accounting quota limit would hit real ENOSPC e=
asily IMHO.
>>
>>>
>>> @David as I've seen your response on that topic on the mailing list,
>>> maybe you can tell me if there are any plans to support correct
>>> subvolume quota reporting e.g. for "df -h" calls from within a
>>> container? Maybe there's already something on your / SUSE's roadmap? =
:-)
>>>
>>> As more and more container environments spin up these days, there mig=
ht
>>> be a growing demand on that :-) Personally I'd really appreciate if I=

>>> could read the current file system usage and limit from within a
>>> container using BTRFS as storage backend.
>>
>> For current btrfs design, I think it's skeptical to implement such
>> design.
>> The main problem here is, btrfs doesn't do the full LVM work. (unlike
>> ZFS IIRC)
>> It doesn't really manage multiple volumes, that's why it's called
>> subvolume in btrfs.
> ZFS quotas work the way they do not because it's trivial to implement
> them that way due to the underlying implementation, but because they
> provide the functionality that people actually want.=C2=A0 Being able t=
o put
> proper hard limits on space usage for a given volume/subvolume/dataset
> is _critical_ for a large number of enterprise deployment scenarios.
> Same goes for being able to put a fixed space reservation for a given
> volume/subvolume/dataset.=C2=A0 If we want to even remotely compete (an=
d it
> sure seems like we do), we need equivalent features that work
> intuitively for _regular_ people (not those who have intimate
> understandings of the internal workings of BTRFS).

Then, the design and use case of btrfs quota itself needs to be reworked
from the the very beginning.
At least get rid of the high level qgroups and exclusive/reference limit.=


Or there will be no way to report in df using that 2 limits.

Thanks,
Qu

>=20
>> A subvolume is not a fully usable fs, it's just a subset of a full fs.=

>> It relies on all the other trees (root tree, extent tree, chunk tree,
>> csum tree, and quota tree in this case) to do all the work.
> A ZFS dataset isn't a fully usable FS either.=C2=A0 It's still dependen=
t on
> all the underlying infrastructure from the zpool itself (and so are
> zvols), which, in fact, does a vast majority of the work.=C2=A0 The
> difference here is that a ZFS dataset is far more self-contained than a=

> BTRFS subvolume.=C2=A0 If we ever want sane per-subvolume storage profi=
les or
> mount options, we're going to need to get a lot closer to that anyway.
>=20
>> Thus it's pretty hard to implement such special purposed df call.
> To implement it perfectly maybe.=C2=A0 Except most applications don't n=
eed it
> to be perfect, they want to know how much space they can actually use.
> Even a trivial blatantly imperfect implementation that just shows you
> the total space that can be used and how much is used based on quotas
> will give better behavior that the current case of just hiding the
> quotas behind a root-only call.=C2=A0 Pretty much anything which does i=
t's
> own disk usage management is currently broken on BTRFS when quotas are
> being used.=C2=A0 Just reporting the quota for the total space, and the=
 space
> accounted to the subvolume by the quota would fix almost all such
> applications.
>>
>> On the other hand, isn't easier to implement special interface for
>> container to get real disk usage/limit other than using the old vanill=
a
>> df interface?
> This isn't just an issue for containers.=C2=A0 Anybody who is using quo=
tas
> like they are typically used in ZFS deployments has the same issue, and=

> there _ARE_ people doing that (see for example OpenSUSE, where they are=

> using quotas (if they are enabled because of snapshot support) to limit=

> space consumption of paths like /tmp).
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--e4wWR8bht5crDgjBV2IikWfNjuV3PkRrw--

--Ztp4SIhQH3HxTEUAZoPcnW1as6UdUbW2i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlthC6EACgkQwj2R86El
/qijZggAq+Hhn+ntbEFWjGrMChDCNWBaFvkl9VuM5mOk/2pO7nkMPbaGfY/n6Lms
Ogw9W822La5d88pybLPHRO4u51V9K/BKW7nVEenpVwXSuoNf/AFss1Vhr1i1sZaH
mXSxGvoscFXd/4sAEA3MngwXSZsogdvWO2VJu3nfk8grMasXN4nPfT3bgDxTEqj8
yMaFvyno7JZkY0X9H/pjCxQ7FyBgKiTS3QfNOA+47qg9/+tdkecWnl/V8EDn8ofc
lgGGnjR1xq7/pR/y0R+cGFPGmLHYS373/MbBKfbXUIEmFS/v9bwwiQQbVESCNW3j
ip8iuDvgPHIGVuPzu0rA0+8mC+qZJA==
=Sf9V
-----END PGP SIGNATURE-----

--Ztp4SIhQH3HxTEUAZoPcnW1as6UdUbW2i--
