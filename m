Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:44548 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757168AbcIOCOK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 22:14:10 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 4B4FC5FCAB
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 02:14:07 +0000 (UTC)
Received: from mailgw-01.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id QpC8wRhrrQtU for <linux-btrfs@vger.kernel.org>;
        Thu, 15 Sep 2016 02:14:05 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-46-244-200-251.dynamic.mnet-online.de [46.244.200.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-01.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 02:14:05 +0000 (UTC)
Message-ID: <1473905644.8603.44.camel@scientia.net>
Subject: Re: stability matrix (was: Is stability a joke?)
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Thu, 15 Sep 2016 04:14:04 +0200
In-Reply-To: <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
References: <57D51BF9.2010907@online.no>
         <20160912142714.GE16983@twin.jikos.cz>
         <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
         <20160912165107.GG16983@twin.jikos.cz>
         <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
         <20160915010759.GD32452@DigitalMercury.dynalias.net>
         <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-TgPCaXNHVXU6PaAR5GTy"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-TgPCaXNHVXU6PaAR5GTy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey.

As for the stability matrix...

In general:
- I think another column should be added, which tells when and for
=C2=A0 which kernel version the feature-status of each row was=C2=A0
=C2=A0 revised/updated the last time and especially by whom.
=C2=A0 If a core dev makes a statement on a particular feature, this
=C2=A0 probably means much more, than if it was made by "just" a list
=C2=A0 regular.
=C2=A0 And yes I know, in the beginning it already says "this is for 4.7"..=
.
=C2=A0 but let's be honest, it's pretty likely when this is bumped to 4.8
=C2=A0 that not each and every point will be thoroughly checked again.
- Optionally even one further column could be added, that lists bugs
=C2=A0 where the specific cases are kept record of (if any).
- Perhaps a 3rd Status like "eats-your-data" which is worse than
=C2=A0 critical, e.g. for things were it's known that there is a high
=C2=A0 chance for still getting data corruption (RAID56?)


Perhaps there should be another section that lists general caveats
and pitfalls including:
- defrag/auto-defrag causes ref-link break up (which in turn causes
=C2=A0 possible extensive space being eaten up)
- nodatacow files are not yet[0] checksummed, which in turn means
=C2=A0 that any errors (especially silent data corruption) will not be
=C2=A0 noticed AND which in turn also means the data itself cannot be
=C2=A0 repaired even in case of RAIDs (only the RAIDs are made consistent
=C2=A0 again)
- subvolume UUID attacks discussed in the recent thread
- fs/device UUID collisions
=C2=A0 - the accidental corruption that can happen in case colliding
=C2=A0 =C2=A0 fs/device UUIDs appear in a system (and telling the user that
=C2=A0 =C2=A0 this is e.g. the case when dd'ing and image or using lvm
=C2=A0 =C2=A0 snapshots, probably also when having btrfs on MD RAID1 or RAI=
D10)
=C2=A0 - the attacks that are possible when UUIDs are known to an attacker
- in-band dedupe
=C2=A0 deduped are IIRC not bitwise compared by the kernel before de-duping=
,
=C2=A0 as it's the case with offline dedupe.
=C2=A0 Even if this is considered safe by the community... I think users
=C2=A0 should be told.
- btrfs check --repair (and others?)
=C2=A0 Telling people that this may often cause more harm than good.
- even mounting a fs ro, may cause it to be changed
- DB/VM-image like IO patterns + nodatacow + (!)checksumming
=C2=A0 + (auto)defrag + snapshots
=C2=A0 a)
=C2=A0 People typically may have the impression:
=C2=A0 btrfs =3D checksummed =3D> als is guaranteed to be "valid" (or at le=
ast
=C2=A0 noticed)
=C2=A0 However this isn't the case for nodatacow'ed files, which in turn is
=C2=A0 kinda "mandatory" for DB/VM-image like IO patterns, cause otherwise
=C2=A0 these would fragment to heavily (see (b).
=C2=A0 Unless claimed by some people, none of the major DBs or VM-image
=C2=A0 formats do general checksumming on their own, most even don't suppor=
t
=C2=A0 it, some that do wouldn't do it without app-support and few "just"
=C2=A0 don't do it per default.
=C2=A0 Thus one should bump people to this situation and that they may not
=C2=A0 get this "correctness" guarantee here.
=C2=A0 b)
=C2=A0 IIRC, it doesn't even help to simply not use nodatacow on such files
=C2=A0 and using auto-defrag instead to countermeasure the fragmenting, as
=C2=A0 that one doesn't perform too well on large files.




