From: Arne Jansen <sensille@gmx.net>
Subject: Re: Quota Implementation
Date: Sat, 04 Jun 2011 08:36:22 +0200
Message-ID: <4DE9D266.7000403@gmx.net>
References: <4DE90AC9.5040106@gmx.net> <20110603164730.GB10842@carfax.org.uk> <BANLkTikaEpiDucHfTALmh=Ndsf-j=dwSJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Hugo Mills <hugo@carfax.org.uk>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>, hch@infradead.org,
	ricwheeler@gmail.com
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikaEpiDucHfTALmh=Ndsf-j=dwSJA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03.06.2011 22:44, Andrey Kuzmin wrote:
> On Fri, Jun 3, 2011 at 8:47 PM, Hugo Mills<hugo@carfax.org.uk>  wrote:
>> On Fri, Jun 03, 2011 at 06:24:41PM +0200, Arne Jansen wrote:
>>> Hi,
>>>
>>> If no one is already working on it, I'd like to take the Quota lock and
>>> see how far I come.
>>> Let me sketch out in short what I'm planning to do:
>>>
>>>   - Quota will be subvolume based. Only the FS-trees and data extents
>>>     will be accounted.
>>>   - Quota Groups can be defined. Every quota group can comprise any
>>>     number of subvolumes. A subvolume can be assigned to any number
>>>     of quota groups.
>>>   - A Quota Group can account/limit the total amount of space that is
>>>     referenced by it and/or the amount of space that is exclusively
>>>     referenced (i.e. referenced by no other quota group).
>>>   - With this it is possible to define a hierarchical quota that need
>>>     not necessarily reflect the filesystem hierarchy.
>>>   - It is also possible to decide for each snapshot if it should be
>>>     accounted into the parent group. So in a scenario where each
>>>     subvolume reflect a user home, it's possible to have some snapshots
>>>     accounted to the user and others not (e.g. the ones needed for system
>>>     backups).
>>>   - Quota information will be stored in new records, possibly in a
>>>     separate tree.
>>>   - It should be possible to change the Quota config and group
>>>     assignments online, though this might need a full re-scan of the fs.
>>>   - It does NOT include any kind of user/group (UID/GID) quota.
>>>
>>> Any addenda or arguments why it's impossible or insane welcome.
>>
>>    There's a problem in that in some cases, it's possible to get into
>> a situation where you can't *delete* files because you're going over
>> quota. If I have two subvolumes that share most of their data
>> (e.g. one is a snapshot of the other), and both subvolumes have a
>> limit under the "exclusive use" clause, then deleting material from
>> subvolume A could cause subvolume B to go over quota.
>>
>>    If users can create their own subvolumes, then using the "exclusive
>> use" form is also pointless, because as a user, I can simply snapshot
>> (or otherwise CoW copy) all my data into a snapshot, and I then don't
>> pay for it. That one probably comes under the "admin shot himself in
>> the foot", though.
>>
>>    Getting out the bike-shed brush, I might suggest the use of some
>> name other than "quota", because inevitably people will think of
>> UID/GID-type quotas, and we've got enough confusingly-modified
>> terminology already. "Size bounds", "storage bounds", possibly?
>
> Budget :)?

I wouldn't bother trying to coin a new term. Quota is already widely
in use for non-UID style quotas. ZFS has Filesystem Quotas, NetApp has
Tree Quotas (well, originally Quota Trees). So with calling them
Subvolume Quotas or Subvol Quotas I feel comfortable. This is distinct
enough from "User Quota".

-Arne

>
> Regards,
> Andrey
>
>>
>>    Hugo.
>>
>> --
>> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>>          --- Is it true that "last known good" on Windows XP ---
>>                             boots into CP/M?
>>
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.4.10 (GNU/Linux)
>>
>> iD8DBQFN6RAiIKyzvlFcI40RAkkQAKCAulO65dL1F/vaO7W20qJEAKuonwCghfvH
>> XlliA+eCfmLmP/G0quVALe0=
>> =m513
>> -----END PGP SIGNATURE-----
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

