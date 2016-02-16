Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.3.12.4.46.clients.your-server.de ([46.4.12.3]:44307 "EHLO
	mx.mokrynskyi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752393AbcBPEuh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 23:50:37 -0500
Received: from localhost (localhost [127.0.0.1])
	by mx.mokrynskyi.com (Postfix) with ESMTP id D624F73A6
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 04:44:32 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
	by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qlBZrc_Mmk57 for <linux-btrfs@vger.kernel.org>;
	Tue, 16 Feb 2016 04:44:32 +0000 (UTC)
Received: from [192.168.1.167] (user-31-175-12-243.play-internet.pl [31.175.12.243])
	by mx.mokrynskyi.com (Postfix) with ESMTPSA id 3BC6873A5
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 04:44:30 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: Major HDD performance degradation on btrfs receive
Message-ID: <b9e02f6f-dc3e-94c1-1a60-30192206c95e@mokrynskyi.com>
Date: Tue, 16 Feb 2016 05:44:30 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030807050707070304030305"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030807050707070304030305
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

I have 2 SSD with BTRFS filesystem (RAID) on them and several=20
subvolumes. Each 15 minutes I'm creating read-only snapshot of=20
subvolumes /root, /home and /web inside /backup.
After this I'm searching for last common subvolume on /backup_hdd,=20
sending difference between latest common snapshot and simply latest=20
snapshot to /backup_hdd.
On top of all above there is snapshots rotation, so that /backup=20
contains much less snapshots than /backup_hdd.

I'm using this setup for last 7 months or so and this is luckily the=20
longest period when I had no problems with BTRFS at all.
However, last 2+ months btrfs receive command loads HDD so much that I=20
can't even get list of directories in it.
This happens even if diff between snapshots is really small.
HDD contains 2 filesystems - mentioned BTRFS and ext4 for other files,=20
so I can't even play mp3 file from ext4 filesystem while btrfs receive=20
is running.
Since I'm running everything each 15 minutes this is a real headache.

My guess is that performance hit might be caused by filesystem=20
fragmentation even though there is more than enough empty space. But I'm =

not sure how to properly check this and can't, obviously, run=20
defragmentation on read-only subvolumes.

I'll be thankful for anything that might help to identify and resolve=20
this issue.

~> uname -a
Linux nazar-pc 4.5.0-rc4-haswell #1 SMP Tue Feb 16 02:09:13 CET 2016=20
x86_64 x86_64 x86_64 GNU/Linux

~> btrfs --version
btrfs-progs v4.4

~> sudo btrfs fi show
Label: none  uuid: 5170aca4-061a-4c6c-ab00-bd7fc8ae6030
     Total devices 2 FS bytes used 71.00GiB
     devid    1 size 111.30GiB used 111.30GiB path /dev/sdb2
     devid    2 size 111.30GiB used 111.29GiB path /dev/sdc2

Label: 'Backup'  uuid: 40b8240a-a0a2-4034-ae55-f8558c0343a8
     Total devices 1 FS bytes used 252.54GiB
     devid    1 size 800.00GiB used 266.08GiB path /dev/sda1

~> sudo btrfs fi df /
Data, RAID0: total=3D214.56GiB, used=3D69.10GiB
System, RAID1: total=3D8.00MiB, used=3D16.00KiB
System, single: total=3D4.00MiB, used=3D0.00B
Metadata, RAID1: total=3D4.00GiB, used=3D1.87GiB
Metadata, single: total=3D8.00MiB, used=3D0.00B
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

~> sudo btrfs fi df /backup_hdd
Data, single: total=3D245.01GiB, used=3D243.61GiB
System, DUP: total=3D32.00MiB, used=3D48.00KiB
System, single: total=3D4.00MiB, used=3D0.00B
Metadata, DUP: total=3D10.50GiB, used=3D8.93GiB
Metadata, single: total=3D8.00MiB, used=3D0.00B
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

Relevant mount options:
UUID=3D5170aca4-061a-4c6c-ab00-bd7fc8ae6030    / btrfs       =20
compress=3Dlzo,noatime,relatime,ssd,subvol=3D/root    0 1
UUID=3D5170aca4-061a-4c6c-ab00-bd7fc8ae6030    /home btrfs       =20
compress=3Dlzo,noatime,relatime,ssd,subvol=3D/home 0    1
UUID=3D5170aca4-061a-4c6c-ab00-bd7fc8ae6030    /backup btrfs       =20
compress=3Dlzo,noatime,relatime,ssd,subvol=3D/backup 0    1
UUID=3D5170aca4-061a-4c6c-ab00-bd7fc8ae6030    /web btrfs       =20
compress=3Dlzo,noatime,relatime,ssd,subvol=3D/web 0    1
UUID=3D40b8240a-a0a2-4034-ae55-f8558c0343a8    /backup_hdd btrfs       =20
compress=3Dlzo,noatime,relatime,noexec 0    1

--=20
Sincerely, Nazar Mokrynskyi
github.com/nazar-pc
Skype: nazar-pc
Diaspora: nazarpc@diaspora.mokrynskyi.com
Tox: A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8E=
F5261249



--------------ms030807050707070304030305
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: ÐÑÑÐ¿ÑÐ¾Ð³ÑÐ°ÑÑÑÐ½Ð¸Ð¹ Ð¿ÑÐ´Ð¿Ð¸Ñ S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuMwggT5MIID4aADAgECAhBk6v6TVth6hqLyl5xsFf+NMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTUxMjIyMDYwNTUxWhcNMTYxMjIyMDYwNTUxWjBEMR0wGwYDVQQDDBRuYXph
ckBtb2tyeW5za3lpLmNvbTEjMCEGCSqGSIb3DQEJARYUbmF6YXJAbW9rcnluc2t5aS5jb20w
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCugsLCcazI+Sjl29kaCHer/z6I0aPy
cKYqk4Bk0jUE6CcfQLX98E8b1sc2kbBjwd+jPPvWtqSGHzLUKLL1jfXJC6X5At+UHNdWiU6n
xaKnCiWiV0NZK6AVfrr+KdP+f1gYfMryPp/JkzcRDquML+YSz0BJ3ODaU538lDtC2sPeH7hY
nTiuMBfL6h2c680MF9UrIUqvqJ94QEillrDShGxaMHIWZepLxydmACnI9Sga8dZPjG84hV//
JKGRmdlQ1fA7g0LUE2hZcY/zdB6Qey87ctNkND/bQfghbArOdJZK2/cal0xJ6znrPAyqs7wj
2HVz8/coOlXPPsV4OkoA9X1PAgMBAAGjggG0MIIBsDALBgNVHQ8EBAMCBLAwHQYDVR0lBBYw
FAYIKwYBBQUHAwIGCCsGAQUFBwMEMAkGA1UdEwQCMAAwHQYDVR0OBBYEFCfmAiR7cI5aUj1L
5j5v0+wVzVy1MB8GA1UdIwQYMBaAFCSBbDlhvkkPj7cbRivJKLUnSG1oMG8GCCsGAQUFBwEB
BGMwYTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDkGCCsGAQUFBzAC
hi1odHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9zY2EuY2xpZW50MS5jcnQwOAYDVR0f
BDEwLzAtoCugKYYnaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2NhLWNsaWVudDEuY3JsMB8G
A1UdEQQYMBaBFG5hemFyQG1va3J5bnNreWkuY29tMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBGBgNVHSAEPzA9MDsGCysGAQQBgbU3AQIEMCwwKgYIKwYBBQUHAgEW
Hmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0BAQsFAAOCAQEAkIZk
GJPfY91CrJnZzsF0+qviIsqRCWqdT64E5ttyODEvfo9TVccBvwTgVZzKJY2e+ALaDNX0dBH+
9YXMUg5pNfXGHauhQjGan8bdKsaLhvqaq3g0CO1oZU38pqizWTzQYbzu62414VeIDauHMbFD
pdRD0Egx/iY8R7JAO9k+hciD0W/L7FPRU7UTtz1vPqrKO54mYNFMn6EUhR2poM1j0dmwZH4W
Cly6N88RT6zhncbgDnjKr6+IHCxSP0E75uf+6kgbYRtwHnLydUIZdkEESlHhKdgJJFoL7nHr
PU3kWyAMrRdf2YtCwDa5USI5mE9v6sf0ynMrThlXbkb12Dz9wzCCBeIwggPKoAMCAQICEGun
in0K14jWUQr5WeTntOEwDQYJKoZIhvcNAQELBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE1
MTIxNjAxMDAwNVoXDTMwMTIxNjAxMDAwNVowdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0
YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5
MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAL192vfDon2D9luC/dtbX64eG3XAtRmvmCSsu1d52DXsCR58zJQb
CtB2/A5uFqNxWacpXGGtTCRk9dEDBlmixEd8QiLkUfvHpJX/xKnmVkS6Iye8wUbYzMsDzgnp
azlPg19dnSqfhM+Cevdfa89VLnUztRr2cgmCfyO9Otrh7LJDPG+4D8ZnAqDtVB8MKYJL6QgK
yVhhaBc4y3bGWxKyXEtx7QIZZGxPwSkzK3WIN+VKNdkiwTubW5PIdopmykwvIjLPqbJK7yPw
FZYekKE015OsW6FV+s4DIM8UlVS8pkIsoGGJtMuWjLL4tq2hYQuuN0jhrxK1ljz50hH23gA9
cbMCAwEAAaOCAWQwggFgMA4GA1UdDwEB/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
KwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIBADAyBgNVHR8EKzApMCegJaAjhiFodHRwOi8v
Y3JsLnN0YXJ0c3NsLmNvbS9zZnNjYS5jcmwwZgYIKwYBBQUHAQEEWjBYMCQGCCsGAQUFBzAB
hhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wMAYIKwYBBQUHMAKGJGh0dHA6Ly9haWEuc3Rh
cnRzc2wuY29tL2NlcnRzL2NhLmNydDAdBgNVHQ4EFgQUJIFsOWG+SQ+PtxtGK8kotSdIbWgw
HwYDVR0jBBgwFoAUTgvvGqRAW6UXaYcwyjRoQ9BBrvIwPwYDVR0gBDgwNjA0BgRVHSAAMCww
KgYIKwYBBQUHAgEWHmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0B
AQsFAAOCAgEAi+P3h+wBi4StDwECW5zhIycjBL008HACblIf26HY0JdOruKbrWDsXUsiI0j/
7Crft9S5oxvPiDtVqspBOB/y5uzSns1lZwh7sG96bYBZpcGzGxpFNjDmQbcM3yl3WFIRS4Wh
NrsOY14V7y2IrUGsvetsD+bjyOngCIVeC/GmsmtbuLOzJ606tEc9uRbhjTu/b0x2Fo+/e7Uk
QvKzNeo7OMhijixaULyINBfCBJb+e29bLafgu6JqjOUJ9eXXj20p6q/CW+uVrZiSW57+q5an
2P2i7hP85jQJcy5j4HzA0rSiF3YPhKGAWUxKPMAVGgcYoXzWydOvZ3UDsTDTagXpRDIKQLZo
02wrlxY6iMFqvlzsemVf1odhQJmi7Eh5TbxI40kDGcBOBHhwnaOumZhLP+SWJQnjpLpSlUOj
95uf1zo9oz9e0NgIJoz/tdfrBzez76xtDsK0KfUDHt1/q59BvDI7RX6gVr0fQoCyMczNzCTc
RXYHY0tq2J0oT+bsb6sH2b4WVWAiJKnSYaWDjdA70qHX4mq9MIjO/ZskmSY8wtAk24orAc0v
wXgYanqNsBX5Yv4sN4Z9VyrwMdLcusP7HJgRdAGKpkR2I9U4zEsNJQJewM7S4Jalo1DyPrLp
L2nTET8ZrSl5Utp1UeGp/2deoprGevfnxWB+vHNQiu85o6MxggPMMIIDyAIBATCBiTB1MQsw
CQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEpMCcGA1UECxMgU3RhcnRDb20g
Q2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0Q29tIENsYXNzIDEgQ2xp
ZW50IENBAhBk6v6TVth6hqLyl5xsFf+NMA0GCWCGSAFlAwQCAQUAoIICEzAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjAyMTYwNDQ0MzBaMC8GCSqGSIb3
DQEJBDEiBCDBhQQH3KYVDR5jFyvKkjHIxLJJ9KQDXlGtoK2kp5HF5TBsBgkqhkiG9w0BCQ8x
XzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwIC
AgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGaBgkrBgEEAYI3
EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNV
BAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENv
bSBDbGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTCBnAYLKoZIhvcNAQkQAgsx
gYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsT
IFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBD
bGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTANBgkqhkiG9w0BAQEFAASCAQBW
Yjlj9eXY12BbxuWNmefH/qwpSWXuqnjUMSVSzD1mT/zuBnQKzc7qnRDpkcss6m1x8w7tm0Gn
qcfVqP/lxV75j1oVRUoOqvNkDvefCexP39X9+QrKQOP7+TNYSgV+xbqp7784xeDXeIupECw5
r72pN08ewF3qUo7aY22fBpQoFXjdGuYSnWURKQkdA5DffTt0eJ9nisG/e3OGol180GRDDBJ+
KrlI4Owr4zZY/oQQ38iHviUJZNliIREmlcYoHWKAO2CchV7eQXIp6XCovLQ5XZ4ob8oP0eGj
oNaA2VKeRuN1/PTWPN7oIT2XYGyDgYmV/Df85SNtVL2pMLkOaF9AAAAAAAAA
--------------ms030807050707070304030305--
