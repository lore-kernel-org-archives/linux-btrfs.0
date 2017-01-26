Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:49635 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdAZCum (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 21:50:42 -0500
Message-ID: <1485399036.23328.7.camel@scientia.net>
Subject: Re: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework
 update
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: chris@colorremedies.com, dsterba@suse.cz
Date: Thu, 26 Jan 2017 03:50:36 +0100
In-Reply-To: <8d21a04e-7035-5b5d-5b58-9ac0d7f93f02@cn.fujitsu.com>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
         <1485276845.12065.1.camel@scientia.net>
         <35be430d-1210-9b33-3b18-c22127cc64a7@cn.fujitsu.com>
         <1485305208.12065.9.camel@scientia.net>
         <8d21a04e-7035-5b5d-5b58-9ac0d7f93f02@cn.fujitsu.com>
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-Z4GKOfLIuQZ01sUuiGJQ"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-Z4GKOfLIuQZ01sUuiGJQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-25 at 12:16 +0800, Qu Wenruo wrote:
> https://github.com/adam900710/btrfs-progs/tree/lowmem_fixes

Just finished trying your new patches.

Same game as last time, applied to 4.9, no RW mount between the runs.


btrfs-progs v4.9 WITHOUT patch:
*******************************
# btrfs check /dev/nbd0 ; echo $?
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
found 7519512838144 bytes used err is 0
total csum bytes: 7330834320
total tree bytes: 10902437888
total fs tree bytes: 2019704832
total extent tree bytes: 1020149760
btree space waste bytes: 925714197
file data blocks allocated: 7509228494848
=C2=A0referenced 7630551511040
0


# btrfs check --mode=3Dlowmem /dev/nbd0 ; echo $?
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
ERROR: block group[8116980678656 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
found 7519512838144 bytes used err is -5
total csum bytes: 7330834320
total tree bytes: 10902437888
total fs tree bytes: 2019704832
total extent tree bytes: 1020149760
btree space waste bytes: 925714197
file data blocks allocated: 7509228494848
=C2=A0referenced 7630551511040
1

btrfs-progs v4.9 WITH patches:
******************************
# btrfs check /dev/nbd0 ; echo $?
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
found 7519512838144 bytes used, no error found
total csum bytes: 7330834320
total tree bytes: 10902437888
total fs tree bytes: 2019704832
total extent tree bytes: 1020149760
btree space waste bytes: 925714197
file data blocks allocated: 7509228494848
=C2=A0referenced 7630551511040
0

# btrfs check --mode=3Dlowmem /dev/nbd0 ; echo $?
checking extents
checking free space cache
checking fs roots
ERROR: root 6031 EXTENT_DATA[277 524288] datasum missing
ERROR: errors found in fs roots
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
found 7519512838144 bytes used, error(s) found
total csum bytes: 7330834320
total tree bytes: 10902437888
total fs tree bytes: 2019704832
total extent tree bytes: 1020149760
btree space waste bytes: 925714197
file data blocks allocated: 7509228494848
=C2=A0referenced 7630551511040
1

=3D> so unfortunately what seems to be the very same error than before

Just tell me if you find something new :)


Cheers,
Chris.
--=-Z4GKOfLIuQZ01sUuiGJQ
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTcwMTI2MDI1MDM2WjBPBgkqhkiG9w0BCQQxQgRAfQlZ
mc9gy3vI/cLX3AA3FS+UqTxeoxhauLDEm0/d9dwwIihlOxHBqD3CS94LWmHpEOytlUhcT0TSbFCd
uajZlDCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIABmSO
DhOsgY1oN/5YjMdnQWWSeDfjMRT1UBEH1jMr5G3gvGlCXzZzE4ttN/YVThaLJsQ/tWxljFC4R9Or
J7qKnCG9VAKGG71ClsmZji2wWZdAiifLnPkIxl0JU8JlYbuvtNJfZso2ml6hekxrftYPAlXZVTUq
1tg6C2Ggv4LTWMSlyTwVaf3CPOy1DbHFoDuvAllINiY/arle31qbeOIeHr5ry6GDglmaVpPwUq+E
PUX8f0s5VQpYpyyeuFPXVKM8Vg/VfzeCifOpKbt2zxviQiPvI7aIAgMB+fPeHm5SIHYgLYZfd985
L6G8aSfly6as2nN23hecyyGHuRApBoDod/x1YklQE/FdlLgdOfsMHpfDc86OJBL/wjoTyJ6CPP4i
AEWfiPUDiOx+fnuxj/Jr3cIoyPgv4SNwAgqUnHHQ/hHwF0iTeurXI9JIIzVw6AeOEmjz/dMHvd3U
8u29HX5Idf0jQTibYMLzYjEj2+G4iY6kRpJy1+NvRLZzFNvjxL4LnjUO4yhY5bj+0bGmq0YgeoRu
oVjKdaFmWgfs1btsJh39cFjMJ0ukhAIMgLF2Z21bVdxIHviD+vcyGS/dzMDBXf/a5yKudtg5XEYA
YqUdnL310sUsqIK4zXXz8w1zdEmCRA6GfDvIffjpMRZiXE0POY0/HR3RwnMdzhIuCXngvtEAAAAA
AAA=


--=-Z4GKOfLIuQZ01sUuiGJQ--

