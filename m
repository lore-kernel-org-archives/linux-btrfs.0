Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:53060 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaEVLKp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 07:10:45 -0400
Received: by mail-ig0-f171.google.com with SMTP id c1so7443015igq.4
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 04:10:44 -0700 (PDT)
Message-ID: <537DDB36.8070104@gmail.com>
Date: Thu, 22 May 2014 07:10:46 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: ditto blocks on ZFS
References: <2308735.51F3c4eZQ7@xev> <4483661.BdmCOR8JR5@xev> <57f050e2a37907d810b40c5e115b28ff.squirrel@webmail.wanet.net> <1795587.Ol58oREtZ7@xev> <lljbfo$6vm$1@ger.gmane.org>
In-Reply-To: <lljbfo$6vm$1@ger.gmane.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030407080907080607060703"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030407080907080607060703
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2014-05-21 19:05, Martin wrote:
> Very good comment from Ashford.
>=20
>=20
> Sorry, but I see no advantages from Russell's replies other than for a
> "feel-good" factor or a dangerous false sense of security. At best,
> there is a weak justification that "for metadata, again going from 2% t=
o
> 4% isn't going to be a great problem" (storage is cheap and fast).
>=20
> I thought an important idea behind btrfs was that we avoid by design in=

> the first place the very long and vulnerable RAID rebuild scenarios
> suffered for block-level RAID...
>=20
>=20
> On 21/05/14 03:51, Russell Coker wrote:
>> Absolutely. Hopefully this discussion will inspire the developers to
>> consider this an interesting technical challenge and a feature that
>> is needed to beat ZFS.
>=20
> Sorry, but I think that is completely the wrong reasoning. ...Unless
> that is you are some proprietary sales droid hyping features and big
> numbers! :-P
>=20
>=20
> Personally I'm not convinced we gain anything beyond what btrfs will
> eventually offer in any case for the n-way raid or the raid-n Cauchy st=
uff.
>=20
> Also note that usually, data is wanted to be 100% reliable and
> retrievable. Or if that fails, you go to your backups instead. Gambling=

> "proportions" and "importance" rather than *ensuring* fault/error
> tolerance is a very human thing... ;-)
>=20
>=20
> Sorry:
>=20
> Interesting idea but not convinced there's any advantage for disk/SSD
> storage.
>=20
>=20
> Regards,
> Martin
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
 Another nice option in this case might be adding logic to make sure
that there is some (considerable) offset between copies of metadata
using the dup profile (all of the filesystems that I have actually
looked at the low-level on-disk structures have had both copies of the
System chunks right next to each other, right at the beginning of the
disk, which of course mitigates the usefulness of storing two copies of
them on disk).  Adding an offset in those allocations would provide some
better protection against some of the more common 'idiot' failure-modes
(i.e. trying to use dd to write a disk image to a USB flash drive, and
accidentally overwriting the first n GB of your first HDD instead).
Ideally, once we have n-way replication, System chunks should default to
one copy per device for multi-device filesystems.


