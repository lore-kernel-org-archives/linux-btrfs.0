Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43663 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752320AbdF2StO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 14:49:14 -0400
Subject: Re: Lock between userspace and btrfs-cleaner on extent_buffer
To: Sargun Dhillon <sargun@sargun.me>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
References: <CAMp4zn9Bv=ULBx9f-jPAZrmc9oOOT+egpypBPSjajd03WFA71A@mail.gmail.com>
 <CAMp4zn9KmzW2gC9hHsuATsDZSMWT6PeqkA+cBLj3wMroZkXFLA@mail.gmail.com>
 <4c844bc7-2cee-d249-b1af-e1da7cab35a0@suse.com>
 <c3f16d38-1331-e420-2a92-37db71ea8dee@suse.com>
 <CAMp4zn_6up7FVB=HdkAka7B5qkYDNE_mseiWP2+SC-v_Gu4Vog@mail.gmail.com>
 <4952ca4f-2824-fabf-1b0d-048d8e901e2f@suse.com>
 <CAMp4zn8mr-24aO6m0_vpc-9WLSkkhgscZUGcxPDhdbUYtOPrOw@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <e4a12dcf-62e9-adba-72f9-07e2d2c4ca68@suse.com>
Date: Thu, 29 Jun 2017 14:49:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAMp4zn8mr-24aO6m0_vpc-9WLSkkhgscZUGcxPDhdbUYtOPrOw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="P2pGDwCg8Qox3OCHM4pXlMNXCfiRQaSan"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P2pGDwCg8Qox3OCHM4pXlMNXCfiRQaSan
Content-Type: multipart/mixed; boundary="Eou7PbCpFCPWq1qKmBrgAk0CWAbHLsXrs";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Sargun Dhillon <sargun@sargun.me>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Message-ID: <e4a12dcf-62e9-adba-72f9-07e2d2c4ca68@suse.com>
Subject: Re: Lock between userspace and btrfs-cleaner on extent_buffer
References: <CAMp4zn9Bv=ULBx9f-jPAZrmc9oOOT+egpypBPSjajd03WFA71A@mail.gmail.com>
 <CAMp4zn9KmzW2gC9hHsuATsDZSMWT6PeqkA+cBLj3wMroZkXFLA@mail.gmail.com>
 <4c844bc7-2cee-d249-b1af-e1da7cab35a0@suse.com>
 <c3f16d38-1331-e420-2a92-37db71ea8dee@suse.com>
 <CAMp4zn_6up7FVB=HdkAka7B5qkYDNE_mseiWP2+SC-v_Gu4Vog@mail.gmail.com>
 <4952ca4f-2824-fabf-1b0d-048d8e901e2f@suse.com>
 <CAMp4zn8mr-24aO6m0_vpc-9WLSkkhgscZUGcxPDhdbUYtOPrOw@mail.gmail.com>
In-Reply-To: <CAMp4zn8mr-24aO6m0_vpc-9WLSkkhgscZUGcxPDhdbUYtOPrOw@mail.gmail.com>

--Eou7PbCpFCPWq1qKmBrgAk0CWAbHLsXrs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/29/17 2:46 PM, Sargun Dhillon wrote:
> On Thu, Jun 29, 2017 at 11:42 AM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 6/28/17 6:02 PM, Sargun Dhillon wrote:
>>> On Wed, Jun 28, 2017 at 2:55 PM, Jeff Mahoney <jeffm@suse.com> wrote:=

>>>> On 6/27/17 5:12 PM, Jeff Mahoney wrote:
>>>>> On 6/13/17 9:05 PM, Sargun Dhillon wrote:
>>>>>> On Thu, Jun 8, 2017 at 11:34 AM, Sargun Dhillon <sargun@sargun.me>=
 wrote:
>>>>>>> I have a deadlock caught in the wild between two processes --
>>>>>>> btrfs-cleaner, and userspace process (Docker). Here, you can see =
both
>>>>>>> of the backtraces. btrfs-cleaner is trying to get a lock on
>>>>>>> ffff9859d360caf0, which is owned by Docker's pid. Docker on the o=
ther
>>>>>>> hand is trying to get a lock on ffff9859dc0f0578, which is owned =
by
>>>>>>> btrfs-cleaner's Pid.
>>>>>>>
>>>>>>> This is on vanilla 4.11.3 without much workload. The background
>>>>>>> workload was basically starting and stopping Docker with a medium=

