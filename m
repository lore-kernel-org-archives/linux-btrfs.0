Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:49946 "EHLO
	mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbcFEUbi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 16:31:38 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
	by mailgw-01.dd24.net (Postfix) with ESMTP id 791A95FBB2
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jun 2016 20:31:35 +0000 (UTC)
Received: from mailgw-01.dd24.net ([192.168.1.35])
	by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
	with ESMTP id g20P_fX97-_c for <linux-btrfs@vger.kernel.org>;
	Sun,  5 Jun 2016 20:31:33 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-46-244-202-98.dynamic.mnet-online.de [46.244.202.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mailgw-01.dd24.net (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jun 2016 20:31:33 +0000 (UTC)
Message-ID: <1465158692.6702.21.camel@scientia.net>
Subject: Re: RAID1 vs RAID10 and best way to set up 6 disks
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Sun, 05 Jun 2016 22:31:32 +0200
In-Reply-To: <CAJCQCtSLsA5RfPG1Q2m99DHmYCp3EAXkTnZxBbfX8usLvFbgCw@mail.gmail.com>
References: <1464977432.1571.20.camel@gmail.com>	
	<1464977591.6679.13.camel@scientia.net>	
	<1464979359.1571.25.camel@gmail.com>	
	<1464980373.6679.28.camel@scientia.net>	
	<89aaee85-9ad5-9bde-b4fb-6c4758e8fd34@swiftspirit.co.za>	
	<1465089045.6662.19.camel@scientia.net>
	 <CAJCQCtSLsA5RfPG1Q2m99DHmYCp3EAXkTnZxBbfX8usLvFbgCw@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-wWSVX3qaV+hOrOSVSXlj"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-wWSVX3qaV+hOrOSVSXlj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2016-06-05 at 09:36 -0600, Chris Murphy wrote:
> That's ridiculous. It isn't incorrect to refer to only 2 copies as
> raid1.
No, if there are only two devices then not.
But obviously we're talking about how btrfs does RAID1, in which even
with n>2 devices there are only 2 copies - that's incorrect.


>  You have to explicitly ask both mdadm
Aha, and which option would that be?

>  and lvcreate for the
> number of copies you want, it doesn't automatically happen.
I've said that before, but at least it allows you to use the full
number of disks, so we're again back to that it's closer to the
original and common meaning of RAID1 than what btrfs does.


>  The man
> page for mkfs.btrfs is very clear you only get two copies.

I haven't denied that... but one shouldn't use terms that are commonly
understood in a different mannor and require people to read all the
small printed.
One could also have changed it's RAID0 with RAID1, and I guess people
wouldn't be too delighted if the excuse was "well it's in the manpage".


>=20
> > Well I'd say, for btrfs: do away with the term "RAID" at all, use
> > e.g.:
> >=20
> > linear =3D just a bunch of devices put together, no striping
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0basically what MD=
's linear is
> Except this isn't really how Btrfs single works. The difference
> between mdadm linear and Btrfs single is more different in behavior
> than the difference between mdadm raid1 and btrfs raid1. So you're
> proposing tolerating a bigger difference, while criticizing a smaller
> one. *shrug*

What's the big difference? Would you care to explain? But I'm happy
with "single" either, it just doesn't really tell that there is no
striping, I mean "single" points more towards "we have no resilience
but only 1 copy", whether this is striped or not.



> If a metaphor is going to be used for a technical thing, it would be
> mirrors or mirroring. Mirror would mean exactly two (the original and
> the mirror). See lvcreate --mirrors. Also, the lvm mirror segment
> type
> is legacy, having been replaced with raid1 (man lvcreate uses the
> term
> raid1, not RAID1 or RAID-1). So I'm not a big fan of this term.

Admittedly, I didn't like the "mirror(s)" either... I was just trying
to show that different names could be used that are already a bit
better.


> > striped =3D basically what RAID0 is
>=20
> lvcreate uses only striped, not raid0. mdadm uses only RAID0, not
> striped. Since striping is also employed with RAIDs 4, 5, 6, 7, it
> seems ambiguous even though without further qualification whether
> parity exists, it's considered to mean non-parity striping. The
> ambiguity is probably less of a problem than the contradiction that
> is
> RAID0.

Mhh,.. well or one makes schema names that contain all possible
properties of a "RAID", something like:
replicasN-parityN-[not]striped

SINGLE would be something like "replicas1-parity0-notstriped".
RAID5 would be something like "replicas0-parity1-striped".


> > And just mention in the manpage, which of these names comes closest
> > to
> > what people understand by RAID level i.
>=20
> It already does this. What version of btrfs-progs are you basing your
> criticism on that there's some inconsistency, deficiency, or
> ambiguity
> when it comes to these raid levels?

Well first, the terminology thing is the least serious issue from my
original list ;-) ... TBH I don't know why such a large discussion came
out of that point.

Even though I'm not reading along all mails here, we have probably at
least every month someone who wasn't aware that RAID1 is not what he
assumes it to be.
And I don't think these people can be blamed for not RTFM, because IMHO
this is a term commonly understood as mirror all available devices.
That's how the original paper describes it, it's how Wikipedia
describes it and all other sources I've ever read to the topic.


>  The one that's unequivocally
> problematic alone without reading the man page is raid10. The
> historic
> understanding is that it's a stripe of mirrors, and this suggests you
> can lose a mirror of each stripe i.e. multiple disks and not lose
> data, which is not true for Btrfs raid10. But the man page makes that
> clear, you have 2 copies for redundancy, that's it.
Yes, same basic problem.


> On the CLI? Not worth it. If the user is that ignorant, too bad, use
> a
> GUI program to help build the storage stack from scratch. I'm really
> not sympathetic if a user creates a raid1 from two partitions of the
> same block device anymore than if it's ultimately the same physical
> device managed by a device mapper variant.

Well one I have no strong opinion on that... if testing for it (or at
least simple cases) would be easy, why not.
Not every situation may be as easily visible as creating a RAID1 on
/dev/sda1 and /dev/sda2.
One may use LABELs, or UUIDs and accidentally catch the wrong, and in
such cases a check may help.


Cheers,
Chris.
--=-wWSVX3qaV+hOrOSVSXlj
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwNjA1MjAzMTMyWjBPBgkqhkiG9w0BCQQxQgRAsKo1
hzu8e1dky1qmeK5smxneZyRUk4GreWFHRxEdgrmP/hCkm0n/VNf5gEK077mUrj/wwsGbWpzTBRPm
+GXfdzCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAGUnF
LCbKvY/mivA6OLr0yEYLD9yEMLU5bNwJNA/5ruxV47LhL5HdGK+FPfGfcO2VG2lXY/zvZf2o7QOF
o0lJSDCJC/nrdayGtjvfOUuvj5yI9nAXsZ4exoeDrImWuR6Boog0pZ1CSRA8VDgKKqxBX/2U94Vm
9RwkSIsUO+E8wIOZDmKG03ht9ueq2YQ5jmom9iKlQqFN+rhp9kOyi+JNpjhyJmQ4lhG5F0nhcpgG
iQeZFHKlQefurZajiM9iSLeOEr9bNW8eiIfM53x+qdh8yFKjJ9KHz2rnegcbZ5+R0hNYrbeO6vb8
jrk1UeQvlAACUVk0fs3vrepqpVKuo5rRWbp81uLhRQRpBkd5TGnrP5Thg5BF3tqIa/aH74b8TDEo
CaFyCpA4p6ZuCT/0jrSwyYdWsyUv+ujwELw6XuhgUxySBrwoXKRPzi4L7fmUIxJ2YN1d7l+DaWz+
B4QCuagu12EY+DcTYCHDIP/GSwXnmfshTlkbT1IJiUqsXopq9aw5W04xOaVzjy4+w1IPUqadTz4T
pkxzoN5/jnxnS5k4s54ekN2NsmsaRObLzuG/0DEg4v9tUtJMEhLfc5o47pTgyZzRLR3wjGJDH3Ks
Dsj4jPdGI7QfAAKRl7jKtUzEb5BbP9fT1e2XOw7SstPU2Z8nkOpFJbBiHEVPWebGMkGEmGIAAAAA
AAA=


--=-wWSVX3qaV+hOrOSVSXlj--

