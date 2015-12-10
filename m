Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33218 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbLJMIz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 07:08:55 -0500
Received: by iouu10 with SMTP id u10so91496594iou.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 04:08:54 -0800 (PST)
Subject: Re: attacking btrfs filesystems via UUID collisions?
To: "S.J." <sorry@anonym.com>, linux-btrfs@vger.kernel.org
References: <20151204120529.37E47D5A28@emkei.cz>
 <20151204130758.GR8775@carfax.org.uk>
 <1449286104.18841.14.camel@scientia.net>
 <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
 <1449366680.3183.37.camel@scientia.net> <56644785.4090702@gmx.com>
 <1449639588.7835.2.camel@scientia.net> <5668A1CB.1020007@anonym.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56696B53.7070905@gmail.com>
Date: Thu, 10 Dec 2015 07:08:51 -0500
MIME-Version: 1.0
In-Reply-To: <5668A1CB.1020007@anonym.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080702080007010206070807"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080702080007010206070807
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-12-09 16:48, S.J. wrote:
>> 1. better practices, we really need to tell users, and documentation
>> writers, that using dd (or variant) to copy Btrfs volumes has a
>> consequence and should not be used to make copies.
>=20
>> 2. Btrfs needs a better way to make a copy of a volume when there are
>> snapshots (including even rw snapshots); e.g. permit send/receive to
>> work on rw snapshots if the fs is ro mounted; e.g. a way to do
>> "recursive" send/receive.
>=20
>> 3. Some way to fail gracefully, when there's ambiguity that cannot be
>> resolved. Once there are duplicate devs (dd or lvm snapshots, etc)
>> then there's simply no way to resolve the ambiguity automatically, and=

>> the volume should just refuse to rw mount until the user resolves the
>> ambiguity. I think it's OK to fallback to ro mount (maybe) by default
>> in such a case rather than totally fail to mount.
>=20
> About 3:
> RO fallback for the second device/partitions is not good.
> It won't stop confusing the two partitions, and even if both are RO,
> thinking it's ok to read and then reading the wrong data is bad.
>=20
> About 1 and 2 ... if 3 gets fulfilled, why?
> DD itself is not a problem "if" the UUID is changed after it
> (which is a command as simple as dd), and if someone doesn't
> know that, he/she will notice when mount refuses to work
> because UUID duplicate.
Unless things have changed significantly, changing the UUID on a BTRFS
image is not anywhere near as simple as copying it with dd.  The UUID
gets used internally somehow, and changing it would require rewriting
_all_ the metadata blocks.



--------------ms080702080007010206070807
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjEwMTIwODUxWjBPBgkq
hkiG9w0BCQQxQgRASOpuOCADu3v5OKk09NFup+mAJvRKJB79YTLaA7JFMb4NoAgiwBzvSd1x
PH2X/jgURx1IrNsjhOYBuAFDJxYzpjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB2gna9koeyw8p3vLo/kqtdYfSeEG7+AHD/eMOC8e8gbRN/qnvq
Cg0hGasr46MMLXKuHmWD1WOuN9BlyMxWZ0vLV8Cbgur+8XURPtT/2Sr2zZnOTX83cPj3X4Kv
jkAFf1BiRmEl7/hn318e11HybYq4L38GLgHhz15Ri8U6P1IEZ3PjmIgZFQ8mNNGcTY8nbs4x
PuKeM4FJRv8+6TgKM9UkyBFltJoL1tNF1WEmErhSWlwO5DBhA6KOeOUpoHD1t4v9bML32fo/
3637cihT7S73wLWCoPB6jvOxlahWLYq5e067l//2SMzfMWhmwKv9KpEHTg+cJ7YL/mXrz7Lj
LmuYm2tjr/dh35/nOc0ifL87DuNfSl/MW+K5fRJXGQuJtPNxsLp2zKHdxTYlms0KQwPPebGU
YV/J0TyA74y3GmWyM+KvTJsFoJ9f5CyIQpNCFeqQ+TTXqpXEd6dQAO9rvky6F049Z8V/TcMs
JtmiToRcuUaPYxjlegytZyqK3CklxbgPx0g7ptEJk6HTfGVYIs+AF1dBYYvWhLPv5PK+ZxDX
xznSrtNGq2xfWFjn3aRuyYOoWjGHRh084jP5zBhmO49mCcnAUPMb0Kw4ydNtBBRLNrzla7Qd
J1e5KGN/dB3IYdWLqlUZjDz4Qcz2TfRQ3KlWfdzTdboVRTeRPEUp0zzrBwAAAAAAAA==
--------------ms080702080007010206070807--
