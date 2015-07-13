Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:35252 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbbGMLlK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 07:41:10 -0400
Received: by iecuq6 with SMTP id uq6so232904853iec.2
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 04:41:09 -0700 (PDT)
Message-ID: <55A3A3D2.9020306@gmail.com>
Date: Mon, 13 Jul 2015 07:41:06 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Did btrfs filesystem defrag just make things worse?
References: <CAC=t97A0eR34GyMLC_XhdWMVAf1YaCgX=qrXGkip991znH5N9A@mail.gmail.com>	<pan$e3829$abc1de8c$4dc42856$7192e92@cox.net>	<CAC=t97Cr6W5qU_LuEqXXNqUUizfFKAeA_febaiwfArZvX9UsKg@mail.gmail.com> <pan$a54a$19bc33f8$104eb18a$cf97db25@cox.net>
In-Reply-To: <pan$a54a$19bc33f8$104eb18a$cf97db25@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020402020400070005040009"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020402020400070005040009
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-11 11:24, Duncan wrote:
> I'm not a coder, only a list regular and btrfs user, and I'm not sure o=
n
> this, but there have been several reports of this nature on the list
> recently, and I have a theory.  Maybe the devs can step in and either
> confirm or shoot it down.
While I am a coder, I'm not a BTRFS developer, so what I say below may=20
still be incorrect.
>
[...trimmed for brevity...]
> Of course during normal use, files get deleted as well, thereby clearin=
g
> space in existing chunks.  But this space will be fragmented, with a mi=
x
> of unallocated extents and still remaining files.  The allocator will I=

> /believe/ (this is where people who can actually read the code come in)=

> try to use up space in existing chunks before allocating additional
> space, possibly subject to some reasonable extent minimum size, below
> which btrfs will simply allocate another chunk.
AFAICT, this is in fact the case.
>
> 1) Prioritize reduced fragmentation, at the expense of higher data chun=
k
> allocation.  In the extreme, this would mean always choosing to allocat=
e
> a new chunk and use it if the file (or remainder of the file not yet
> defragged) was larger than the largest free extent in existing data
> chunks.
>
> The problem with this is that over time, the number of partially used
> data chunks goes up as new ones are allocated to defrag into, but sub-1=

> GiB files that are already defragged are left where they are.  Of cours=
e
> a balance can help here, by combining multiple partial chunks into fewe=
r
> full chunks, but unless a balance is run...
>
> 2) Prioritize chunk utilization, at the expense of leaving some
> fragmentation, despite massive amounts of unallocated space.
>
> This is what I've begun to suspect defrag does.  With a bunch of free b=
ut
> fragmented space in existing chunks, defrag could actually increase
> fragmentation, as the space in existing chunks is so fragmented a rewri=
te
> is forced to use more, smaller extents, because that's all there is fre=
e,
> until another chunk is allocated.
>
> As I mentioned above for normal file allocation, it's quite possible th=
at
> there's some minimum extent size (greater than the bare minimum 4 KiB
> block size) where the allocator will give up and allocate a new data
> chunk, but if so, perhaps this size needs bumped upward, as it seems a
> bit low, today.
If I'm reading the code correctly, defrag does indeed try to avoid=20
allocating a new chunk if at all possible.
>
>
> Meanwhile, there's a number of exacerbating factors to consider as well=
=2E
>
> * Snapshots and other shared references lock extents in place.
>
> Defrag doesn't touch anything but the subvolume it's actually pointed a=
t
> for the defrag.  Other subvolumes and shared-reference files will
> continue to keep the extents they reference locked in place.  And COW
> will rewrite blocks of a file, but the old reference extent remains
> locked, until all references to it are cleared -- the entire file (or a=
t
> least all blocks that were in that extent) must be rewritten, and no
> snapshots or other references to it remain, before it can be freed.
>
> For a few kernel cycles btrfs had snapshot-aware-defrag, but that
> implementation didn't scale well at all, so it was disabled until it
> could be rewritten, and that rewrite hasn't occurred yet.  So snapshot-=

