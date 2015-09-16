Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38207 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbbIPSWV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 14:22:21 -0400
Received: by igxx6 with SMTP id x6so37191669igx.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 11:22:21 -0700 (PDT)
Subject: Re: FYIO: A rant about btrfs
To: Vincent Olivier <vincent@up4.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
 <A4269DC6-6CD6-4E8C-B3C9-5F5DDBE86911@up4.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F9B357.4070505@gmail.com>
Date: Wed, 16 Sep 2015 14:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <A4269DC6-6CD6-4E8C-B3C9-5F5DDBE86911@up4.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000404070606090801080704"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000404070606090801080704
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-16 12:51, Vincent Olivier wrote:
> Hi,
>
>
>> On Sep 16, 2015, at 11:20 AM, Austin S Hemmelgarn <ahferroin7@gmail.co=
m> wrote:
>>
>> On 2015-09-16 10:43, M G Berberich wrote:
>>> Hello,
>>>
>>> just for information. I stumbled about a rant about btrfs-performance=
:
>>>
>>>   http://blog.pgaddict.com/posts/friends-dont-let-friends-use-btrfs-f=
or-oltp
> I read it too.
>> It is worth noting a few things that were done incorrectly in this tes=
ting:
>> 1. _NEVER_ turn off write barriers (nobarrier mount option), doing so =
subtly breaks the data integrity guarantees of _ALL_ filesystems, but esp=
ecially so on COW filesystems like BTRFS.  With this off, you will have a=
 much higher chance that a power loss will cause data loss.  It shouldn't=
 be turned off unless you are also turning off write-caching in the hardw=
are or know for certain that no write-reordering is done by the hardware =
(and almost all modern hardware does write-reordering for performance rea=
sons).
> But can the =E2=80=9Cnobarrier=E2=80=9D mount option affect performance=
s negatively for Btrfs (and not only data integrity)?
Using it improves performance for every filesystem on Linux that=20
supports it.  This does not mean that it is _EVER_ a good idea to do so. =

  This mount option is one of the few things on my list of things that I =

will _NEVER_ personally provide support to people for, because it almost =

