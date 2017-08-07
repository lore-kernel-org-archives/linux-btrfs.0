Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36003 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751429AbdHGSKp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Aug 2017 14:10:45 -0400
Subject: Re: Btrfs umount hang
From: Jeff Mahoney <jeffm@suse.com>
To: Angel Shtilianov <kernel@kyup.com>, linux-btrfs@vger.kernel.org
References: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
 <c9fbfedd-1a3b-b6f4-8773-1a7e5f79f18a@suse.com>
Message-ID: <1d36851e-6a1c-1c32-ee00-96f43ead55d2@suse.com>
Date: Mon, 7 Aug 2017 14:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <c9fbfedd-1a3b-b6f4-8773-1a7e5f79f18a@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GuHfS0MR3aSD90IHmOu4j7Ew3TktcSWiv"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GuHfS0MR3aSD90IHmOu4j7Ew3TktcSWiv
Content-Type: multipart/mixed; boundary="Rugn154bbLgXSDKSBbQVsOJEJ40w6Jome";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Angel Shtilianov <kernel@kyup.com>, linux-btrfs@vger.kernel.org
Message-ID: <1d36851e-6a1c-1c32-ee00-96f43ead55d2@suse.com>
Subject: Re: Btrfs umount hang
References: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
 <c9fbfedd-1a3b-b6f4-8773-1a7e5f79f18a@suse.com>
In-Reply-To: <c9fbfedd-1a3b-b6f4-8773-1a7e5f79f18a@suse.com>

--Rugn154bbLgXSDKSBbQVsOJEJ40w6Jome
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/7/17 1:19 PM, Jeff Mahoney wrote:
> On 8/7/17 10:12 AM, Angel Shtilianov wrote:
>> Hi there,
>> I'm investigating sporadic hanging during btrfs umount. The FS is
>> contained in a loop mounted file.
>> I have no reproduction scenario and the issue may happen once a day or=

>> once a month. It is rare, but frustrating.
>> I have a crashdump (the server has been manually crashed and collected=

>> a crashdump), so I could take look through the data structures.
>> What happens is that umount is getting in D state and a the kernel
>> complains about hung tasks. We are using kernel 4.4.y The actual back
>> trace is from 4.4.70, but this happens with all the 4.4 kernels I've
>> used (4.4.30 through 4.4.70).
>> Tasks like:
>> INFO: task kworker/u32:9:27574 blocked for more than 120 seconds.
>> INFO: task kworker/u32:12:27575 blocked for more than 120 seconds.
>> INFO: task btrfs-transacti:31625 blocked for more than 120 seconds.
>> are getting blocked waiting for btrfs_tree_read_lock, which is owned
>> by task umount:31696 (which is also blocked for more than 120 seconds)=

>> regarding the lock debug.
>>
>> umount is hung in "cache_block_group", see the '>' mark:
>>        while (cache->cached =3D=3D BTRFS_CACHE_FAST) {
>>                 struct btrfs_caching_control *ctl;
>>
>>                 ctl =3D cache->caching_ctl;
>>                 atomic_inc(&ctl->count);
>>                 prepare_to_wait(&ctl->wait, &wait, TASK_UNINTERRUPTIBL=
E);
>>                 spin_unlock(&cache->lock);
>>
>>>                schedule();
>>
>>                 finish_wait(&ctl->wait, &wait);
>>                 put_caching_control(ctl);
>>                 spin_lock(&cache->lock);
>>         }
>>
>> The complete backtraces could be found in the attached log.
>>
>> Do you have any ideas ?
>=20
> Hi Angel -
>=20
> In your log, it says lockdep is disabled.  What tripped it earlier?
> Lockdep really should be catching locking deadlocks in situations like
> this, if that's really the underlying cause.

Actually, I'm not sure if lockdep would catch this one.  Here's my
hypothesis:

kworker/u32:9 is waiting on a read lock while reading the free space
cache, which means it owns the cache->cached value and will issue the
wakeup when it completes.

umount is waiting on for the wakeup from kworker/u32:9 but is holding
some tree locks in write mode.

If kworker/u32:9 is waiting on the locks that umount holds, we have a
deadlock.

Can you dump the extent buffer that kworker/u32:9 is waiting on?  Part
of that will contain the PID of the holder, and if matches umount, we
found the cause.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--Rugn154bbLgXSDKSBbQVsOJEJ40w6Jome--

--GuHfS0MR3aSD90IHmOu4j7Ew3TktcSWiv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWYitIh57S2MheeWyAQg8ehAAniO0aXHQoheaQtQMqUgY96P5xkZCdmiX
UanXD/40Xs33WwevWNixH17+Hp38ctPopkiEwu+Za8OCMj8ozdtPJOiWkCa7rASL
t0hngSeCEyJuHJmC/Sd1POWDS5/2No7OGzLkkjZN+r1Rew9EAiyJvDGhrGQPSH+7
tjKfqBxDHgdUMs4RTBO4kg4K74FFxI1tF6U3CdR27t3m+aqqKxpKemIf5hM/GaAG
C8otU3yh7HpN8OkQkZV67iHjO+BUJFrMOSqwaMn1sb0DLwt7A4F3cgjC7uate63I
dH97DxsMmfkjNWImiaYX7xczc73Vq+NNpKmXGKAtXS43bKC+6NtiDoVmJHsoTz1P
UuUb1X10RS6pOpmxDSf/uaNt7X7qJTBF9VKvSLUU9le0nH8Fv+/RfXWWGMOEd/iD
EMl/6fYEOitNiyYWEDltVHd8oGjyYWQjnO96F/xIUTceupC/paqkgq6EJ5bQSRji
js3bpEOkpjc/ByE6Bza9Jg/ayPp7a0xHNbagPFp7N4aFLdVfXMlKHLiAjA8GQf4L
Y/Sl/aGqY0rhPBqcXWD9MoMtLAyMPYiRXPP7nyU/U7af5EIGQo+mtTl8tlOAdR8z
L+o1GeLeFtQJqp6j9InN/v33QiJH1MUJrVnorvR3nee/nPEKHwEd8wfpqE3SeTtM
cYcBRTw+jPQ=
=Lw4o
-----END PGP SIGNATURE-----

--GuHfS0MR3aSD90IHmOu4j7Ew3TktcSWiv--
