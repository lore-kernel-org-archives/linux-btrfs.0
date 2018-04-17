Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55139 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751836AbeDQOok (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 10:44:40 -0400
Subject: Re: [PATCH] btrfs: Do super block verification before writing it to
 disk
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180417014719.3799-1-wqu@suse.com>
 <1be75939-0ae0-9485-fe27-f3f5a92358c9@oracle.com>
 <a0bb0231-8cb0-03de-876b-f902a89d7d4c@gmx.com>
 <11f21c80-6089-8c26-3a36-92d5d9c2b2b0@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bcf4baa1-0060-2cd8-a274-857f865d7680@gmx.com>
Date: Tue, 17 Apr 2018 22:44:23 +0800
MIME-Version: 1.0
In-Reply-To: <11f21c80-6089-8c26-3a36-92d5d9c2b2b0@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="F9AoC31c8o9pvgl0N1825vTiQxAo4kAcm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F9AoC31c8o9pvgl0N1825vTiQxAo4kAcm
Content-Type: multipart/mixed; boundary="jeiU96xSkjdx4NPW1qdHCYBYtpifCKP01";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <bcf4baa1-0060-2cd8-a274-857f865d7680@gmx.com>
Subject: Re: [PATCH] btrfs: Do super block verification before writing it to
 disk
References: <20180417014719.3799-1-wqu@suse.com>
 <1be75939-0ae0-9485-fe27-f3f5a92358c9@oracle.com>
 <a0bb0231-8cb0-03de-876b-f902a89d7d4c@gmx.com>
 <11f21c80-6089-8c26-3a36-92d5d9c2b2b0@oracle.com>
In-Reply-To: <11f21c80-6089-8c26-3a36-92d5d9c2b2b0@oracle.com>

--jeiU96xSkjdx4NPW1qdHCYBYtpifCKP01
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8817=E6=97=A5 22:32, Anand Jain wrote:
>=20
>=20
> On 04/17/2018 05:58 PM, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B404=E6=9C=8817=E6=97=A5 17:05, Anand Jain wrote:
>>>
>>>> v3:
>>>> =C2=A0=C2=A0=C2=A0 Update commit message to show the corruption in d=
etails.
>>>> =C2=A0=C2=A0=C2=A0 Modify the kernel error message to show corruptio=
n is detected
>>>> before
>>>> =C2=A0=C2=A0=C2=A0 transaction commitment.
>>> =C2=A0=C2=A0Nice. Thanks. more below.
>>>
>>>> @@ -3310,6 +3311,27 @@ static int write_dev_supers(struct btrfs_devi=
ce
>>>> *device,
>>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
btrfs_set_super_bytenr(sb, bytenr);
>>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* check th=
e validation of the primary sb before writing */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (i =3D=3D 0) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
ret =3D btrfs_check_super_valid(device->fs_info, sb);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
if (ret) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_err(device->fs_info,
>>>> +"superblock corruption detected before transaction commitment for
>>>> device %llu",
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 device->devid);=

>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -EUCLEAN;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
}
>>>
>>> =C2=A0=C2=A0Why not move this entire check further below, after we ha=
ve the ready
>>> =C2=A0=C2=A0crc and use btrfs_check_super_csum(), instead of
>>> =C2=A0=C2=A0btrfs_check_super_valid()? so that we verify only what is=
 known to be
>>> =C2=A0=C2=A0corrupted that is ..
>>
>> The problem is, we don't know the cause yet, so we must check the whol=
e
>> superblock.
>>
>> For example, if the corruption is caused by some wild pointer of other=

>> kernel module, and we're just unlucky that one day it corrupts nodesiz=
e,
>> then we can't detect it if we only check certain members.
>=20
> Right I notice that.
>=20
> But without btrfs_check_super_csum(), it leaves out checking one of the=

> member (csum_type) which is know to be corrupted at the two instances,
> so it can also include btrfs_check_super_csum().
>=20
> There were two cases, both of them corrupted the same offset, its not
> just a coincidence that both of these reported corrupted the same
> offset.

Yep, but since we're here to do extra verification, checking everything
is never a bad idea. By this we don't need to bother checking other
members when new corruption pops out.

>=20
> Also the incompatible features flags (169) are still valid in both the
> cases. It looks as if we wrote u32 to a u64. I notice that we provide
> the options to write the incompatible flags through mount option, sysfs=

> and ioctl.

While I don't think that's the cause of these reported corruption.
I'd prefer some under/over flow of memory which corrupted
fs_info->super_copy somehow. It may be btrfs or it may not.

It's pretty hard to determine with just 2 reports.
Especially for ben's report, he is using latest vega graphics IIRC, who
knows what could went wrong with latest amd drm codes.

>=20
>=20
>>> btrfs_super_block {
>>> ::
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le64 incompat_flag=
s;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le16 csum_type;
>>> ::
>>> }
>>>
>>> =C2=A0=C2=A0And also can you dump contents of incompat_flags and csum=
_type at both
>>> =C2=A0=C2=A0=C2=A0 fs_info->super_copy
>>> =C2=A0=C2=A0and
>>> =C2=A0=C2=A0=C2=A0 fs_info->super_for_commit
>>
>> Not really needed, as when corruption happens, it's super_copy
>> corrupted, not something went wrong after we called memcpy()
>=20
> As shown below, we aren't memcpy()-ing in the btrfs_sync_log() thread,
> did you check if btrfs_sync_log() can not be the last person to write
> at umount?

I checked the dump super output, where log_tree output is all 0, means
no log tree, hence not btrfs_sync_log() caused the problem.

=46rom Ben's:
------
chunk_root		5518540881920
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
------

And from Ken's
------
chunk_root        21004288
chunk_root_level    1
log_root        0
log_root_transid    0
log_root_level        0
------

So at least for current only reports, it's not btrfs_sync_log() causing
the problem.

Thanks,
Qu

>=20
> Thanks, Anand
>=20
>> Thanks,
>> Qu
>>
>>>
>>> =C2=A0=C2=A0Because at each commit transaction we
>>>
>>> btrfs_commit_transaction()
>>> {
>>> =C2=A0=C2=A0 ::
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 memcpy(fs_info->supe=
r_for_commit, fs_info->super_copy,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 sizeof(*fs_info->super_copy));
>>> =C2=A0=C2=A0 ::
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D write_all_su=
pers(fs_info, 0);
>>>
>>> }
>>>
>>> =C2=A0=C2=A0And also the sync log can write the
>>>
>>> btrfs_sync_log()
>>> {
>>> ::
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D write_all_su=
pers(fs_info, 1);
>>>
>>>
>>> =C2=A0=C2=A0Finally locks between these two threads needs a review as=
 well.
>>>
>>> Thanks, Anand
>>> --=C2=A0
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.ht=
ml
>>


--jeiU96xSkjdx4NPW1qdHCYBYtpifCKP01--

--F9AoC31c8o9pvgl0N1825vTiQxAo4kAcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrWCEcACgkQwj2R86El
/qg0Xgf9GbBWp3kfiqjFUR6hhckFKuq/bzsEyw0WloH+lXtdn/ytoRWmhzYzP+lm
v2diyD0KfLGqbpS7vBwg5PDl8YQVvHRKFgaITkycsc6bL+S5+yTklo3t99DWpOce
zaVrwr3yqOG3fHV5heWpjv+WQP7Mf2muH2Uz7xHOMePfO7Mbo0I3Sh30rhdBXHMC
kbsL3h2qivBAhPeeoX7UUvrLRCQWGzyrrgEzVK9WYKQZwcpBke3I3Rzbds8AUThK
UIUynZEhXjg+B/Rr2zxBgHnd+iEjoIM15eaAfx5ZnEEr0jyxIKhDbt28WPBWTkX+
Ks+kIn0aD7Cks8oqZR0kPO/4DfkTbg==
=XeqV
-----END PGP SIGNATURE-----

--F9AoC31c8o9pvgl0N1825vTiQxAo4kAcm--
