Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from einhorn-mail.in-berlin.de ([217.197.80.20]:43772 "EHLO
        einhorn-mail.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754345AbeEHH5i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 03:57:38 -0400
Subject: Re: Btrfs installation advices
To: faurepierr@gmail.com, linux-btrfs@vger.kernel.org
References: <a064411e-dcec-ecc8-98b9-98cb86284f1e@gmail.com>
From: Rolf Wald <rolf.wald@lug-balista.de>
Message-ID: <63a6c2b4-79ab-18bd-2e24-6acf10b2fd63@lug-balista.de>
Date: Tue, 8 May 2018 09:50:23 +0200
MIME-Version: 1.0
In-Reply-To: <a064411e-dcec-ecc8-98b9-98cb86284f1e@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010508040800010704050701"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010508040800010704050701
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

Hello,

some hints inside

Am 08.05.2018 um 02:22 schrieb faurepierr@gmail.com:
> Hi,
>=20
> I'm curious about btrfs, and maybe considering it for my new laptop
> installation (a Lenovo T470).
> I was going to install my usual lvm+ext4+full disk encryption setup, bu=
t
> thought I should maybe give a try to btrfs.
>=20
>=20
> Is it possible to meet all these criteria?
> - operating system: debian sid
> - file system: btrfs
> - disk encryption (or at least of sensitives partitions)
> - hibernation feature (which implies a swap partition or file, and I've=

> read btrfs is not a big fan of the latter)

A swap partition is not possible inside or with btrfs alone.

You can choose btrfs filesystem out of the box in debian install, but=20
that would mean full-disk-encryption with lvm and btrfs. The extra layer =

lvm doesn't hurt, but you have two layers with many functions double,=20
e.g. snapshotting, resize.

>=20
> If yes, how would you suggest me to achieve it?

Yes, there is a solution, and it works for me now several years.
You need to build three partitions, e.g. named boot, swap, root. The=20
sizes choose to your need. the boot partition remains unencrypted, but=20
the other two partitions are encrypted with cryptsetup (luks)=20
separately. Normally there are two passphrases to type in (and to=20
remember), but there is an option in the cryptsetup scripts=20
(/lib/cryptsetup/scripts) decrypt_derived, which could take the key from =

the root partition to decrypt the swap partition also. The filesystems=20
then on the partitions are boot with ext(2,3,4), swap with swap and root =

with btrfs.
This configuration is not reachable with a standard debian installation. =

Debian always choose lvm if you want full encryption. You have to do the =

first steps manually: make partitions, cryptsetup(luks) for the=20
partitions swap and root, and open the encrypted partitions manually.=20
After that you can install your OS. The manual steps you have to make=20
from a working distro, e.g. live system (disk or stick) with a recent=20
kernel and recent btrfs-progs (debian sid is ok for this).
After the install of the OS you have to made the changes for a=20
successful (re)boot manually. Please read the advices you can find in=20
the net. There are some nice articles.

>=20
> Thanks for your kind help.

--=20
Mit freundlichen Gr=C3=BC=C3=9Fen (kind regards) Rolf Wald
LUG-Balista Hamburg e.V., Germany
c/o B=C3=BCrgerhaus Barmbek
Lorichsstr. 28a
22307 Hamburg
http://www.lug-hamburg.de
No HTML please
S/MIME signed email preferred, encryption wanted


--------------ms010508040800010704050701
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DVcwggX2MIID3qADAgECAgMCv5gwDQYJKoZIhvcNAQENBQAwVDEUMBIGA1UEChMLQ0FjZXJ0
IEluYy4xHjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0
IENsYXNzIDMgUm9vdDAeFw0xODAzMDkxNjAyMzJaFw0xOTAzMDkxNjAyMzJaMIG+MQswCQYD
VQQGEwJERTELMAkGA1UECBMCSEgxEDAOBgNVBAcTB0hhbWJ1cmcxITAfBgNVBAoTGExVRy1C
YWxpc3RhIEhhbWJ1cmcgZS5WLjEMMAoGA1UECxMDb3JnMRIwEAYDVQQDEwlSb2xmIFdhbGQx
JzAlBgkqhkiG9w0BCQEWGHJvbGYud2FsZEBsdWctYmFsaXN0YS5kZTEiMCAGCSqGSIb3DQEJ
ARYTcm9sZi53YWxkQGx1Zy1oaC5kZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
AJ8XWPcILliuTMkBSJV11RZ1hKSXk96eZ/ahW/sh+F7zygA+L7O/BrdUKPoOANew0sE5ZkVk
MmkVeIrW0pdxQCIcobLVc2W5VpVamuMLgx8kPMWz70s3Ae9fnvusKnM29AHG1pv+xxqlqAWf
9dL4BjSRFpNnXRKehkCHeKDvNhoxTrRe6yi2Ij5L32ntDYuie6+tm23RrmCO9J7BAbokcbqy
h6hJmvrv0FW1Ujhp+jf3LrErGNSJk76oqhQ0CV7O2JwXr/iXILIalb05kE25SrhdwIN6D14u
Y73tnreQ1bZwsVDR04JYBPEEMwN93BuKLYGlDgcdldiLe8lEF6v2298CAwEAAaOCAWQwggFg
MAwGA1UdEwEB/wQCMAAwVgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZp
Y2F0ZSBmb3IgRlJFRSBoZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMA4GA1Ud
DwEB/wQEAwIDqDBABgNVHSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQG
CisGAQQBgjcKAwMGCWCGSAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0
dHA6Ly9vY3NwLmNhY2VydC5vcmcwOAYDVR0fBDEwLzAtoCugKYYnaHR0cDovL2NybC5jYWNl
cnQub3JnL2NsYXNzMy1yZXZva2UuY3JsMDgGA1UdEQQxMC+BGHJvbGYud2FsZEBsdWctYmFs
aXN0YS5kZYETcm9sZi53YWxkQGx1Zy1oaC5kZTANBgkqhkiG9w0BAQ0FAAOCAgEAp9J2tJRl
jygFqFQ/gnVbLqLEoeq1X237j+AQKVr3rqV9eJHGs8a1ZQJTKPY+hBumlSK9sx37Rz5Iz+lA
0kKyv1WCAPSqxfIGOGD08XbvJZaMJpo2RDD+C96HnNysA7hDeRINUIiOYN2BTaZ9U6ghD2nh
EhwPQh2673kgYaiNsMSJgJ8Ru3Z5VU0L82sIuUTAiLC9Ykobl074V3jwFfoGREltCWusoFLZ
q0cLL6gDKw68/s0X4x+cBRdYx0nv2nAsgcmK+DccZ32j8aUn7rjhJUB0Tn/OxsQDjbEZo2Dn
o1omwe0j3APKy6jlxRbrb+ORWbjWCLvMg7zIGGodWMst2z+p8GkiowsiGNglHjb88JKoG6ZK
sJ8EORwUR2pdE5/sKNj4jK4Z5QGJuO1Rz09CzoEDkc4jF+imHDbAHk9KDBX9gOayYlq0Qo+T
z6/2/8ycMo9jmHUisWpJ+ecdip4nuAFVHCaEkqkHUz8PaJ7vu5k0wf+uMuNn/rZCv8sXJEP8
jVDzNddbhQp3oO29LXgAHyiDdBi7CuL1ZIFm/WZgN0rXJWsr0VMcdSCpqmaZ1YuPZAK7rckz
wH6a6Ou+srHZSzjQK7hzqTyuWDZ9lGz96kAV/0Jp7TLv6z/CwPONUM1XLjNSkVO7uIcUVKya
Hb6TXiSq+OUVwBFK2iOibn5kRS8wggdZMIIFQaADAgECAgMKQYowDQYJKoZIhvcNAQELBQAw
eTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIw
IAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBw
b3J0QGNhY2VydC5vcmcwHhcNMTEwNTIzMTc0ODAyWhcNMjEwNTIwMTc0ODAyWjBUMRQwEgYD
VQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYD
VQQDExNDQWNlcnQgQ2xhc3MgMyBSb290MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
AgEAq0k1EUh80iZ+U5TPQ6ndKNdCKovzh3gZWHwPntqJfeH763KQDXShlmSrn6AkmXPa4lV2
xxd79QSsRrjDvn9kjRBsJPNhnMDykPpR5vVpAWPDD1biSkLP4kSMJSioxXkJfUa5ivPp8zQp
CEXkHJ/LlAQcgagUs5hlxEPsToKNCdG9qluNktDs3pDFfwrC4+vmMVpedD6XM1nowwM9YDO/
99FvR8TN7mKDUm4uCJqk2RUYkaaFkkewrkjrbbch7IUaaHI1q//wEF3A9JSnatU7kn5MkAV+
k8Esi6SOYnQVcW4LcQPqrxU4mtTSBXJvjPkr61pyJfk5RuNyGz4Ew2QnIhAqik9YpwOtvrQu
E+1dqkjX1X3UKntc+kYEUOTMDkJbjO3b8s/8lpPg2xE2VGI0OI8MYJs7l1Y4rfPSW4ugW+pO
lrh819WghnBA05Ept6I8rfWMu88akorkNHvA2Gxf6QrCw6cgmlrfLF1SXLpH1ZvvJChwOCAv
1X8pwLJBA2iSzOCczJdLRe86EAqrcDqYlXCtNbHqhSukHIAhMamuYHqAJkgAuAHAk2NVIpE8
Vuev2zol848xVOomi4FZ+aHRUxHFe50D9nQR4G2xLD8shpGZcZqmd4s0YNEUtCysna+MENOf
xGr4bxP8c1n3ZkJ0Horj+NzSb5icy0eYlUAF++kCAwEAAaOCAg0wggIJMB0GA1UdDgQWBBR1
qHFgTIgT8HjZiXe1bcWJ37yxejCBowYDVR0jBIGbMIGYgBQWtTIb1Mfz4OaO873SsDrusjkY
0aF9pHsweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQu
b3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkB
FhJzdXBwb3J0QGNhY2VydC5vcmeCAQAwDwYDVR0TAQH/BAUwAwEB/zBdBggrBgEFBQcBAQRR
ME8wIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLkNBY2VydC5vcmcvMCgGCCsGAQUFBzAChhxo
dHRwOi8vd3d3LkNBY2VydC5vcmcvY2EuY3J0MEoGA1UdIARDMEEwPwYIKwYBBAGBkEowMzAx
BggrBgEFBQcCARYlaHR0cDovL3d3dy5DQWNlcnQub3JnL2luZGV4LnBocD9pZD0xMDA0Bglg
hkgBhvhCAQgEJxYlaHR0cDovL3d3dy5DQWNlcnQub3JnL2luZGV4LnBocD9pZD0xMDBQBglg
hkgBhvhCAQ0EQxZBVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFLCBnbyB0
byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDQYJKoZIhvcNAQELBQADggIBACkoha5EqbmvpHkT
8KijK5dg81zu4y/B9uJmoBGuNjc6dhUEU+pC9fnqwBXYpoLZ5GGucgspXJBD6EGy4XfbAhNE
eEdVr1j8zJj2RbnRIPjYIQf+bapz1LPGB+kJhcw78ra+LBwl1XGMObUu6r4Ygbqwk7gP4+bX
JowxWnIDhFLmpvUzIkUKyAsNirg2b5AJoau919VOLnGi1K76p1Qr6zWNWrdUiC/udJ/tSBbK
DUjQlNOspKL2JN+S473rQ0CRbhwYjla0ghLzqZOf1LycrZx17lqXG5XndC0cD7Asl5/7qTM5
eucDOpKOIvaMDeTZfg12GPcB+e+WlqJVc8A8cbQdGlZDt8MKjXL84hAJC0HOjJSg+QP9cXNL
ilcz5Y50fhUBAObMShznf5UZLcWlDIu7te2Fs1zT37i58srHDQEUrHBYxYyNM9SdZqMaUJUj
/EjgBkMS2c2nhjkvNnKjgBDk4fPRy1sawOSAmnwTcwZP26NrJAq6sxy8Sni75eN1OKVIp6Ie
r3bUXvc4hlZaic7Ww6d5slKgxvGFtCWM8j+WsxDZjWxXO59vhjoYgiI2yLCRONsqoZOqhD/1
J2Wuc9XI1dN36kudx0G7x8DjoD/kfaSNc+YSS9+hc3NzOoDo1cuOL8vqE6fWQYus+jyJ1yT1
TrTgYZK38zeYxL6Wo7eKMYIDOzCCAzcCAQEwWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEe
MBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3Mg
MyBSb290AgMCv5gwDQYJYIZIAWUDBAIBBQCgggGxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MDUwODA3NTAyNFowLwYJKoZIhvcNAQkEMSIEIN2hzpOP
W0J8Y5XiNyZaFraSgOK7PIsNkXmGJmBVbIgeMGoGCSsGAQQBgjcQBDFdMFswVDEUMBIGA1UE
ChMLQ0FjZXJ0IEluYy4xHjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UE
AxMTQ0FjZXJ0IENsYXNzIDMgUm9vdAIDAr+YMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwbAYLKoZIhvcNAQkQAgsxXaBbMFQxFDAS
BgNVBAoTC0NBY2VydCBJbmMuMR4wHAYDVQQLExVodHRwOi8vd3d3LkNBY2VydC5vcmcxHDAa
BgNVBAMTE0NBY2VydCBDbGFzcyAzIFJvb3QCAwK/mDANBgkqhkiG9w0BAQEFAASCAQA8rNzK
25k13oyzhr4azXSU+3CCceGYxNlcHBofxL8vRbpM6r8122ssY88S2fNaUl4hIEGhD11YrvW9
3Uu8ZYdJz3sCuVhGIXcPZUnrR28mtBJE9oqTKbNcBKZF9zQrd9nc9516UZtiUtvY8SKEN1CW
FXJgt2DngdZGwQc4Pvm0gzZJlIZXFImcYGCzHdMazRu2sv0zgaQvbTDEeunAo6/Vw1Qf3qiN
IzCHCI5LC1ECYF6TUzrZbvboige1gfl17X0jlKuDlbNDJrmO2fR+qyFOJNZuWFeyuM6NC05F
0iVBZGF7E58hhHD5jy+F6FLVPx3Ba41HFx+EUDSoTs1yZm0BAAAAAAAA
--------------ms010508040800010704050701--