>>>>>>> sized image like ubuntu:latest with sleep 5. So, snapshot creatio=
n,
>>>>>>> destruction. And there's some stuff that's logging to btrfs.
>>>>>
>>>>> Hi Sargun -
>>>>>
>>>>> We hit this bug in testing last week.  I have a patch that I've wri=
tten
>>>>> up and have run under your reproducer for a while.  So far it hasn'=
t
>>>>> hit.  I'll post it shortly and CC you.  It does depend lightly on t=
he
>>>>> rbtree code, though.  Since we'll want this fix for -stable, I'll w=
rite
>>>>> up a version for that too.
>>>>
>>>> After thinking about it a bit more, I think my patch just happens to=

>>>> make it less likely to hit but would ultimately degrade into a livel=
ock
>>>> where it was a deadlock previously.  I was just trylocking and
>>>> requeuing, so both threads are allowed to do other work and maybe ev=
en
>>>> finish but ultimately if there's a true deadlock it'll hit anyway.
>>>>
>>>> -Jeff
>>>>
>>> Does it make sense to spend the time on making it so that
>>> btrfs-cleaner has abortable operations, and the ability to abort if
>>> the root deletion either takes too long, or if it receives a signal?
>>> Although, such a case may result in a livelock, to me it seems like a=

>>> lot less bad than deadlocking.
>>
>>
>> For now, reverting:
>>
>> commit fb235dc06fac9eaa4408ade9c8b20d45d63c89b7
>> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date:   Wed Feb 15 10:43:03 2017 +0800
>>
>>     btrfs: qgroup: Move half of the qgroup accounting time out of comm=
it
>> trans
>>
>> ... should do the trick.
>>
>> -Jeff
>>
> I thought it was this as well, but we still saw lock-ups even after
> reverting this change on 4.11. They were rarer, but we still saw
> issues with locked up btrfs-transactions. It may have been due to a
> different issue. If you want. I can try to revert this, and run a
> workload on it to see where the exact lock-up is?

Yeah, I'd be interested in those results.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--Eou7PbCpFCPWq1qKmBrgAk0CWAbHLsXrs--

--P2pGDwCg8Qox3OCHM4pXlMNXCfiRQaSan
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWVVLph57S2MheeWyAQhHQhAAs9Twc6rruv1suIWhJAQqNV06eUOpA3Ke
GOUtWr6O3QYchW38cH9rlqb83xDHx3K3pgiKK0Im8mr8cesXKpLGNG8jth6Z8P9S
cb+ObuqkDKOqnaPzPPL2hJmCkTnyjMYI4vxN3hno/RA5a0y9sW1vYNalyuKMIHWP
DBO3a4P2j384N8GgtXFLyhpkTKfR45axMqDVMi5gxBVAgNs2+7JVLVi9kuH+QE5j
zZWCLmFcLSa80rKbclipFFe1QJED29WdxKcPCGFgpDK51Hq6nNU8+LX42ADo8Ogv
n+y8YSarzkYsuCDhu3tz3ztkt+bsJrf0PgrONZ7m35wmbYedargxgLSyYGm/ZMwC
RyHyi6UawBH+UnsXWL334VyZzDDfgkbTZ3GQZRaKsN7VmIhUPRw7yguH+TZrbKCg
dGGpmLRo6+ufSEkFLQ2vrfNYNHXrfa5YSOf00V6I9P5ZCUj1PtWJPnkYpT8Y4T1f
5rJ/Nli98JR+RHSXp1Ck//1peMqr0/L2FKrEZ512/iYyyvik4jELhN1Xx90ddTRu
5YzLEacme0W2urgX5oFdvWkHOijsqe6Sz7MkgJRoVQM2NaA6wu8noDWaeg1M+QX8
QWbrPuREwW3HG58JWx+xP9PcqppkIMofT7JNUNosFMB90b3yFvw5xX7aRUkjiLA5
EoJlz/qq+04=
=nquO
-----END PGP SIGNATURE-----

--P2pGDwCg8Qox3OCHM4pXlMNXCfiRQaSan--
