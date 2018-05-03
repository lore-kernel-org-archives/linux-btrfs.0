Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:44166 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbeECHFw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 May 2018 03:05:52 -0400
Received: by mail-lf0-f46.google.com with SMTP id h197-v6so24363564lfg.11
        for <linux-btrfs@vger.kernel.org>; Thu, 03 May 2018 00:05:51 -0700 (PDT)
Received: from [172.21.1.5] (94-154-27-228.zapnet-isp.net. [94.154.27.228])
        by smtp.googlemail.com with ESMTPSA id o192-v6sm1388940lfe.12.2018.05.03.00.05.49
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 May 2018 00:05:49 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?TWljaGHFgiBXxJlncnp5bmVr?=
        <michal.wegrzynek@malloc.com.pl>
Subject: Corrupt leaf, name hash mismatch with key
Message-ID: <2b79941f-e1a1-bdf2-8942-9b88549bc8b7@malloc.com.pl>
Date: Thu, 3 May 2018 09:05:48 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020107060107030504090106"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020107060107030504090106
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Hi!

I'm running btrfs on a bcache device, for now, it performed flawlessly.=20
Yesterday, however, during backup, I found the following errors in the=20
journal:

BTRFS critical (device bcache0): corrupt leaf: root=3D1 block=3D367591424=
=20
slot=3D1 ino=3D10085264, name hash mismatch with key, have=20
0x00000000fffffffe expect 0x0000000099a9205a

It correlated=C2=A0 with a backing device error:

maj 02 16:47:58 miner kernel: print_req_error: I/O error, dev sdb,=20
sector 8950560
maj 02 16:48:41 miner kernel: sd 2:0:0:0: [sdb] tag#29 FAILED Result:=20
hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
maj 02 16:48:41 miner kernel: sd 2:0:0:0: [sdb] tag#29 Sense Key :=20
Medium Error [current]
maj 02 16:48:41 miner kernel: sd 2:0:0:0: [sdb] tag#29 Add. Sense:=20
Unrecovered read error - auto reallocate failed
maj 02 16:48:41 miner kernel: sd 2:0:0:0: [sdb] tag#29 CDB: Read(16) 88=20
00 00 00 00 00 00 88 92 f0 00 00 01 00 00 00

so it seems this the reason for corruption.

The inode in question corresponds to=20
/home/mwegrzynek/.cache/google-chrome/Default/Cache/ so it's making a=20
lot of noise during Chrome usage ;). I'm not able to delete it, nor its=20
parent

[mwegrzynek@miner ~]$ LC_ALL=3DC rm -rf=20
/home/mwegrzynek/.cache/google-chrome/Default/Cache/
rm: cannot remove=20
'/home/mwegrzynek/.cache/google-chrome/Default/Cache/': Directory not emp=
ty
[mwegrzynek@miner ~]$ LC_ALL=3DC ls -l=20
/home/mwegrzynek/.cache/google-chrome/Default/Cache/
ls: reading directory=20
'/home/mwegrzynek/.cache/google-chrome/Default/Cache/': Input/output erro=
r
total 0
[mwegrzynek@miner ~]$ LC_ALL=3DC rm -rf=20
/home/mwegrzynek/.cache/google-chrome/Default/
rm: cannot remove '/home/mwegrzynek/.cache/google-chrome/Default/Cache': =

Directory not empty

I tried to run btrfs check --repair on this filesystem, but it just=20
looped on this inode for a half an hour not fixing anything (sorry, no=20
logs available, but I may try to reproduce them if needed).

I was able to rename the folder, so no problems for now for me, I also=20
ordered a replacement drive.

Can you tell me, how to fix these kinds of errors? Would they be=20
corrected when running a mirror? How to deal with these things in=20
production setup?

Regards,

Micha=C5=82




