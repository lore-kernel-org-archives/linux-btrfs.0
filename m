Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:32818 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbbHQLia (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 07:38:30 -0400
Received: by igfj19 with SMTP id j19so54824259igf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2015 04:38:30 -0700 (PDT)
Subject: Re: The performance is not as expected when used several disks on
 raid0.
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
 <CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
 <55CE4682.3080106@gmail.com>
 <CAJCQCtTTgiuNA7+bqd31CG1OHeDiZ=TwQEnVbUF2jNU7qBRRnA@mail.gmail.com>
 <55CE4866.6060207@gmail.com> <pan$82931$bcf5ef1b$88d8d18$c8aa5770@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D1C7A5.7050204@gmail.com>
Date: Mon, 17 Aug 2015 07:38:13 -0400
MIME-Version: 1.0
In-Reply-To: <pan$82931$bcf5ef1b$88d8d18$c8aa5770@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080403090903060204060309"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080403090903060204060309
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-15 02:30, Duncan wrote:
> Austin S Hemmelgarn posted on Fri, 14 Aug 2015 15:58:30 -0400 as
> excerpted:
>
>> FWIW, running BTRFS on top of MDRAID actually works very well,
>> especially for BTRFS raid1 on top of MD-RAID0 (I get an almost 50%
>> performance increase for this usage over BTRFS raid10, although most o=
f
>> this is probably due to how btrfs dispatches I/O's to disks in
>> multi-disk stetups).
>
> Of course that's effectively a raid01, which is normally supposed to mo=
st
> often be a mistakenly reversed raid10 implementation, mistakenly, due t=
o
> the IO cost of the rebuild should a device fail, since the whole raid0 =
of
> the one raid1 side would have to be rereplicated to the other, vs only
> having to rereplicate one device to the other locally, in a raid10
> arrangement.
>
> However, in this case it's a very smart arrangement, actually, the only=

> md-raid-under-btrfs-raid arrangement that makes real sense (well, other=

> than raid00, raid0 at both levels, perhaps), in particular because the
> btrfs raid1 on top still gives you the full benefit of btrfs file
> integrity features as well as the usual raid1 redundancy, tho in this
> case it's only at the one raid0 against the other as the pair of btrfs
> raid1 copies.  And the mdraid0 is much better optimized than btrfs raid=
0,
> so there's that bonus, while at the same time the btrfs raid1 redundanc=
y
> nicely balances the usual "Russian Roulette" quality of raid0.
>
> Very nice configuration! =3D:^)
>
> Thanks for mentioning it, as I guess I was effectively ruling it out as=

> an option before even really considering it due to the usual raid10's
> better than raid01 thing, and thus was entirely blind to the
> possibility.  Which was bad, because as I alluded to, mdraid's lack of
> file integrity features and thus lack of any way to have btrfs scrub
> properly filter down to the mdraid level when there's mdraid level
> redundancy, kind of makes a mess of things, otherwise.  But btrfs raid1=

> on mdraid0 effectively balances and eliminates the negatives at each
> level with the strengths of the other level, and is really a quite
> awesome solution, that until now I was entirely blinded to! =3D:^)
>
I've also found that BTRFS raid5/6 on top of MD RAID0 mitigates (to a=20
certain extent that is) the performance penalty of doing raid5/6 if you=20
aren't on ridiculously fast storage, probably not something that should=20
be used in production yet, but it's how I've got the near-line backups=20
setup on my home server system.  It may also be worth pointing out that=20
BTRFS raid6 lets you use 4 disks minimum, as opposed to most other raid6 =

implementations that (unnecessarily, as a 4 disk RAID6 is not a=20
degenerate form) require 5.


--------------ms080403090903060204060309
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODE3MTEzODEzWjBPBgkq
hkiG9w0BCQQxQgRAgTpJ1vYZ73QElFJw1NCrL/q2Z6k6eerQMYDzOSKD6lbMuWAQjMszvOEx
CKA2bttanvYYWo6sXTNhpnB6rijwfTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBTc7U/OvmlUpAN/mnLs/xpVK0tsXg5nP+uyKcxIlTIV1Va/xK/
ix9gM23opY9ZrNV1iyQck0at84gQQlsarw2vtGCWWuxPyxXNofzasCROFxxBe75nFwL5FaLO
8ctUetx9avG8e8kULCKnwKazJo2cMuU5Idw7/MWFKF1Jcq2Cfn7LX3xk5JTs2xOzcYPwv78T
sy9xhbFfC5xdL1+RoqCwhvMSJcrF6tpPkaokyT/1eU382M+UC6/ejB25ATF7Riq93JDh6Gh/
8fC8STFIK98Cppb6krz6w9b4u8lQ/hpZDe9RVBRD1wbwu1qAVM1X3QbZrqQvqqBjTM81/hY+
J0CdyN+Gg4mzPlmAk0umyzqF27lJtK6qhHt+pmzp7I0H4QtTm4lctOuvn7HtWpi44ObAxbzw
9kNyvQtCfmfyyTT3W9X97OaTDzKVyuVNvIObIVB5jHd8SKn1njv/QxOtiZqXy+XzW7RN+mZv
9PQHueVp1cp1iSzVek46kq2xuUHbE5tSz/utqk4BmWoxFq1MD6OAVIfEm2AB0EE9INPcn70w
UJyvkapw0yyNFFlDgOAVYgGHfWag5kt46B/tplY1d0icuE3y7DOwue8DYC2jpMB0S1LYnVGC
jvr6r+KkBrLoyPpe5R0xm/qEYQgHLiRMNN1KDlkA+Kzn5n1/73g0pVrU6AAAAAAAAA==
--------------ms080403090903060204060309--
