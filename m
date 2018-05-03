Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59171 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbeECP5f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 11:57:35 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 29F4FAEA6
        for <linux-btrfs@vger.kernel.org>; Thu,  3 May 2018 15:57:34 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
References: <20180502211156.9460-1-jeffm@suse.com>
 <20180502211156.9460-2-jeffm@suse.com>
 <c5f71950-25c4-0b12-dbc2-306757db621d@suse.com>
 <c0990ec8-e31a-94a9-0f2c-e677939e06e2@suse.com>
 <ce166087-96d9-43d7-b13c-0bdb316b1da4@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <cb1c47ef-1161-b60b-f176-c47d7b7df73e@suse.com>
Date: Thu, 3 May 2018 11:57:31 -0400
MIME-Version: 1.0
In-Reply-To: <ce166087-96d9-43d7-b13c-0bdb316b1da4@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="crjwbD1ThyqzDk9rzXkoVZsBdLtVa8csR"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--crjwbD1ThyqzDk9rzXkoVZsBdLtVa8csR
Content-Type: multipart/mixed; boundary="Gwy4gsFOBGTSWEtXtQj9xPDQRsAvwiWkP";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, dsterba@suse.com,
 linux-btrfs@vger.kernel.org
Message-ID: <cb1c47ef-1161-b60b-f176-c47d7b7df73e@suse.com>
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
References: <20180502211156.9460-1-jeffm@suse.com>
 <20180502211156.9460-2-jeffm@suse.com>
 <c5f71950-25c4-0b12-dbc2-306757db621d@suse.com>
 <c0990ec8-e31a-94a9-0f2c-e677939e06e2@suse.com>
 <ce166087-96d9-43d7-b13c-0bdb316b1da4@suse.com>
In-Reply-To: <ce166087-96d9-43d7-b13c-0bdb316b1da4@suse.com>

--Gwy4gsFOBGTSWEtXtQj9xPDQRsAvwiWkP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/3/18 11:52 AM, Nikolay Borisov wrote:
>=20
>=20
> On  3.05.2018 16:39, Jeff Mahoney wrote:
>> On 5/3/18 3:24 AM, Nikolay Borisov wrote:
>>>
>>>
>>> On  3.05.2018 00:11, jeffm@suse.com wrote:
>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>
>>>> Commit 8d9eddad194 (Btrfs: fix qgroup rescan worker initialization)
>>>> fixed the issue with BTRFS_IOC_QUOTA_RESCAN_WAIT being racy, but
>>>> ended up reintroducing the hang-on-unmount bug that the commit it
>>>> intended to fix addressed.
>>>>
>>>> The race this time is between qgroup_rescan_init setting
>>>> ->qgroup_rescan_running =3D true and the worker starting.  There are=

>>>> many scenarios where we initialize the worker and never start it.  T=
he
>>>> completion btrfs_ioctl_quota_rescan_wait waits for will never come.
>>>> This can happen even without involving error handling, since mountin=
g
>>>> the file system read-only returns between initializing the worker an=
d
>>>> queueing it.
>>>>
>>>> The right place to do it is when we're queuing the worker.  The flag=

>>>> really just means that btrfs_ioctl_quota_rescan_wait should wait for=

>>>> a completion.
>>>>
>>>> Since the BTRFS_QGROUP_STATUS_FLAG_RESCAN flag is overloaded to
>>>> refer to both runtime behavior and on-disk state, we introduce a new=

>>>> fs_info->qgroup_rescan_ready to indicate that we're initialized and
>>>> waiting to start.
>>>
>>> Am I correct in my understanding that this qgroup_rescan_ready flag i=
s
>>> used to avoid qgroup_rescan_init being called AFTER it has already be=
en
>>> called but BEFORE queue_rescan_worker ? Why wasn't the initial versio=
n
>>> of this patch without this flag sufficient?
>>
>> No, the race is between clearing the BTRFS_QGROUP_STATUS_FLAG_RESCAN
>> flag near the end of the worker and clearing the running flag.  The
>> rescan lock is dropped in between, so btrfs_rescan_init will let a new=

>> rescan request in while we update the status item on disk.  We wouldn'=
t
>> have queued another worker since that's what the warning catches, but =
if
>> there were already tasks waiting for completion, they wouldn't have be=
en
>> woken since the wait queue list would be reinitialized.  There's no wa=
y
>> to reorder clearing the flag without changing how we handle
>> ->qgroup_flags.  I plan on doing that separately.  This was just meant=

>> to be the simple fix.
>=20
> Great, I think some of this information should go into the change log,
> in explaining what the symptoms of the race condition are.

You're right.  I was treating as a race that my patch introduced but it
didn't.  It just complained about it.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--Gwy4gsFOBGTSWEtXtQj9xPDQRsAvwiWkP--

--crjwbD1ThyqzDk9rzXkoVZsBdLtVa8csR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlrrMWsACgkQHntLYyF5
5bKMgg//dfVlxLweTDseIvLRqxkwU2QrWtiwI5/oaDUW83VGYrTvcN4oZWUIPkmI
4UkuPfSAQDgufa920Id7mOjVEXp+nIQmJ0oJ7NhkQlz0gqMrsw6rzGjT3JwBqoFp
oXDYSWm7gqFK9b5s6VMYWyxFvftnVH3arojU0hvppAdzsEsd6lxe5YuTfQmqcQnW
WWsJec1ouTQMo4alceCKRNBc98lhROg3gqu8SUzjPV/f1aRaGfVJtBzjrjhzaMse
f8TYpGjEY2Zlhh/dMvk0N5a656t401xh2RK6zkQpQevc5V0S2kOWZOoSMpz1s1pH
kCrQIy1G+gOwimNJpLlmjc7ec+wXcaXBxCkTuu30NfIMVFYA6K2yU2tao7ZPhAOX
j03JNGpfKoZsx+EUAZmYtd56sQqLja4y2RhAHaTlapeOm5KiMH8gA5rIC2eRDEpD
uEoBPOCRv+4mIPm9zEB3FXM1tA/lIODzFchSvhdGJS10k4OcLnB8zlDY3MjrLp0R
LDeM976bmR+D4AuKHceSoZe7yvHiDkgTcesPek5YDqmVZHAR49p1aDrHKC6mc08c
pEfVKbJMEXOHcAJ9YX6/YOLJyPkZTpUBuNAA1lMGNthcOvCCrSu8xsSVsmNRGxXi
f63rjMsI4gzppRUTCpv1pDk8z0te0IM2ewyMJhZ2L8DLSK62TAg=
=JcJN
-----END PGP SIGNATURE-----

--crjwbD1ThyqzDk9rzXkoVZsBdLtVa8csR--
