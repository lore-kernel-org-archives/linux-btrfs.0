Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:43968 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbcLYWAk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Dec 2016 17:00:40 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 5B79F5FEA8
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Dec 2016 22:00:37 +0000 (UTC)
Received: from mailgw-02.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id lTHR_DPt-7Sq for <linux-btrfs@vger.kernel.org>;
        Sun, 25 Dec 2016 22:00:35 +0000 (UTC)
Received: from schliemann.scientia.net (p579DFE54.dip0.t-ipconnect.de [87.157.254.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-02.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Dec 2016 22:00:35 +0000 (UTC)
Message-ID: <1482703234.6497.1.camel@scientia.net>
Subject: some free space cache corruptions
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Sun, 25 Dec 2016 23:00:34 +0100
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-h9blgpbcYiRezWuqOUiX"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-h9blgpbcYiRezWuqOUiX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey.

Had the following on a Debian sid:
Linux heisenberg 4.8.0-2-amd64 #1 SMP Debian 4.8.11-1 (2016-12-02)
x86_64 GNU/Linux

btrfs-progs v4.7.3


I was doing a btrfs check of a rather big btrfs (8TB device, nearly
full), having many snapshots on it, all incrementally send from another
8TB device, which in turn functions as the master copy:
# btrfs check /dev/mapper/data-a2 ; echo $?
Checking filesystem on /dev/mapper/data-a2
UUID: f8acb432-7604-46ba-b3ad-0abe8e92c4db
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 6805741969408 bytes used err is 0
total csum bytes: 6634558200
total tree bytes: 10292641792
total fs tree bytes: 2074869760
total extent tree bytes: 1100251136
btree space waste bytes: 885346193
file data blocks allocated: 6922343247872
=C2=A0referenced 7040929374208
0

=3D> this already showed an unusual:
cache and super generation don't match, space cache will be invalidated
Where does it come from?=20


Then I did some incremental send/receive (-p) from the other master 8TB
master btrfs and another fsck afters wards:

# btrfs check /dev/mapper/data-a2 ; echo $?
Checking filesystem on /dev/mapper/data-a2
UUID: f8acb432-7604-46ba-b3ad-0abe8e92c4db
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 7467006156800 bytes used err is 0
total csum bytes: 7279407560
total tree bytes: 11069603840
total fs tree bytes: 2127314944
total extent tree bytes: 1141342208
btree space waste bytes: 922662895
file data blocks allocated: 7599280926720
=C2=A0referenced 7720960733184
0

=3D> all fine...



Afterwards I removed all ro-snapshots except the most recent one... and
repeated the fsck:
# btrfs check /dev/mapper/data-a2 ; echo $?
Checking filesystem on /dev/mapper/data-a2
UUID: f8acb432-7604-46ba-b3ad-0abe8e92c4db
checking extents
checking free space cache
block group 5431552376832 has wrong amount of free space
failed to load free space cache for block group 5431552376832
checking fs roots
checking csums
checking root refs
found 7427361222656 bytes used err is 0
total csum bytes: 7240763996
total tree bytes: 10998038528
total fs tree bytes: 2100297728
total extent tree bytes: 1137065984
btree space waste bytes: 992708933
file data blocks allocated: 7416363184128
=C2=A0referenced 7536754290688
0

=3D> Isn't that some indication of a bug already? Nothing happened, just
deletion of snapshots and there is apparently some free space cache
corruption?


Then I tried the usual recipe:
mount /data/data-a/2/ -o clear_cache
kernel said:
Dec 25 22:14:17 heisenberg kernel: BTRFS info (device dm-2): force clearing=
 of disk cache

...re-mounted,rw, deleted some regular files... repeated the fsck and
again:
# btrfs check /dev/mapper/data-a2 ; echo $?
Checking filesystem on /dev/mapper/data-a2
UUID: f8acb432-7604-46ba-b3ad-0abe8e92c4db
checking extents
checking free space cache
block group 5431552376832 has wrong amount of free space
failed to load free space cache for block group 5431552376832
checking fs roots
checking csums
checking root refs
found 7427284213760 bytes used err is 0
total csum bytes: 7240689688
total tree bytes: 10997907456
total fs tree bytes: 2100281344
total extent tree bytes: 1137049600
btree space waste bytes: 992679805
file data blocks allocated: 7416286306304
=C2=A0referenced 7536677412864
0

=3D> same error again...

Any ideas how to resolve? And is this some serious error that could
have caused corruptions?


Cheers,
Chris.
--=-h9blgpbcYiRezWuqOUiX
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYxMjI1MjIwMDM0WjBPBgkqhkiG9w0BCQQxQgRAPi2h
2DF+9PEYpEKGC+hqbpb/0MB3Px4Tiw89EPkNBjnNYwR0rNFpo9Up8aE3DqBk3Uoe4SuwbbFG/3lm
ehpd5TCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAPHhx
OY9yQXHskCbYbXlG8WphYuPXItsrJIewpwriDZm5iwSetSvWuTJXymuRWUcNsaMWae7UlVRY27oD
m3m8NC004zhmccDk/hVEEZldf1O35cjza2nOqOdbXQ4DMMfeSgkEu9GxOMerYu1+SKByVdATb+Yu
YmamLGA47UCTBJmRbHTq/x2cFqdtDqoa6qjxhmHn4EDUpJRlvL3f9L9jbaY81aGGbf2a2SxIlF/e
zaWUTiN4vL2ae1ArgyTNMQPe5X4AcNNtVvn4UXS8pzvp7XvVa/WxEipyx/rvLVRUrkuFDq+PqPyq
7lfdMse5vKoFJ7ryG9+6l09NkwMxDK4NW6qTDPGAfRroap1Sw5pX8WVSWUkB03vgP1HaXk3vGIr9
p/OWdD1G62PhCr4fS5wtLEPNaqgck7pqwrDUE6dTc4reeQQ2aEPul6GV4tMGYTOSonyFZTiC0by+
uxle54ZFO3kw2FwzDUnlM436cX2h0W5QnADxedPVE4uE9sLeSds/UNjoAUKRU7mCqb74V+1T0jiX
B3tkasYYZq/DbFekXTxWNPXV1EZFdY5Oo4DSUX8Zh1Q4FSYU9ZGWxB3bdkRFiDIrGE/iJdE8A5eR
77uj3K8eWUupoj+iJx7/qrYuKISrPuM7Y4T9hTw65tP5J9RKu/mdNz3tcA29LsJvQsVkCSoAAAAA
AAA=


--=-h9blgpbcYiRezWuqOUiX--

