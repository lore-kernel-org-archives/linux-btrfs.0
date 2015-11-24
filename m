Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33111 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbbKXUjr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 15:39:47 -0500
Received: by iouu10 with SMTP id u10so33521152iou.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 12:39:46 -0800 (PST)
Subject: Re: shall distros run btrfsck on boot?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Eric Sandeen <sandeen@redhat.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <1448337754.14125.33.camel@scientia.net>
 <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
 <1448340211.14125.44.camel@scientia.net>
 <pan$c9010$71046470$f37154a0$cd8b55eb@cox.net>
 <pan$d4967$d0c5632e$fa0a61b0$e3c076ef@cox.net> <56549AFB.3040904@redhat.com>
 <1448385809.21291.22.camel@scientia.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5654CAE0.5040907@gmail.com>
Date: Tue, 24 Nov 2015 15:38:56 -0500
MIME-Version: 1.0
In-Reply-To: <1448385809.21291.22.camel@scientia.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040305090607040008030605"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040305090607040008030605
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-24 12:23, Christoph Anton Mitterer wrote:
> On Tue, 2015-11-24 at 11:14 -0600, Eric Sandeen wrote:
>> In a nutshell, though, I think a filesystem repair should be an
>> admin-initiated
>> action, not something that surprises you on a boot, at least for a
>> journaling
>> filesystem which is designed to maintain its integrity even in the
>> face of
>> a power loss or crash.
>
> Well I wouldn't agree here... I maintain some >2PiB of storage for a
> LHC Tier-2,... right now everything with ext4.
> During normal operation we can of course not have any fsck, but every
> now and then, when we reboot, it happens automatically,... and
> regularly shows at least some (apparently non-serious) glitches.
Yeah, that's pretty normal for any large storage array with a high=20
uptime.  ext4 also doesn't correct anything on the fly, so it's more=20
important that you always run a check on boot when you don't reboot=20
often (which brings up why i personally suggest stuff like GlusterFS or=20
Ceph for large scale data storage, you can reboot individual nodes one=20
at a time, have zero down time, and maintain a high degree of=20
performance and data safety).
>
> IMHO, either the kernel driver itself already checks "everything", then=

> we wouldn't need a dedicated check tool.
> Or it does not, but in that case, there will be people who want to have=

> that in-depth checks run regularly (and even if it's just every half a
> year).
> I better wait half an hour at boot, and find such errors, rather than
> that they silently pile up until I really run into troubles.
Well, that depends on the type of errors.  XFS doesn't need a fsck on=20
mount usually, but there is still a xfs_repair tool for fixing badly=20
damaged filesystems that the kernel can't mount.  btrfs check falls into =

