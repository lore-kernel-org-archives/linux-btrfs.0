Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:45661 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbdAOREf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Jan 2017 12:04:35 -0500
Message-ID: <1484499869.17186.1.camel@scientia.net>
Subject: Re: corruption: yet another one after deleting a ro snapshot
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: Sun, 15 Jan 2017 18:04:29 +0100
In-Reply-To: <25993bdf-d1fe-30df-7236-b9d5d6e5cfb2@cn.fujitsu.com>
References: <1484183243.10253.5.camel@scientia.net>
         <a7b82ec9-bd8d-d6bb-27e7-3732b466ca06@cn.fujitsu.com>
         <1484188092.29002.4.camel@scientia.net>
         <25993bdf-d1fe-30df-7236-b9d5d6e5cfb2@cn.fujitsu.com>
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-muJAtOFaS8VFTHDE3WWQ"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-muJAtOFaS8VFTHDE3WWQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-01-12 at 10:38 +0800, Qu Wenruo wrote:
> IIRC, RO mount won't continue background deletion.
I see.


> Would you please try 4.9 btrfs-progs?

Done now, see results (lowmem and original mode) below:

# btrfs version
btrfs-progs v4.9

# btrfs check /dev/nbd0 ; echo $?
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
checking extents
ref mismatch on [37765120 16384] extent item 0, found 1
Backref 37765120 parent 6403 root 6403 not found in extent tree
backpointer mismatch on [37765120 16384]
owner ref check failed [37765120 16384]
ref mismatch on [51200000 16384] extent item 0, found 1
Backref 51200000 parent 6403 root 6403 not found in extent tree
backpointer mismatch on [51200000 16384]
owner ref check failed [51200000 16384]
ref mismatch on [78135296 16384] extent item 0, found 1
Backref 78135296 parent 6403 root 6403 not found in extent tree
backpointer mismatch on [78135296 16384]
owner ref check failed [78135296 16384]
ref mismatch on [5960381235200 16384] extent item 0, found 1
Backref 5960381235200 parent 6403 root 6403 not found in extent tree
backpointer mismatch on [5960381235200 16384]
checking free space cache
checking fs roots
checking csums
checking root refs
found 7483995824128 bytes used err is 0
total csum bytes: 7296183880
total tree bytes: 10875944960
total fs tree bytes: 2035286016
total extent tree bytes: 1015988224
btree space waste bytes: 920641324
file data blocks allocated: 8267656339456
=C2=A0referenced 8389440876544
0


# btrfs check --mode=3Dlowmem /dev/nbd0 ; echo $?
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
checking extents
ERROR: block group[74117545984 1073741824] used 1073741824 but extent items=
 used 0
