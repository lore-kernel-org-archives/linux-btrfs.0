From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Why does Btrfs allow raid1 with mismatched drives? Also: How to look behind the curtain
Date: Thu, 5 Jan 2012 11:39:20 +0100
Message-ID: <201201051139.20334.Martin@lichtvoll.de>
References: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com> <20120105094444.GF27122@carfax.org.uk> <DFD486DD-C324-43EE-82BC-87DDCF432DB6@gmail.com> (sfid-20120105_110507_083017_9F92DD8C)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Fabian Zeindl <fabian.zeindl@gmail.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <DFD486DD-C324-43EE-82BC-87DDCF432DB6@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 5. Januar 2012 schrieb Fabian Zeindl:
> On Thursday, January 5, 2012 at 10:44 , Hugo Mills wrote:
> > You should probably read the mis-named "Sysadmin's Guide"
> > on the wiki[1], which explains what btrfs actually does with its
> > replication.
> >=20
> > You should also probably read the FAQ entries on free space[2],
> > since using plain "df" for btrfs is usually misleading.
>=20
> I read both, but it doesn't answer my question on how btrfs behaves
> when it can't actually do a raid1, because there's not enough data on
> an "other" disk for a chunk-copy.

=46rom my reading that Sysadmin Guide answers your question:

BTRFS with RAID-1 will allocate chunks on two devices:

> Btrfs's "RAID" implementation bears only passing resemblance to
> traditional RAID implementations. Instead, btrfs replicates data on a=
=20
> per-chunk basis. If the filesystem is configured to use "RAID-1", for=
=20
> example, chunks are allocated in pairs, with each chunk of the pair=20
> being taken from a different block device. Data written to such a chu=
nk=20
> pair will be duplicated across both chunks.
>=20
> Stripe-based "RAID" levels (RAID-0, RAID-10) work in a similar way,=20
> allocating as many chunks as can fit across the drives with free spac=
e,=20
> and then perform striping of data at a level smaller than a chunk. So=
,=20
> for a RAID-10 filesystem on 4 disks, data may be stored like this:

[=E2=80=A6 quoted from the Wiki page =E2=80=A6]

"Allocating as many chunks as can fit across the drives" is also pretty=
=20
clear to me. So if BTRFS can=C2=B4t allocate a new chunk on two devices=
, its=20
full. To me it seems obvious that BTRFS will not break the RAID-1=20
redundancy guarentee unless a drive fails.

Thus when using a RAID-1 with two devices, the smaller one should defin=
e=20
the maximum capacity of the device. But when you use a RAID-1 with one =
500=20
GB and two 250 GB drives, BTRFS can replicate each chunk on the 500 GB=20
drive on *one* of the both 250 GB drives.

Thus is makes perfect sense to support differently sized drives in a BT=
RFS=20
pool.

My own observations with a RAID-10 across 4 devices support this. I ech=
o=C2=B4d=20
"1" > /sys/block/sdX/delete to remove one harddisk while a dd was runni=
ng=20
to the RAID. BTRFS used the remaining disks. On next reboot all disks=20
where available again. While BTRFS didn=C2=B4t start rebalancing the RA=
ID=20
automatically a btrfs filesystem balance made it fill up the previously=
=20
failed device until all devices had the same usage. This is also descri=
bed=20
in the sysadmin guide: So this is what you have to care for manually. I=
f a=20
drive failed, you have to balance the filesystem so that it creates=20
replicas where they are missing.

Now anyone deeper into BTRFS please check at whether my understanding=20
matches what BTRFS is doing=E2=80=A6

> > You could run a scrub, which will verify all of the data mirrors on
> > the volume, and fix anything that's not redundant.
>=20
> Will this command fail then for example?

No, unless more than the allowed number of disks are failing.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
