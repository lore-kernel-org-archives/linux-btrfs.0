Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:51330 "EHLO
	mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbcFEVcE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 17:32:04 -0400
Message-ID: <1465162317.6702.53.camel@scientia.net>
Subject: Re: btrfs
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Sun, 05 Jun 2016 23:31:57 +0200
In-Reply-To: <20160605210721.GH24492@carfax.org.uk>
References: <1464819934.6742.71.camel@scientia.net>	
 <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>	
 <1464975482.6679.11.camel@scientia.net>	
 <6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>	
 <1465005092.6648.39.camel@scientia.net>	
 <CAPmG0jZGY841PNwYi6gaun38gjN83=OMQB0r_UiVrdL9iY2J9Q@mail.gmail.com>	
 <1465160205.6702.38.camel@scientia.net>
	 <20160605210721.GH24492@carfax.org.uk>
Content-Type: multipart/signed; micalg="sha-512";
	protocol="application/x-pkcs7-signature";
	boundary="=-ugL4t+RXxoTSseJM4c/N"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-ugL4t+RXxoTSseJM4c/N
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2016-06-05 at 21:07 +0000, Hugo Mills wrote:
> =C2=A0=C2=A0=C2=A0The problem is that you can't guarantee consistency wit=
h
> nodatacow+checksums. If you have nodatacow, then data is overwritten,
> in place. If you do that, then you can't have a fully consistent
> checksum -- there are always race conditions between the checksum and
> the data being written (or the data and the checksum, depending on
> which way round you do it).

I'm not an expert in the btrfs internals... but I had a pretty long
discussion back then when I brought this up first, and everything that
came out of that - to my understanding - indicated, that it should be
simply possible.

a) nodatacow just means "no data cow", but not "no meta data cow".
=C2=A0 =C2=A0And isn't the checksumming data meda data? So AFAIU, this is i=
tself
=C2=A0 =C2=A0anyway COWed.
b) What you refer to above is, AFAIU, that data may be written (not
=C2=A0 =C2=A0COWed) and there is of course no guarantee that the written da=
ta
=C2=A0 =C2=A0matches the checksum (which may e.g. still be the old sum).
=C2=A0 =C2=A0=3D> So what?
=C2=A0 =C2=A0 =C2=A0 This anyway only happens in case of crash/etc. and in =
that case
=C2=A0 =C2=A0 =C2=A0 we anyway have no idea, whether the written not COWed =
block is
=C2=A0 =C2=A0 =C2=A0 consistent or not, whether we do checksumming or not.
=C2=A0 =C2=A0 =C2=A0 We rather get the benefit that we now know: it may be =
garbage
=C2=A0 =C2=A0 =C2=A0 The only "bad" thing that could happen was:
=C2=A0 =C2=A0 =C2=A0 the block is fully written and actually consistent, bu=
t the
=C2=A0 =C2=A0 =C2=A0 checksum hasn't been written yet - IMHO much less like=
ly than
=C2=A0 =C2=A0 =C2=A0 the other case(s). And I rather get one false positive=
 in an
=C2=A0 =C2=A0 =C2=A0 more unlikely case, than corrupted blocks in all other=
 possible
=C2=A0 =C2=A0 =C2=A0 situations (silent block errors, etc. pp.)
=C2=A0 =C2=A0 =C2=A0 And in principle, nothing would prevent a future btrfs=
 to get a
=C2=A0 =C2=A0 =C2=A0 journal for the nodatacow-ed writes.

Look for the past thread "dear developers, can we have notdatacow +
checksumming, plz?",... I think I wrote about much more cases there,
any why - even it may not be perfect as datacow+checksumming - it would
always still be better to have checksumming with nodatacow.

> > Wasn't it said, that autodefrag performs bad for anything larger
> > than
> > ~1G?
>=20
> =C2=A0=C2=A0=C2=A0I don't recall ever seeing someone saying that. Of cour=
se, I may
> have forgotten seeing it...
I think it was mentioned below this thread:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/50444/focus=3D50586
and also implied here:
http://article.gmane.org/gmane.comp.file-systems.btrfs/51399/match=3Dautode=
frag+large+files


> > Well the fragmentation has also many other consequences and not
> > just
> > seeks (assuming everyone would use SSDs, which is and probably
> > won't be
> > the case for quite a while).
> > Most obviously you get much more IOPS and btrfs itself will, AFAIU,
> > also suffer from some issues due to the fragmentation.
> =C2=A0=C2=A0=C2=A0This is a fundamental problem with all CoW filesystems.=
 There are
> some mititgations that can be put in place (true CoW rather than
> btrfs's redirect-on-write, like some databases do, where the original
> data is copied elsewhere before overwriting; cache aggressively and
> with knowledge of the CoW nature of the FS, like ZFS does), but they
> all have their drawbacks and pathological cases.
Sure... but defrag (if it would generally work) or notdatacow (if it
wouldn't make you loose the ability to determine whether you're
consistent or not) would be already quite helpful here.


Cheers,
Chris.
--=-ugL4t+RXxoTSseJM4c/N
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwNjA1MjEzMTU3WjBPBgkqhkiG9w0BCQQxQgRAaBq/
pmAje0WiTMSGA54OvTJtL0c3r0Amb7qEbyziRNOLkYXnI7FnMWtBPaRZu23rMTllhPLde226qA2Q
NwMomDCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAbr3E
mhLDoiNMtWYCbFafVsz0T5HbOh1WYg5r3ktq7LoJn6qNkM7lRZPIO2d0y9P+fiAogpZOIX0Q0oY4
CFzv6lB5G15CsRAFaaZfAq6yHm47CEoFNtP8Z/m8DBvaQMWQQgV9jVCYwFoR6wJOTXQygVrrbsp+
QkoWJhFqwBtEAHlWO0/Qh9PHC/dE93a9MjLtGh4u5v4bVkLxbmnb/ZRIv3dYNyRILl5RkjdaRIGA
pYDYRuQpaXH4KHcNPUtnarFvSGGZcyVmqOGq1CDuCV8KSgDgVmXc2tzZu9bRRPfRb3gLdFEDHSK6
cz5IumAMwCE0wkQsHPkCkwTNkNN/FZ7WCMBv5/wGaF5IM92MM3CQfsZEh/bh+Oj3+rBTLwgYuYNH
T7mjTWtXD1EIv8/Nhfqcen+sFUeDWCor0aF8d+HLqSvR0kXrL2CkQFPqb4Ty1CxjhhFUf8jlOonx
VS+bYGaIklJ5X4pCNfWMZRkgXuP5h7LFxpKIQgqdETPuLZrzeVC8TEgms+cRStlQT8lfCIcUuxLt
x5EDn5yO8t4+ZiVf2QRaJIRaPrpWYqF3kH16Y33qChu0S0PLShqSEoBcRYISFmmCsJwFH71HuELd
ENoJ83vZ9YPcH0gf0bAy2zRgwhXB09Y6ymB6A+Jj6lRN/pEUry3D708HXEp4ZijC5Fw9Y7EAAAAA
AAA=


--=-ugL4t+RXxoTSseJM4c/N--

