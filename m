Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46373 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753517AbdHIPnF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Aug 2017 11:43:05 -0400
Subject: Re: Btrfs umount hang
To: Angel Shtilianov <kernel@kyup.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
 <c9fbfedd-1a3b-b6f4-8773-1a7e5f79f18a@suse.com>
 <1d36851e-6a1c-1c32-ee00-96f43ead55d2@suse.com>
 <CAJM9R-+=ww-7Zz9rgsGuCmiPZFZ+U8zhLHA4bEuzNederH49OQ@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <0bea5669-f6de-b14b-4e40-15f144a60976@suse.com>
Date: Wed, 9 Aug 2017 11:42:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAJM9R-+=ww-7Zz9rgsGuCmiPZFZ+U8zhLHA4bEuzNederH49OQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XwVCKeBGurT3hu9WUK9VSjBIRgiuiHTIW"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XwVCKeBGurT3hu9WUK9VSjBIRgiuiHTIW
Content-Type: multipart/mixed; boundary="Gfc6X8fmlEL3vjmEKrOw12AQOEsG2hIew";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Angel Shtilianov <kernel@kyup.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <0bea5669-f6de-b14b-4e40-15f144a60976@suse.com>
Subject: Re: Btrfs umount hang
References: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
 <c9fbfedd-1a3b-b6f4-8773-1a7e5f79f18a@suse.com>
 <1d36851e-6a1c-1c32-ee00-96f43ead55d2@suse.com>
 <CAJM9R-+=ww-7Zz9rgsGuCmiPZFZ+U8zhLHA4bEuzNederH49OQ@mail.gmail.com>
In-Reply-To: <CAJM9R-+=ww-7Zz9rgsGuCmiPZFZ+U8zhLHA4bEuzNederH49OQ@mail.gmail.com>

--Gfc6X8fmlEL3vjmEKrOw12AQOEsG2hIew
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/8/17 7:30 AM, Angel Shtilianov wrote:
> crash> bt -f 31625
> PID: 31625  TASK: ffff88046a833400  CPU: 7   COMMAND: "btrfs-transacti"=

> wants to acquire struct extent_buffer ffff88000460aca0 lock, whose
> lock_owner is 27574.
>=20
> here is pid 27574:
> PID: 27574  TASK: ffff88038b469a00  CPU: 4   COMMAND: "kworker/u32:9"
> which is also is trying to acquire eb lock ffff8802598b6200, and here
> the owner is 31696.
>=20
> 31696 is
> PID: 31696  TASK: ffff88044b59ce00  CPU: 5   COMMAND: "umount"
>=20
> So definitely here is a kind of deadlock.
> umount holds the lock needed by the workers to complete and waits them
> to complete.
> Lockdep wouldn't complain about that.
> I am still about to investigate what has previously triggered/disabled =
lockdep.
> I have to obtain the log from the machine, but I need some time to get =
it.
>=20
> Jeff, you were right.
> Could you help demystifying how we ended up here?

Hi Angel -

It looks like a regression introduced by 291c7d2f5, but that's a very
old commit.  As that commit says, it's a rare occurence to hit that
wait, and that's probably why we haven't seen this issue sooner.

There's potential for this to happen whenever two threads are modifying
the tree at once and one needs to find a free extent.  I'll need to
think a bit on how to fix it.

-Jeff

> Best regards,
> Angel
>=20
> On Mon, Aug 7, 2017 at 9:10 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 8/7/17 1:19 PM, Jeff Mahoney wrote:
>>> On 8/7/17 10:12 AM, Angel Shtilianov wrote:
>>>> Hi there,
>>>> I'm investigating sporadic hanging during btrfs umount. The FS is
>>>> contained in a loop mounted file.
>>>> I have no reproduction scenario and the issue may happen once a day =
or
>>>> once a month. It is rare, but frustrating.
>>>> I have a crashdump (the server has been manually crashed and collect=
ed
>>>> a crashdump), so I could take look through the data structures.
>>>> What happens is that umount is getting in D state and a the kernel
>>>> complains about hung tasks. We are using kernel 4.4.y The actual bac=
k
>>>> trace is from 4.4.70, but this happens with all the 4.4 kernels I've=