> aware-defrag remains disabled, and defrag only works on the subvolume
> it's actually pointed at.
>
> As a result, if defrag rewrites a snapshotted file, it actually doubles=

> the space that file takes, as it makes a new copy, breaking the referen=
ce
> link between it and the copy in the snapshot.
>
> Of course, with the space not freed up, this will, over time, tend to
> fragment space that is freed even more heavily.
To mitigate this, one can run offline data deduplication (duperemove is=20
the tool I'd suggest for this), although there are caveats to doing that =

as well.
>
> * Chunk reclamation.
>
> This is the relatively new development that I think is triggering the
> surge in defrag not defragging reports we're seeing now.
>
> Until quite recently, btrfs could allocate new chunks, but it couldn't,=

> on its own, deallocate empty chunks.  What tended to happen over time w=
as
> that people would find all the filesystem space taken up by empty or
> mostly empty data chunks, and btrfs would start spitting ENOSPC errors
> when it needed to allocate new metadata chunks but couldn't, as all the=

> space was in empty data chunks.  A balance could fix it, often relative=
ly
> quickly with a -dusage=3D0 or -dusage-10 filter or the like, but it was=
 a
> manual process, btrfs wouldn't do it on its own.
>
> Recently the devs (mostly) fixed that, and btrfs will automatically
> reclaim entirely empty chunks on its own now.  It still doesn't reclaim=

> partially empty chunks automatically; a manual rebalance must still be
> used to combine multiple partially empty chunks into fewer full chunks;=

> but it does well enough to make the previous problem pretty rare -- we
> don't see the hundreds of GiB of empty data chunks allocated any more,
> like we used to.
>
> Which fixed the one problem, but if my theory is correct, it exacerbate=
d
> the defrag issue, which I think was there before but seldom triggered s=
o
> it generally wasn't noticed.
>
> What I believe is happening now compared to before, based on the rash o=
f
> reports we're seeing, is that before, space fragmentation in allocated
> data chunks seldom became an issue, because people tended to accumulate=

> all these extra empty data chunks, leaving defrag all that unfragmented=

> empty space to rewrite the new extents into as it did the defrag.
>
> But now, all those empty data chunks are reclaimed, leaving defrag only=

> the heavily space-fragmented partially used chunks.  So now we're getti=
ng
> all these reports of defrag actually making the problem worse, not bett=
er!
I believe that this is in fact the root cause.  Personally, I would love =

to be able to turn this off without having to patch the kernel.  Since=20
it went in, not only does it (apparently) cause issues with defrag, but=20
DISCARD/TRIM support is broken, and most of my (heavily rewritten)=20
filesystems are running noticeably slower as well.  I'm going to start a =

discussion regarding this in another thread however, as it doesn't just=20
affect defrag.



--------------ms020402020400070005040009
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAxBuVTANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNTAz
MjUxOTM0MzhaFw0xNTA5MjExOTM0MzhaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCdD/zW
2rRAFCLnDfXpWxU1+ODqRVUgzHvrRO7ADUxRo1CBDc3JSX5TIW2OGmQ3DAKGOACp8Z0sgxMc
B05tzAZ/M7m4jajVrwwdVCdrwVGxTdAai7Kwg4ZCVfyMVhcwo8R2eW3QahBx34G0RKumK9sZ
ZQSQ+zULAzpY6uz7T1sAk/erMoivRXF6u8WvOsLkOD1F/Xyv1ZccSUG5YeDgZgc0nZUBvyIp
zXSHjgWerFkrxEM3y2z/Ff3eL1sgGYecV/I1F+I5S01V7Kclt/qRW10c/4JEGRcI1FmrJBPu
BtMYPbg/3Y9LZROYN+mVIFxZxOfrmjfFZ96xt/TaMXo8vcEKtWcNEjhGBjEbfMUEm4aq8ygQ
4MuEcpJc8DJCHBkg2KBk13DkbU2qNepTD6Uip1C+g+KMr0nd6KOJqSH27ZuNY4xqV4hIxFHp
ex0zY7mq6fV2o6sKBGQzRdI20FDYmNjsLJwjH6qJ8laxFphZnPRpBThmu0AjuBWE72GnI1oA
aO+bs92MQGJernt7hByCnDO82W/ykbVz+Ge3Sax8NY0m2Xdvp6WFDY/PjD9CdaJ9nwQGsUSa
N54lrZ2qMTeCI9Vauwf6U69BA42xgk65VvxvTNqji+tZ4aZbarZ7el2/QDHOb/rRwlCFplS/
z4l1f1nOrE6bnDl5RBJyW3zi74P6GwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAGvl7xb42JMRH5D/vCIDYvFY3dR2FPd5kmOqpKU/fvQ8ovmJa
p5N/FDrsCL+YdslxPY+AAn78PYmL5pFHTdRadT++07DPIMtQyy2qd+XRmz6zP8Il7vGcEDmO
WmMLYMq4xV9s/N7t7JJp6ftdIYUcoTVChUgilDaRWMLidtslCdRsBVfUjPb1bF5Ua31diKDP
e0M9/e2CU36rbcTtiNCXhptMigzuL3zJXUf2B9jyUV8pnqNEQH36fqJ7YTBLcpq3aYa2XbAH
Hgx9GehJBIqwspDmhPCFZ/QmqUXCkt+XfvinQ2NzKR6P3+OdYbwqzVX8BdMeojh7Ig8x/nIx
mQ+/ufstL1ZYp0bg13fyK/hPYSIBpayaC76vzWovkIm70DIDRIFLi20p/qTd7rfDYy831Hjm
+lDdCECF9bIXEWFk33kA97dgQIMbf5chEmlFg8S0e4iw7LMjvRqMX3eCD8GJ2+oqyZUwzZxy
S0Mx+rBld5rrN7LsXwZ671HsGqNeYbYeU25e7t7/Gcc6Bd/kPfA+adEuUGFcvUKH3trDYqNq
6mOkAd8WO/mQadlc3ztS++XDMhmIpfBre9MPAr6usqf+wc+R8Nk9KLK39kEgrqVfzc/fgf8L
MaD4rHnusdg4gca6Yi+kNrm99anw7SwaBrBvULYBp7ixNRUhaYiNW4YjTrYxggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5VMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcxMzExNDEwNlowIwYJKoZIhvcNAQkE
MRYEFMYgCNJMck6OuFGgIjH+p75rl0BIMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICABiQWdKW8FCVjlWycsRCPm4+d159ltShlSX49NXnP0szkjVw
LN7ZlFEp4FBad1H59q15QzoOWR+cODuRGpfuthKcvyLVPl0ZJcaCGZH/6VUB9Y2QvzKBdjGK
yMf4sWEla/LkizrirbXjTTu6Z79QBevFu+UArE3NptvKtu3l4TzVRGQEK2OIfNSm0JBFe5cA
2F7GDwWyaxc6qYfqVWnnt+xnmIdb76F6PGAVBTpufxttIn+jUquebRfGEucaMU9O0zyr7P1n
euugqo9yg7XYO0qD9g8+H7CgOuo9ohvxy3BZkY/wycAcb99dYBGcezs+uCPwQtrGYQoCilZX
jewWu0/caaFZ1LyxiGeq9kE9RBGDkmvkjJMRaSKJytDJiOOW1MSeRSV8ZjvRRGUp+s6Z7DPC
iFO/Y3TuIyyz3MAl6hMStp2S/GM+GLblIEaYEuenwshSk5IMyRENqX+4Y8WOwrqi6E7ziNgF
KNog5PERSs/Ge80iTX1LYTk/p/6IrocijAfVeaMUffCQpYo2cokxuS0tT08uNxqXOjXV4MmV
joWQ83APN6OTRxL7sXWs7zUEGOwD3Cze6TrGq5J4XVqJbONXHPw4MZOyaPnZokj7m0ShFGA2
uh3VN7pUtw/hO3epBMdksDGBykGiNbIj4Kn3aiX5lnbNbOErAuF6inAj9AgnAAAAAAAA
--------------ms020402020400070005040009--
