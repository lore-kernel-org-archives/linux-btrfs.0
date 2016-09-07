Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:52042 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757580AbcIGSIG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 14:08:06 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-02.dd24.net (Postfix) with ESMTP id CC0F45FF84
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Sep 2016 18:08:02 +0000 (UTC)
Received: from mailgw-02.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id rkI1NPOjZRIX for <linux-btrfs@vger.kernel.org>;
        Wed,  7 Sep 2016 18:08:00 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-46-244-209-217.dynamic.mnet-online.de [46.244.209.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-02.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Sep 2016 18:08:00 +0000 (UTC)
Message-ID: <1473271679.24874.36.camel@scientia.net>
Subject: Re: Security implications of btrfs receive?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Wed, 07 Sep 2016 20:07:59 +0200
In-Reply-To: <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
         <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
         <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
         <1473259316.24874.3.camel@scientia.net>
         <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-WxNeaEnGcT0osSaDjD2Q"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-WxNeaEnGcT0osSaDjD2Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-09-07 at 11:06 -0400, Austin S. Hemmelgarn wrote:
> This is an issue with any filesystem,
Not really... any other filesystem I'd know (not sure about ZFS) keeps
working when there are UUID collisions... or at least it won't cause
arbitrary corruptions, which then in the end may even be used for such
attacks as described in that thread.

Even other multi-device containers (LVM, MD) don't at least corrupt
your data like it allegedly can happen with btrfs.



>  it is just a bigger issue with=C2=A0
> BTRFS.
No corruption vs. possible arbitrary data corruption and leakage seems
to be more than "just bigger".
I'd call it unacceptable for a production system.


> =C2=A0=C2=A0Take a system using ext4, or XFS, or almost any other Linux=
=C2=A0
> filesystem, running almost any major distro, create a minimum sized=C2=A0
> partition on the disk for that filesystem type, and create a
> filesystem=C2=A0
> there with the same UUID as the root filesystem.=C2=A0=C2=A0Next time tha=
t
> system=C2=A0
> reboots, things will usually blow up (XFS will refuse to mount, ext4
> and=C2=A0
> most other filesystems will work sometimes and not others).
Well but that's something completely different.
It would be perfectly fine if, in case of an UUID collision, the system
simply denies mounting/assembly (actually that's one of the solutions
others and I've proposed in the aforementioned thread).

But it's not acceptable if the system does *something* in such
situation,... or if such fs/container is already mounted/active and
another device with colliding UUID appears *then*, it's neither
acceptable that the already active fs/container wouldn't continue to
work properly.

And that seems to my experience just how e.g. LVM handles this.

"Not booting" is not really an issue in terms of data corruption.


At least I'm pretty sure to remember that one of the main developers
(was it Qu?) acknowledged these issues (both in terms of accidental
corruption and security wise) and that he was glad that these issues
were brought up and that they should be solved.


> It hasn't, because there's not any way it can be completely
> fixed.
Why not? As it was laid out by myself and others, the basic solution
would be:
- Refuse any mounting in case UUID collisions are detected.
- Generally don't do any auto-rebuilds or e.g. RAID assemblies unless
=C2=A0 specifically allowed/configured by the user (as this might also be
=C2=A0 used to extract data from a system).
- If there are any collisions (either by mounting or by processes like
=C2=A0 rebuilds/added devices) require the user to specify uniquely which
=C2=A0 device he actually wants (e.g. by path).
- And in case a filesystem is already mounted and UUID collisions
=C2=A0 happens then (e.g. a dd clone get's plugged in), continue to use the
=C2=A0 already active device... just as e.g. LVM does.

> =C2=A0=C2=A0This=C2=A0
> particular case is an excellent example of why it's so hard to
> fix.=C2=A0=C2=A0To=C2=A0
> close this particular hole, BTRFS itself would have to become aware
> of=C2=A0
> whether whoever is running an ioctl is running in a chroot or not,
> which=C2=A0
> is non-trivial to determine to begin with, and even harder when you=C2=A0
> factor in the fact that chroot() is a VFS level thing, not a
> underlying=C2=A0
> filesystem thing, while ioctls are much lower level.
Isn't it simply enough to:
- know which blockdevices with a btrfs and with which UUIDs there are
- let userland tools deny any mount/assembly/etc. actions in case of
=C2=A0 collisions
- do the actual addressing of devices via the device path (so that
=C2=A0 proper devices will continued to be if the fs was already mounted
=C2=A0 when a collision occurs)
?

And further, as I've said, security wise auto-assembly of multi-device
seems always prone to attacks at least in certain use cases, so for the
security conscious people:
- Don't do auto-assembly/rebuild/etc. based on scanning for UUID
- Let the user choose to do this manually via specifying the devices
=C2=A0 (via e.g. path).
=C2=A0 So a user could say something like
=C2=A0 mount -t btrfs -o device=3D/dev/disk/by-path/pci-0000\:00\:1f.2-ata-=
1,device=3D/dev/disk/by-path/pci-0000\:00\:2f.2-ata-2 /foo
=C2=A0 in order to be sure that just these devices would be *tried* to be
=C2=A0 used for the RAID1 btrfs, and not the one an attacker might have
=C2=A0 plugged into the USB.


> That said, nobody's really done any work on mitigating the issues=C2=A0
> either, although David Sterba has commented about having interest in=C2=
=A0
> fixing issues caused by crafted filesystem images, so hopefully
> things=C2=A0will start moving more in the direction of proper security.
Well that's good do hear... it's IMO one of the bigger potential issues
in btrfs, next to the ongoing stability problems[0] and still not
really working RAID.

Anyone working on this should probably have a look at the thread I've
mentioned, cause there are really several tricky ways one could exploit
this... to me especially any auto-(i.e. based on scanning for UUIDs)-
assembly/rebuilding and that like seemed to pose quite a big surface.


Cheers,
Chris.


[0] Though I must say that I personally have never had any problems or
=C2=A0 =C2=A0 corruptions thus far, even in case of system crashes :)
--=-WxNeaEnGcT0osSaDjD2Q
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwOTA3MTgwODAwWjBPBgkqhkiG9w0BCQQxQgRAQHDi
xmCZJmYXU0+aUenppDndmI05gAK6MBf8l+8HJaF5Qm9RzYBbcUo3YMjqCElfygN/VMSJcot7ziye
cVF6vzCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAhH5r
Ix7hyyGG50zCJIlqIyQ4n9wSJi2bCO8lP4dg7Spgt7EHCJKGIFyJgbefvN2VgPyq6xIgaotiZGM4
J6Ke5jrvRjea9SRAHKVN27wqy93tIJuat6oH+TaeEVSBThF5DLa8t0AJ3uWvFQb9/6KaFtVcCbgm
2sZRDQAjWJMsGl8Zl9SzcKhgi0+ZZu0jCGoFWEBPuZ+79rRY8Gjvonq84F56vEbZJhJLAWw9jsN2
eElzukaD9Rh5DD4wqSptKsZDe3tpOvMNVKnlAMMBSMj6zpytKtEVS/hfv7hItb3C3y7NzjC1A1rs
BDrQxj0dRBFJDPbyl066P2OQRB0HAjJsWb8V9aBvSJ8fgcayQXiLgn/jA2ZgiPbrVce7cwh0tSFS
sFDt10BW2K2AuXkc00QtyVbmGv0xiG7QT7+EqtfNIAyCUPmxzut8mU5oYlonQ8lZSeHzNU7TGrNn
f3Bo0X9yM5ckNAzCgdQm9+xM3o86yNEinRCHoHdwxJkd28LW+YGqHHTaXyDxBpfr8FgTWE/EdFo3
jC4ThR4xbY4239bfEZGd/VJSXDApz118UpE/PaGsJO27eAbw3ZAhRTi0xqGbgqbfqZE/diedwh+Z
iPGzSsJ5Kp3YxeAeRfoCwIqocEFLxiGTt7jjGJoq4DyqetAVayfnrbcrF+hMdqOGJIZORw4AAAAA
AAA=


--=-WxNeaEnGcT0osSaDjD2Q--

