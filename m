Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:55533 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbbIPTEk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 15:04:40 -0400
Received: from smtp4.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp4.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id A2A061802D8
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 15:04:39 -0400 (EDT)
Received: from smtp4.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp4.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 9D32F18030A
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 15:04:39 -0400 (EDT)
Received: by smtp4.relay.ord1c.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id 787751802D8
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 15:04:39 -0400 (EDT)
Content-Type: multipart/signed; boundary="Apple-Mail=_C77A4C1B-D595-4932-B816-9137B7DEED29"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Subject: Re: FYIO: A rant about btrfs
From: Vincent Olivier <vincent@up4.com>
In-Reply-To: <55F9B357.4070505@gmail.com>
Date: Wed, 16 Sep 2015 15:04:38 -0400
Message-Id: <54A9EC91-FDFD-44A8-97B9-7347A89FA415@up4.com>
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com> <A4269DC6-6CD6-4E8C-B3C9-5F5DDBE86911@up4.com> <55F9B357.4070505@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_C77A4C1B-D595-4932-B816-9137B7DEED29
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Sep 16, 2015, at 2:22 PM, Austin S Hemmelgarn =
<ahferroin7@gmail.com> wrote:
>=20
> On 2015-09-16 12:51, Vincent Olivier wrote:
>> Hi,
>>=20
>>=20
>>> On Sep 16, 2015, at 11:20 AM, Austin S Hemmelgarn =
<ahferroin7@gmail.com> wrote:
>>>=20
>>> On 2015-09-16 10:43, M G Berberich wrote:
>>>> Hello,
>>>>=20
>>>> just for information. I stumbled about a rant about =
btrfs-performance:
>>>>=20
>>>>  =
http://blog.pgaddict.com/posts/friends-dont-let-friends-use-btrfs-for-oltp=

>> I read it too.
>>> It is worth noting a few things that were done incorrectly in this =
testing:
>>> 1. _NEVER_ turn off write barriers (nobarrier mount option), doing =
so subtly breaks the data integrity guarantees of _ALL_ filesystems, but =
especially so on COW filesystems like BTRFS.  With this off, you will =
have a much higher chance that a power loss will cause data loss.  It =
shouldn't be turned off unless you are also turning off write-caching in =
the hardware or know for certain that no write-reordering is done by the =
hardware (and almost all modern hardware does write-reordering for =
performance reasons).
>> But can the =E2=80=9Cnobarrier=E2=80=9D mount option affect =
performances negatively for Btrfs (and not only data integrity)?
> Using it improves performance for every filesystem on Linux that =
supports it.  This does not mean that it is _EVER_ a good idea to do so. =
 This mount option is one of the few things on my list of things that I =
