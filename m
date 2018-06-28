Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:37953 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753717AbeF1N3m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 09:29:42 -0400
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180628070443.23421-1-wqu@suse.com>
 <575511f2-512c-2aa0-1dd9-027f00c4ce75@gmx.com>
 <6f5c1e15-f9ca-4e10-5e28-f671ceaa5f85@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <26cecb4b-afc9-e55d-03f1-144b5cf69235@gmx.com>
Date: Thu, 28 Jun 2018 21:29:30 +0800
MIME-Version: 1.0
In-Reply-To: <6f5c1e15-f9ca-4e10-5e28-f671ceaa5f85@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BrulhcnZSFkGVzmrhGgvqe6s9hoZP5O0U"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BrulhcnZSFkGVzmrhGgvqe6s9hoZP5O0U
Content-Type: multipart/mixed; boundary="Zm8QFP3T1VNFKts6IICUv8lXD4LjCfLCg";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <26cecb4b-afc9-e55d-03f1-144b5cf69235@gmx.com>
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
References: <20180628070443.23421-1-wqu@suse.com>
 <575511f2-512c-2aa0-1dd9-027f00c4ce75@gmx.com>
 <6f5c1e15-f9ca-4e10-5e28-f671ceaa5f85@oracle.com>
In-Reply-To: <6f5c1e15-f9ca-4e10-5e28-f671ceaa5f85@oracle.com>

--Zm8QFP3T1VNFKts6IICUv8lXD4LjCfLCg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 21:26, Anand Jain wrote:
>=20
>=20
> On 06/28/2018 04:02 PM, Qu Wenruo wrote:
>> Also CC Anand Jain, since he is also working on various device related=

>> work, and an expert on this.
>>
>> Especially I'm not pretty sure if such enhancement is already on his
>> agenda or there are already some unmerged patch for this.
>=20
> =C2=A0Right, some of the patches are already in the ML and probably it =
needs
> =C2=A0a revival. Unless there are new challenges, my target is to conso=
lidate
> =C2=A0them and get them integrated by this year. I am trying harder.
>=20
> =C2=A0I think its a good idea to report the write-hole status to the
> =C2=A0user-land instead of failing the mount, so that a script can trig=
ger
> =C2=A0the re-silver as required by the use case. I introduced
> =C2=A0fs_devices::volume_flags, which is under review as of now, and ha=
ve
> =C2=A0plans to add the volume degraded state bit which can be accessed =
by
> =C2=A0the sysfs. So yes this is been taken care.

Glad to hear that!

However I found it pretty hard to trace your latest work, would you mind
to share the git repo and branch you're working on?

Maybe I could take some time to do some review.

Thanks,
Qu

>=20
>=20
> Thanks, Anand
>=20
>=20
>> Thanks,
>> Qu
>>
>> On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 15:04, Qu Wenruo wrote:
>>> There is a reporter considering btrfs raid1 has a major design flaw
>>> which can't handle nodatasum files.
>>>
>>> Despite his incorrect expectation, btrfs indeed doesn't handle device=

>>> generation mismatch well.
>>>
>>> This means if one devices missed and re-appeared, even its generation=

>>> no longer matches with the rest device pool, btrfs does nothing to it=
,
>>> but treat it as normal good device.
>>>
>>> At least let's detect such generation mismatch and avoid mounting the=

