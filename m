Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37395 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbKJMOd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 07:14:33 -0500
Received: by igbhv6 with SMTP id hv6so95112335igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2015 04:14:32 -0800 (PST)
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
 <5640A903.9030209@gmail.com> <pan$24d10$91cf318$b08c3c88$ac288e4@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5641DF73.7030309@gmail.com>
Date: Tue, 10 Nov 2015 07:13:39 -0500
MIME-Version: 1.0
In-Reply-To: <pan$24d10$91cf318$b08c3c88$ac288e4@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050804060409010001060108"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050804060409010001060108
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-09 16:29, Duncan wrote:
> Austin S Hemmelgarn posted on Mon, 09 Nov 2015 09:09:07 -0500 as
> excerpted:
>
>>>    btrfs fi show
>>>    Label: none  uuid: 52f170c1-725c-457d-8cfd-d57090460091
>>>     Total devices 2 FS bytes used 112.00KiB
>>>     devid    1 size 2.00GiB used 417.50MiB path /dev/sdc
>>>     devid    2 size 2.00GiB used 417.50MiB path /dev/sdd
>>>
>>>    Global spare
>>>     device size 3.00GiB path /dev/sde
>
> First of all, thanks from me too, AJ, for this very nice new feature. =3D=
:^)
>
>> Would I be correct in assuming that we can have more than one hot-spar=
e
>> device at a time?  If so, what method is used to select which one to u=
se
>> when one is needed?
>
> In the later patches overview section, patches 10,11,12,13/15 paragraph=
,
> AJ mentions a helper function to pick/release a spare device from/to th=
e
> spare devices pool.  That would appear to be patch 13, provide framewor=
k
> to get and put a spare device.
>
> Which means yes, multiple hot-spares are (at least planned to be)
> allowed. =3D:^)
Ah, you're right, somehow I missed that bit.
>
> While I'm not a coder and could very well be misinterpreting this,
> however, reading the btrfs_get_spare_device function in patch 13, there=
's
> a comment that goes like this:
>
>>> /* as of now there is only one device in the spare fs_devices */
>
> I don't read C well enough to know whether that's a comment on the
> internal progress in the function (tho I don't see any obvious hints to=

> indicate that), or whether it can be taken at face value, that right no=
w
> there's only provision for one in the "pool" (seems the more obvious
> interpretation).
>
> So unless my lack of C skills is deceiving me, while a pool is intended=
,
> current patch implementation status simply assumes a spare pool of one,=

> and the first spare found is picked. The put function in the same patch=

> doesn't appear to have a limit on the number of spares that can be adde=
d,
> so assuming the current pool implementation allows it, more than one
> spare can be added to the pool, but as I said, the get function appears=

> to assume just one in the pool, so picks the first spare it finds.
AFAICT, you are correct.  I hadn't yet gotten a chance to look at the=20
actual code, so I hadn't seen this yet.
>
> At least at the non-enterprise level, size-similar picking logic would
> seem to be pretty useful if not feature critical, then, and given that
> it /should/ be reasonably simple to implement, I'd hope that doing so
> becomes a priority, tho certainly an initial first-pick base
> implementation to which size-similar logic can be added later, is fine =
as
> well.  I'd just hope that "later" is within a couple kernel cycles, not=
 a
> couple kernel major version cycles (~4 years each with bumps at .20).
>
Hopefully, per-filesystem hot-spares will be a high priority too, as=20
that type of usage is pretty much required for many enterprise type=20
uses, although that doesn't need to be the same code doing it (in fact,=20
I could see having per-fs spares and global spares both available=20
potentially being very useful).


--------------ms050804060409010001060108
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEwMTIxMzM5WjBPBgkq
hkiG9w0BCQQxQgRAIm8yQKvynFBdOyF4VW603LgJjuclEmP5GFYL4kXuw464BB4zYE1NlRn5
mKpehE7BP83+F18/xvxwnApm1Z7TmTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBAPPFjlpcGgncvX20aDdE9dTEk2Ey1ugBpzypsAA71NvHRQXte
9gr+ir5Q1HdKHF5iE2wiNs8v9RpNGGcduVks0WdABSGZCIrh524pSvdv6BSWfd0XzUoWwH0C
bUlQdyJp30MYM1MNM9TQnI397TFWJsZsoDo+NFN5wPVnXwTKMj4q21DK9LB89R8/wf+kNM73
hGPIIuJ6iL9h1oeyExPpjOXcWr2nXH+hLWHmVKZs8eSonGy9h7TAlOtDqouAKcUBbp4pzDgG
8Wsfz6ZZLrxFvbFJ7eoFzh947dBnVTpxdXBLTm98DyeFrlv1NGrE7NEkOCe7Cxrw/l5wXLvO
KsWV3+CNfcBL2mDbBvcwKcumzkh8EpgloO2u8hRhCbUNHoxdAQi9gjwwaXjoefaaVmE2E8+k
DXbzi+47VpNDRKxrs6XIJN0zQ5i7Brg/+lj6aDaHTJQHOA0G7s6YDSVPCGhfxIhkqjcnKd4g
ebgTgcHNZwBOglvoW54vgI5GuMrPiVUhktW+HwwDX1fdQ9VpfMvjct8lAWVOtEynrCPr3eEY
H9cL1IiyKqEpQvfFRAzb4yssHu+tjBgKlr4pG/l2iaic1NpukYIXy+xB1sz2O3Y2wOLcLuz/
kcDKMzu72QMfaf3zmQH7qyzDOFC2AfduZ6I1LjXgydoX8/9rtnWDjUb6pgAAAAAAAA==
--------------ms050804060409010001060108--
