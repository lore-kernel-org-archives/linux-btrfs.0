Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750906AbcHSTeO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 15:34:14 -0400
Subject: Re: [PATCH 1/2] btrfs/131: test for umount of read-only fs when quota
 rescan is paused
To: Eryu Guan <eguan@redhat.com>
References: <2f102cc7-a6b2-e23d-9c56-de6c6bc5110d@suse.com>
 <20160817084539.GS27776@eguan.usersys.redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <c93508d9-712b-891d-2b55-8bc19b2a688f@suse.com>
Date: Fri, 19 Aug 2016 15:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <20160817084539.GS27776@eguan.usersys.redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="e9NT9LMCcG5QjdCx0gfTAnbgJrmIp65gG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e9NT9LMCcG5QjdCx0gfTAnbgJrmIp65gG
Content-Type: multipart/mixed; boundary="GQL9V6bD0LxtTCLTSPeuoFfSUVhtUUPso"
From: Jeff Mahoney <jeffm@suse.com>
To: Eryu Guan <eguan@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org,
 Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c93508d9-712b-891d-2b55-8bc19b2a688f@suse.com>
Subject: Re: [PATCH 1/2] btrfs/131: test for umount of read-only fs when quota
 rescan is paused
References: <2f102cc7-a6b2-e23d-9c56-de6c6bc5110d@suse.com>
 <20160817084539.GS27776@eguan.usersys.redhat.com>
In-Reply-To: <20160817084539.GS27776@eguan.usersys.redhat.com>

--GQL9V6bD0LxtTCLTSPeuoFfSUVhtUUPso
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/17/16 4:45 AM, Eryu Guan wrote:
> On Tue, Aug 16, 2016 at 02:30:21PM -0400, Jeff Mahoney wrote:
>> +_require_btrfs
>> +BTRFS_DEBUG_TREE_PROG=3D"`set_prog_path btrfs-debug-tree`"
>> +_require_command "$BTRFS_DEBUG_TREE_PROG" btrfs-debug-tree
>> +TIMEOUT_PROG=3D"`set_prog_path timeout`"
>> +_require_command "$TIMEOUT_PROG" timeout
>=20
> The "set_prog_path" calls belong to common/config, we only need
> "_require_command" calls in test.

Ok, then we should probably fix up the existing cases that do this in
tests/ since this and the cp /lib/modules thing were copied from other
test cases in the repo.

>> +
>> +rm -f $seqres.full
>> +_scratch_mkfs >>$seqres.full 2>&1
>> +
>> +_scratch_mount
>> +cp -aR /lib/modules/$(uname -r) $SCRATCH_MNT
>=20
> Consider populating the filesystem using _populate_fs or fsstress?

Same.

>> +
>> +# A qgroup rescan on an empty or small file system completes nearly
>> +# immediately.  We need to ensure that it runs long enough that it wi=
ll
>> +# be paused on umount.  Snapshots slow down the rescan so we should s=
ee
>> +# the race without a lot of data.  This is an arbitrary number that
>> +# works on a ramdisk so it should be sufficient for any storage.
>> +for n in $(seq 1 100); do
>> +  _run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/$=
n
>=20
> Use tab for indention.

Ok.

>> +done
>> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
>> +_scratch_unmount
>> +
>> +echo "read-write umount completed"
>> +
>> +# Confirm that the rescan is paused
>> +if ! $BTRFS_DEBUG_TREE_PROG $SCRATCH_DEV | \
>> +	egrep -q 'flags ON|SCANNING|INCONSISTENT scan'; then
>> +	echo "qgroup rescan not paused."
>> +fi
>> +_scratch_mount -r
>> +
>> +# If the bug exists, this will hang.  If we can kill it, that's anoth=
er bug.
>> +$TIMEOUT_PROG 10 umount $SCRATCH_MNT
>> +if test $? -eq 124 ; then
>> +    echo "umount hung but was killed"
>=20
> I see this log with 4.8-rc1 kernel, is that expected?

Yes, the patch was posted this week and hasn't landed yet.

Thanks,

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--GQL9V6bD0LxtTCLTSPeuoFfSUVhtUUPso--

--e9NT9LMCcG5QjdCx0gfTAnbgJrmIp65gG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXt1vnAAoJEB57S2MheeWyWMYP/jGBphfDwcrAwQxbzsbES2EO
d7NOumPwoqVSgpXaAW4PwOysBdfo24r1hQQPXWx9K7l9UwJ6OSmWuv0FP5hpn2bm
+x4opiFNG888gz6+HZM7qGgHB1odyrvLMAeJd0Pw4c8hXNY8PBbQ+sOxpZAUbh+k
2tKq5NBTTt22xEBAqb6c0Zuh42Abb6ONYJjLrUXtwRjzBqF+IO1lK7FZnNgMaN9T
LUIKxV8uG6SuT9Wu9e572JUNS0hNmbNtD1fH9cDWDJ9Pezr7jvpoTv1y1ZYPyqSl
WKzz669iZZ9zu1Ijab+0aGBEHTaef/ku72PiuNMBWtcCc3yS0N9RjpJeF6Kf26dh
wKjkX87M1tdPGZ/DWGJ18uzZq3teJrAZemMz1W6fCS8yKczdLxADlYWxxwOGl7Gx
h/dHDjfDyheepJy6JBs2kNdncoXtawii0QkYjUBDjMiLH9KWvplK5xXYphBYzTyF
Xc73DIHaXfH8o22+g2CB/lWQ4yi29NRp8AeA18cHoTTBNcHaAedbDvQmkfwJKlSl
/c+ejAeEnOIysyWrJdgKBE/5kLCMf+I6blG6r72ApB6rkF+rakTr/lDOhrOqZUIc
WVADBWe4mjIxFNLOHwNoGOslqZoDPc5SwRQXwGc8X1a8lWJ1hRaMVYWgAog1fAWF
iGUrrusDe1As+8ZTZWnt
=97S6
-----END PGP SIGNATURE-----

--e9NT9LMCcG5QjdCx0gfTAnbgJrmIp65gG--