For specific features:
- Autodefrag
=C2=A0 - didn't that also cause reflinks to be broken up? that should be
=C2=A0 =C2=A0 mentioned than as well, as it is (more or less) for defrag an=
d
=C2=A0 =C2=A0 people could then assume it's not the case for autodefrag (wh=
ich I
=C2=A0 =C2=A0 did initially)
=C2=A0 - wasn't it said that autodefrag performs bad with files > ~1GB?
=C2=A0 =C2=A0 Perhaps that should be mentioned too
- defrag
=C2=A0 "extents get unshared" is IMO not an adequate description for the en=
d
=C2=A0 user,... it should perhaps link to the defrag article and there
=C2=A0 explain in detail that any ref-linked files will be broken up, which
=C2=A0 means space usage will increase, and may especially explode in case
=C2=A0 of snapshots
- all the RAID56 related points
=C2=A0 wasn't there recently a thread that discussed a more serious bug,
=C2=A0 where parity was wrongly re-calculated which in turn caused actual
=C2=A0 data corruption?
=C2=A0 I think if that's still an issue "write hole still exists, parity
=C2=A0 not checksummed" is not enough but one should emphasize that data ma=
y
=C2=A0 easily be corrupted.
- RAID*
=C2=A0 No userland tools for monitoring/etc.
- Device replace=C2=A0
=C2=A0 IIRC, CM told me that this may cause severe troubles on RAID56


Also, the current matrix talks about "auto-repair"... what's that? (=3D>
should be IMO explained).=C2=A0


Last but not least, perhaps this article may also be the place to
document 3rd party things and how far they work stable with btrfs.
For example:
- Which grub version supports booting from it? Which features does it
=C2=A0 [not] support (e.g. which RAIDs, skinny-extents, etc.)?
- Which forensic tools (e.g. things like testdisk) do work with btrfs?
- Which are still maintained/working dedupe userland tools (and are
=C2=A0 they stable?)



Cheers,
Chris.



[0] Yeah I know, a number of list regulars constantly tried to convince
=C2=A0 =C2=A0 me that this wasn't possible per se, but a recent discussion =
I had
=C2=A0 =C2=A0 with CM seemed to have revealed (unless I understood it wrong=
) that
=C2=A0 =C2=A0 it wouldn't be generally impossible at all.
--=-TgPCaXNHVXU6PaAR5GTy
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwOTE1MDIxNDA0WjBPBgkqhkiG9w0BCQQxQgRAxE2/
4d87zmiZSpe57oXa1ddql1UmK/f+oDu53E2JrETXaZAhji7CDP9JowpmNFRK56iofMQS+TlOQ/RU
myU96zCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAAlu3
29CsgPmsZthjQc8BwNpZ65/SdqghHGoApeYDMMKrzfuzGp/lVMydCNAth+q2FuDHELgBjOqQ8qXk
44CqhRd9JNFfp6PA99uYO4dXWGsIgukI0N4vHvQ7Wz2by5HYTls6msEvoAbCOG+ZW9eeX2sH3KLY
qjht6wi7W8L7skg5670jGcLOvovIfU0QDYolDZyNB1xJIvILsbrwdXJtQhfDA/cmOFmztTSSz/8Y
b9QiqacUDq2U1aAgw27YhOzz6GoUZW7uiR6jhU/94faHI8ClWHY/6aK5o1kXy9NLkB/ZJ5CrNlQo
fOu8epBhYci+ETE2uM0HAr+R1AyClPdxSHtKVC+hFk/cZfg5gD3FmlpWXWAiEilffHLA0F23puoO
1q9aOBsfStPQYDCcec1p6XLr4LEtvOGpUGxKRiRgEDs4Q3RjQy+kFKGqWWtQ1kl6bmffBM6IVLQL
Povc6wY+eCGJPUmjH86R7aVqTtKcl1MrUPv3Gzn1GDGXCVzY6Nq+hMnj6DPhZPsABrl3mb1CfvDd
O7v7Kq+kQjhZCuBsExm8PTQdc5X8EwOMk7deWafdZQ1GFvAkKBmRG1UIzsXCsS0TVMMi6cc7w2W1
0HVyVI0dSV+ZKVL1+1vCQpz33TIDFF2l3iqyfad9t3FUx+w5CmueOBUQtQP+N1l2deUV1WoAAAAA
AAA=


--=-TgPCaXNHVXU6PaAR5GTy--

