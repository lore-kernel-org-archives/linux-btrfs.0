Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54267 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbeGLFvW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 01:51:22 -0400
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
To: Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
Date: Thu, 12 Jul 2018 13:43:16 +0800
MIME-Version: 1.0
In-Reply-To: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IMDasJUEwcbmqNsoRJXnNxir39yw52Rct"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IMDasJUEwcbmqNsoRJXnNxir39yw52Rct
Content-Type: multipart/mixed; boundary="zsau56zBQ1XzrcqAzPqtdotDXKPcyxLCk";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <db352d50-ce1b-f5fe-afbb-57bdd322b5fb@gmx.com>
Subject: Re: [DOC] BTRFS Volume operations, Device Lists and Locks all in one
 page
References: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>
In-Reply-To: <4fba8087-ebbe-1d05-1f72-e1683981235e@oracle.com>

--zsau56zBQ1XzrcqAzPqtdotDXKPcyxLCk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8811=E6=97=A5 15:50, Anand Jain wrote:
>=20
>=20
> BTRFS Volume operations, Device Lists and Locks all in one page:
>=20
> Devices are managed in two contexts, the scan context and the mounted
> context. In scan context the threads originate from the btrfs_control
> ioctl and in the mounted context the threads originates from the mount
> point ioctl.
> Apart from these two context, there also can be two transient state
> where device state are transitioning from the scan to the mount context=

> or from the mount to the scan context.
>=20
> Device List and Locks:-
>=20
> =C2=A0Count: btrfs_fs_devices::num_devices
> =C2=A0List : btrfs_fs_devices::devices -> btrfs_devices::dev_list
> =C2=A0Lock : btrfs_fs_devices::device_list_mutex
>=20
> =C2=A0Count: btrfs_fs_devices::rw_devices

So btrfs_fs_devices::num_devices =3D btrfs_fs_devices::rw_devices + RO
devices.

How seed and ro devices are different in this case?


> =C2=A0List : btrfs_fs_devices::alloc_list -> btrfs_devices::dev_alloc_l=
ist
> =C2=A0Lock : btrfs_fs_info::chunk_mutex

At least the chunk_mutex is also shared with chunk allocator, or we
should have some mutex in btrfs_fs_devices other than fs_info.
Right?


>=20
> =C2=A0Lock: set_bit btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
>=20
> FSID List and Lock:-
>=20
> =C2=A0Count : None
> =C2=A0HEAD=C2=A0 : Global::fs_uuids -> btrfs_fs_devices::fs_list
> =C2=A0Lock=C2=A0 : Global::uuid_mutex
>=20
>=20
> After the fs_devices is mounted, the btrfs_fs_devices::opened > 0.

fs_devices::opended should be btrfs_fs_devices::num_devices if no device
is missing and -1 or -2 for degraded case, right?

>=20
> In the scan context we have the following device operations..
>=20
> Device SCAN:-=C2=A0 which creates the btrfs_fs_devices and its correspo=
nding
> btrfs_device entries, also checks and frees the duplicate device entrie=
s.
> Lock: uuid_mutex
> =C2=A0 SCAN
> =C2=A0 if (found_duplicate && btrfs_fs_devices::opened =3D=3D 0)
> =C2=A0=C2=A0=C2=A0=C2=A0 Free_duplicate
> Unlock: uuid_mutex
>=20
> Device READY:- check if the volume is ready. Also does an implicit scan=

