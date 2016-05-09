Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbcEIBdh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 May 2016 21:33:37 -0400
Subject: Re: [PATCH] btrfs-progs: udev: add rules for dm devices
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6ddc2c5c-42df-e7ca-daff-8848cbc3d9e9@suse.com>
 <572EC7D7.8040608@gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <572FE8E5.9060106@suse.com>
Date: Sun, 8 May 2016 21:33:25 -0400
MIME-Version: 1.0
In-Reply-To: <572EC7D7.8040608@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mdRDCU0nnrQjGcUoR0WeSNqnp1MH8TeJF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mdRDCU0nnrQjGcUoR0WeSNqnp1MH8TeJF
Content-Type: multipart/mixed; boundary="vDSQwhrvE3wqWajeOcI2qFc5OHM9DTjwc"
From: Jeff Mahoney <jeffm@suse.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <572FE8E5.9060106@suse.com>
Subject: Re: [PATCH] btrfs-progs: udev: add rules for dm devices
References: <6ddc2c5c-42df-e7ca-daff-8848cbc3d9e9@suse.com>
 <572EC7D7.8040608@gmail.com>
In-Reply-To: <572EC7D7.8040608@gmail.com>

--vDSQwhrvE3wqWajeOcI2qFc5OHM9DTjwc
Content-Type: multipart/mixed;
 boundary="------------040707000201040408040207"

This is a multi-part message in MIME format.
--------------040707000201040408040207
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 5/8/16 1:00 AM, Andrei Borzenkov wrote:
> 06.05.2016 22:27, Jeff Mahoney =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> Systemd's btrfs rule runs btrfs dev ready on each device
>> as it's discovered.  The btrfs command is executed as a builtin
>> command via an IMPORT{builtin} rule, which means it gets
>> executed at rule evaluation time, not rule execution time.  That
>> means that the device mapper links haven't been setup yet and the only=

>> nodes that can be depended upon are /dev/dm-#.  That we see
>> /dev/mapper/name names in /proc/mounts is only because we replace the
>> device name we have cached with the one passed in via mount.  If
>> we have a multi-device file system and the primary device is removed,
>> the remaining devices will show /dev/dm-#.  In addition, if the
>=20
> And I still do not understand why it is bad while /dev/sd#n is good.

The dm-# names are for in-kernel use because the major:minor mappings
don't change but the tables host upon them can be changed to a
completely different mapping without tearing down the device. This is
different behavior than sd#n, which will maintain the same mapping for
lifetime of the device.

Both device mapper and util-linux treat these names as preferred names.
 They're used by mount.  The links are created by device mapper.
Always.  These aren't "arbitrary" names as you insist on calling them.
The are the de facto official names for device mapper devices.

If you use any file system to mount using e.g. LVM's /dev/vg/lv, it will
appear in 'mount' or /proc/mounts as /dev/mapper/vg-lv.  If you use any
file system mount using multipath names, they will similarly appear in
'mount' or /proc/mounts as /dev/mapper/wwid-part#.  It's the same for
dm-crypt, dm-raid, and literally every other device mapper mapping.
There may be other convenience links but these are the names that the
device mapper userspace, which configures everything surrounding device
mapper, uses and expects to exist.

This is different for btrfs.  Every other file system just uses the name
as passed in via the mount command.  Btrfs does too for the first device
and for any devices added from the command line as opposed to being
discovered as long as there are no change events on the block device.
Once that change event comes in or a device is removed to reveal one of
the discovered devices, it reverts to the dm-# names as provided by the
initial udev rule.

That is a *clear* user-visible inconsistency that is easily
reproducible.  That's why it's an issue that needs to be resolved.

That you think that the dm-# names should be used everywhere is an
opinion shared far too late.  The /dev/mapper names are used everywhere
and we need to resolve this inconsistency.  The solution is *not* to fly
in the face of years of user experience and change everything /else/ to
use dm-#.

>> +# Once the device mapper symlink is created, tell btrfs about it
>> +# so we get the friendly name in /proc/mounts (and tools that read it=
)
>> +ENV{DM_NAME}=3D=3D"?*", TEST=3D=3D"/dev/mapper/$env{DM_NAME}", RUN{bu=
iltin}+=3D"btrfs ready /dev/mapper/$env{DM_NAME}"
>> +
>=20
> That won't work for the very first event (presumably "add"). /dev/mappe=
r
> link is created only after all rules have been processed, so it will
> always evaluate to false.

Yep, I missed that in my test after adding it.  I'd focused on the
partprobe portion of it after adding that rule.  Removing the TEST=3D=3D
section is safe and results in the correct behavior.  If the link
doesn't exist at that point, device mapper userspace is broken.

An easy test is attached.  If the before and after are different, that's
the problem.  My results, in both modes, without the rule change look
like this:

Before
/dev/mapper/testvg1-lvtest
/dev/mapper/testvg2-lvtest
After
/dev/dm-1
/dev/mapper/testvg1-lvtest