the same general usage as XFS repair, IOW, if the system was shut down=20
cleanly, you're fine barring software bugs, but if it crashed, you=20
should be running a check on the FS.  Like I mentioned above, ext4=20
doesn't correct errors while online, it either (depending on how the fs=20
is configured) ignores them, goes read-only, or panics the system.=20
BTRFS on the other hand, can correct many types of errors while online=20
(that's part of what scrub is for), and is usually pretty resilient when =

it comes to disk errors (I have a few TB worth of data on assorted BTRFS =

filesystems, I run scrubs on them weekly (which usually turns up about a =

single block error across the whole data set per month), and run a check =

on them monthly, which has never turned up anything unless the system=20
had crashed).
>
> That being said, of course it should be configurable for the admin...
> and it is, via fstab.
> So apart from that, given the expectation that btrfsck should be rock-
> solid as e.g. e2fsck in some future, I wouldn't see why people
> shouldn't have the necessary facilities to have it auto-run.
btrfsck has to parse all the data in the FS, and unlike ext4, BTRFS has=20
multiple copies of each metadata block (and often on large filesystems,=20
is configured for multiple copies of each data block), and has checksums =

on _everything_, which need to be validated.  There is no way that this=20
can be made all that much faster short of getting faster hardware to run =

it on.


--------------ms040305090607040008030605
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCC
Brgwgga0MIIEnKADAgECAgMRLfgwDQYJKoZIhvcNAQENBQAweTEQMA4GA1UEChMHUm9vdCBD
QTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNp
Z25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcwHhcN
MTUwOTIxMTEzNTEzWhcNMTYwMzE5MTEzNTEzWjBjMRgwFgYDVQQDEw9DQWNlcnQgV29UIFVz
ZXIxIzAhBgkqhkiG9w0BCQEWFGFoZmVycm9pbjdAZ21haWwuY29tMSIwIAYJKoZIhvcNAQkB
FhNhaGVtbWVsZ0BvaGlvZ3QuY29tMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
nQ/81tq0QBQi5w316VsVNfjg6kVVIMx760TuwA1MUaNQgQ3NyUl+UyFtjhpkNwwChjgAqfGd
LIMTHAdObcwGfzO5uI2o1a8MHVQna8FRsU3QGouysIOGQlX8jFYXMKPEdnlt0GoQcd+BtESr
pivbGWUEkPs1CwM6WOrs+09bAJP3qzKIr0VxervFrzrC5Dg9Rf18r9WXHElBuWHg4GYHNJ2V
Ab8iKc10h44FnqxZK8RDN8ts/xX93i9bIBmHnFfyNRfiOUtNVeynJbf6kVtdHP+CRBkXCNRZ
qyQT7gbTGD24P92PS2UTmDfplSBcWcTn65o3xWfesbf02jF6PL3BCrVnDRI4RgYxG3zFBJuG
qvMoEODLhHKSXPAyQhwZINigZNdw5G1NqjXqUw+lIqdQvoPijK9J3eijiakh9u2bjWOMaleI
SMRR6XsdM2O5qun1dqOrCgRkM0XSNtBQ2JjY7CycIx+qifJWsRaYWZz0aQU4ZrtAI7gVhO9h
pyNaAGjvm7PdjEBiXq57e4QcgpwzvNlv8pG1c/hnt0msfDWNJtl3b6elhQ2Pz4w/QnWifZ8E
BrFEmjeeJa2dqjE3giPVWrsH+lOvQQONsYJOuVb8b0zao4vrWeGmW2q2e3pdv0Axzm/60cJQ
haZUv8+JdX9ZzqxOm5w5eUQSclt84u+D+hsCAwEAAaOCAVkwggFVMAwGA1UdEwEB/wQCMAAw
VgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBmb3IgRlJFRSBo
ZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMA4GA1UdDwEB/wQEAwIDqDBABgNV
HSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisGAQQBgjcKAwMGCWCG
SAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLmNhY2Vy
dC5vcmcwMQYDVR0fBCowKDAmoCSgIoYgaHR0cDovL2NybC5jYWNlcnQub3JnL3Jldm9rZS5j
cmwwNAYDVR0RBC0wK4EUYWhmZXJyb2luN0BnbWFpbC5jb22BE2FoZW1tZWxnQG9oaW9ndC5j
b20wDQYJKoZIhvcNAQENBQADggIBADMnxtSLiIunh/TQcjnRdf63yf2D8jMtYUm4yDoCF++J
jCXbPQBGrpCEHztlNSGIkF3PH7ohKZvlqF4XePWxpY9dkr/pNyCF1PRkwxUURqvuHXbu8Lwn
8D3U2HeOEU3KmrfEo65DcbanJCMTTW7+mU9lZICPP7ZA9/zB+L0Gm1UNFZ6AU50N/86vjQfY
WgkCd6dZD4rQ5y8L+d/lRbJW7ZGEQw1bSFVTRpkxxDTOwXH4/GpQfnfqTAtQuJ1CsKT12e+H
NSD/RUWGTr289dA3P4nunBlz7qfvKamxPymHeBEUcuICKkL9/OZrnuYnGROFwcdvfjGE5iLB
kjp/ttrY4aaVW5EsLASNgiRmA6mbgEAMlw3RwVx0sVelbiIAJg9Twzk4Ct6U9uBKiJ8S0sS2
8RCSyTmCRhJs0vvva5W9QUFGmp5kyFQEoSfBRJlbZfGX2ehI2Hi3U2/PMUm2ONuQG1E+a0AP
u7I0NJc/Xil7rqR0gdbfkbWp0a+8dAvaM6J00aIcNo+HkcQkUgtfrw+C2Oyl3q8IjivGXZqT
5UdGUb2KujLjqjG91Dun3/RJ/qgQlotH7WkVBs7YJVTCxfkdN36rToPcnMYOI30FWa0Q06gn
F6gUv9/mo6riv3A5bem/BdbgaJoPnWQD9D8wSyci9G4LKC+HQAMdLmGoeZfpJzKHMYIE0TCC
BM0CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNl
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTI0MjAzODU2WjBPBgkq
hkiG9w0BCQQxQgRA1WZd98JJr0qV/K3iqLK2Qn2LYhCyeaUVcc7YlTEh+PPwByK80pGS+tRT
VI5YNKQxJMgrtBjFojJDtqVeOCOZfTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB16hdV4CBOIX+Ke5Sj/40pXXvKdzAMbv0IMtzkSgfXFzr+MCdH
IJsBmIXVfh+MGVe2QkmeVubhpmJtCdKclGpSTY5SmPRVTmoNo8twz1Zx7l4WnrL4ZxdwTzOl
7Q0iav+qjYiTNJm23Az+pbmYlH5cmIu0IE2jVTWKGf3RxXSP7uqg0pMvQfpAVXDMSHLLPXwg
nX6yG5U89NIlGwLSmgCwcZXNq4kK5/UN5GxHNFCFxhgVpHRu49//aCmQoT8lCgg2pRJr9Knm
ICTo0KUFXVUmFbUTu+sddysCi7E8jt2r2XWj+GVANGVibvB90Om0/9q3WPoZ5RBkLWVZ4WZS
/X+C3QJonf5VNBE9OzwPaOYhnf/eTJ97BjkzWz4vy72l/BAxNnbGFWpzGV3L7a8EQIOBbIRa
xtH1c3h+LlPP8na6yXv/ZljCSR7r6BdCWH7QI0cZLiU7cq55MuH1BDVdJbK2Y6UWAaYux4AN
Rrzmb3fRiRalpvie4LlDCXaZJtZ1QxNzmX4cwfW2JYgplUy6gMRDn6B8hFLixOrO2rZPtnH+
8q7Fra7ENpEwbrQuUoi876aJOCfvFbpvw4gmsrWNadS97HC0u5wnVg0exOkghS4Zd+zK243F
lpYYrLizYTE1x83UqnAdFYOATF4LqCK7JF/dUphcI3FV21eV2jKXqFAYGwAAAAAAAA==
--------------ms040305090607040008030605--
