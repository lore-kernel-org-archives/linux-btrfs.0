Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60567 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751172AbeEDNc4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 May 2018 09:32:56 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B1E29ACE5
        for <linux-btrfs@vger.kernel.org>; Fri,  4 May 2018 13:32:55 +0000 (UTC)
Subject: Re: [PATCH v3 0/3] btrfs: qgroup rescan races (part 1)
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
References: <20180502211156.9460-1-jeffm@suse.com>
 <b12bde4d-babe-8d2f-1ae8-86e3e9fddbc3@suse.com>
 <ea3cabf7-584a-4ec3-3baf-845aa1f83351@suse.com>
 <14832abb-4d2c-c643-07e4-d81dc6ab8209@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <0fe1ba45-0609-1a31-773e-3cb42d15995e@suse.com>
Date: Fri, 4 May 2018 09:32:52 -0400
MIME-Version: 1.0
In-Reply-To: <14832abb-4d2c-c643-07e4-d81dc6ab8209@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XRnaipzkbtC0HsMngFKPJMVoheYH47ALb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XRnaipzkbtC0HsMngFKPJMVoheYH47ALb
Content-Type: multipart/mixed; boundary="C5yPoOlTDRwzTzvf657d1i2MNmkVxpLRe";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com,
 linux-btrfs@vger.kernel.org
Message-ID: <0fe1ba45-0609-1a31-773e-3cb42d15995e@suse.com>
Subject: Re: [PATCH v3 0/3] btrfs: qgroup rescan races (part 1)
References: <20180502211156.9460-1-jeffm@suse.com>
 <b12bde4d-babe-8d2f-1ae8-86e3e9fddbc3@suse.com>
 <ea3cabf7-584a-4ec3-3baf-845aa1f83351@suse.com>
 <14832abb-4d2c-c643-07e4-d81dc6ab8209@suse.com>
In-Reply-To: <14832abb-4d2c-c643-07e4-d81dc6ab8209@suse.com>

--C5yPoOlTDRwzTzvf657d1i2MNmkVxpLRe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/4/18 1:59 AM, Nikolay Borisov wrote:
>=20
>=20
> On  4.05.2018 01:27, Jeff Mahoney wrote:
>> On 5/3/18 2:23 AM, Nikolay Borisov wrote:
>>>
>>>
>>> On  3.05.2018 00:11, jeffm@suse.com wrote:
>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>
>>>> Hi Dave -
>>>>
>>>> Here's the updated patchset for the rescan races.  This fixes the is=
sue
>>>> where we'd try to start multiple workers.  It introduces a new "read=
y"
>>>> bool that we set during initialization and clear while queuing the w=
orker.
>>>> The queuer is also now responsible for most of the initialization.
>>>>
>>>> I have a separate patch set start that gets rid of the racy mess sur=
rounding
>>>> the rescan worker startup.  We can handle it in btrfs_run_qgroups an=
d
>>>> just set a flag to start it everywhere else.
>>> I'd be interested in seeing those patches. Some time ago I did send a=

>>> patch which cleaned up the way qgroup rescan was initiated. It was do=
ne
>>> from "btrfs_run_qgroups" and I think this is messy. Whatever we do we=

