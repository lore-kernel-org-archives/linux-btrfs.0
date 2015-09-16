Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38759 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbbIPTIt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 15:08:49 -0400
Received: by igxx6 with SMTP id x6so37939975igx.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 12:08:49 -0700 (PDT)
Subject: Re: FYIO: A rant about btrfs
To: Zia Nayamuth <zedestructor@gmail.com>, linux-btrfs@vger.kernel.org
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
 <55F997E9.8040401@gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F9BE3B.6070309@gmail.com>
Date: Wed, 16 Sep 2015 15:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <55F997E9.8040401@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070306040902070402060008"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070306040902070402060008
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-16 12:25, Zia Nayamuth wrote:
> Some response to your criticism:
>
> 1. How would that hole fare with a fully battery-backed/flash-backed
> path (battery-backed or flash-backed HBA with disks with full power-los=
s
> protection, like the Intel S3500)? In such a situation (quite
> commonplace in server-land), power-loss should not cause any data loss
> since all data in the cache is guaranteed to be committed to
> non-volatile memory at some point (whether such assurances may be
> trusted is another matter entirely though, and well outside the scope o=
f
> this discussion).
It's not as much of an issue if you have full power loss protection=20
(assuming of course it works), but even then having write-barriers=20
turned off is still not as safe as having them turned on.  Most of the=20
time when I've tried testing with 'nobarrier' (not just on BTRFS but on=20
ext* as well), I had just as many issues with data loss when the system=20
crashed as when it (simlated via killing the virtual machine) lost=20
power.  Both journaling and COW filesystems need to ensure ordering of=20
certain write operations to be able to maintain consistency.  For=20
example, the new/updated data blocks need to be on disk before the=20
metadata is updated to point to them, otherwise you database can end up=20
corrupted.
>
> 2. Fair point. I'd like to know his hardware, given how strongly
> hardware can influence things.
>
> 3. It's pretty obvious that the author of that blog is specifically
> targeting OLTP performance (explicit statement in intro, choice of
> benchmark, name and focus of blog), not common-case, and even states
> that in the first two paragraphs of his conclusion. The focus is
> somewhat less clear in said conclusion, namely, is he truly talking
> about general purpose use or is he talking about general purpose OLTP u=
se?
>
My takeaway was that he intended 'general purpose use' to mean generic=20
every day usage across a wide variety of systems, he was not=20
particularly specific about it however.



--------------ms070306040902070402060008
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE2MTkwODQzWjBPBgkq
hkiG9w0BCQQxQgRAinmTlpt7T9JibsBY+4KF3YY+1iLqld9ZtgcfUaxoNcbvGzJ32PcM1cRs
R2bbFdrVyDb9JPR0gbgzfhaoEY89bjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBwI4Sq/ckJcIymUr5UV6s052KQpj+7DEx75OQTwAIB/9IBMdD3
H0RSdwv4GyOnC0RDfXRZUkxp+fmMNRm/9RBUMTj8Y3U/0qcNvM/AnV5OFF/YwNBn8B8IupWB
ertOd/MJham9+yB+EmakKocIAOWaFhCSjuJL1pOXTzx0/gvOyH4Zc2RwBSlks+NBmHbMykKD
YGF30Q9XuXJPJdTJAW91Whor4a2eayJWkDlV5a+3aqUM918ripwX375bQfEJKNCcJJ0MhLHY
4KyoWmMA8B0REWY+CyeQHECyZh+k3s4etQB0N4W87vjQ9f0djGmwUcSHqX0mejoatEQcgNek
5zWtcePc86K2GC8ePxptM8qFGjrQD7M8l9IdEn46hFDCcXKLfRko5Lafzq9RpmjEF5eWNdrg
LRI0j9nOFxaeWBN0Mc1nxGct+4UDAdBBJBY0MqH2y6b3M2aXuQe0JeP5r6Rm0H2LglnuV236
oLB301jdeL0Timkbo+yhMcp927MEVrQXpvii2sbwsEfv6VoeimlKYUYUNOv0GijheQzjcFf5
Xl6gtUhLISKcf5BAwShYeTBXvVWFlYb17La1AXcz5zHAirWQm9SvO0hZCPd72KuQ3aSH36M2
3ELa5963mbg8Qe9tr56DMl9Ekkivm6Dh8E7AqFHPV5Xc40PBnbfgqVJLrAAAAAAAAA==
--------------ms070306040902070402060008--