>>>> used (4.4.30 through 4.4.70).
>>>> Tasks like:
>>>> INFO: task kworker/u32:9:27574 blocked for more than 120 seconds.
>>>> INFO: task kworker/u32:12:27575 blocked for more than 120 seconds.
>>>> INFO: task btrfs-transacti:31625 blocked for more than 120 seconds.
>>>> are getting blocked waiting for btrfs_tree_read_lock, which is owned=

>>>> by task umount:31696 (which is also blocked for more than 120 second=
s)
>>>> regarding the lock debug.
>>>>
>>>> umount is hung in "cache_block_group", see the '>' mark:
>>>>        while (cache->cached =3D=3D BTRFS_CACHE_FAST) {
>>>>                 struct btrfs_caching_control *ctl;
>>>>
>>>>                 ctl =3D cache->caching_ctl;
>>>>                 atomic_inc(&ctl->count);
>>>>                 prepare_to_wait(&ctl->wait, &wait, TASK_UNINTERRUPTI=
BLE);
>>>>                 spin_unlock(&cache->lock);
>>>>
>>>>>                schedule();
>>>>
>>>>                 finish_wait(&ctl->wait, &wait);
>>>>                 put_caching_control(ctl);
>>>>                 spin_lock(&cache->lock);
>>>>         }
>>>>
>>>> The complete backtraces could be found in the attached log.
>>>>
>>>> Do you have any ideas ?
>>>
>>> Hi Angel -
>>>
>>> In your log, it says lockdep is disabled.  What tripped it earlier?
>>> Lockdep really should be catching locking deadlocks in situations lik=
e
>>> this, if that's really the underlying cause.
>>
>> Actually, I'm not sure if lockdep would catch this one.  Here's my
>> hypothesis:
>>
>> kworker/u32:9 is waiting on a read lock while reading the free space
>> cache, which means it owns the cache->cached value and will issue the
>> wakeup when it completes.
>>
>> umount is waiting on for the wakeup from kworker/u32:9 but is holding
>> some tree locks in write mode.
>>
>> If kworker/u32:9 is waiting on the locks that umount holds, we have a
>> deadlock.
>>
>> Can you dump the extent buffer that kworker/u32:9 is waiting on?  Part=

>> of that will contain the PID of the holder, and if matches umount, we
>> found the cause.
>>
>> -Jeff
>>
>> --
>> Jeff Mahoney
>> SUSE Labs
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--Gfc6X8fmlEL3vjmEKrOw12AQOEsG2hIew--

--XwVCKeBGurT3hu9WUK9VSjBIRgiuiHTIW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWYsthR57S2MheeWyAQhO3xAAtaxjA0p+kTOE96ThTznbRJJ9ZJBeZqW6
/y7Y6tuuQKk7tvmyDoJkdyfPwbZEiOvkJp+M13mi7oW4RQy+jNzwfYS8dbJlv7tX
SucvtCeyv10OJ47f4hv/e4M0DK6ndOtTwOTH2oe+KYDCbMJFTH+0KF9PNvonTYcT
u/Ml/b2EvSudMoLmcE7Y1n7wqSbC8WMVmi9TdY58GRiw9LSfwhUUyJp+URJZmTbS
IhgYUe6jHeiKTgIcjZM2r/8GVElf/K5R320/4GdGjbrxdJxv8vXew2zhMvI3HUAe
yUrhmXjjgPudomPVAehBeDF9r6YqlTf9CsApgunFz0v32ocxtaNdacRwP9HJ7k9I
1BmYfwaZ9yM0xyvrHUymtg6FQcN+/I0ifmdpMJXNOZINHCBJsRSsBdNkplf2tvAT
1fUANEi98pAyHv/vYmu67H+A20jftCdbdH5aUBHRL1emGY9POo8so8TzIXGht2yp
Av/SpAqzlUJTh7pgNANewoX0JGXDwsef1s0T+9n2SV4SED2cDLpcEPfYsreiz91R
gdpf7OW6lrgW1lFRWy/uqhhGg+2LxayQJQIkqKzZTkpC97fRGFLOoPwRZuLaCZ/j
yUGHN46eiAb2XrTYFAawubOOcJPrjbTEBtIWFDip/px5GQaN3CMajRy8vs3hepQD
PnHd0JYNrCg=
=Amp2
-----END PGP SIGNATURE-----

--XwVCKeBGurT3hu9WUK9VSjBIRgiuiHTIW--