>>> fs.
>>> Currently there is no automatic rebuild yet, which means if users fin=
d
>>> device generation mismatch error message, they can only mount the fs
>>> using "device" and "degraded" mount option (if possible), then replac=
e
>>> the offending device to manually "rebuild" the fs.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> I totally understand that, generation based solution can't handle
>>> split-brain case (where 2 RAID1 devices get mounted degraded separate=
ly)
>>> at all, but at least let's handle what we can do.
>>>
>>> The best way to solve the problem is to make btrfs treat such lower g=
en
>>> devices as some kind of missing device, and queue an automatic scrub =
for
>>> that device.
>>> But that's a lot of extra work, at least let's start from detecting s=
uch
>>> problem first.
>>> ---
>>> =C2=A0 fs/btrfs/volumes.c | 50 ++++++++++++++++++++++++++++++++++++++=
++++++++
>>> =C2=A0 1 file changed, 50 insertions(+)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index e034ad9e23b4..80a7c44993bc 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -6467,6 +6467,49 @@ static void btrfs_report_missing_device(struct=

>>> btrfs_fs_info *fs_info,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devid, uuid);
>>> =C2=A0 }
>>> =C2=A0 +static int verify_devices_generation(struct btrfs_fs_info *fs=
_info,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_device *=
dev)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_devices *fs_devices =3D dev->fs_d=
evices;
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_device *cur;
>>> +=C2=A0=C2=A0=C2=A0 bool warn_only =3D false;
>>> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (!fs_devices || fs_devices->seeding || !dev->g=
eneration)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * If we're not replaying log, we're complet=
ely safe to allow
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * generation mismatch as it won't write any=
thing to disks, nor
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * remount to rw.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_test_opt(fs_info, NOLOGREPLAY))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 warn_only =3D true;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 rcu_read_lock();
>>> +=C2=A0=C2=A0=C2=A0 list_for_each_entry_rcu(cur, &fs_devices->devices=
, dev_list) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cur->generation && cu=
r->generation !=3D dev->generation) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (warn_only) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_warn_rl_in_rcu(fs_info,
>>> +=C2=A0=C2=A0=C2=A0 "devid %llu has unexpected generation, has %llu e=
xpected %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 dev->devid,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 dev->generation,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 cur->generation);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }=
 else {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_err_rl_in_rcu(fs_info,
>>> +=C2=A0=C2=A0=C2=A0 "devid %llu has unexpected generation, has %llu e=
xpected %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 dev->devid,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 dev->generation,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 cur->generation);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>=20
>=20
>=20
>=20
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 break;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }=

>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 rcu_read_unlock();
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> =C2=A0 static int read_one_chunk(struct btrfs_fs_info *fs_info, struc=
t
>>> btrfs_key *key,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 struct extent_buffer *leaf,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 struct btrfs_chunk *chunk)
>>> @@ -6552,6 +6595,13 @@ static int read_one_chunk(struct btrfs_fs_info=

>>> *fs_info, struct btrfs_key *key,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return PTR_ERR(map->stripes[i].dev);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_report_missing_device(fs_info, devid, uuid, false);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
et =3D verify_devices_generation(fs_info,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 map->stripes[i].dev);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
f (ret < 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 free_extent_map(em);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }=

>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(BTRFS_=
DEV_STATE_IN_FS_METADATA,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &(map->stripes[i].dev->dev_state));
>>>
>>


--Zm8QFP3T1VNFKts6IICUv8lXD4LjCfLCg--

--BrulhcnZSFkGVzmrhGgvqe6s9hoZP5O0U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls04roACgkQwj2R86El
/qg0KQf+I56RHRUQsZ348Fb8M2hkcf/lNAzlE6buLtkmvHeYeV5UMy+R78cpxNCA
IJ/u79jOm7Bdt+jI6nnQvtL+S9pqYu7tTwHqqNi9A1nYbGGMbXtnoV97/1DZHzv1
GAbAyrsvoOnpMCrH4zj3RrjHXBRkeeW2d9yMkSMkPW9L7qPswZA2nSWBcUP0rgjL
Oc2x9rvmMgXdzQvh5tDLdHGGol1O906T8YfaqB5okZPD/9fBvFTXwUUMXrPtzI0D
buKGHGRR/0u0C9kaLeCx3WflksU3PQxA2dMY5ospIlJ5uEEjeTJ5VtwTwx2mTefb
WtjEzT22fMkCVHUN/7+2fM6sk9tdqg==
=BwBG
-----END PGP SIGNATURE-----

--BrulhcnZSFkGVzmrhGgvqe6s9hoZP5O0U--
