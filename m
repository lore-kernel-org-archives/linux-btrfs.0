From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: Quota Implementation
Date: Sat, 4 Jun 2011 00:44:54 +0400
Message-ID: <BANLkTikaEpiDucHfTALmh=Ndsf-j=dwSJA@mail.gmail.com>
References: <4DE90AC9.5040106@gmx.net> <20110603164730.GB10842@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>, Arne Jansen <sensille@gmx.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>, hch@infradead.org,
	ricwheeler@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110603164730.GB10842@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 3, 2011 at 8:47 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Jun 03, 2011 at 06:24:41PM +0200, Arne Jansen wrote:
>> Hi,
>>
>> If no one is already working on it, I'd like to take the Quota lock =
and
>> see how far I come.
>> Let me sketch out in short what I'm planning to do:
>>
>> =C2=A0- Quota will be subvolume based. Only the FS-trees and data ex=
tents
>> =C2=A0 =C2=A0will be accounted.
>> =C2=A0- Quota Groups can be defined. Every quota group can comprise =
any
>> =C2=A0 =C2=A0number of subvolumes. A subvolume can be assigned to an=
y number
>> =C2=A0 =C2=A0of quota groups.
>> =C2=A0- A Quota Group can account/limit the total amount of space th=
at is
>> =C2=A0 =C2=A0referenced by it and/or the amount of space that is exc=
lusively
>> =C2=A0 =C2=A0referenced (i.e. referenced by no other quota group).
>> =C2=A0- With this it is possible to define a hierarchical quota that=
 need
>> =C2=A0 =C2=A0not necessarily reflect the filesystem hierarchy.
>> =C2=A0- It is also possible to decide for each snapshot if it should=
 be
>> =C2=A0 =C2=A0accounted into the parent group. So in a scenario where=
 each
>> =C2=A0 =C2=A0subvolume reflect a user home, it's possible to have so=
me snapshots
>> =C2=A0 =C2=A0accounted to the user and others not (e.g. the ones nee=
ded for system
>> =C2=A0 =C2=A0backups).
>> =C2=A0- Quota information will be stored in new records, possibly in=
 a
>> =C2=A0 =C2=A0separate tree.
>> =C2=A0- It should be possible to change the Quota config and group
>> =C2=A0 =C2=A0assignments online, though this might need a full re-sc=
an of the fs.
>> =C2=A0- It does NOT include any kind of user/group (UID/GID) quota.
>>
>> Any addenda or arguments why it's impossible or insane welcome.
>
> =C2=A0 There's a problem in that in some cases, it's possible to get =
into
> a situation where you can't *delete* files because you're going over
> quota. If I have two subvolumes that share most of their data
> (e.g. one is a snapshot of the other), and both subvolumes have a
> limit under the "exclusive use" clause, then deleting material from
> subvolume A could cause subvolume B to go over quota.
>
> =C2=A0 If users can create their own subvolumes, then using the "excl=
usive
> use" form is also pointless, because as a user, I can simply snapshot
> (or otherwise CoW copy) all my data into a snapshot, and I then don't
> pay for it. That one probably comes under the "admin shot himself in
> the foot", though.
>
> =C2=A0 Getting out the bike-shed brush, I might suggest the use of so=
me
> name other than "quota", because inevitably people will think of
> UID/GID-type quotas, and we've got enough confusingly-modified
> terminology already. "Size bounds", "storage bounds", possibly?

Budget :)?

Regards,
Andrey

>
> =C2=A0 Hugo.
>
> --
> =3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.=
org.uk =3D=3D=3D
> =C2=A0PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.=
org.uk
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 --- Is it true that "last known good" on =
Windows XP ---
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0boots into CP/M?
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iD8DBQFN6RAiIKyzvlFcI40RAkkQAKCAulO65dL1F/vaO7W20qJEAKuonwCghfvH
> XlliA+eCfmLmP/G0quVALe0=3D
> =3Dm513
> -----END PGP SIGNATURE-----
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
