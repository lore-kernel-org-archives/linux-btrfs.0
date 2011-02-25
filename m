From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Comparing snapshots?
Date: Fri, 25 Feb 2011 21:08:24 +0100
Message-ID: <4D680C38.10903@libero.it>
References: <20110225095916.GA7609@suse.de> <6D8C263D-FCFC-49EE-AC28-8D821C3340CA@gmail.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?ISO-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6D8C263D-FCFC-49EE-AC28-8D821C3340CA@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/25/2011 08:32 PM, Jo=E3o Eduardo Lu=EDs wrote:
> Hello,
>=20
> Please note that my experience with btrfs is both recent and, above
> all, very small. However, I've been wondering about the same issue
> for a different purpose and your question intrigues me.
>=20
> However, and I may be off-base here, I think that wouldn't be trivial
> to achieve.
>=20
> Even if one would be able to differ the metadata changes between both
> snapshots, the problem would still be present regarding finding the
> changed data. It would be possible to check for changed extents, at
> least by comparing extent checksums, but I don't think it would be
> trivial to discover where (exactly) the extent was modified.

Look at the find-new command. It returns also which part of the file is
changed. I don't remember very well the details, but also the data is
stored in a tree like the metadata. Using the same strategies of
comparing the keys and revid leads to discover which part of the file i=
s
changed, with minimum effort (no checksums comparing is needed).

>=20
> I would recommend using the generation fields, whenever applicable,
> but I believe these are private to each subvolume/snapshot.
>=20
>=20
> Anyway, I wonder if keeping a data structure (I would go with a tree)
> containing metadata regarding the changed files, within the file
> system, could be a plausible solution, but I'm in no condition
> (btrfs-knowledge-wise) to make such statement.
>=20
>=20
> Cheers.
>=20
> --- Jo=E3o Eduardo Lu=EDs gpg key: 477C26E5 from pool.keyserver.eu
>=20
>=20
>=20
>=20
>=20
> On Feb 25, 2011, at 9:59 AM, Arvin Schnell wrote:
>=20
>> Hi,
>>=20
>> for a backup program I have to find all differing files (including
>> metadata) in two snapshots taken from the same subvolume.
>>=20
>> Having looked at the find-new command I thought about this=20
>> process:
>>=20
>> 1. Get the two transids when the two snapshots were created.
>>=20
>> 2. Query modifications to the original subvolume between the two=20
>> transids.
>>=20
>> Is the general process corrent or have I overseen something?
>>=20
>> AFAIS the btrfs tool does not provide the required=20
>> information/commands. Would it be possible to add those?
>>=20
>> Thanks in advance, Arvin
>>=20
>> -- Arvin Schnell, <aschnell@suse.de> Senior Software Engineer,
>> Research & Development SUSE LINUX Products GmbH, GF: Markus Rex,
>> HRB 16746 (AG N=FCrnberg) -- To unsubscribe from this list: send the
>> line "unsubscribe linux-btrfs" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
