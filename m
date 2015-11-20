Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:32916 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161341AbbKTNwj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 08:52:39 -0500
Received: by iouu10 with SMTP id u10so125758370iou.0
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 05:52:39 -0800 (PST)
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
To: Hugo Mills <hugo@carfax.org.uk>, Dmitry Katsubo <dma_k@mail.ru>,
        linux-btrfs@vger.kernel.org
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk> <564D1AE5.3000700@cn.fujitsu.com>
 <pan$61583$65d817c9$bfda2de6$465dca20@cox.net> <564F0671.8060402@mail.ru>
 <564F1E5B.6040004@gmail.com> <20151120132714.GK24333@carfax.org.uk>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <564F2599.6050802@gmail.com>
Date: Fri, 20 Nov 2015 08:52:25 -0500
MIME-Version: 1.0
In-Reply-To: <20151120132714.GK24333@carfax.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060607080005090402010904"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060607080005090402010904
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-20 08:27, Hugo Mills wrote:
> On Fri, Nov 20, 2015 at 08:21:31AM -0500, Austin S Hemmelgarn wrote:
>> On 2015-11-20 06:39, Dmitry Katsubo wrote:
>>> If I may add:
>>>
>>> Information for "System"
>>>
>>>    System, DUP: total=3D32.00MiB, used=3D16.00KiB
>>>
>>> is also quite technical, as for end user system =3D metadata (one can=
 call
>>> it "filesystem metadata" perhaps). For simplicity the numbers can be
>>> added to "Metadata" thus eliminating that line as well.
>>>
>>> For those power users who really want to see the tiny details like
>>> "System" and "GlobalReserve" I suggest to implement "-v" flag:
>>>
>>> # btrfs fi usage -v
>> Actually, I really like this idea, one of the questions I get asked
>> when I show people BTRFS is the difference between System and
>> Metadata, and it's not always easy to explain to somebody who
>> doesn't have a background in filesystem development.  For some
>> reason, people seem to have trouble with the concept that the system
>> tree is an index of the other trees.
>
>     Actually, it's not that in the system chunks. :)
>
>     System chunks contain the chunk tree, not the tree of tree roots.
> They're special (and small) because they're listed explicitly by devid
> and physical offset at the end of the superblock, and allow the FS to
> read them first so that it can bootstrap the logical:physical mapping
> table before it starts reading all the other metadata like the tree of
> tree roots (which is "normal" metadata).
I guess my understanding was wrong then.  Thanks for the explanation.


--------------ms060607080005090402010904
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTIwMTM1MjI1WjBPBgkq
hkiG9w0BCQQxQgRAv2xyzUI1UqpYIkeqg6VJut+tX1ypsujcrtR5KcNFgfQWamf929jDRIQC
orFiCjjZLvxdHditV5pekVxq9M7xYjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgA0gtBbBhOngCGEaYaWQLex5HGo7kDLDQca+U92ZWU/5lQ8XyjC
EnSNQiNcYubS5rbDl54ElXMvVLdmtbUr2lVkkbyoQXhh5HbuKg1+xlWtvdtzK4yelcxKz3My
7AXyr3laBlfM4Hhjtv46KAb3TEgQ3gYEzknYSEChJC6C9KTBlMGIf8ie03ighausDobJKvuC
sS3w/K3gzfF6q1jpzToK4Z3tRFxGwH4URQHHbBnlh8W0QjjeojBUSN5l/gtorgEq9ySOD6xy
zB/QZn9yGXI+XTVZs7c8vfl6Cu3yAvyz4yND8lJAcLJDjS1FOz8Siao9J00050+r1uYniB9A
o+7zZgKnPr2nAUGDEqQAhXnzNDCESusaACXMsr1PY0T9Hd/BcFHz2r7RGWc5HOg6U8BuQX4D
kZAh4FHNk7ntdPuvjOIcXYNZKyrogC6ZEgGAxzOHmH+Scid5LiP7+32pDLQMLYhcWxxhrDY6
jRyREjeu2uHN7sERSzkEdRZHsYGliWKPRqEtOfGytxNfNgQq8HnyzT6j1rDl2VTHxzXVwFdf
KL5J7qgzcDpROpBZuxJBHEHCnYatG26VQp0hVCYq1axN6l+WL4DHi4As4QpTu4+wU2QIEH50
Ilp7ASV1+dorkeg5771uS0mvhEJPOq05pcQVr0NxrieYdXYYpE7lJOTuMAAAAAAAAA==
--------------ms060607080005090402010904--
