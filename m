Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-3.smtp-out.eu-west-1.amazonses.com ([54.240.4.3]:58346 "EHLO
        a4-3.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1762119AbdADAIQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 19:08:16 -0500
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Peter Becker <floyd.net@gmail.com>
References: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
 <0d0a4169-8c09-56c5-a052-0c894c46081c@gmail.com>
 <CAEtw4r2hU74Qfa_6X=y5hNQSq-yN9y=9wpAF7CjRgVP2p=ns-w@mail.gmail.com>
 <69d0539f-6cb4-644f-2e7e-16bb1575052e@mendix.com>
 <CAEtw4r1-WwLiK2trAWNJMwFRP2shOS+hemSNWMbKWAd-FBQrKw@mail.gmail.com>
 <624c67f5-6039-0332-fdea-19d6a80074ec@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <0102015966cdff9c-f5a50e4e-b8b7-45a1-9235-49f86aa11883-000000@eu-west-1.amazonses.com>
Date: Wed, 4 Jan 2017 00:08:13 +0000
MIME-Version: 1.0
In-Reply-To: <624c67f5-6039-0332-fdea-19d6a80074ec@mendix.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030105070506000301060408"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030105070506000301060408
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04.01.2017 00:43 Hans van Kranenburg wrote:
> On 01/04/2017 12:12 AM, Peter Becker wrote:
>> Good hint, this would be an option and i will try this.
>>
>> Regardless of this the curiosity has packed me and I will try to
>> figure out where the problem with the low transfer rate is.
>>
>> 2017-01-04 0:07 GMT+01:00 Hans van Kranenburg <hans.van.kranenburg@men=
dix.com>:
>>> On 01/03/2017 08:24 PM, Peter Becker wrote:
>>>> All invocations are justified, but not relevant in (offline) backup
>>>> and archive scenarios.
>>>>
>>>> For example you have multiple version of append-only log-files or
>>>> append-only db-files (each more then 100GB in size), like this:
>>>>
>>>>> Snapshot_01_01_2017
>>>> -> file1.log .. 201 GB
>>>>
>>>>> Snapshot_02_01_2017
>>>> -> file1.log .. 205 GB
>>>>
>>>>> Snapshot_03_01_2017
>>>> -> file1.log .. 221 GB
>>>>
>>>> The first 201 GB would be every time the same.
>>>> Files a copied at night from windows, linux or bsd systems and
>>>> snapshoted after copy.
>>> XY problem?
>>>
>>> Why not use rsync --inplace in combination with btrfs snapshots? Even=
 if
>>> the remote does not support rsync and you need to pull the full file
>>> first, you could again use rsync locally.
> <annoyed>please don't toppost</annoyed>
>
> Also, there is a rather huge difference in the two approaches, given th=
e
> way how btrfs works internally.
>
> Say, I have a subvolume with thousands of directories and millions of
> files with random data in it, and I want to have a second deduped copy
> of it.
>
> Approach 1:
>
> Create a full copy of everything (compare: retrieving remote file again=
)
> (now 200% of data storage is used), and after that do deduplication, so=

> that again only 100% of data storage is used.
>
> Approach 2:
>
> cp -av --reflink original/ copy/
>
> By doing this, you end up with the same as doing approach 1 if your
> deduper is the most ideal in the world (and the files are so random the=
y
> don't contain duplicate blocks inside them).
>
> Approach 3:
>
> btrfs sub snap original copy
>
> W00t, that was fast, and the only thing that happened was writing a few=

> 16kB metadata pages again. (1 for the toplevel tree page that got clone=
d
> into a new filesystem tree, and a few for the blocks one level lower to=

> add backreferences to the new root).
>
> So:
>
> The big difference in the end result between approach 1,2 and otoh 3 is=

> that while deduplicating your data, you're actually duplicating all you=
r
> metadata at the same time.
>
> In your situation, if possible doing an rsync --inplace from the remote=
,
> so that only changed appended data gets stored, and then useing native
> btrfs snapshotting it would seem the most effective.
>
Or use UrBackup as backup software. It uses the snapshot then modfiy
approach with btrfs, plus you get file level deduplication between
clients using reflinks.



--------------ms030105070506000301060408
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuQwggT6MIID4qADAgECAhBuZlYKQ9u25a8FBnl/zd+MMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTYwOTE5MTMxNzAyWhcNMTcwOTE5MTMxNzAyWjBCMRwwGgYDVQQDDBNtYXJ0
aW5AdXJiYWNrdXAub3JnMSIwIAYJKoZIhvcNAQkBFhNtYXJ0aW5AdXJiYWNrdXAub3JnMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw/FqcYQTj3z2wO8ASP8j0Jvb4AbMNgB9
iv2PLMtAMzYmuW7w2VfUcXwWgM4Fkg6Nm33VhOK+Vryd2bj+jGNhm+DmbMZCfki/NrhdcHKH
AT7i1NL1lps8X3xJ7N0eJpghht9Wx5OAUfGv18HDD3yBUzqW4x7OaGoKqM0DwyUm9O/rUU6D
ugxVONmgprREB1JyJBAV8lgYbY0EEUFS1JECuxNcJQEY+G8EpUNCsZxc8nvROyRD72Aztuy2
qQj4Rs+FzQNCplzmvXot7W0T2KAH9gKb25Q5Lv0sFQEux1stcJc6KKNea21UufblNMLApQ2Z
cSNWwDF5R+YpUFW8HiBOmwIDAQABo4IBtzCCAbMwDgYDVR0PAQH/BAQDAgSwMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDBDAJBgNVHRMEAjAAMB0GA1UdDgQWBBTKwa9D/4YV1XsZ
6affm7Wv4ykzdTAfBgNVHSMEGDAWgBQkgWw5Yb5JD4+3G0YrySi1J0htaDBvBggrBgEFBQcB
AQRjMGEwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbTA5BggrBgEFBQcw
AoYtaHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc2NhLmNsaWVudDEuY3J0MDgGA1Ud
HwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL3NjYS1jbGllbnQxLmNybDAe
BgNVHREEFzAVgRNtYXJ0aW5AdXJiYWNrdXAub3JnMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBHBgNVHSAEQDA+MDwGCysGAQQBgbU3AQIFMC0wKwYIKwYBBQUHAgEW
H2h0dHBzOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggEBADMT
EdZtz2a7sT3FDGszfzlAfmwVamtLbG5+O6NC5xc1n9AtWa7LdRPsQzgIROT/e84D+uTPAo1c
F6rEJ7oSqhgxJcAWgGN1G0KyEzSaFs+nLvfFN1LeaYQjElnmw87z6LGLvjOnfu01M0Atj+DR
DB3NyRoAn2/5yXHJKP7/mlUSXV/fiplcvP+TJbYJwrL7QDETySua89BU0oH3vtidOm8rlWzl
cZ4ug+kXzMMwjcwSIFb/P6LDZm3FMCNbg8sBt59+V5+Duk8y6aOcQ0GdGrIXMNs+oIKL5iQW
sP9+c55K9mJVl4+3J4sTcyT/L2EOXxEZY+zEhnJAds9dQJXkKfswggXiMIIDyqADAgECAhBr
p4p9CteI1lEK+Vnk57ThMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBT
aWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0x
NTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQC9fdr3w6J9g/Zbgv3bW1+uHht1wLUZr5gkrLtXedg17AkefMyU
GwrQdvwObhajcVmnKVxhrUwkZPXRAwZZosRHfEIi5FH7x6SV/8Sp5lZEuiMnvMFG2MzLA84J
6Ws5T4NfXZ0qn4TPgnr3X2vPVS51M7Ua9nIJgn8jvTra4eyyQzxvuA/GZwKg7VQfDCmCS+kI
CslYYWgXOMt2xlsSslxLce0CGWRsT8EpMyt1iDflSjXZIsE7m1uTyHaKZspMLyIyz6mySu8j
8BWWHpChNNeTrFuhVfrOAyDPFJVUvKZCLKBhibTLloyy+LatoWELrjdI4a8StZY8+dIR9t4A
PXGzAgMBAAGjggFkMIIBYDAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIG
CCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDov
L2NybC5zdGFydHNzbC5jb20vc2ZzY2EuY3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcw
AYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0
YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0OBBYEFCSBbDlhvkkPj7cbRivJKLUnSG1o
MB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7yMD8GA1UdIAQ4MDYwNAYEVR0gADAs
MCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcN
AQELBQADggIBAIvj94fsAYuErQ8BAluc4SMnIwS9NPBwAm5SH9uh2NCXTq7im61g7F1LIiNI
/+wq37fUuaMbz4g7VarKQTgf8ubs0p7NZWcIe7Bvem2AWaXBsxsaRTYw5kG3DN8pd1hSEUuF
oTa7DmNeFe8tiK1BrL3rbA/m48jp4AiFXgvxprJrW7izsyetOrRHPbkW4Y07v29MdhaPv3u1
JELyszXqOzjIYo4sWlC8iDQXwgSW/ntvWy2n4LuiaozlCfXl149tKeqvwlvrla2Yklue/quW
p9j9ou4T/OY0CXMuY+B8wNK0ohd2D4ShgFlMSjzAFRoHGKF81snTr2d1A7Ew02oF6UQyCkC2
aNNsK5cWOojBar5c7HplX9aHYUCZouxIeU28SONJAxnATgR4cJ2jrpmYSz/kliUJ46S6UpVD
o/ebn9c6PaM/XtDYCCaM/7XX6wc3s++sbQ7CtCn1Ax7df6ufQbwyO0V+oFa9H0KAsjHMzcwk
3EV2B2NLatidKE/m7G+rB9m+FlVgIiSp0mGlg43QO9Kh1+JqvTCIzv2bJJkmPMLQJNuKKwHN
L8F4GGp6jbAV+WL+LDeGfVcq8DHS3LrD+xyYEXQBiqZEdiPVOMxLDSUCXsDO0uCWpaNQ8j6y
6S9p0xE/Ga0peVLadVHhqf9nXqKaxnr358VgfrxzUIrvOaOjMYIDzDCCA8gCAQEwgYkwdTEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29t
IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENs
aWVudCBDQQIQbmZWCkPbtuWvBQZ5f83fjDANBglghkgBZQMEAgEFAKCCAhMwGAYJKoZIhvcN
AQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTcwMTA0MDAwODEyWjAvBgkqhkiG
9w0BCQQxIgQgkZde22mqAuyjmETIh4K0q3XmuN7GDqrKHw8ttS0UyDAwbAYJKoZIhvcNAQkP
MV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMC
AgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBmgYJKwYBBAGC
NxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRD
b20gQ2xhc3MgMSBDbGllbnQgQ0ECEG5mVgpD27blrwUGeX/N34wwgZwGCyqGSIb3DQEJEAIL
MYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQL
EyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMSBDbGllbnQgQ0ECEG5mVgpD27blrwUGeX/N34wwDQYJKoZIhvcNAQEBBQAEggEA
OHqmPhn90OyGdgR7qG7RqRcr10v4/yirxEoUrl1MdTcQkQvCN8InUxxQyuTpzR+ODe2GpCUo
N5LQmInHl0RejdHpKplletpVC+slP6Yvn9BPoAyLl6N7enHNZpIoXMeBgtGN1ebbHFO+TFYW
sCMd36LVG+XXOL3Z1cI8rjKLnd6Do51ANGz5gAObo9WLIxRFGEY0nQOxoX7SupeaxYRBrzeD
XC15NP4BUXQzub9jGRmbq8wCiY+Rhc7UA02v/XPEe4ktMjdOOYFMi9IMSQQfOBB43ZNuMlGK
7C2tmJ/z3GxD5XgRU78AzjtxNM7JapckVBfx32R+aERSEDA0vLjHPwAAAAAAAA==
--------------ms030105070506000301060408--
