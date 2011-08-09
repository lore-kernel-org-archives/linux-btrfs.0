From: Josef Bacik <josef@redhat.com>
Subject: Re: =?UTF-8?B?4oCcYmlvIHRvbyBiaWfigJ0gcmVncmVzc2lvbiBhbmQgc2lsZW4=?=
 =?UTF-8?B?dCBkYXRhIGNvcnJ1cHRpb24gaW4gMy4w?=
Date: Tue, 09 Aug 2011 10:01:20 -0400
Message-ID: <4E413DB0.7050404@redhat.com>
References: <orwreobtuf.fsf@livre.localdomain> <orty9r5m88.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <orty9r5m88.fsf@livre.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/08/2011 10:53 PM, Alexandre Oliva wrote:
> On Aug  7, 2011, Alexandre Oliva <oliva@lsd.ic.unicamp.br> wrote:
>=20
>> 2. Removing a partition from the filesystem (say, the external disk)
>> didn't relocate =E2=80=9Csingle=E2=80=9D block groups as such to oth=
er disks, as
>> expected.
>=20
> /me reads some code and resets expectations about RAID0 in btrfs ;-)
>=20
> update_block_group_flags is what does this.  It doesn't care what was
> chosen when the filesystem was created, it just forces RAID0 if more
> than 1 disk remains:
>=20
> 		/* turn single device chunks into raid0 */
> 		return stripped | BTRFS_BLOCK_GROUP_RAID0;
>=20
> Is this really intended?  Given my current understanding that RAID0
> doesn't mean striping over all disks, but only over two disks, I gues=
s I
> might even be interested in it, but...  I still think the user's choi=
ce
> should be honored, but I don't see where the choice is stored (if it =
is
> at all).

Well -m single -d single means that we only have one disk and we don't
want duplication (usually one just does -m single since metadata is the
only thing duplicated by default).  But if you add more disks we want t=
o
do RAID0 as we should be stripping across all the devices in the fs.

>=20
>=20
>> I wonder, why can't btrfs mark at least mounted partitions as busy, =
in
>> much the same way that swap, md and various filesystems do, to avoid
>> such accidental reuses?
>=20
> Heh.  And *unmark* them when they're removed, too...  As in, it won't
> let me create a new filesystem in a partition that was just removed f=
rom
> a filesystem, if that was the partition listed in /etc/mtab.
>=20

Yeah our "what is busy" thing should be a little smarter.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