will _NEVER_ personally provide support to people for, because it almost =
guarantees that you will lose data if the system dies unexpectedly (even =
if it's for a reason other than power loss).



OK fine. Let it be clearer then (on the Btrfs wiki): nobarrier is an =
absolute no go. Case closed.



>>> 2. He provides no comparison of any other filesystem with TRIM =
support turned on (it is very likely that all filesystems will =
demonstrate such performance drops.  Based on that graph, it looks like =
the device doesn't support asynchronous trim commands).
>> I think he means by the text surrounding the only graph that mentions =
TRIM that this exact same test on the other filesystems he benchmarked =
yield much better results.
> Possibly, but there are also known issues with TRIM/DISCARD on BTRFS =
in 4.0.  And his claim is still baseless unless he actually provides =
reference for it.



Same as above: TRIM/DISCARD officially not recommended in production =
until further notice?



>>> 3. He's testing it for a workload is a known and documented problem =
for BTRFS, and claiming that that means that it isn't worth considering =
as a general usage filesystem.  Most people don't run RDBMS servers on =
their systems, and as such, such a workload is not worth considering for =
most people.
>> Apparently RDBMS being a problem on Btrfs is neither known nor =
documented enough (he=E2=80=99s right about the contrast with claiming =
publicly that Btrfs is indeed production ready).
> OK, maybe not documented, but RDBMS falls under 'Large files with =
highly random access patterns and heavy RMW usage', which is a known =
issue for BTRFS, and also applies to VM images.


This guy is no idiot. If it wasn=E2=80=99t clear enough for him. It=E2=80=99=
s not clear enough period.


>>> His points about the degree of performance jitter are valid however, =
as are the complaints of apparent CPU intensive stalls in the BTRFS =
code, and I occasionally see both on my own systems.
>> Me too. My two cents is that focusing on improving performances for =
Btrfs-optimal use cases is much more interesting than bringing new =
features like automatically turning COW off for RDBMS usage or debugging =
TRIM support.
> It depends, BTRFS is still not feature complete with the overall =
intent when it was started (raid56 and qgroups being the two big issues =
at the moment), and attempting to optimize things tends to introduce =
bugs, which we have quite enough of already without people adding more =
(and they still seem to be breeding like rabbits).



I would just like a clear statement from a dev-lead saying : until we =
are feature-complete (with a finite list of features to complete) the =
focus will be on feature-completion and not optimizing =
already-implemented features. Ideally with an ETA on when optimization =
will be more of a priority than it is today.



> That said, my systems (which are usually doing mostly CPU or memory =
bound tasks, and not I/O bound like the aforementioned benchmarks were =
testing) run no slower than they did with ext4 as the main filesystem, =
and in some cases work much faster (even after averaging out the jitter =
in performance).  Based on this, I wouldn't advocate it for most server =
usage (except possibly as the root filesystem), but it does work very =
well for most desktop usage patterns and a number of HPC usage patterns =
as well.



See, this is interesting: I=E2=80=99d rather have a super fast and =
discardable SSD F2FS/ext4 root with a large Btrfs RAID for (NAS) server =
usage. Does your non-advocacy of Btrfs for server usage include a <10 =
user Samba NAS ?

Are more details about the Facebook deployment going to be available =
soon ? I=E2=80=99m very curious about this.

Regards,

Vincent

--Apple-Mail=_C77A4C1B-D595-4932-B816-9137B7DEED29
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJV+b1HAAoJEOggPckf4s14z4QQAJ37w0ZgIL/kFlb4JqKLZ94N
QmnrBVvQuBneeacM6X44GouZBmhfCFJRdx+bO07NzfL/r9B6EadvqzUMcZvfzC2h
hRKMdRpehuUDaS7HEfeEmyUWUYaXS69s9D3N7qxqrNHP5OCMNsS8rgKuRl9Liqq6
AdItCa5Srj24NDudMXGUnRPyIO1yp19wqHU/2yY6wXiqYL4JEOlwlbiydcHU87bn
/NsUnnZehEOlKl7AgAmiFxTUDhW91GXa5mgxxCSOdJv47ZoGRjAKgAj6cEH87ki3
fCjqPlUVaKxrTNIHwxY2VZWoG4uCDTa2gxrgVIM79Sq7ZFxUTWSNA2MKM7JF23gf
uMhI865wbgoc4zZqnngYkPZAxpoDuLxmQu3IEylqnvukxa9kLRU7IWjTISSCCG/C
qIEZdQa7QNH3s24kUbsc9duAEmSQv7d0hDdHMaixUu95dDBwYoWGeTbYvRfPuM4Y
Zn0JG3R6ulW3Ffq3UJIGoyviefzP8m1oIkV75lSZr7nHqynzky2IV+jh+I438bot
36a0jmvceQ20yqPPPTkZjU0+yFp/XRXOE8MYG8FT/BFbHVCnsPmtGF6tgBq4eGTl
cUr3oXu+Vz7OhmMdiBFw76nMadlTP9tdQEmPBM+CxWd8dAQHvCAWQu29964/6Xq9
nFUy3aToJ1R8n5WPXzy8
=Cruz
-----END PGP SIGNATURE-----

--Apple-Mail=_C77A4C1B-D595-4932-B816-9137B7DEED29--