guarantees that you will lose data if the system dies unexpectedly (even =

if it's for a reason other than power loss).
>> 2. He provides no comparison of any other filesystem with TRIM support=
 turned on (it is very likely that all filesystems will demonstrate such =
performance drops.  Based on that graph, it looks like the device doesn't=
 support asynchronous trim commands).
> I think he means by the text surrounding the only graph that mentions T=
RIM that this exact same test on the other filesystems he benchmarked yie=
ld much better results.
Possibly, but there are also known issues with TRIM/DISCARD on BTRFS in=20
4.0.  And his claim is still baseless unless he actually provides=20
reference for it.
>> 3. He's testing it for a workload is a known and documented problem fo=
r BTRFS, and claiming that that means that it isn't worth considering as =
a general usage filesystem.  Most people don't run RDBMS servers on their=
 systems, and as such, such a workload is not worth considering for most =
people.
> Apparently RDBMS being a problem on Btrfs is neither known nor document=
ed enough (he=E2=80=99s right about the contrast with claiming publicly t=
hat Btrfs is indeed production ready).
OK, maybe not documented, but RDBMS falls under 'Large files with highly =

random access patterns and heavy RMW usage', which is a known issue for=20
BTRFS, and also applies to VM images.
> My view on this is that having one filesystem to rule them all (all sto=
rage technologies, all use cases) is unrealistic. Also the time when you =
could put your NAS on an old i386 with 3MB of RAM is over. Compression, c=
hecksumming, COW, snapshotting, quotas, etc. are all computationally inte=
nsive features. In 2015 block storage has become computationally intensiv=
e. How about saying non-root Btrfs RAID10 is the best choice for a Samba =
NAS on rotational-HDDs with no SMR (my use case)? For root and RDBMS, I u=
se ext4 on a M.2 SSD and with a sane initramfs and the most recent stable=
 kernel. I am happy with the performances and delighted with the features=
 Btrfs provides. I think it is much more productive to document and compa=
re the most successful Btrfs deployments rather than trying to find bugs =
and bottlenecks for use cases that are the development focus of other fil=
esystems. I don=E2=80=99t know, I might not make a lot of sense here but =
on top of refactoring the Gotchas, I would be happy to
 start a successful deployment story section on the wiki and maybe improv=
e my usage of Btrfs along the way (who else here is using Btrfs in a simi=
lar fashion?).
Agreed, there's a reason that XFS was never the default in most Linux=20
distributions, and similarly why there are so many filesystem drivers=20
available.  Any given filesystem can have a number of arguments made=20
against it, for example:
  * ZFS: Ridiculously resource hungry, and doesn't use the normal page-ca=
che
  * XFS: filesystems can't be shrunk, and tends to perform slow under=20
light load compared to most other filesystems.
  * NTFS: Poor file layout for many use cases, and clusters all the=20
metadata together in one place.
  * ext*: Lacks some useful functionality (reflinks for example), and=20
the file layout and aggressive journaling are usually bad for flash.
  * reiserfs: numerous gotchas in usage, and fsck loses it's mind when=20
dealing with filestems that have reiserfs images stored in them as=20
regular files
>> His points about the degree of performance jitter are valid however, a=
s are the complaints of apparent CPU intensive stalls in the BTRFS code, =
and I occasionally see both on my own systems.
> Me too. My two cents is that focusing on improving performances for Btr=
fs-optimal use cases is much more interesting than bringing new features =
like automatically turning COW off for RDBMS usage or debugging TRIM supp=
ort.
It depends, BTRFS is still not feature complete with the overall intent=20
when it was started (raid56 and qgroups being the two big issues at the=20
moment), and attempting to optimize things tends to introduce bugs,=20
which we have quite enough of already without people adding more (and=20
they still seem to be breeding like rabbits).

That said, my systems (which are usually doing mostly CPU or memory=20
bound tasks, and not I/O bound like the aforementioned benchmarks were=20
testing) run no slower than they did with ext4 as the main filesystem,=20
and in some cases work much faster (even after averaging out the jitter=20
in performance).  Based on this, I wouldn't advocate it for most server=20
usage (except possibly as the root filesystem), but it does work very=20
well for most desktop usage patterns and a number of HPC usage patterns=20
as well.


--------------ms000404070606090801080704
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE2MTgyMjE1WjBPBgkq
hkiG9w0BCQQxQgRAaTpGoHSuVzTPhywLJR5PMjM/vEKq9Lb3MW8cGASDT6aYWBc/iW3tlaFI
XauFxQ7Tu5vxkTtLmf8N17g6ZiEqtTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBmU3dAZYyNx5T4frlCF82KopNUx2XAYwdHg4IenBUG+RbHhUOD
yBCVrDEcWr+fkV/uOjdq+2DYfgLSE4mN4iTQxHNf1rfIXEwh/0kCqqtTszi+DEkVPMxmKg4Z
nNKJ9wmo+Hoq0gVjtYHUk1Pn3ViVx3ghfmGLWwyQIu82P+0VNsB9xcd7sg+CV7pgUHiAJC8E
MU/NufvrNB8OlWhdFiCegazNfmxdDeZszQOinAv8T6jX4PkELm4S42HOmg/x3bZ02rXq7qi2
gm/tlA9wjqsCLswtc25ibiltusS8jzrfDOaHhW2Pz33uPgszmXHhZa2j0Hnx6TLg5SHggDUh
2opbMNSyF9lqj4mKPNoRqfLCYdDrJ286DGN/tHG00y0CLs4SjUrJiGolq/Oro1xd4Wm675vu
3RkTDmuvDjhob04/HhOCquFDrQ98e4oeLtjnmnQDmo58gNMqDDNMK98n+qlmaKgmXyRECRUb
Mo1QevqNPkcmHSUcNSi+FOLe5PpWqAnv9IYdyic5EeMIgpBfNjqOPSnK/1jPxxBPqbv07tcQ
f7kJsLPE+c/ZOs4/Xu7IjXNweJBoojUVg1c07dnbV3CexUh1X8EMTG6SWBQZi7xdrIESBpd7
NGsG2h6XbBo7zCpTCLGW3zBc1Yoip2sRb8XxQcciQ65OaP19Y+EsWBbnrwAAAAAAAA==
--------------ms000404070606090801080704--