ERROR: block group[239473786880 1073741824] used 1073741824 but extent item=
s used 1207959552
ERROR: block group[500393050112 1073741824] used 1073741824 but extent item=
s used 1207959552
ERROR: block group[581997428736 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[626557714432 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[668433645568 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[948680261632 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[982503129088 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[1039411445760 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1054443831296 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[1190809042944 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1279392743424 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1481256206336 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1620842643456 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[1914511032320 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[3055361720320 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[3216422993920 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[3670615785472 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[3801612288000 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[3828455833600 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[4250973241344 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4261710659584 1073741824] used 1073741824 but extent ite=
ms used 1074266112
ERROR: block group[4392707162112 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4558063403008 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4607455526912 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4635372814336 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4640204652544 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4642352136192 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[4681006841856 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[5063795802112 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[5171169984512 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[5216267141120 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[5290355326976 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[5445511020544 1073741824] used 1073741824 but extent ite=
ms used 1074266112
ERROR: block group[6084387405824 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[6104788500480 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[6878956355584 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[6997067956224 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[7702516334592 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[8051482427392 1073741824] used 1073741824 but extent ite=
ms used 1084751872
ERROR: block group[8116980678656 1073741824] used 1073217536 but extent ite=
ms used 0
ERROR: extent[5960381235200 16384] backref lost (owner: 6403, level: 1)
ERROR: check node failed root 6403 bytenr 5960381235200 level 1, force cont=
inue check
ERROR: extent[51200000 16384] backref lost (owner: 257, level: 1)
ERROR: check node failed root 6403 bytenr 51200000 level 1, force continue =
check
ERROR: extent[37765120 16384] backref lost (owner: 257, level: 1)
ERROR: check node failed root 6403 bytenr 37765120 level 1, force continue =
check
ERROR: extent[78135296 16384] backref lost (owner: 257, level: 1)
ERROR: check node failed root 6403 bytenr 78135296 level 1, force continue =
check
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
found 7483995758592 bytes used err is -5
total csum bytes: 7296183880
total tree bytes: 11018780672
total fs tree bytes: 2178121728
total extent tree bytes: 1015988224
btree space waste bytes: 936782513
file data blocks allocated: 9157658292224
=C2=A0referenced 9292573106176
1


It's the same fs as I was talking before, I just had to do it via NBD.


> But, I'm still not sure whether it's a false alert or a *REAL*
> corruption.
>=20
> Even it may cause problem and corrupt your data, I still hope you
> could=C2=A0
> do a rw mount and trigger a btrfs fi sync.
>=20
> If it's a false alert, we can fix it then with ease.
> Or, it's a really big problem.

So what should I do next (as said, this is just a backup for me, so
while it would be annoying to recreate it (because nearly the full
8TiB) I could do it without any problem)... in terms of debugging this
issue?

Shall I rw-mount the fs and do sync and wait and retry? Or is there
anything else that you want me to try before in order to get the kernel
bug (if any) or btrfs-progs bug nailed down?


Cheers,
Chris.
--=-muJAtOFaS8VFTHDE3WWQ
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEmow
ggXiMIIDyqADAgECAhBctkhuRwyYxn/2gNtkSuKNMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYT
AklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0
aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTAeFw0xNTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDuD1CMlQkjhKz1UGqP1jeiTiH9MgllRz6vOPrVG/eE0H/J4QQLV/PeL8RT
4xc44bEzsoJu0IhwnEchb+TxE/qw88w7hxODuw3N8Faxix6a1jp83+RWvZHZf78+O+3GYBpekZfT
Oe9A/FoTXbcgwZfLTMQodn+ckNnX31M/1M2f2/7VA7QBlvihontyHQOlIlryQXnGI0UMCD21oopK
tW48ckv0wUVg8irBKGMeD65gTON/Fsw/ZBbBqadoD1jt85FIM1ql24WUBEBwO1d0ykCKOIbgcqes
3fbcjQpruUNMBbIu1MMIRMqwjx/M7IvSKcS7VYRWl0/K2byzWvBAHh/1AgMBAAGjggFkMIIBYDAO
BgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQI
MAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2ZzY2Eu
Y3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29t
MDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0O
BBYEFJmXqxg1OotZRUOYsnJxyPT7Cc8WMB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7y
MD8GA1UdIAQ4MDYwNAYEVR0gADAsMCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNv
bS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggIBAJlBQQTO9iT1TjA0eEO7V/1AbBvMAfibjAgofxmJ
01jBmHKg0pbTjWInTTYoxb3LBgz3mfjvvS1PjnIfb29MyVm0G/PSHjgq7Ews1dEJMPC9XTuxPf2c
+MWLkynBlotW542JprW+iTWfZafyUtzIKW1hk0YASJ8zSSj8D++9yR+0UhkbvlECJkdi1+et0EaI
7HIX6ccj1rfcFFflWX/fPT64dn9jpg9s0nuJug4WsVkEK236WndZoMHrZmgF7CIyZ3T0muqYwkAS
DDcRt9A21o/Mc+D8Q6GVmKRGB3gEKvOtsioHZEqJv6CdAm3a6gloo5pX3RL1eCzc8Lzfs4T0ISZj
r8xNMbTGlsuHaFH+stDewKsfnpo4N64OtAGrzmVfFFsMIRENRHsVlSEe/6LVpBpjn00+7bqEN3qe
qSxIOraYJ12mJ08G4YnP2U1fadHIaS50O5ZXqAivoBl9pi/6CBNc5wIMlkXMyFZ0sLsI+9ErFDu9
OJhX7iWCo69X0ydlzXj08+2K1PKyr+g6/vTPHur63JotNrhyoWEJyWEjBLA4QmJXfGpB5u+bCwNf
sFpcYAlkiFt1Rs2vemgSBy3q4DHDbPKvr1YImZNRSHP+TX9NP94JRkmqcyD/qaN7u2JV1pRAlwG0
npyrn6ZQM1QHV+iFbwQ4VqLMWk//QVo/rZy1MIIGPjCCBSagAwIBAgIQPZ6tDP/RHLwcz1F+2kRA
DzANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEp
MCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0
Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMDIzNloXDTE4MDEwMjAyMDIzNlowejEL
MAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITcO8bmNoZW4xITAfBgNVBAMM
GENocmlzdG9waCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50
aWEubmV0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsoxs789VtR81tlqeP2vwE3Cp
YosZYRfrovj+Wb91paoV5OQcFuXA7yONnLsWxOnJ3AGgy1/wG79Ko+yHSmF2K88pEWjrFe0zmZWZ
0b2OtMoKLEjxz7Nz2N7/lmgss8XinJ083LwLKSe4f+JLjnF5hX/g6wG4NkFXVOIf2YFZ0+c1NYFQ
T6Vy42EWdk+JLDoXjyd2hEperLCz9rQr2k3wh0cn8R1FDUGerBGpMnvyKV6JXj5vZsqJnmiiId9e
0IdBj4Wcs3hT2usk6dJYwHrZ8b7Fkv6BRq90DUI7i8+ukTdp5hnAb8TPSbe1JS4h3Jc7r2NVLkpo
Gbuw98er9s2PEAvpECD3toO3ojBevL56vEDbGa5tXpvvcWCz6t3QyEKJ2E54hWw1fbUA0BtydQC0
mhKBtrENVnnCDrSgiyBMnd8y+kw6iPKeJEjNObGubc4BZp47zPn/ZiDBaHue6S0MXsoS7XEGOuCU
09S/8kD8wTecBg+KdlLSNkLm+xqx6Cy7zwcj3IuQv0PeWi4kfEkAJfl8IeAP/4049iA6a1rkhJl7
1rDjpEGBCG+i9BAgBeNdHLtQ7bugdvU+GfHjFXEU1emUk91E2liML8kpCvhUAXcLhhL8bxPJiX2/
VQ2esrpQVO56OzpivNauonLaWmHEKOSfPC3s5AKMytMTiUiszEUCAwEAAaOCAcMwggG/MAsGA1Ud
DwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAdBgNVHQ4E
FgQUwRklxF1ZV2ooSMkFwLiK13apkK0wHwYDVR0jBBgwFoAUmZerGDU6i1lFQ5iycnHI9PsJzxYw
bwYIKwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wOQYI
KwYBBQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQyLmNydDA4
BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50Mi5jcmww
IAYDVR0RBBkwF4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcBAgQwLDAq
BggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3DQEBCwUA
A4IBAQBb8EIsoUN/tgUgQqrNXNtlksPep84kx5yRBgr71uf3ITLddGtzfDBj6KdZUoy7SG3MQkyO
kvYmXBClj23rv8Iol48/3oi9XWZw5EV3uHrRse1TzQgMPZE0hZsDgkqXVoxMQfk55ndjZIHMfSkn
hdnqSP5zZ4TCmDEKLppPMDcQSSrjilnbthpxlIJzeGeEFtrh6ssh/oF6mUaEGFcd8kx9RS51K1gt
H4J36y4E6pKB7EdxG2+0yVzAIta8dkD/BiMCKRWhp1EmzQ2uIh2nX5y8t4e2xHHuiy11Yeq6UTW/
JmfxF4xcbkNK/rv9ISBg9K+mZtg2QXr+P/CJBtej2RLUMIIGPjCCBSagAwIBAgIQPZ6tDP/RHLwc
z1F+2kRADzANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20g
THRkLjEpMCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMT
GlN0YXJ0Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMDIzNloXDTE4MDEwMjAyMDIz
NlowejELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITcO8bmNoZW4xITAf
BgNVBAMMGENocmlzdG9waCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9A
c2NpZW50aWEubmV0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsoxs789VtR81tlqe
P2vwE3CpYosZYRfrovj+Wb91paoV5OQcFuXA7yONnLsWxOnJ3AGgy1/wG79Ko+yHSmF2K88pEWjr
Fe0zmZWZ0b2OtMoKLEjxz7Nz2N7/lmgss8XinJ083LwLKSe4f+JLjnF5hX/g6wG4NkFXVOIf2YFZ
0+c1NYFQT6Vy42EWdk+JLDoXjyd2hEperLCz9rQr2k3wh0cn8R1FDUGerBGpMnvyKV6JXj5vZsqJ
nmiiId9e0IdBj4Wcs3hT2usk6dJYwHrZ8b7Fkv6BRq90DUI7i8+ukTdp5hnAb8TPSbe1JS4h3Jc7
r2NVLkpoGbuw98er9s2PEAvpECD3toO3ojBevL56vEDbGa5tXpvvcWCz6t3QyEKJ2E54hWw1fbUA
0BtydQC0mhKBtrENVnnCDrSgiyBMnd8y+kw6iPKeJEjNObGubc4BZp47zPn/ZiDBaHue6S0MXsoS
7XEGOuCU09S/8kD8wTecBg+KdlLSNkLm+xqx6Cy7zwcj3IuQv0PeWi4kfEkAJfl8IeAP/4049iA6
a1rkhJl71rDjpEGBCG+i9BAgBeNdHLtQ7bugdvU+GfHjFXEU1emUk91E2liML8kpCvhUAXcLhhL8
bxPJiX2/VQ2esrpQVO56OzpivNauonLaWmHEKOSfPC3s5AKMytMTiUiszEUCAwEAAaOCAcMwggG/
MAsGA1UdDwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAd
BgNVHQ4EFgQUwRklxF1ZV2ooSMkFwLiK13apkK0wHwYDVR0jBBgwFoAUmZerGDU6i1lFQ5iycnHI
9PsJzxYwbwYIKwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5j
b20wOQYIKwYBBQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQy
LmNydDA4BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50
Mi5jcmwwIAYDVR0RBBkwF4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0MCMGA1UdEgQcMBqGGGh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcB
AgQwLDAqBggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3
DQEBCwUAA4IBAQBb8EIsoUN/tgUgQqrNXNtlksPep84kx5yRBgr71uf3ITLddGtzfDBj6KdZUoy7
SG3MQkyOkvYmXBClj23rv8Iol48/3oi9XWZw5EV3uHrRse1TzQgMPZE0hZsDgkqXVoxMQfk55ndj
ZIHMfSknhdnqSP5zZ4TCmDEKLppPMDcQSSrjilnbthpxlIJzeGeEFtrh6ssh/oF6mUaEGFcd8kx9
RS51K1gtH4J36y4E6pKB7EdxG2+0yVzAIta8dkD/BiMCKRWhp1EmzQ2uIh2nX5y8t4e2xHHuiy11
Yeq6UTW/JmfxF4xcbkNK/rv9ISBg9K+mZtg2QXr+P/CJBtej2RLUMYIEfjCCBHoCAQEwgYkwdTEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENl
cnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAyIENsaWVudCBD
QQIQPZ6tDP/RHLwcz1F+2kRADzANBglghkgBZQMEAgMFAKCCAcUwGAYJKoZIhvcNAQkDMQsGCSqG
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTcwMTE1MTcwNDI5WjBPBgkqhkiG9w0BCQQxQgRApID7
rGK/KbZ1p/VyCTPO2G0AE4dJb0kbcu06LSNkjjCnDPE09ZU4VWoiVyhTjZLNcv+QSHhZ1AU1SI3W
io5bKDCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAdCsH
F8Zu9dDvO7D+L5oPgFAiXlyFI/n37H0uLO8ASnOJ9N/oHbxBSwBEHSdZZcub/lBQa0991Qxc7xB6
gMURWQe3woy92hjwzipxqqtOPjvsJSReVwBom61jL+gCdhF/kfXVpmAXWlqIq3JKXQaS9pTmO/Q3
QWRs1Gj+byAdAApkZK1HnkQuHFWOToa2QGi9vfd7em6QLckH6ZUh6abp0qg333zXok7JBuBAR2g7
WUnaAPLpHETAT9tgr1D/Cwa1AN61nYEqhDsNB+9Brv/FqWnZ6savULw9NPPoAZt/u9Sytmb12+q1
Sq3o1bIfY5o3upTmeCWkoN8tmKpxTPMfLHSRYA23JJ4Ck9NjPztHg6iY54OVqJ8rw9IOsECdZeZt
K1IYkrfGOBvq8Sn9MD4VvgsLIGvVe2MMgdxq6b7aG/CXSXypyQRJj0Iyu3IoIF3dEkk5Gvj08XJs
QucH61FzSWrSltTKuzG2YEU2xyD422KZ6IJfOvoWS2FOG3mWKz+0wLMV6/g3TjcpQIm3wx+pEwSo
PMeTr9X4iAXBb+sXcLD+Xj7Y49rH5FRN6//0xu5PAqHMQ0jh10egD9su1Ezwt0OG4xVjztrvcK/c
ZG/dvqr+feCdciljgq3iKgQ0wjS/jbmq0c6u54h9c54Sm9E/Ua0P5RzkWFh73ny3IoAlvZUAAAAA
AAA=


--=-muJAtOFaS8VFTHDE3WWQ--

