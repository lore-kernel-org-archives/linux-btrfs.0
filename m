Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:40916 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbcISTpw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 15:45:52 -0400
Message-ID: <1474314346.10189.19.camel@scientia.net>
Subject: Re: stability matrix (was: Is stability a joke?)
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: dave@jikos.cz
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 19 Sep 2016 21:45:46 +0200
In-Reply-To: <20160919152753.GG933@twin.jikos.cz>
References: <57D51BF9.2010907@online.no>
         <20160912142714.GE16983@twin.jikos.cz>
         <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
         <20160912165107.GG16983@twin.jikos.cz>
         <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
         <20160915010759.GD32452@DigitalMercury.dynalias.net>
         <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
         <1473905644.8603.44.camel@scientia.net>
         <20160919152753.GG933@twin.jikos.cz>
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-Iv8mPfBZNhdBw6akD7ud"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-Iv8mPfBZNhdBw6akD7ud
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+1 for all your changes with the following comments in addition...


On Mon, 2016-09-19 at 17:27 +0200, David Sterba wrote:
> That's more like a usecase, thats out of the scope of the tabular
> overview. But we have an existing page UseCases that I'd like to
> transform to a more structured and complete overview of usceases of
> various features, so the UUID collisions would build on top of that
> with
> "and this could hapen if ...".
Well I don't agree here and see it basically like Austin.

It's not that these UUID collisions can only happen in special
circumstances but plain normal situations that always used to work with
probably literally each and every fs. (So much for the accidental
corruptions).

And an attack is probably never "usecase dependant"... it always
depends on the attacker.
And since that seems to be a pretty real attack vector, I'd also say
it's mandatory to quite clearly warn about that deficiency...

TBH, I'm rather surprised that this situation seems to be kinda
"accepted".

I had a chat with CM recently and he implied things might be solved
with encryption.
While this is probably the case for at least some of the described
problems, it rather seems like a workaround:
- why making btrfs-encryption mandatory for devices who have partially
=C2=A0 secured access (e.g. where a systemdisk with btrfs is not physically
=C2=A0 accessible but a USB port is)
- what about users that rather want to use block device encryption
=C2=A0 instead of fs-level-encryption?


> > - in-band dedupe
> > =C2=A0 deduped are IIRC not bitwise compared by the kernel before de-
> > duping,
> > =C2=A0 as it's the case with offline dedupe.
> > =C2=A0 Even if this is considered safe by the community... I think user=
s
> > =C2=A0 should be told.
> Only features merged are reflected. And the out-of-band dedupe does
> full
> memcpy. See btrfs_cmp_data() called from btrfs_extent_same().
Ah,... I kinda thought it was already merged ... possibly got confused
by the countless patch iterations of it ;)


> > - btrfs check --repair (and others?)
> > =C2=A0 Telling people that this may often cause more harm than good.
> I think userspace tools do not belong to the overview.
Well... I wouldn't mind if there was a btrfs-progs status page... (and
both link each other).
OTOH,... the user probably wants one central point where all relevant
info can be found... and not again having to dig through n websites.


> > - even mounting a fs ro, may cause it to be changed
>=20
> This would go to the UseCases
Fine for me.


>=20
> >=20
> > - DB/VM-image like IO patterns + nodatacow + (!)checksumming
> > =C2=A0 + (auto)defrag + snapshots
> > =C2=A0 a)
> > =C2=A0 People typically may have the impression:
> > =C2=A0 btrfs =3D checksummed =3D> als is guaranteed to be "valid" (or a=
t
> > least
> > =C2=A0 noticed)
> > =C2=A0 However this isn't the case for nodatacow'ed files, which in tur=
n
> > is
> > =C2=A0 kinda "mandatory" for DB/VM-image like IO patterns, cause
> > otherwise
> > =C2=A0 these would fragment to heavily (see (b).
> > =C2=A0 Unless claimed by some people, none of the major DBs or VM-image
> > =C2=A0 formats do general checksumming on their own, most even don't
> > support
> > =C2=A0 it, some that do wouldn't do it without app-support and few
> > "just"
> > =C2=A0 don't do it per default.
> > =C2=A0 Thus one should bump people to this situation and that they may
> > not
> > =C2=A0 get this "correctness" guarantee here.
> > =C2=A0 b)
> > =C2=A0 IIRC, it doesn't even help to simply not use nodatacow on such
> > files
> > =C2=A0 and using auto-defrag instead to countermeasure the fragmenting,
> > as
> > =C2=A0 that one doesn't perform too well on large files.
>=20
> Same.
Fine for me either... you already said above you would mention the
nodatacow=3D>no-checksumming=3D>no-verification-and-no-raid-repair in the
general section... this is enough for that place.


> > For specific features:
> > - Autodefrag
> > =C2=A0 - didn't that also cause reflinks to be broken up?
>=20
> No and never had.

Absolutely sure? One year ago, I was told that at first too so I
started using it, but later on some (IIRC) developer said auto-defrag
would also suffer from it.

> > - RAID*
> > =C2=A0 No userland tools for monitoring/etc.
>=20
> That's a usability bug.

Well it is and it will probably go away sooner or later... but the
unaware user may not really realise that he actually has to take care
on this by himself for now.
So I though it would be helpful to have it added.



Best wishes,
Chris.
--=-Iv8mPfBZNhdBw6akD7ud
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwOTE5MTk0NTQ2WjBPBgkqhkiG9w0BCQQxQgRASZFY
mE8zFLOSA9t4hr6Hwhxbo7yDLtnYjLSmloY6HPMxua1i8avUxJP0if365+t4VltmEceZE4AHKzOq
nuFq/TCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAcHtY
t1Tp31vk8ZFA5AWaqJGULAM4GyojzMX3ftKEmG1ms4zTkaQRx4q99CUt+0iqnKZmBIvFtV66vRRU
rr9VifF8cTo6lspAyqPxzhULAxMxddbqomPtiSJBmuFn9092HcYD0wA/ksNbQEotUzvHN6SUV77C
VFwYyPMX8ZdDZWDnqyUvrHob2gHko6rY+QNj9DH7SSBDgqZPbVpi30d5xYhbHmKdU8Xn0KfciGjs
AWy27r62t3/6LPxA5b3s/UAsJmkBFyOXQ0h9x2VsqPEVSpaVxTUqWS4iDDIPQrLMnqJW2Rzjn2X1
FCACYy7057PMDdvzIiMg8RjYonTm2yDodlqMpl1o6v6HjX9Lx2Ebjutqrq++4tzzRGU2xDgu5gET
U5j0adRExTKevZcn5co3ahtmwIm6T14RyUaP100Zl+IqURw27x3rkheLEWJx5OHbfgtznOr6uPwp
ptTVcFnBfVF+Y+YIrlaBLcwvPVbRi3JTYixDuzqne7o5Rg5K+yMjMzG3GTrRkctNSABgAdTzgURh
UlIpOVUM/iNUf7+4pwrpBGzwcfL0BHj9VQF++iI/ifgS4Et8h48RsLnUKiaq+mvljdL7QdWQn5rM
6oNc4dDs6r3BgIbVj9hzIECQHxQcHTz/fw4qOh+RHnto50rsXciUCsxDZZksHsQuUJsUZu8AAAAA
AAA=


--=-Iv8mPfBZNhdBw6akD7ud--