> and duplicate device free as in Device SCAN.
> Lock: uuid_mutex
> =C2=A0 SCAN
> =C2=A0 if (found_duplicate && btrfs_fs_devices::opened =3D=3D 0)
> =C2=A0=C2=A0=C2=A0=C2=A0 Free_duplicate
> =C2=A0 Check READY
> Unlock: uuid_mutex
>=20
> Device FORGET:- (planned) free a given or all unmounted devices and
> empty fs_devices if any.
> Lock: uuid_mutex
> =C2=A0 if (found_duplicate && btrfs_fs_devices::opened =3D=3D 0)
> =C2=A0=C2=A0=C2=A0 Free duplicate
> Unlock: uuid_mutex
>=20
> Device mount operation -> A Transient state leading to the mounted cont=
ext
> Lock: uuid_mutex
> =C2=A0Find, SCAN, btrfs_fs_devices::opened++
> Unlock: uuid_mutex
>=20
> Device umount operation -> A transient state leading to the unmounted
> context or scan context
> Lock: uuid_mutex
> =C2=A0 btrfs_fs_devices::opened--
> Unlock: uuid_mutex
>=20
>=20
> In the mounted context we have the following device operations..
>=20
> Device Rename through SCAN:- This is a special case where the device
> path gets renamed after its been mounted. (Ubuntu changes the boot path=

> during boot up so we need this feature). Currently, this is part of
> Device SCAN as above. And we need the locks as below, because the
> dynamic disappearing device might cleanup the btrfs_device::name
> Lock: btrfs_fs_devices::device_list_mutex
> =C2=A0=C2=A0 Rename
> Unlock: btrfs_fs_devices::device_list_mutex
>=20
> Commit Transaction:- Write All supers.
> Lock: btrfs_fs_devices::device_list_mutex
> =C2=A0 Write all super of btrfs_devices::dev_list
> Unlock: btrfs_fs_devices::device_list_mutex
>=20
> Device add:- Add a new device to the existing mounted volume.
> set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
> Lock: btrfs_fs_devices::device_list_mutex
> Lock: btrfs_fs_info::chunk_mutex
> =C2=A0=C2=A0 List_add btrfs_devices::dev_list
> =C2=A0=C2=A0 List_add btrfs_devices::dev_alloc_list
> Unlock: btrfs_fs_info::chunk_mutex
> Unlock: btrfs_fs_devices::device_list_mutex
>=20
> Device remove:- Remove a device from the mounted volume.
> set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
> Lock: btrfs_fs_devices::device_list_mutex
> Lock: btrfs_fs_info::chunk_mutex
> =C2=A0=C2=A0 List_del btrfs_devices::dev_list
> =C2=A0=C2=A0 List_del btrfs_devices::dev_alloc_list
> Unlock: btrfs_fs_info::chunk_mutex
> Unlock: btrfs_fs_devices::device_list_mutex
>=20
> Device Replace:- Replace a device.
> set_bit: btrfs_fs_info::flags::BTRFS_FS_EXCL_OP
> Lock: btrfs_fs_devices::device_list_mutex
> Lock: btrfs_fs_info::chunk_mutex
> =C2=A0=C2=A0 List_update btrfs_devices::dev_list

Here we still just add a new device but not deleting the existing one
until the replace is finished.