=2E.. and after the rule change:

Before
/dev/mapper/testvg1-lvtest
/dev/mapper/testvg2-lvtest
After
/dev/mapper/testvg1-lvtest
/dev/mapper/testvg2-lvtest

-Jeff

--=20
Jeff Mahoney
SUSE Labs

--------------040707000201040408040207
Content-Type: application/x-sh;
 name="test.sh"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="test.sh"

uevent=3Dadd
LVNAME=3Dlvtest
MNT=3D/mnt
IMG1=3Ddm-device-1.img
VG1=3Dtestvg1
IMG2=3Ddm-device-2.img
VG2=3Dtestvg2
dd if=3D/dev/zero of=3D$IMG1 bs=3D1M count=3D1 seek=3D10240 status=3Dnone=

dd if=3D/dev/zero of=3D$IMG2 bs=3D1M count=3D1 seek=3D10240 status=3Dnone=


DEV1=3D$(losetup --show -f $IMG1)=20
DEV2=3D$(losetup --show -f $IMG2)=20

vgcreate $VG1 $DEV1 > /dev/null 2>&1
vgcreate $VG2 $DEV2> /dev/null 2>&1
lvcreate -l 100%VG $VG1 -n $LVNAME> /dev/null 2>&1
lvcreate -l 100%VG $VG2 -n $LVNAME> /dev/null 2>&1

# Create fs and add second device
mkfs.btrfs /dev/$VG1/$LVNAME> /dev/null 2>&1
mount /dev/$VG1/$LVNAME $MNT> /dev/null 2>&1
btrfs dev add /dev/$VG2/$LVNAME $MNT> /dev/null 2>&1

echo "Before"
btrfs fi usage -T $MNT | grep /dev|awk '{print $1}'

if [ "$uevent" =3D "add" ]; then

umount $MNT> /dev/null 2>&1
vgchange -a n $VG1> /dev/null 2>&1
vgchange -a n $VG2> /dev/null 2>&1

# Reactivate and see what devices btrfs knows about for this fs.
# The names *should* be /dev/mapper/$VG1-$LVNAME and /dev/mapper/$VG2-$LV=
NAME
vgchange -a y $VG1> /dev/null 2>&1
vgchange -a y $VG2> /dev/null 2>&1
mount /dev/$VG1/$LVNAME $MNT> /dev/null 2>&1
else
	partprobe $DEV1 $DEV2
fi

echo "After"
btrfs fi usage -T $MNT | grep /dev|awk '{print $1}'

umount $MNT

vgchange -a n $VG1 > /dev/null 2>&1
vgchange -a n $VG2 > /dev/null 2>&1

vgremove -f $VG1 > /dev/null 2>&1
vgremove -f $VG2 > /dev/null 2>&1
losetup -d $DEV1
losetup -d $DEV2
rm -f $IMG1
rm -f $IMG2

--------------040707000201040408040207--

--vDSQwhrvE3wqWajeOcI2qFc5OHM9DTjwc--

--mdRDCU0nnrQjGcUoR0WeSNqnp1MH8TeJF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXL+jsAAoJEB57S2MheeWyc9oP/2sqqREODvfPOInEAMpAP1RR
koJhK5DbdrvfnqLgkBW9PRs2Zbak4lbPHPIlJvhW80+yYvIlhWY+NxQZ9gkZCYrz
pfHY422Nk9v30E5RXAw4d5H6Fh0p7kD/fv3Qv36YvqeXtiJRv6SU1FzI0pTsA5wI
woTmaPb1XYmpHdupi6jamf8Y8CfWT1rDyVTOhliuwcCS3BeJg8xIdnHWgzAofWpz
4sQnY5D51hVId4dy/JuNklTXs5FdzQpGITQ3/bf3/U3YsYebHX01ziWhxr3dHP9F
idl3PZCgrtIQQS4RNYb+L5FJWdtoMTjOkeJRD5CJgDjAqrmL/gH8TpigURMIWoBa
yZY+EjXp/qWaAjNrJja/TeH5S13OiNqiuRhXj1FwNasiJf0ooJ/MCa+xtHhkS9ot
OOBT6jnRx+TxY/XHKEdqGv8bNwU2z8NWGh4dkVbDnQYKsgWRDBHqUKPQB8OPwVhu
Jiib4sgtb0vi0yc+amkuK8AwCqb30wLbOXjL68q+tN6EyRPXmZmHs4IeZlG6Z2yT
XcAolVY1zHdGh0i+LNr/T/0h7SsYeDV9hy9HucniqbQokVoIhlAGPgjTQfkx6jCW
FWj0KTTp92F+8A1NDoTao8PzYem0xg/rAjwCe9sbsREpvDiFwddJEPNniUJ5pIZO
rJkcKveZHtepziYAmHHO
=SfkP
-----END PGP SIGNATURE-----

--mdRDCU0nnrQjGcUoR0WeSNqnp1MH8TeJF--
