Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.3.12.4.46.clients.your-server.de ([46.4.12.3]:46532 "EHLO
	mx.mokrynskyi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752906AbcBWQzp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 11:55:45 -0500
Received: from localhost (localhost [127.0.0.1])
	by mx.mokrynskyi.com (Postfix) with ESMTP id 63B628365
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 16:55:44 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
	by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s7UBPpLJrS3B for <linux-btrfs@vger.kernel.org>;
	Tue, 23 Feb 2016 16:55:44 +0000 (UTC)
Received: from [192.168.1.167] (user-31-175-12-243.play-internet.pl [31.175.12.243])
	by mx.mokrynskyi.com (Postfix) with ESMTPSA id AB91274C8
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 16:55:42 +0000 (UTC)
Subject: Re: Major HDD performance degradation on btrfs receive
To: linux-btrfs@vger.kernel.org
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Message-ID: <04df0eaf-9dc8-b9fa-05cb-020507940bed@mokrynskyi.com>
Date: Tue, 23 Feb 2016 17:55:41 +0100
MIME-Version: 1.0
In-Reply-To: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060904000503080306090500"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060904000503080306090500
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

> > What is wrong with noatime,relatime? I'm using them for a long time a=
s
> > good compromise in terms of performance.
> The one option ends up canceling the other, as they're both atime relat=
ed
> options that say do different things.
>
> I'd have to actually setup a test or do some research to be sure which
> one overrides the other (but someone here probably can say without
> further research), tho I'd /guess/ the latter one overrides the earlier=

> one, which would effectively make them both pretty much useless, since
> relatime is the normal kernel default and thus doesn't need to be
> specified.
>
> Noatime is strongly recommended for btrfs, however, particularly with
> snapshots, as otherwise, the changes between snapshots can consist most=
ly
> of generally useless atime changes.
>
> (FWIW, after over a decade of using noatime here (I first used it on th=
e
> then new reiserfs, after finding a recommendation for it on that), I go=
t
> tired of specifying the option on nearly all my fstab entries, and now
> days carry a local kernel patch that changes the default to noatime,
> allowing me to drop specifying it everywhere.  I don't claim to be a
> coder, let alone a kernel level coder, but as a gentooer used to buildi=
ng
> from source for over a decade, I've found that I can often find the cod=
e
> behind some behavior I'd like to tweak, and given good enough comments,=
 I
> can often create trivial patches to accomplish that tweak, even if it's=

> not exactly the code a real C coder would choose to use, which is exact=
ly
> what I've done here.  So now, unless some other atime option is
> specified, my filesystems are all mounted noatime.  =3D:^)
Well, then I'll leave relatime on root fs and noatime on partition with=20
snapshots, thanks.

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc
Skype: nazar-pc
Diaspora: nazarpc@diaspora.mokrynskyi.com
Tox: A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8E=
F5261249



--------------ms060904000503080306090500
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: ÐÑÑÐ¿ÑÐ¾Ð³ÑÐ°ÑÑÑÐ½Ð¸Ð¹ Ð¿ÑÐ´Ð¿Ð¸Ñ S/MIME

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuMwggT5MIID4aADAgECAhBk6v6TVth6hqLyl5xsFf+NMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTUxMjIyMDYwNTUxWhcNMTYxMjIyMDYwNTUxWjBEMR0wGwYDVQQDDBRuYXph
ckBtb2tyeW5za3lpLmNvbTEjMCEGCSqGSIb3DQEJARYUbmF6YXJAbW9rcnluc2t5aS5jb20w
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCugsLCcazI+Sjl29kaCHer/z6I0aPy
cKYqk4Bk0jUE6CcfQLX98E8b1sc2kbBjwd+jPPvWtqSGHzLUKLL1jfXJC6X5At+UHNdWiU6n
xaKnCiWiV0NZK6AVfrr+KdP+f1gYfMryPp/JkzcRDquML+YSz0BJ3ODaU538lDtC2sPeH7hY
nTiuMBfL6h2c680MF9UrIUqvqJ94QEillrDShGxaMHIWZepLxydmACnI9Sga8dZPjG84hV//
JKGRmdlQ1fA7g0LUE2hZcY/zdB6Qey87ctNkND/bQfghbArOdJZK2/cal0xJ6znrPAyqs7wj
2HVz8/coOlXPPsV4OkoA9X1PAgMBAAGjggG0MIIBsDALBgNVHQ8EBAMCBLAwHQYDVR0lBBYw
FAYIKwYBBQUHAwIGCCsGAQUFBwMEMAkGA1UdEwQCMAAwHQYDVR0OBBYEFCfmAiR7cI5aUj1L
5j5v0+wVzVy1MB8GA1UdIwQYMBaAFCSBbDlhvkkPj7cbRivJKLUnSG1oMG8GCCsGAQUFBwEB
BGMwYTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDkGCCsGAQUFBzAC
hi1odHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9zY2EuY2xpZW50MS5jcnQwOAYDVR0f
BDEwLzAtoCugKYYnaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2NhLWNsaWVudDEuY3JsMB8G
A1UdEQQYMBaBFG5hemFyQG1va3J5bnNreWkuY29tMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBGBgNVHSAEPzA9MDsGCysGAQQBgbU3AQIEMCwwKgYIKwYBBQUHAgEW
Hmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0BAQsFAAOCAQEAkIZk
GJPfY91CrJnZzsF0+qviIsqRCWqdT64E5ttyODEvfo9TVccBvwTgVZzKJY2e+ALaDNX0dBH+
9YXMUg5pNfXGHauhQjGan8bdKsaLhvqaq3g0CO1oZU38pqizWTzQYbzu62414VeIDauHMbFD
pdRD0Egx/iY8R7JAO9k+hciD0W/L7FPRU7UTtz1vPqrKO54mYNFMn6EUhR2poM1j0dmwZH4W
Cly6N88RT6zhncbgDnjKr6+IHCxSP0E75uf+6kgbYRtwHnLydUIZdkEESlHhKdgJJFoL7nHr
PU3kWyAMrRdf2YtCwDa5USI5mE9v6sf0ynMrThlXbkb12Dz9wzCCBeIwggPKoAMCAQICEGun
in0K14jWUQr5WeTntOEwDQYJKoZIhvcNAQELBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTE1
MTIxNjAxMDAwNVoXDTMwMTIxNjAxMDAwNVowdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0
YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5
MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAL192vfDon2D9luC/dtbX64eG3XAtRmvmCSsu1d52DXsCR58zJQb
CtB2/A5uFqNxWacpXGGtTCRk9dEDBlmixEd8QiLkUfvHpJX/xKnmVkS6Iye8wUbYzMsDzgnp
azlPg19dnSqfhM+Cevdfa89VLnUztRr2cgmCfyO9Otrh7LJDPG+4D8ZnAqDtVB8MKYJL6QgK
yVhhaBc4y3bGWxKyXEtx7QIZZGxPwSkzK3WIN+VKNdkiwTubW5PIdopmykwvIjLPqbJK7yPw
FZYekKE015OsW6FV+s4DIM8UlVS8pkIsoGGJtMuWjLL4tq2hYQuuN0jhrxK1ljz50hH23gA9
cbMCAwEAAaOCAWQwggFgMA4GA1UdDwEB/wQEAwIBBjAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
KwYBBQUHAwQwEgYDVR0TAQH/BAgwBgEB/wIBADAyBgNVHR8EKzApMCegJaAjhiFodHRwOi8v
Y3JsLnN0YXJ0c3NsLmNvbS9zZnNjYS5jcmwwZgYIKwYBBQUHAQEEWjBYMCQGCCsGAQUFBzAB
hhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wMAYIKwYBBQUHMAKGJGh0dHA6Ly9haWEuc3Rh
cnRzc2wuY29tL2NlcnRzL2NhLmNydDAdBgNVHQ4EFgQUJIFsOWG+SQ+PtxtGK8kotSdIbWgw
HwYDVR0jBBgwFoAUTgvvGqRAW6UXaYcwyjRoQ9BBrvIwPwYDVR0gBDgwNjA0BgRVHSAAMCww
KgYIKwYBBQUHAgEWHmh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeTANBgkqhkiG9w0B
AQsFAAOCAgEAi+P3h+wBi4StDwECW5zhIycjBL008HACblIf26HY0JdOruKbrWDsXUsiI0j/
7Crft9S5oxvPiDtVqspBOB/y5uzSns1lZwh7sG96bYBZpcGzGxpFNjDmQbcM3yl3WFIRS4Wh
NrsOY14V7y2IrUGsvetsD+bjyOngCIVeC/GmsmtbuLOzJ606tEc9uRbhjTu/b0x2Fo+/e7Uk
QvKzNeo7OMhijixaULyINBfCBJb+e29bLafgu6JqjOUJ9eXXj20p6q/CW+uVrZiSW57+q5an
2P2i7hP85jQJcy5j4HzA0rSiF3YPhKGAWUxKPMAVGgcYoXzWydOvZ3UDsTDTagXpRDIKQLZo
02wrlxY6iMFqvlzsemVf1odhQJmi7Eh5TbxI40kDGcBOBHhwnaOumZhLP+SWJQnjpLpSlUOj
95uf1zo9oz9e0NgIJoz/tdfrBzez76xtDsK0KfUDHt1/q59BvDI7RX6gVr0fQoCyMczNzCTc
RXYHY0tq2J0oT+bsb6sH2b4WVWAiJKnSYaWDjdA70qHX4mq9MIjO/ZskmSY8wtAk24orAc0v
wXgYanqNsBX5Yv4sN4Z9VyrwMdLcusP7HJgRdAGKpkR2I9U4zEsNJQJewM7S4Jalo1DyPrLp
L2nTET8ZrSl5Utp1UeGp/2deoprGevfnxWB+vHNQiu85o6MxggPMMIIDyAIBATCBiTB1MQsw
CQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEpMCcGA1UECxMgU3RhcnRDb20g
Q2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0Q29tIENsYXNzIDEgQ2xp
ZW50IENBAhBk6v6TVth6hqLyl5xsFf+NMA0GCWCGSAFlAwQCAQUAoIICEzAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjAyMjMxNjU1NDFaMC8GCSqGSIb3
DQEJBDEiBCCyR9oUH+vjU8E7Gtuq/2VLeUAWMbOFcdcHjPsIkepvdzBsBgkqhkiG9w0BCQ8x
XzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwIC
AgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGaBgkrBgEEAYI3
EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNV
BAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENv
bSBDbGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTCBnAYLKoZIhvcNAQkQAgsx
gYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsT
IFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBD
bGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTANBgkqhkiG9w0BAQEFAASCAQCP
jrtfthRl/Ly2mbXIUwMYoCowm7C4wF9evaaIORzKv0x+13z57T389a/nRUZ9TBtOr6ciWCeP
Gj/bLrlHHJKUVIqjnCUZx71P20/FvQrszqrMrow+r2tFdZQ2Gl5iiCZuXSYM+We5BqWsdQyY
dK2m+RrDYE3sxi1fx+dgJ/51cQNFweIpr21fl/KL9NTMzKjn4lgf2IsWVPZwGxiBXsyT30L/
TKFbgJxyurvJLQ31HXfTnYcnUWx5Gjk3liExaS4bYSatu+KEjXMpxwiNqBxtHWVwrwGVRgNR
+M68ghkgd3xeFuf4a/hk+mMMVFmwgRuS7UohTidz8vWyB7W0fXFJAAAAAAAA
--------------ms060904000503080306090500--