>>> ought to really have well-defined semantics when qgroups rescan are r=
un,
>>> preferably we shouldn't be conflating rescan + run (unless there is
>>> _really_ good reason to do). In the past the rescan from scan was use=
d
>>> only during qgroup enabling.
>>
>> I think btrfs_run_qgroups is the place to do it.  Here's why:
>>
>> 2773 int
>> 2774 btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
>> 2775 {
>> 2776         int ret =3D 0;
>> 2777         struct btrfs_trans_handle *trans;
>> 2778
>> 2779         ret =3D qgroup_rescan_init(fs_info, 0, 1);
>> 2780         if (ret)
>> 2781                 return ret;
>> 2782
>> 2783         /*
>> 2784          * We have set the rescan_progress to 0, which means no m=
ore
>> 2785          * delayed refs will be accounted by btrfs_qgroup_account=
_ref.
>> 2786          * However, btrfs_qgroup_account_ref may be right after i=
ts call
>> 2787          * to btrfs_find_all_roots, in which case it would still =
do the
>> 2788          * accounting.
>> 2789          * To solve this, we're committing the transaction, which=
 will
>> 2790          * ensure we run all delayed refs and only after that, we=
 are
>> 2791          * going to clear all tracking information for a clean st=
art.
>> 2792          */
>> 2793
>> 2794         trans =3D btrfs_join_transaction(fs_info->fs_root);
>> 2795         if (IS_ERR(trans)) {
>> 2796                 fs_info->qgroup_flags &=3D ~BTRFS_QGROUP_STATUS_F=
LAG_RESCAN;
>> 2797                 return PTR_ERR(trans);
>> 2798         }
>> 2799         ret =3D btrfs_commit_transaction(trans);
>> 2800         if (ret) {
>> 2801                 fs_info->qgroup_flags &=3D ~BTRFS_QGROUP_STATUS_F=
LAG_RESCAN;
>> 2802                 return ret;
>> 2803         }
>> 2804
>> 2805         qgroup_rescan_zero_tracking(fs_info);
>> 2806
>> 2807         queue_rescan_worker(fs_info);
>> 2808         return 0;
>> 2809 }
>>
>> The delayed ref race should exist anywhere we initiate a rescan outsid=
e of
>> initially enabling qgroups.  We already zero the tracking and queue th=
e rescan
>> worker in btrfs_run_qgroups for when we enable qgroups.  Why not just =
always
>> queue the worker there so the initialization and execution has a clear=
 starting point?
>=20
> This is no longer true in upstream as of commit 5d23515be669 ("btrfs:
> Move qgroup rescan on quota enable to btrfs_quota_enable"). Hence my
> asking about this. I guess if we make it unconditional it won't increas=
e
> the complexity, but the original code which was only run during qgroup
> enable was rather iffy I Just don't want to repeat this.

Ah, ok.  My repo is still using v4.16.  How does this work with the race
that is described in btrfs_qgroup_rescan?

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--C5yPoOlTDRwzTzvf657d1i2MNmkVxpLRe--

--XRnaipzkbtC0HsMngFKPJMVoheYH47ALb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlrsYQUACgkQHntLYyF5
5bKGCBAAn6ydc3wuNhgsSuwBaVeIx29gcIA2V2AgwIvVD/O/cTRwr7CMWTZIikVX
P9WP0zlAL0DKs1wEC+Sv//bAp3iEweZX7uXyewXghWiDMJAsIiaJ7000K3nalku4
5AQ1ItoOUoddxN040asJrVB3m6KO/iBRGPIAUZCjeU36Oaa+8r8aE1EDnnOlUgGx
2dLnTSviTe0RzBCLYI8GpvWi5BRMxS3dqq+kjLd+/WW/RMYM9zXVT5ucKy5bqqVZ
IHuYQs1p8ARFIitfDA10V/zFW7Bd3dbSd72tZEU3XTTXWVqBeDHCllaCQJxh56eX
T/3/2KJLkSx+W3fK0TNlYOwMgfhbTd+mPatEAE8GkoaprGC5l61oaUXCIugtNiqJ
pf8he+QzZRK0UpGfeOW6/fsabysqg4lqK3wLxx7ERSZNPxZ01RzuEiyOBVAH3RfR
wuIbjzOQLqc0ErDy7wRUlhUtGWDL9fc82cIlFqxntW2oSF3b1cFVUvvqCWBhBhhd
QqPS457HpQtwL6fIo2hPqc8dQXYZalgu6eY3xMW5G0Q+oC7g1dSdnQGXjB5vA6dL
x6XQ3u2aw3uUzyDkYZ6oiDvFEOW3ikd80fHCPrDdpYeB9mhLk/w++++LUh4F+owj
AeTK+Dqwv7Z0juak5gFG+GYcMzkPXriz+4dapc8JZpytanE9Ph4=
=awjb
-----END PGP SIGNATURE-----

--XRnaipzkbtC0HsMngFKPJMVoheYH47ALb--
