Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:54673 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbeGLNJR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 09:09:17 -0400
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
To: Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
Date: Thu, 12 Jul 2018 20:59:35 +0800
MIME-Version: 1.0
In-Reply-To: <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GYbKrfkRxNq8oyk7S5T2P43WfbQwVWBWp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GYbKrfkRxNq8oyk7S5T2P43WfbQwVWBWp
Content-Type: multipart/mixed; boundary="WP3fRPPYC2xuPkeOUOcTCHmqJ8vY7BL8O";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <e968020c-f68a-16f2-521b-6aaa08e9d654@gmx.com>
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
 <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
 <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>
In-Reply-To: <49fc4dbb-5e02-ab13-d7f1-7e52bf8868d6@oracle.com>

--WP3fRPPYC2xuPkeOUOcTCHmqJ8vY7BL8O
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8812=E6=97=A5 20:33, Anand Jain wrote:
>=20
>=20
> On 07/12/2018 01:43 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B407=E6=9C=8811=E6=97=A5 15:50, Anand Jain wrote:
>>>
>>>
>>> BTRFS Volume operations, Device Lists and Locks all in one page:
>>>
>>> Devices are managed in two contexts, the scan context and the mounted=

>>> context. In scan context the threads originate from the btrfs_control=

>>> ioctl and in the mounted context the threads originates from the moun=
t
>>> point ioctl.
>>> Apart from these two context, there also can be two transient state
>>> where device state are transitioning from the scan to the mount conte=
xt
>>> or from the mount to the scan context.
>>>
>>> Device List and Locks:-
>>>
>>> =C2=A0=C2=A0Count: btrfs_fs_devices::num_devices
>>> =C2=A0=C2=A0List : btrfs_fs_devices::devices -> btrfs_devices::dev_li=
st
>>> =C2=A0=C2=A0Lock : btrfs_fs_devices::device_list_mutex
>>>
>>> =C2=A0=C2=A0Count: btrfs_fs_devices::rw_devices
>>
>> So btrfs_fs_devices::num_devices =3D btrfs_fs_devices::rw_devices + RO=

>> devices.
>> How seed and ro devices are different in this case?
>=20
> =C2=A0Given:
> =C2=A0btrfs_fs_devices::total_devices =3D btrfs_super_num_devices(disk_=
super);
>=20
> =C2=A0Consider no missing devices, no replace target, no seeding. Then,=