--------------ms020107060107030504090106
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: Kryptograficzna sygnatura S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCC
CwowggTTMIIDu6ADAgECAhBm2u8D24RhkWsluoP7F04TMA0GCSqGSIb3DQEBCwUAMH4xCzAJ
BgNVBAYTAlBMMSIwIAYDVQQKExlVbml6ZXRvIFRlY2hub2xvZ2llcyBTLkEuMScwJQYDVQQL
Ex5DZXJ0dW0gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIjAgBgNVBAMTGUNlcnR1bSBUcnVz
dGVkIE5ldHdvcmsgQ0EwHhcNMTUwNDIxMTI0NTI2WhcNMjcwNjA5MTI0NTI2WjCBijELMAkG
A1UEBhMCUEwxIjAgBgNVBAoMGVVuaXpldG8gVGVjaG5vbG9naWVzIFMuQS4xJzAlBgNVBAsM
HkNlcnR1bSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEuMCwGA1UEAwwlQ2VydHVtIERpZ2l0
YWwgSWRlbnRpZmljYXRpb24gQ0EgU0hBMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAMXgVrv+CZfjKNqcnk5TvUOn3z6o4OTx4yA5BWu3CqgW7mEez4WlFuPdCVTshvZ+28Yl
5lmZ3v/44J+DCI3/nVr7729zaucJI4UsJVPYmp+5dJfy4NmraGKrhhe7GSxIPFJihexNItJF
l36wj3n1Gzggk81/i6LjT7lsDvOifiuBPxGiL4QxOxL6nQlVmydHNydqx8hA8n2GTDxIzZ6E
RQWcNLxJgHCu+BtEMP+L57n8NEjVbW/2J3pUIrS8Esm2rlkYPFF6aJON6zOWvntQ2+aenJ0x
Cip7Y+xvsL74+eVenAKRBVTMzMLevIaE799+7GkfbwYiX9j/GQorMHSzo2UCAwEAAaOCAT4w
ggE6MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFD/KWOrxyQl+bjPBI61OrT49bEWnMB8G
A1UdIwQYMBaAFAh2zcsH/yT2xc3tu5C84oQ3RnX3MA4GA1UdDwEB/wQEAwIBBjAvBgNVHR8E
KDAmMCSgIqAghh5odHRwOi8vY3JsLmNlcnR1bS5wbC9jdG5jYS5jcmwwawYIKwYBBQUHAQEE
XzBdMCgGCCsGAQUFBzABhhxodHRwOi8vc3ViY2Eub2NzcC1jZXJ0dW0uY29tMDEGCCsGAQUF
BzAChiVodHRwOi8vcmVwb3NpdG9yeS5jZXJ0dW0ucGwvY3RuY2EuY2VyMDkGA1UdIAQyMDAw
LgYEVR0gADAmMCQGCCsGAQUFBwIBFhhodHRwOi8vd3d3LmNlcnR1bS5wbC9DUFMwDQYJKoZI
hvcNAQELBQADggEBAAu9CcEJlt/B/nZI1fXxhekorONITDb7P93cFmK7kgZ239iLT81i82C0
gjPesCQOL7LejnVmP3bM2NSLwYMiUp+pUgblyKC/5nWaRBaakyL+kfbIpd4zmaVHUK+ZMhTc
l40F6CgGLmsXlHiLqsbCVEqG1Z+wPp3Jx4aO2JyyYu3eRZbV3FapB9jUTKF2YPGU1dHbTtHN
PsSKypHEcHiuub5YNjqSe294eUupVQR4+wEHewz4OCNjFczvJ1EUj9l6v0Epl8pb+/V/QZA2
2HYN+xXkxSzwrLPDoCoMJHHse7AA533JrsRhs6t4yLwdvb3nmmajpWFqrYo++M9igLcpKmUw
ggYvMIIFF6ADAgECAhAVSZs6zlnAYPD3NbMjQTDgMA0GCSqGSIb3DQEBCwUAMIGKMQswCQYD
VQQGEwJQTDEiMCAGA1UECgwZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEnMCUGA1UECwwe
Q2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MS4wLAYDVQQDDCVDZXJ0dW0gRGlnaXRh
bCBJZGVudGlmaWNhdGlvbiBDQSBTSEEyMB4XDTE4MDEyMjAyMjgyNloXDTIxMDEyMTAyMjgy
NlowTzELMAkGA1UEBhMCUEwxETAPBgNVBAMMCEJhc2ljIElEMS0wKwYJKoZIhvcNAQkBFh5t
aWNoYWwud2Vncnp5bmVrQG1hbGxvYy5jb20ucGwwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
ggIKAoICAQCIoH+sbOTJIxNVp/aqyoNR5hE1bqwqKR5MdeAonRY35Hq33gQ4eCwlfHt++VF9
v7+sutB6kbjMT8ANSru67cC51vkIMTRcd41XiXH8hlysM/Yc27P1DABnhqSuD8Hr12f2URcQ
FiDJhFcwMgIy9vGNUET5hc2eY3qZXiOTbrW4bm8Y/8bFKxJKtymvXQ3MxhOl/ZSu1Wn6Ws3m
u9O6hejLfO/A7YK7lu7p8pbr7kgHqiYoLUjjoiM/SPFr6t14GaUvzoCalEoKiZl+tHphrD0r
9Nglyl9w2wlbkocFK7l+vDjoJvvLet9D/FMIc3IMpa/lCzh2faxastVU5T2aKfhewwEkYW1u
jSqkdTFDJ1ulwVoI57i+wXjUKKL/nX+c9Fr2F/1rAuhRI8yKWnkIVXHUN6eatVLP7MF6MtlO
n1Y8pjRQe55gE8DNRtL8uK9DIsoo2jmO9zGaYXCGuH5VmWcbyraGRHTHhUN+zWH28rDWIrot
JJS/1ZgQtmkmMuTosrDcDPYWaiEmeHiLAKp/JJYsuk8oxGKpR+oB7Kbq371DoFf68ziClNnI
UeRkHuwjwZxnea8FnZTJV2b363sOUPiixXsxAB4msanBXSV2mImKXkGuNEehKYc9zw9xZjsI
g8fJfOflzRAhXmrh1HcPJhtbXd0croWXXD66A/wpCizN4QIDAQABo4IByTCCAcUwDAYDVR0T
AQH/BAIwADAyBgNVHR8EKzApMCegJaAjhiFodHRwOi8vY3JsLmNlcnR1bS5wbC9kaWNhc2hh
Mi5jcmwwcQYIKwYBBQUHAQEEZTBjMCsGCCsGAQUFBzABhh9odHRwOi8vZGljYXNoYTIub2Nz
cC1jZXJ0dW0uY29tMDQGCCsGAQUFBzAChihodHRwOi8vcmVwb3NpdG9yeS5jZXJ0dW0ucGwv
ZGljYXNoYTIuY2VyMB8GA1UdIwQYMBaAFD/KWOrxyQl+bjPBI61OrT49bEWnMB0GA1UdDgQW
BBTGVnG/CskuOIzb84qmY1VfxJLohzAdBgNVHRIEFjAUgRJkaWNhc2hhMkBjZXJ0dW0ucGww
DgYDVR0PAQH/BAQDAgSwMEIGA1UdIAQ7MDkwNwYMKoRoAYb2dwIFAQYMMCcwJQYIKwYBBQUH
AgEWGWh0dHBzOi8vd3d3LmNlcnR1bS5wbC9DUFMwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsG
AQUFBwMEMBEGCWCGSAGG+EIBAQQEAwIFoDApBgNVHREEIjAggR5taWNoYWwud2Vncnp5bmVr
QG1hbGxvYy5jb20ucGwwDQYJKoZIhvcNAQELBQADggEBAMJCKp7MLCU4ns4o/3v0pS9vFJmL
Ekk9dJImpilrj3w9KyLn9e6OSQpUVlLrX2159FjMzDJ0MlATcmiP/kEjuUB8G7CyBHpLMW08
hkf4kLSJ5RqhqVYACN7L7kLiA7yK3LmSOG80OraF+YfivpMM3eaSKR8JkuTzTnGYzY72IqMv
OVN+phJ1fGFwKPIX8qBCS0P5pJf1X1TuLZBcBaGF6D6hc5b/BumvL68QVETiThsr34fD3ErG
D1mNBtDVve13lCesIo5nXJpnoobFg34EsQeH9Fee2sOZkSWEZ+9Wvlm5MZF2Gmsu7ta5cQNV
20iyeRrsJdojmYlvXEFcwGtMRJwxggUuMIIFKgIBATCBnzCBijELMAkGA1UEBhMCUEwxIjAg
BgNVBAoMGVVuaXpldG8gVGVjaG5vbG9naWVzIFMuQS4xJzAlBgNVBAsMHkNlcnR1bSBDZXJ0
aWZpY2F0aW9uIEF1dGhvcml0eTEuMCwGA1UEAwwlQ2VydHVtIERpZ2l0YWwgSWRlbnRpZmlj
YXRpb24gQ0EgU0hBMgIQFUmbOs5ZwGDw9zWzI0Ew4DANBglghkgBZQMEAgMFAKCCAl8wGAYJ
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwNTAzMDcwNTQ4WjBP
BgkqhkiG9w0BCQQxQgRA0s/X9OdS5IWNUxApi5rP3Ov9fkNTrNESAWAYL+ZqmfyWO9AAyxbh
i1hVWA8J6FThHdDi4GrYbSja5BH3mgI8YDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGwBgkrBgEEAYI3EAQxgaIwgZ8wgYoxCzAJ
BgNVBAYTAlBMMSIwIAYDVQQKDBlVbml6ZXRvIFRlY2hub2xvZ2llcyBTLkEuMScwJQYDVQQL
DB5DZXJ0dW0gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxLjAsBgNVBAMMJUNlcnR1bSBEaWdp
dGFsIElkZW50aWZpY2F0aW9uIENBIFNIQTICEBVJmzrOWcBg8Pc1syNBMOAwgbIGCyqGSIb3
DQEJEAILMYGioIGfMIGKMQswCQYDVQQGEwJQTDEiMCAGA1UECgwZVW5pemV0byBUZWNobm9s
b2dpZXMgUy5BLjEnMCUGA1UECwweQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MS4w
LAYDVQQDDCVDZXJ0dW0gRGlnaXRhbCBJZGVudGlmaWNhdGlvbiBDQSBTSEEyAhAVSZs6zlnA
YPD3NbMjQTDgMA0GCSqGSIb3DQEBAQUABIICADvIYczWTaBkHHQgeVqDULUDYraTdpG4h21k
cyeEw8J5UAZFss3AxUA/p0dFB+6HFGmVyXHuT2tuxkaFOW1JnZmG5ZQ446hbPzKz2CSk+anH
u74QlhfbuzKdkCXwDul5phJGbmLB0aWXFNvc3LNr7B0hXDtffuoP4Gn+EoJ9Vnj/12wFr45O
1lPsufA5NmmfL0IQgPx44/IwzvbELaOIkD1mkckJJnZKbSywyGKJgS2+xp/OZv5GVWuMV3k2
ABvmS6TY6axxN5iVpUrQklo9joSGEtNyV/mz5cW8VQdAZHim3TVj07LZ47h3xN+p84jyRvjS
VvMPT7hBClQhjU/sCQxPvP82E/4CeQQPFYLVVyE47H3Onx3dCOCCSuBECFwGVrw+PU3M4f2M
L93Nx8xwK33gDjV1Wxdv/xrp0jIpbUACLmA5hegtPk4qgnFFpYoEVikAiw59wKNqpJZTbBjf
ozrMEQxTmAtAPij9tY8/Ale/fv0QHE+MqlJ05/rphLAB5wcVRzdHeybEIpDNplrNOrNwezxn
E9w3f+stlQhTIcJNxJ7UErhgjRHzHhMG8BOzxtpyC/gWNnO14eV0J+Eqc6K2BDD+qu4T/iaw
Zn49iU4I0wND46xztZHJvolm9NaMt9PnU7OkI1Z4/EuX0YTGpQxz2FCYc2TvEU33D5nbtmCU
AAAAAAAA
--------------ms020107060107030504090106--
