Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-6.smtp-out.eu-west-1.amazonses.com ([54.240.4.6]:42821 "EHLO
        a4-6.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756407AbcKWSeA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 13:34:00 -0500
Subject: Re: Inconsistent free space with false ENOSPC
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <010201588c655ba6-4fe49dba-25fb-45ca-adf5-4bb721cd6ecb-000000@eu-west-1.amazonses.com>
 <010201588d22ec8f-40a41aa2-9046-462a-ab95-347f101dfd02-000000@eu-west-1.amazonses.com>
 <pan$aca24$249fdeaf$20473dcc$c7efe94c@cox.net>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <0102015891fee0c8-d9e6073c-c86c-43a7-80f7-3d51dfefa0fd-000000@eu-west-1.amazonses.com>
Date: Wed, 23 Nov 2016 16:22:29 +0000
MIME-Version: 1.0
In-Reply-To: <pan$aca24$249fdeaf$20473dcc$c7efe94c@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030703080708060302090601"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030703080708060302090601
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 23.11.2016 07:09 Duncan wrote:
> Yes, you're in a *serious* metadata bind.
> Any time global reserve has anything above zero usage, it means the=20
> filesystem is in dire straits, and well over half of your global reserv=
e=20
> is used, a state that is quite rare as btrfs really tries hard not to u=
se=20
> that space at all under normal conditions and under most conditions wil=
l=20
> ENOSPC before using the reserve at all.
>
> And the global reserve comes from metadata but isn't accounted in=20
> metadata usage, so your available metadata is actually negative by the =

> amount of global reserve used.
>
> Meanwhile, all available space is allocated to either data or metadata =

> chunks already -- no unallocated space left to allocate new metadata=20
> chunks to take care of the problem (well, ~1 MiB unallocated, but that'=
s=20
> not enough to allocate a chunk, metadata chunks being nominally 256 MiB=
=20
> in size and with metadata dup, a pair of metadata chunks must be=20
> allocated together, so 512 MiB would be needed, and of course even if t=
he=20
> 1 MiB could be allocated, it'd be ~1/2 MiB worth of metadata due to=20
> metadata-dup and you're 300+ MiB into global reserve, so it wouldn't ev=
en=20
> come close to fixing the problem).
>
>
> Now normally, as mentioned in the ENOSPC discussion in the FAQ on the=20
> wiki, temporarily adding (btrfs device add) another device of some GiB =

> (32 GiB should do reasonably well, 8 GiB may, a USB thumb drive of=20
> suitable size can be used if necessary) and using the space it makes=20
> available to do a balance (-dusage=3D incrementing from 0 to perhaps 30=
 to=20
> 70 percent, higher numbers will take longer and may not work at first) =
in=20
> ordered to combine partially used chunks and free enough space to then =

> remove (btrfs device remove) the temporarily added device.
>
> However, in your case the data usage is 488 of 508 GiB on a 512 GiB=20
> device with space needed for several GiB of metadata as well, so while =
in=20
> theory you could free up ~20 GiB of space that way and that should get =

> you out of the immediate bind, the filesystem will still be very close =
to=20
> full, particularly after clearing out the global reserve usage, with=20
> perhaps 16 GiB unallocated at ideal, ~97% used.  And as any veteran=20
> sysadmin or filesystem expert will tell you, filesystems in general lik=
e=20
> 10-20% free in ordered to be able to "breath" or work most efficiently,=
=20
> with btrfs being no exception, so while the above might get you out of =

> the immediate bind, it's unlikely to work for long.
>
> Which means once you're out of the immediate bind, you're still going t=
o=20
> need to free some space, one way or another, and that might not be as=20
> simple as the words make it appear.

Yes, adding a temporary disk allowed me to fix it. Though, it wanted to
write RAID1 metadata instead of DUP first, which further confused me.

File system is being written to by a program that watches disk usage and
deletes stuff/stops writing if too much is used. But it could not
anticipate the jump from 20GiB to zero free. I have now set
"metadata_ratio=3D8" to prevent that, and will lower it if it still
becomes a problem.

Perhaps it would be good to somehow show that "global reserve" belongs
to metadata and show in btrfs fi usage/df that metadata is full if
global reserve>=3Dfree metadata, so that future users are not as confused=

by this situation as I was.

Regards,
Martin Raiber



--------------ms030703080708060302090601
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuQwggT6MIID4qADAgECAhBuZlYKQ9u25a8FBnl/zd+MMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTYwOTE5MTMxNzAyWhcNMTcwOTE5MTMxNzAyWjBCMRwwGgYDVQQDDBNtYXJ0
aW5AdXJiYWNrdXAub3JnMSIwIAYJKoZIhvcNAQkBFhNtYXJ0aW5AdXJiYWNrdXAub3JnMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw/FqcYQTj3z2wO8ASP8j0Jvb4AbMNgB9
iv2PLMtAMzYmuW7w2VfUcXwWgM4Fkg6Nm33VhOK+Vryd2bj+jGNhm+DmbMZCfki/NrhdcHKH
AT7i1NL1lps8X3xJ7N0eJpghht9Wx5OAUfGv18HDD3yBUzqW4x7OaGoKqM0DwyUm9O/rUU6D
ugxVONmgprREB1JyJBAV8lgYbY0EEUFS1JECuxNcJQEY+G8EpUNCsZxc8nvROyRD72Aztuy2
qQj4Rs+FzQNCplzmvXot7W0T2KAH9gKb25Q5Lv0sFQEux1stcJc6KKNea21UufblNMLApQ2Z
cSNWwDF5R+YpUFW8HiBOmwIDAQABo4IBtzCCAbMwDgYDVR0PAQH/BAQDAgSwMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDBDAJBgNVHRMEAjAAMB0GA1UdDgQWBBTKwa9D/4YV1XsZ
6affm7Wv4ykzdTAfBgNVHSMEGDAWgBQkgWw5Yb5JD4+3G0YrySi1J0htaDBvBggrBgEFBQcB
AQRjMGEwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbTA5BggrBgEFBQcw
AoYtaHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc2NhLmNsaWVudDEuY3J0MDgGA1Ud
HwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL3NjYS1jbGllbnQxLmNybDAe
BgNVHREEFzAVgRNtYXJ0aW5AdXJiYWNrdXAub3JnMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBHBgNVHSAEQDA+MDwGCysGAQQBgbU3AQIFMC0wKwYIKwYBBQUHAgEW
H2h0dHBzOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggEBADMT
EdZtz2a7sT3FDGszfzlAfmwVamtLbG5+O6NC5xc1n9AtWa7LdRPsQzgIROT/e84D+uTPAo1c
F6rEJ7oSqhgxJcAWgGN1G0KyEzSaFs+nLvfFN1LeaYQjElnmw87z6LGLvjOnfu01M0Atj+DR
DB3NyRoAn2/5yXHJKP7/mlUSXV/fiplcvP+TJbYJwrL7QDETySua89BU0oH3vtidOm8rlWzl
cZ4ug+kXzMMwjcwSIFb/P6LDZm3FMCNbg8sBt59+V5+Duk8y6aOcQ0GdGrIXMNs+oIKL5iQW
sP9+c55K9mJVl4+3J4sTcyT/L2EOXxEZY+zEhnJAds9dQJXkKfswggXiMIIDyqADAgECAhBr
p4p9CteI1lEK+Vnk57ThMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBT
aWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0x
NTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQC9fdr3w6J9g/Zbgv3bW1+uHht1wLUZr5gkrLtXedg17AkefMyU
GwrQdvwObhajcVmnKVxhrUwkZPXRAwZZosRHfEIi5FH7x6SV/8Sp5lZEuiMnvMFG2MzLA84J
6Ws5T4NfXZ0qn4TPgnr3X2vPVS51M7Ua9nIJgn8jvTra4eyyQzxvuA/GZwKg7VQfDCmCS+kI
CslYYWgXOMt2xlsSslxLce0CGWRsT8EpMyt1iDflSjXZIsE7m1uTyHaKZspMLyIyz6mySu8j
8BWWHpChNNeTrFuhVfrOAyDPFJVUvKZCLKBhibTLloyy+LatoWELrjdI4a8StZY8+dIR9t4A
PXGzAgMBAAGjggFkMIIBYDAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIG
CCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDov
L2NybC5zdGFydHNzbC5jb20vc2ZzY2EuY3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcw
AYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0
YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0OBBYEFCSBbDlhvkkPj7cbRivJKLUnSG1o
MB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7yMD8GA1UdIAQ4MDYwNAYEVR0gADAs
MCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcN
AQELBQADggIBAIvj94fsAYuErQ8BAluc4SMnIwS9NPBwAm5SH9uh2NCXTq7im61g7F1LIiNI
/+wq37fUuaMbz4g7VarKQTgf8ubs0p7NZWcIe7Bvem2AWaXBsxsaRTYw5kG3DN8pd1hSEUuF
oTa7DmNeFe8tiK1BrL3rbA/m48jp4AiFXgvxprJrW7izsyetOrRHPbkW4Y07v29MdhaPv3u1
JELyszXqOzjIYo4sWlC8iDQXwgSW/ntvWy2n4LuiaozlCfXl149tKeqvwlvrla2Yklue/quW
p9j9ou4T/OY0CXMuY+B8wNK0ohd2D4ShgFlMSjzAFRoHGKF81snTr2d1A7Ew02oF6UQyCkC2
aNNsK5cWOojBar5c7HplX9aHYUCZouxIeU28SONJAxnATgR4cJ2jrpmYSz/kliUJ46S6UpVD
o/ebn9c6PaM/XtDYCCaM/7XX6wc3s++sbQ7CtCn1Ax7df6ufQbwyO0V+oFa9H0KAsjHMzcwk
3EV2B2NLatidKE/m7G+rB9m+FlVgIiSp0mGlg43QO9Kh1+JqvTCIzv2bJJkmPMLQJNuKKwHN
L8F4GGp6jbAV+WL+LDeGfVcq8DHS3LrD+xyYEXQBiqZEdiPVOMxLDSUCXsDO0uCWpaNQ8j6y
6S9p0xE/Ga0peVLadVHhqf9nXqKaxnr358VgfrxzUIrvOaOjMYIDzDCCA8gCAQEwgYkwdTEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29t
IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENs
aWVudCBDQQIQbmZWCkPbtuWvBQZ5f83fjDANBglghkgBZQMEAgEFAKCCAhMwGAYJKoZIhvcN
AQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYxMTIzMTYyMjI5WjAvBgkqhkiG
9w0BCQQxIgQghy+GhKnHdWN79L8ic+qo4moZX2o62sq7owU74ZBneM0wbAYJKoZIhvcNAQkP
MV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMC
AgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBmgYJKwYBBAGC
NxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRD
b20gQ2xhc3MgMSBDbGllbnQgQ0ECEG5mVgpD27blrwUGeX/N34wwgZwGCyqGSIb3DQEJEAIL
MYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQL
EyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMSBDbGllbnQgQ0ECEG5mVgpD27blrwUGeX/N34wwDQYJKoZIhvcNAQEBBQAEggEA
Ws7vHtYVjfQIATvmPey6PTYnxC+qXKRp0m7ggoNKh6GMreMh1rWldNfBm4mS748IsT24IEo7
NuKtRZj44beC98iaR+hJmSeWWV6A+Hwfxo9Pg/tw5h58ySEJdw8bO40+3tfA+QMOJ1QLNE/3
BNvNi4aajZrZfloHoJBMmCjAh4zdwmmrcm+zXMSEdTEy8/S1P8Y0QS3hlsZolXd3KC9FQyoV
UZMfKqN/TCZWqRcefjQ4T8OwUv6pBgGLhv9WVmJvlW3ZhNaUaB3GIn/MHgTZ+qBP7ICH8D2l
DyjyVeghODdz5Tn2oNeog42X5hkVh7Xh8taxglT+BIvQOSpTTTkemwAAAAAAAA==
--------------ms030703080708060302090601--
