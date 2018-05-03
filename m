Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbeECW1K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 18:27:10 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 081F7AE26
        for <linux-btrfs@vger.kernel.org>; Thu,  3 May 2018 22:27:09 +0000 (UTC)
Subject: Re: [PATCH v3 0/3] btrfs: qgroup rescan races (part 1)
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
References: <20180502211156.9460-1-jeffm@suse.com>
 <b12bde4d-babe-8d2f-1ae8-86e3e9fddbc3@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <ea3cabf7-584a-4ec3-3baf-845aa1f83351@suse.com>
Date: Thu, 3 May 2018 18:27:06 -0400
MIME-Version: 1.0
In-Reply-To: <b12bde4d-babe-8d2f-1ae8-86e3e9fddbc3@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6sbP8bKVddemFM4rQHzXKaNMPXoNRrUGC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6sbP8bKVddemFM4rQHzXKaNMPXoNRrUGC
Content-Type: multipart/mixed; boundary="Ifb5GO0uNTLiVw9lZo4CyYyLQj3h0NdjI";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com,
 linux-btrfs@vger.kernel.org
Message-ID: <ea3cabf7-584a-4ec3-3baf-845aa1f83351@suse.com>
Subject: Re: [PATCH v3 0/3] btrfs: qgroup rescan races (part 1)
References: <20180502211156.9460-1-jeffm@suse.com>
 <b12bde4d-babe-8d2f-1ae8-86e3e9fddbc3@suse.com>
In-Reply-To: <b12bde4d-babe-8d2f-1ae8-86e3e9fddbc3@suse.com>

--Ifb5GO0uNTLiVw9lZo4CyYyLQj3h0NdjI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/3/18 2:23 AM, Nikolay Borisov wrote:
>=20
>=20
> On  3.05.2018 00:11, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> Hi Dave -
>>
>> Here's the updated patchset for the rescan races.  This fixes the issu=
e
>> where we'd try to start multiple workers.  It introduces a new "ready"=

>> bool that we set during initialization and clear while queuing the wor=
ker.
>> The queuer is also now responsible for most of the initialization.
>>
>> I have a separate patch set start that gets rid of the racy mess surro=
unding
>> the rescan worker startup.  We can handle it in btrfs_run_qgroups and
>> just set a flag to start it everywhere else.
> I'd be interested in seeing those patches. Some time ago I did send a
> patch which cleaned up the way qgroup rescan was initiated. It was done=

> from "btrfs_run_qgroups" and I think this is messy. Whatever we do we
> ought to really have well-defined semantics when qgroups rescan are run=
,
> preferably we shouldn't be conflating rescan + run (unless there is
> _really_ good reason to do). In the past the rescan from scan was used
> only during qgroup enabling.

I think btrfs_run_qgroups is the place to do it.  Here's why:

2773 int
2774 btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
2775 {
2776         int ret =3D 0;
2777         struct btrfs_trans_handle *trans;
2778
2779         ret =3D qgroup_rescan_init(fs_info, 0, 1);
2780         if (ret)
2781                 return ret;
2782
2783         /*
2784          * We have set the rescan_progress to 0, which means no more=

2785          * delayed refs will be accounted by btrfs_qgroup_account_re=
f.
2786          * However, btrfs_qgroup_account_ref may be right after its =
call
2787          * to btrfs_find_all_roots, in which case it would still do =
the
2788          * accounting.
2789          * To solve this, we're committing the transaction, which wi=
ll
2790          * ensure we run all delayed refs and only after that, we ar=
e
2791          * going to clear all tracking information for a clean start=
=2E
2792          */
2793
2794         trans =3D btrfs_join_transaction(fs_info->fs_root);
2795         if (IS_ERR(trans)) {
2796                 fs_info->qgroup_flags &=3D ~BTRFS_QGROUP_STATUS_FLAG=
_RESCAN;
2797                 return PTR_ERR(trans);
2798         }
2799         ret =3D btrfs_commit_transaction(trans);
2800         if (ret) {
2801                 fs_info->qgroup_flags &=3D ~BTRFS_QGROUP_STATUS_FLAG=
_RESCAN;
2802                 return ret;
2803         }
2804
2805         qgroup_rescan_zero_tracking(fs_info);
2806
2807         queue_rescan_worker(fs_info);
2808         return 0;
2809 }

The delayed ref race should exist anywhere we initiate a rescan outside o=
f
initially enabling qgroups.  We already zero the tracking and queue the r=
escan
worker in btrfs_run_qgroups for when we enable qgroups.  Why not just alw=
ays
queue the worker there so the initialization and execution has a clear st=
arting point?

There are a few other races I'd like to fix as well.  We call btrfs_run_q=
groups
directly from btrfs_ioctl_qgroup_assign, which is buggy since
btrfs_add_qgroup_relation only checks to see if the quota_root exists.  I=
t will
exist as soon as btrfs_quota_enable runs but we won't have committed the
transaction yet.  The call will end up enabling quotas in the middle of a=
 transaction.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--Ifb5GO0uNTLiVw9lZo4CyYyLQj3h0NdjI--

--6sbP8bKVddemFM4rQHzXKaNMPXoNRrUGC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlrrjLoACgkQHntLYyF5
5bLJCQ/8Dc9ykKK34ZMFnDHsMm/zj1cwnwqMtvG/Jq5XY9GYtQAtLgoiOWPUtIUW
VxCafmz3RX5zgBfkFHvRYpANIxnZVt88kccQrOAtBJG3reBVB7xKfR4eW37b5mWu
h2WWbSrJ5I94S9cUbsECGgMP1UFvwko4U6ArCZLi81Cb/2xwbe/PYxpgQPuFunwe
lIhQXruZmL4bCqVWA/h45WT8lWaq+f0eRzq8iQOCBb14pmxdwuR9sTZz2ecQkv+9
jYPg5mg6xJ3vDYvYQY6ro6mQmV3qbnKXmYAFQ4oKvZ41KKSwhGXg3qK2AMGI9OXA
A6UjR1ITs4XM82uqYnNl6NT5sfY3mwZtJRhcyePuRd8U2q6Nh2fBthjUmSunRRFs
1f56dPpz4o66Uvo/Hsw5addn4YEfvYGw9C6nehXutefzfyFvDZryaiq8VvvXY12A
arDCwlKFBC+bjacE5Fp/3W36uvkOipLoIC1cT1Jq5Dud6lvKBEzNVeOC1fkpO1is
i8PlcP4nfdJLdkXZxurUH0qbMvl637VdJbsB6JVzS2NgOw76DIrfPLzusWTOPCNr
6tGg5FQF8ctKExtFnlVTlw2IUGiuYXHry2LbBfRG+5ZJ1gZofS/Dbf3S2IjqSGRH
S28FwPyoZHD3nR5ZkvackUoCkz3S9zLcH1GH5I4hIV+5SCL7Aak=
=RyQH
-----END PGP SIGNATURE-----

--6sbP8bKVddemFM4rQHzXKaNMPXoNRrUGC--