--------------ms030407080907080607060703
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAw8BRDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA1
MTIxNDEwMzJaFw0xNDExMDgxNDEwMzJaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDbLUaL
Gs4JTdU7sgr0MzD57CMUAv307ddC9pxooDMN3PiUvzEd5kLtBCh8KDB1wbMdfm4hte2rDd+j
hM1tIq67BvNbdDPztOcBZwT2/3OVyyG4B1ddCqUyt03zGKw6Y34eHNfapsZiiItX0GBNfjHU
Wv+WDo+XNha/WmGSSMv21HkftF9XA1KC9Bpr9JJI23MKK7T2g/7b3KoGZlx3ekLIJsF5B7+B
DMPPDqOHQbRnccyOHEMyhM13g6WoAbU+3aKYc+C/9UsYtDV+xlvBLWagky1acstD5wOA35V6
uDRbUhD+vOjuMRMCj9jJOIYqa6AeSagBjxRnisJr0RFzQ4f+NjGCHPaFTvRvbkiXh4q22doT
0SxbNBUm7B9ANugIOtS9/VQhTWKDi//WTqZQ7Ecl4yVJbMCUg/iaRHMCGS41vqMICPszRidW
rL04NwS9D2cREEY1y/xrNo0ZvKPZu6tLhxhPf7w+5rsN3+wWxGaR1hNpnVUT9AeacLKZO6W9
FsRT3Unkr91IhQATHTKYr4EAkjN/5lgvA+sxp5TxxsUnoJYrD8IHf8aYfJsAHMleBwx4xSeZ
tw/n5iIjJjFZq9IRZ1zQhK62p+a5vJ2vlJHjTgavhQrfb1pUOjbqsnI4ndQ5hNosL9el4Kxq
Yko+HsxVEmSwSsjq6cV2L3oz0z8NUwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAIokFPcW8+cO2Clu0Ei+ehAmQRBHfV5RWJ8aMVLXOCfiJX0ch
IjVSIt6I3uQaR4J1ZIAjCSPkbpfZQDaLoGFI5j8aYEQhOeKxrvOMzY9/aSUYabCJIhE/sX64
klFV0bzm+PR9cDMWeQ9BoZf0m8UROPSfDnrjEk+p04hGg3pAZMcSwCzxdb604NHjgHJmf2xG
UQVzQgC6Ek/BKat0xuPTuPmtPv9OicK75CPmLZKYW3rFpCD6bhb1mm+ROcCNhniRY2LYm9YN
QdlHQUzTFqj0tvuYrzNI3LNV4PjEfN8z6omPCT2Rq8/uKLseN+m8F0ioqm+cphqpmzKoDUpN
nePLkqDFUFWCeWRxSjBTy4IMVUfdNXriVGihH8hyIICQiOfmmBOzhzUifdomJuTGtoXRuHVT
R2f/YdrJrLnKI4f+Othdp7F3KhB4c6JiOnTEH5J8n9q3rFjt4MPRwcjIHMhmF5nZVQlgxEMo
1cPCmvG1D9tcgXbH79jjqydo9SDXhzLQob7axkzGRY96IstNcvoQ/UNsdPPfFMYlHtGz4TxT
DhBjv4ERskGmKBZrfmxkXkcuTV/gcykct6Xvw9YXb8WTL4qSYHSYk9fReVLgE/L4RBUpX2JJ
QvIR0AJLER165/aZlQXZtuJjnfxJtJTJZZ+Gor9h0G2kuR5Dy0JuYdBO4t4xggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFEMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDUyMjExMTA0NlowIwYJKoZIhvcNAQkE
MRYEFCD6L2L1yNrK8EBw7gyzJFtJnIi4MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICAFjpfIXUfmnpU9kVtGy2B4uK+AFIkhq5wa7yRddP+uiAfh9A
HqmoVHZWztiGa+sESzHuSkFRTd9FGD01A6v6FtkWClG/ThsJq6dUPz0CO/61qBap7rzvW2WY
ADaQzTyMLXCTHfRqddpMGuRBID8U/GSrRJNSgs7ITMJtc9MrgxAy1d0E8yhe24OxWioMxsFP
AU5CrqMOn8eJO9CqVPvCynhg9uYLazKTx9Fs3eNukZIOWt2jGDX4P95Lrmr8HYtg0WyWqqCQ
VbZdRXDN2AGtTF8BGfIIAbveklEoah19qxvfN/QoGEw7yjh4lJwf19N/Nn4SjDRVLBhTh7Jy
iE3+7uW81cCO7zwo6TZQoMa7zISYsOmscNShXYckZg28HAnQfoC9AjUFohuHozb/TBqaxgj/
bXS1FupB6pu6Az+duofEYla6PWSrLb/vxfGsJrowBKSyi7LBgIcssspppegKtf+Uh0kEXA+p
my6Z2Sr1xfE6cvKG4xouM+dMorlq2L88QRdYGWltnEi/k3l7jeckx94x/JmZe9AtPmm53HyO
Wqb0sxfrKtodmsMdPTvBcFO8md5aib1wqHza2u6VdNeHbxZILRX4vVW6QPVC7chFvPLJOkCK
6LroA+jn052U70WzlV/Jh/qEaRilo8C+FeZvlZ+iaIwn9RFjWsVK6cDeHp0rAAAAAAAA
--------------ms030407080907080607060703--
