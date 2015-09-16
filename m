Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:53876 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbbIPRBi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 13:01:38 -0400
Received: from smtp13.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp13.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id BC4FE380257
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 12:53:16 -0400 (EDT)
Received: from smtp13.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp13.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id B8A45380282
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 12:53:16 -0400 (EDT)
Received: by smtp13.relay.ord1c.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id 99758380257
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 12:53:16 -0400 (EDT)
Content-Type: multipart/signed; boundary="Apple-Mail=_C2ABD95A-7C86-4ED3-B8A1-D4901DBD92C7"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Subject: Re: FYIO: A rant about btrfs 
From: Vincent Olivier <vincent@up4.com>
In-Reply-To: <55F988A6.8070109@gmail.com>
Date: Wed, 16 Sep 2015 12:53:16 -0400
Message-Id: <AF5C102F-17A3-4562-B667-C69403B0DAB6@up4.com>
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_C2ABD95A-7C86-4ED3-B8A1-D4901DBD92C7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,


> On Sep 16, 2015, at 11:20 AM, Austin S Hemmelgarn =
<ahferroin7@gmail.com> wrote:
>=20
> On 2015-09-16 10:43, M G Berberich wrote:
>> Hello,
>>=20
>> just for information. I stumbled about a rant about =
btrfs-performance:
>>=20
>> =
http://blog.pgaddict.com/posts/friends-dont-let-friends-use-btrfs-for-oltp=




I read it too.


> It is worth noting a few things that were done incorrectly in this =
testing:
> 1. _NEVER_ turn off write barriers (nobarrier mount option), doing so =
subtly breaks the data integrity guarantees of _ALL_ filesystems, but =
especially so on COW filesystems like BTRFS.  With this off, you will =
have a much higher chance that a power loss will cause data loss.  It =
shouldn't be turned off unless you are also turning off write-caching in =
the hardware or know for certain that no write-reordering is done by the =
hardware (and almost all modern hardware does write-reordering for =
performance reasons).


But can the =E2=80=9Cnobarrier=E2=80=9D mount option affect performances =
negatively for Btrfs (and not only data integrity)?


> 2. He provides no comparison of any other filesystem with TRIM support =
turned on (it is very likely that all filesystems will demonstrate such =
performance drops.  Based on that graph, it looks like the device =
doesn't support asynchronous trim commands).


I think he means by the text surrounding the only graph that mentions =
TRIM that this exact same test on the other filesystems he benchmarked =
yield much better results.


> 3. He's testing it for a workload is a known and documented problem =
for BTRFS, and claiming that that means that it isn't worth considering =
as a general usage filesystem.  Most people don't run RDBMS servers on =
their systems, and as such, such a workload is not worth considering for =
most people.



Apparently RDBMS being a problem on Btrfs is neither known nor =
documented enough (he=E2=80=99s right about the contrast with claiming =
publicly that Btrfs is indeed production ready).

My view on this is that having one filesystem to rule them all (all =
storage technologies, all use cases) is unrealistic. Also the time when =
you could put your NAS on an old i386 with 3MB of RAM is over. =
Compression, checksumming, COW, snapshotting, quotas, etc. are all =
computationally intensive features. In 2015 block storage has become =
computationally intensive. How about saying non-root Btrfs RAID10 is the =
best choice for a Samba NAS on rotational-HDDs with no SMR (my use =
case)? For root and RDBMS, I use ext4 on a M.2 SSD and with a sane =
initramfs and the most recent stable kernel. I am happy with the =
performances and delighted with the features Btrfs provides. I think it =
is much more productive to document and compare the most successful =
Btrfs deployments rather than trying to find bugs and bottlenecks for =
use cases that are the development focus of other filesystems. I don=E2=80=
=99t know, I might not make a lot of sense here but on top of =
refactoring the Gotchas, I would be happy to start a successful =
deployment story section on the wiki and maybe improve my usage of Btrfs =
along the way (who else here is using Btrfs in a similar fashion?).



> His points about the degree of performance jitter are valid however, =
as are the complaints of apparent CPU intensive stalls in the BTRFS =
code, and I occasionally see both on my own systems.


Me too. My two cents is that focusing on improving performances for =
Btrfs-optimal use cases is much more interesting than bringing new =
features like automatically turning COW off for RDBMS usage or debugging =
TRIM support.


Vincent

--Apple-Mail=_C2ABD95A-7C86-4ED3-B8A1-D4901DBD92C7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJV+Z58AAoJEOggPckf4s149SIQAJ89LkQ07i1xbbjckwmzYDNQ
I4i6ETDyTAmb/hpw1jW1xpbS1XMLlyMaGlsVXKyIbO2lfxnE6ck0guJ70QE02s6b
BlMbR2UAxdklkBXqb30swJCwL3xTDY1EnMm4/xNZWgbp3zSxtxuHuV347w6oFlbr
Wq+AhbIvm4tUCzsUAudLAdQzHUNV0OF3CkUiTMCi0zeqgo8GVtu/CEYrNuC+Lr7+
D/UW92crpS9kbuKksUlaKruTA52lhprcAFGj0L2dIO9Bn9IVin+WQU+AQZj+/3KH
rSXHxN3nQG51Y6q3XE6aaT8m1JlzdQ8YLc6PL4YVZ0rdyhcpm8E8A2FrzKbzDW5d
zru2QUdA4HI8xKZvy9ySP2ZR/9iEh5lvwTfiLHwOOMP2V7yad/ycPqqoYyoorOFD
upPW3YqficyWog+ueuY+XOEvdXQ5cwjQefLn7EHU/ZPZ/RZDd6gTjZ/uC0LVNrUt
1lxgMxYm4pzXQ86x/1oYR6G7lxEPKvkyJnNTg/5aEhSDx7qzpPgSCFHaqkS/I7yV
hv7uYku0YK4wJFfzq1SSQCel12iL96Sc3tXUHgCvCX5Du1vei0yNjLYkFIAVX1Jg
4EzXfAl5wWB7ro68oevTaCeHPteS9cw8chM7biy7M3YB5bfOGgr7zgblLU1ymVtJ
VmwknFybvFHYK5sOEcjE
=Xleo
-----END PGP SIGNATURE-----

--Apple-Mail=_C2ABD95A-7C86-4ED3-B8A1-D4901DBD92C7--