> =C2=A0=C2=A0 List_update btrfs_devices::dev_alloc_list
> Unlock: btrfs_fs_info::chunk_mutex
> Unlock: btrfs_fs_devices::device_list_mutex
>=20
> Sprouting:- Add a RW device to the mounted RO seed device, so to make
> the mount point writable.
> The following steps are used to hold the seed and sprout fs_devices.
> (first two steps are not necessary for the sprouting, they are there to=

> ensure the seed device remains scanned, and it might change)
> . Clone the (mounted) fs_devices, lets call it as old_devices
> . Now add old_devices to fs_uuids (yeah, there is duplicate fsid in the=

> list but we change the other fsid before we release the uuid_mutex, so
> its fine).
>=20
> . Alloc a new fs_devices, lets call it as seed_devices
> . Copy fs_devices into the seed_devices
> . Move fs_deviecs devices list into seed_devices
> . Bring seed_devices to under fs_devices (fs_devices->seed =3D seed_dev=
ices)
> . Assign a new FSID to the fs_devices and add the new writable device t=
o
> the fs_devices.
>=20
> In the unmounted context the fs_devices::seed is always NULL.
> We alloc the fs_devices::seed only at the time of mount and or at
> sprouting. And free at the time of umount or if the seed device is
> replaced or deleted.
>=20
> Locks: Sprouting:
> Lock: uuid_mutex <-- because fsid rename and Device SCAN
> Reuses Device Add code
>=20
> Locks: Splitting: (Delete OR Replace a seed device)
> uuid_mutex is not required as fs_devices::seed which is local to
> fs_devices is being altered.
> Reuses Device replace code
>=20
>=20
> Device resize:- Resize the given volume or device.
> Lock: btrfs_fs_info::chunk_mutex
> =C2=A0=C2=A0 Update
> Unlock: btrfs_fs_info::chunk_mutex
>=20
>=20
> (Planned) Dynamic Device missing/reappearing:- A missing device might
> reappear after its volume been mounted, we have the same btrfs_control
> ioctl which does the scan of the reappearing device but in the mounted
> context. In the contrary a device of a volume in a mounted context can
> go missing as well, and still the volume will continue in the mounted
> context.
> Missing:
> Lock: btrfs_fs_devices::device_list_mutex
> Lock: btrfs_fs_info::chunk_mutex
> =C2=A0 List_del: btrfs_devices::dev_alloc_list
> =C2=A0 Close_bdev
> =C2=A0 btrfs_device::bdev =3D=3D NULL
> =C2=A0 btrfs_device::name =3D NULL
> =C2=A0 set_bit BTRFS_DEV_STATE_MISSING
> =C2=A0 set_bit BTRFS_VOL_STATE_DEGRADED
> Unlock: btrfs_fs_info::chunk_mutex
> Unlock: btrfs_fs_devices::device_list_mutex
>=20
> Reappearing:
> Lock: btrfs_fs_devices::device_list_mutex
> Lock: btrfs_fs_info::chunk_mutex
> =C2=A0 Open_bdev
> =C2=A0 btrfs_device::name =3D PATH
> =C2=A0 clear_bit BTRFS_DEV_STATE_MISSING
> =C2=A0 clear_bit BTRFS_VOL_STATE_DEGRADED
> =C2=A0 List_add: btrfs_devices::dev_alloc_list
> =C2=A0 set_bit BTRFS_VOL_STATE_RESILVERING
> =C2=A0 kthread_run HEALTH_CHECK

For this part, I'm planning to add scrub support for certain generation
range, so just scrub for certain block groups which is newer than the
last generation of the re-appeared device should be enough.

However I'm wondering if it's possible to reuse btrfS_balance_args, as
we really have a lot of similarity when specifying block groups to
relocate/scrub.

Any idea on this?

Thanks,
Qu

> Unlock: btrfs_fs_info::chunk_mutex
> Unlock: btrfs_fs_devices::device_list_mutex
>=20
> -----------------------------------------------------------------------=

>=20
> Thanks, Anand
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--zsau56zBQ1XzrcqAzPqtdotDXKPcyxLCk--

--IMDasJUEwcbmqNsoRJXnNxir39yw52Rct
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltG6nQACgkQwj2R86El
/qh5xAf/UzAAhE7AM2FmflzqUD8HJt9OFYjYZ5lJ6/QGZSyIWtPkApBPPACYMIKp
EY9IMi4B6uJ1qT4t83ytg0FTUCmPB6XzSoemFWvZ20cKjApxXCKRi1qXmTouGRv1
yFOpWdZkDigfJKyavZyVMus1IOkwnxyb8VUhgr4n5rdxhYSKx8YnaQsjoVXyJlmU
lh5xkdX6khaMtMI3CG4wb1zQ0x18SgR5tAakChQlXPY+wqF+cPdGjWJEri+0P2wS
UkwQkthZVbolziny4LNZ9dJXOtFXouNe7JbBly1z1E80VYOoH37Kqb0ooQkZ7H2h
L+FVbZZ1WbcJTeugcv6SQ7XtmjK9gQ==
=CaxX
-----END PGP SIGNATURE-----

--IMDasJUEwcbmqNsoRJXnNxir39yw52Rct--
