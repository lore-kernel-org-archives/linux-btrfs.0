Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:33121 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752216AbdHNTyw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 15:54:52 -0400
Message-ID: <1502740488.5384.5.camel@scientia.net>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Mon, 14 Aug 2017 21:54:48 +0200
In-Reply-To: <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
         <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
         <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
         <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
         <1502496618.6092.6.camel@scientia.net>
         <20170812074248.GA3352@infradead.org>
         <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
         <1502713484.3608.1.camel@scientia.net>
         <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
         <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
         <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-o2giHmy0L2cNwl0tjnj2"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-o2giHmy0L2cNwl0tjnj2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-08-14 at 11:53 -0400, Austin S. Hemmelgarn wrote:
> Quite a few applications actually _do_ have some degree of secondary=C2=
=A0
> verification or protection from a crash.=C2=A0=C2=A0Go look at almost any
> database=C2=A0
> software.
Then please give proper references for this!

This is from 2015, where you claimed this already and I looked up all
the bigger DBs and they either couldn't do it at all, didn't to it per
default, or it required application support (i.e. from the programs
using the DB)
https://www.spinics.net/lists/linux-btrfs/msg50258.html


> It usually will not have checksumming, but it will almost=C2=A0
> always have support for a journal, which is enough to cover the=C2=A0
> particular data loss scenario we're talking about (unexpected
> unclean=C2=A0
> shutdown).

I don't think we talk about this:
We talk about people wanting checksuming to notice e.g. silent data
corruption.

The crash case is only the corner case about what happens then if data
is written correctly but csums not.


> In my own experience, the things that use nodatacow fall into one of
> 4=C2=A0
> categories:
> 1. Cases where the data is non-critical, and data loss will be=C2=A0
> inconvenient but not fatal.=C2=A0=C2=A0Systemd journal files are a good e=
xample
> of=C2=A0
> this, as are web browser profiles when you're using profile sync.

I'd guess many people would want to have their log files valid and
complete. Same for their profiles (especially since people concerned
about their integrity might not want to have these synced to
Mozilla/Google etc.)


> 2. Cases where the upper level can reasonably be expected to have
> some=C2=A0
> degree of handling, even if it's not correction.=C2=A0=C2=A0VM disk image=
s and=C2=A0
> most database applications fall into this category.

No. Wrong. Or prove me that I'm wrong ;-)
And these two (VMs, DBs) are actually *the* main cases for nodatacow.


> And I and most other sysadmins I know would prefer the opposite with
> the=C2=A0
> addition of a secondary notification method.=C2=A0=C2=A0You can still hoo=
k the=C2=A0
> notification to stop the application, but you don't have to if you
> don't=C2=A0
> want to (and in cases 1 and 2 I listed above, you probably don't want
> to).

Then I guess btrfs is generally not the right thing for such people, as
in the CoW case it will also give them EIO on any corruptions and their
programs will fail.



Cheers,
Chris.
--=-o2giHmy0L2cNwl0tjnj2
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
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTcwODE0MTk1NDQ4WjBPBgkqhkiG9w0BCQQxQgRArz40
941j0VBSanVnAg6ytRhHTf+LP/7dKPRA3R0d0yncnEnbwJJOT/mpwcvazIxHY2GtShv1kivekVG+
8oa5wTCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIAjdBr
PTfbiao3ROOiSyMmIzUuYr7dpRDfrgRWgBbHLyIaMRjZTcOf2MLZx4bmLefWlwtQ09M9cJUkp8Vy
gH39S3FF1iQYBuULYoXUJ2PdZRxlRWEWClZlc3u0u61nLOGQMBQrYZK7s0QFNIObi4KTYXopnV9w
HF3vE5/iFiVVMnZ5c8yS7JJ8cR2R7ibtoFbI8512Jz+2ON6zM4zq38SdUytUST2/F7UWdpOhO7Ih
56EDEONY4QQYeakGEyIZEigkacAz2Hvgp/Pi1BBis01xIahs6eh+aWO1h56wlFjbRlzCh545VfcN
MGEC+8yT4jnr22MecbfftFwuMgimh3W1JSv2nXwVAH15MzL0K5a/bx9Sm0ifRvxmHzZjsNU4dmo6
axN8aaZIeO6iP0Jfj8IUn6hsu3OXHkuwF4+yUAyrnF85Zq9Jy5/Rzs1NTEoVWqtnqyfHxI7s3qTX
xU/Sc6REKyjoYeoaEtzPML8MxTHIwglXsAMOk7VHtPOgMJNFMoLP2507+GTM4ip4gG0U12tp+czz
UiINWx1fILxt6Nj1PDdw/SKKrJw1abbZgXVodlnAZUGIQtpyPaHQFOW5lbmlYTcvfEHEp/e9w/ap
/JPD71VjmOQMfdatrwsRn0JDEcynTD7/vGxLWaA5qtZmKwn3YZhi4pHmlxIPl+yQHeLBnCQAAAAA
AAA=


--=-o2giHmy0L2cNwl0tjnj2--