> =C2=A0=C2=A0 btrfs_fs_devices::total_devices =3D=3D btrfs_fs_devices::n=
um_devices
>=20
> =C2=A0And in case of seeding.
> =C2=A0=C2=A0 btrfs_fs_devices::total_devices=C2=A0 =3D=3D (btrfs_fs_dev=
ices::num_devices +
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_fs_devices::seed::total_dev=
ices
>=20
> =C2=A0=C2=A0 All devices in the list [1] are RW/Sprout
> =C2=A0=C2=A0=C2=A0=C2=A0 [1] fs_info::btrfs_fs_devices::devices
> =C2=A0=C2=A0 All devices in the list [2] are RO/Seed
> =C2=A0=C2=A0=C2=A0=C2=A0 [2] fs_info::btrfs_fs_devices::seed::devices
>=20
>=20
> =C2=A0Thanks for asking will add this part to the doc.

Another question is, what if a device is RO but not seed?

E.g. loopback device set to RO.
IMHO it won't be mounted RW for single device case, but not sure for
multi device case.

>=20
>=20
>>
>>> =C2=A0=C2=A0List : btrfs_fs_devices::alloc_list -> btrfs_devices::dev=
_alloc_list
>>> =C2=A0=C2=A0Lock : btrfs_fs_info::chunk_mutex
>>
>> At least the chunk_mutex is also shared with chunk allocator,
>=20
> =C2=A0Right.
>=20
>> or we
>> should have some mutex in btrfs_fs_devices other than fs_info.
>> Right?
>=20
> =C2=A0More locks? no. But some of the locks-and-flags are wrongly
> =C2=A0belong to fs_info instead it should have been in fs_devices.
> =C2=A0When the dust settles planning to propose to migrate them
> =C2=A0to fs_devices.

OK, migrating to fs_devices looks good to me then.

>=20
>>> =C2=A0=C2=A0Lock: set_bit btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
>>>
>>> FSID List and Lock:-
>>>
>>> =C2=A0=C2=A0Count : None
>>> =C2=A0=C2=A0HEAD=C2=A0 : Global::fs_uuids -> btrfs_fs_devices::fs_lis=
t
>>> =C2=A0=C2=A0Lock=C2=A0 : Global::uuid_mutex
>>>
>>>
>>> After the fs_devices is mounted, the btrfs_fs_devices::opened > 0.
>>
>> fs_devices::opended should be btrfs_fs_devices::num_devices if no devi=
ce
>> is missing and -1 or -2 for degraded case, right?
>=20
> =C2=A0No. I think you are getting confused with
> =C2=A0=C2=A0=C2=A0 btrfs_fs_devices::open_devices
>=20
> =C2=A0btrfs_fs_devices::opened
> =C2=A0 indicate how many times the volume is opened. And in reality it =
would
> =C2=A0stay at 1 always. (except for a short duration of time during
> =C2=A0subsequent subvol mount).

Thanks, this makes sense.

>=20
>=20
>>> In the scan context we have the following device operations..
>>>
>>> Device SCAN:-=C2=A0 which creates the btrfs_fs_devices and its corres=
ponding
>>> btrfs_device entries, also checks and frees the duplicate device
>>> entries.
>>> Lock: uuid_mutex
>>> =C2=A0=C2=A0 SCAN
>>> =C2=A0=C2=A0 if (found_duplicate && btrfs_fs_devices::opened =3D=3D 0=
)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Free_duplicate
>>> Unlock: uuid_mutex
>>>
>>> Device READY:- check if the volume is ready. Also does an implicit sc=
an
>>> and duplicate device free as in Device SCAN.
>>> Lock: uuid_mutex
>>> =C2=A0=C2=A0 SCAN
>>> =C2=A0=C2=A0 if (found_duplicate && btrfs_fs_devices::opened =3D=3D 0=
)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Free_duplicate
>>> =C2=A0=C2=A0 Check READY
>>> Unlock: uuid_mutex
>>>
>>> Device FORGET:- (planned) free a given or all unmounted devices and
>>> empty fs_devices if any.
>>> Lock: uuid_mutex
>>> =C2=A0=C2=A0 if (found_duplicate && btrfs_fs_devices::opened =3D=3D 0=
)
>>> =C2=A0=C2=A0=C2=A0=C2=A0 Free duplicate
>>> Unlock: uuid_mutex
>>>
>>> Device mount operation -> A Transient state leading to the mounted
>>> context
>>> Lock: uuid_mutex
>>> =C2=A0=C2=A0Find, SCAN, btrfs_fs_devices::opened++
>>> Unlock: uuid_mutex
>>>
>>> Device umount operation -> A transient state leading to the unmounted=

>>> context or scan context
>>> Lock: uuid_mutex
>>> =C2=A0=C2=A0 btrfs_fs_devices::opened--
>>> Unlock: uuid_mutex
>>>
>>>
>>> In the mounted context we have the following device operations..
>>>
>>> Device Rename through SCAN:- This is a special case where the device
>>> path gets renamed after its been mounted. (Ubuntu changes the boot pa=
th
>>> during boot up so we need this feature). Currently, this is part of
>>> Device SCAN as above. And we need the locks as below, because the
>>> dynamic disappearing device might cleanup the btrfs_device::name
>>> Lock: btrfs_fs_devices::device_list_mutex
>>> =C2=A0=C2=A0=C2=A0 Rename
>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>
>>> Commit Transaction:- Write All supers.
>>> Lock: btrfs_fs_devices::device_list_mutex
>>> =C2=A0=C2=A0 Write all super of btrfs_devices::dev_list
>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>
>>> Device add:- Add a new device to the existing mounted volume.
>>> set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
>>> Lock: btrfs_fs_devices::device_list_mutex
>>> Lock: btrfs_fs_info::chunk_mutex
>>> =C2=A0=C2=A0=C2=A0 List_add btrfs_devices::dev_list
>>> =C2=A0=C2=A0=C2=A0 List_add btrfs_devices::dev_alloc_list
>>> Unlock: btrfs_fs_info::chunk_mutex
>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>
>>> Device remove:- Remove a device from the mounted volume.
>>> set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
>>> Lock: btrfs_fs_devices::device_list_mutex
>>> Lock: btrfs_fs_info::chunk_mutex
>>> =C2=A0=C2=A0=C2=A0 List_del btrfs_devices::dev_list
>>> =C2=A0=C2=A0=C2=A0 List_del btrfs_devices::dev_alloc_list
>>> Unlock: btrfs_fs_info::chunk_mutex
>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>
>>> Device Replace:- Replace a device.
>>> set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
>>> Lock: btrfs_fs_devices::device_list_mutex
>>> Lock: btrfs_fs_info::chunk_mutex
>>> =C2=A0=C2=A0=C2=A0 List_update btrfs_devices::dev_list
>>
>> Here we still just add a new device but not deleting the existing one
>> until the replace is finished.
>=20
> =C2=A0Right I did not elaborate that part. List_update: I meant add/del=
ete
> =C2=A0accordingly.
>=20
>>> =C2=A0=C2=A0=C2=A0 List_update btrfs_devices::dev_alloc_list
>>> Unlock: btrfs_fs_info::chunk_mutex
>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>
>>> Sprouting:- Add a RW device to the mounted RO seed device, so to make=

>>> the mount point writable.
>>> The following steps are used to hold the seed and sprout fs_devices.
>>> (first two steps are not necessary for the sprouting, they are there =
to
>>> ensure the seed device remains scanned, and it might change)
>>> . Clone the (mounted) fs_devices, lets call it as old_devices
>>> . Now add old_devices to fs_uuids (yeah, there is duplicate fsid in t=
he
>>> list but we change the other fsid before we release the uuid_mutex, s=
o
>>> its fine).
>>>
>>> . Alloc a new fs_devices, lets call it as seed_devices
>>> . Copy fs_devices into the seed_devices
>>> . Move fs_deviecs devices list into seed_devices
>>> . Bring seed_devices to under fs_devices (fs_devices->seed =3D
>>> seed_devices)
>>> . Assign a new FSID to the fs_devices and add the new writable device=
 to
>>> the fs_devices.
>>>
>>> In the unmounted context the fs_devices::seed is always NULL.
>>> We alloc the fs_devices::seed only at the time of mount and or at
>>> sprouting. And free at the time of umount or if the seed device is
>>> replaced or deleted.
>>>
>>> Locks: Sprouting:
>>> Lock: uuid_mutex <-- because fsid rename and Device SCAN
>>> Reuses Device Add code
>>>
>>> Locks: Splitting: (Delete OR Replace a seed device)
>>> uuid_mutex is not required as fs_devices::seed which is local to
>>> fs_devices is being altered.
>>> Reuses Device replace code
>>>
>>>
>>> Device resize:- Resize the given volume or device.
>>> Lock: btrfs_fs_info::chunk_mutex
>>> =C2=A0=C2=A0=C2=A0 Update
>>> Unlock: btrfs_fs_info::chunk_mutex
>>>
>>>
>>> (Planned) Dynamic Device missing/reappearing:- A missing device might=

>>> reappear after its volume been mounted, we have the same btrfs_contro=
l
>>> ioctl which does the scan of the reappearing device but in the mounte=
d
>>> context. In the contrary a device of a volume in a mounted context ca=
n
>>> go missing as well, and still the volume will continue in the mounted=

>>> context.
>>> Missing:
>>> Lock: btrfs_fs_devices::device_list_mutex
>>> Lock: btrfs_fs_info::chunk_mutex
>>> =C2=A0=C2=A0 List_del: btrfs_devices::dev_alloc_list
>>> =C2=A0=C2=A0 Close_bdev
>>> =C2=A0=C2=A0 btrfs_device::bdev =3D=3D NULL
>>> =C2=A0=C2=A0 btrfs_device::name =3D NULL
>>> =C2=A0=C2=A0 set_bit BTRFS_DEV_STATE_MISSING
>>> =C2=A0=C2=A0 set_bit BTRFS_VOL_STATE_DEGRADED
>>> Unlock: btrfs_fs_info::chunk_mutex
>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>
>>> Reappearing:
>>> Lock: btrfs_fs_devices::device_list_mutex
>>> Lock: btrfs_fs_info::chunk_mutex
>>> =C2=A0=C2=A0 Open_bdev
>>> =C2=A0=C2=A0 btrfs_device::name =3D PATH
>>> =C2=A0=C2=A0 clear_bit BTRFS_DEV_STATE_MISSING
>>> =C2=A0=C2=A0 clear_bit BTRFS_VOL_STATE_DEGRADED
>>> =C2=A0=C2=A0 List_add: btrfs_devices::dev_alloc_list
>>> =C2=A0=C2=A0 set_bit BTRFS_VOL_STATE_RESILVERING
>>> =C2=A0=C2=A0 kthread_run HEALTH_CHECK
>>
>> For this part, I'm planning to add scrub support for certain generatio=
n
>> range, so just scrub for certain block groups which is newer than the
>> last generation of the re-appeared device should be enough.
>>
>> However I'm wondering if it's possible to reuse btrfS_balance_args, as=

>> we really have a lot of similarity when specifying block groups to
>> relocate/scrub.
>=20
> =C2=A0What you proposed sounds interesting. But how about failed writes=

> =C2=A0at some generation number and not necessarily at the last generat=
ion?

In this case, it depends on when and how we mark the device resilvering.
If we record the generation of write error happens, then just initial a
scrub for generation greater than that generation.

In the list, some guys mentioned that for LVM/mdraid they will record
the generation when some device(s) get write error or missing, and do
self cure.

>=20
> =C2=A0I have been scratching on fix for this [3] for some time now. Tha=
nks
> =C2=A0for the participation. In my understanding we are missing across-=
tree
> =C2=A0parent transid verification at the lowest possible granular OR

Maybe the newly added first_key and level check could help detect such
mismatch?

> =C2=A0other approach is to modify Liubo approach to provide a list of
> =C2=A0degraded chunks but without a journal disk.

Currently, DEV_ITEM::generation is seldom used. (only for seed sprout cas=
e)
Maybe we could reuse that member to record the last successful written
transaction to that device and do above purposed LVM/mdraid style self cu=
re?

Thanks,
Qu

> =C2=A0=C2=A0 [3] https://patchwork.kernel.org/patch/10403311/
>=20
> =C2=A0Further, as we do a self adapting chunk allocation in RAID1, it n=
eeds
> =C2=A0balance-convert to fix. IMO at some point we have to provide degr=
aded
> =C2=A0raid1 chunk allocation and also modify the scrub to be chunk gran=
ular.
>=20
> Thanks, Anand
>=20
>> Any idea on this?
>>
>> Thanks,
>> Qu
>>
>>> Unlock: btrfs_fs_info::chunk_mutex
>>> Unlock: btrfs_fs_devices::device_list_mutex
>>>
>>> ---------------------------------------------------------------------=
--
>>>
>>> Thanks, Anand
>>> --=C2=A0
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.ht=
ml
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--WP3fRPPYC2xuPkeOUOcTCHmqJ8vY7BL8O--

--GYbKrfkRxNq8oyk7S5T2P43WfbQwVWBWp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltHULcACgkQwj2R86El
/qj/IAf9EvtCyth3njrvt0eU2oIvxcEmPL326PJpszyqJ40zEHZQMITaZ1LXDa4B
MvxYCzwIngDMZ7jtEnQEi2kr0c5UFqSaqcFD9ieuhgCabOBJKs0+/GJrE8hD7m/Y
FMxx4hrCTRk53XjHJVURBmhG/ciY6meSLs3CTqCLQt623vf2MA+P1WXNFSQuHN95
YvShVFjrJsDxCICBlHPoVzwUDQr7b+wUPWE92uNOVrwFv3/Hz7TINxOZYeh9iuRa
2t8Qojp+EEfgRurj2ds4FyWxgbwy6c+2uXnWTqroL/EsGHFI7Ech2AooxTfnONZQ
ObrfylLCkEt8yraUNldmN0gRR1FbKA==
=Rmxe
-----END PGP SIGNATURE-----

--GYbKrfkRxNq8oyk7S5T2P43WfbQwVWBWp--
