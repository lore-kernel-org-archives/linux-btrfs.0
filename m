Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.3.12.4.46.clients.your-server.de ([46.4.12.3]:41634 "EHLO
	mx.mokrynskyi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755611AbcE0CDm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 22:03:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx.mokrynskyi.com (Postfix) with ESMTP id DC1B614866
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 01:57:17 +0000 (UTC)
Received: from mx.mokrynskyi.com ([127.0.0.1])
	by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id h2mSIZwHowW4 for <linux-btrfs@vger.kernel.org>;
	Fri, 27 May 2016 01:57:13 +0000 (UTC)
Received: from [192.168.1.167] (unknown [37.57.231.109])
	by mx.mokrynskyi.com (Postfix) with ESMTPSA id 0A0021485F
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 01:57:11 +0000 (UTC)
Subject: Re: Major HDD performance degradation on btrfs receive
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
 <72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
 <CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
 <ce805cd7-422c-ab6a-fbf8-18a304aa640d@mokrynskyi.com>
 <CAPmG0jbRmWeHvL4cUzhPBAfA=_Ue03uC-pLE4O-u5bzFF_kzEQ@mail.gmail.com>
 <5240211f-27b7-2c87-41e7-c10953374921@mokrynskyi.com>
 <CAPmG0jZwapQ1=V-dHMEEwMYQUjb4+1M102eo96XQeJQV1JoxeQ@mail.gmail.com>
 <1557fe0b-bbcc-c125-5220-46a56e936590@mokrynskyi.com>
 <pan$993a$3e6653ed$790f69a1$c396ece4@cox.net>
 <65fe3ba3-6400-3e39-7c49-4f295466cfb0@mokrynskyi.com>
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Message-ID: <581e72c4-cf60-7858-af42-8587fab3bd4c@mokrynskyi.com>
Date: Fri, 27 May 2016 04:57:11 +0300
MIME-Version: 1.0
In-Reply-To: <65fe3ba3-6400-3e39-7c49-4f295466cfb0@mokrynskyi.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050401090301010805090608"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050401090301010805090608
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I've being running newer version of just-backup-btrfs, which was configur=
ed to remove snapshots in batches ~ at least 3x100 at once (this is what =
I typically have in 1.5-2 days).

Snapshots transferring become much faster, however when I delete 300 snap=
shots at once, well... you can imagine what happens, but I can afford thi=
s on desktop.

Seekwatcher fails to run on my system with following error:

~> sudo seekwatcher -t find.trace -o find.png -p 'find /backup_hdd > /dev=
/null' -d /dev/sda1

Traceback (most recent call last):
  File "/usr/bin/seekwatcher", line 58, in <module>
    from seekwatcher import rundata
  File "numpy.pxd", line 43, in seekwatcher.rundata (seekwatcher/rundata.=
c:7885)
ValueError: numpy.dtype does not appear to be the correct type object

I have no idea what does it mean, but generally I think if seeking becaus=
e of fragmentation is a real cause of performance degradation, then this =
is something that BTRFS can improve, since I still have 65% of free space=
 on BTRFS partition that receives snapshots and fragmentation in this cas=
e seems weird.

P.S. I've unsubscribed from mailing list, cc me on answers, please.

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc
Skype: nazar-pc
Diaspora: nazarpc@diaspora.mokrynskyi.com
Tox: A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C8E=
F5261249

On 18.03.16 16:22, Nazar Mokrynskyi wrote:
>> But seriously, what are you doing that you can't lose more than 15
>> minutes of?  Couldn't it be even 20 minutes, or a half-hour or an hour=

>> with 15 minute snapshots only on the ssds (yes, I know the raid0 facto=
r,
>> but the question still applies)?
> This is artificial psychological limit. Sometimes when you're actively =
coding, it is quite sad to loose even 5 minutes of work, since productivi=
ty is not constant. This is why 15 minutes was chosen as something that i=
s not too critical. There is no other real reason behind this limit other=
 than how I feel it.
>
>> And perhaps more importantly for your data, btrfs is still considered
>> "stabilizing, not fully stable and mature".  Use without backups is
>> highly discouraged, but I'd suggest that btrfs in its current state mi=
ght
>> not be what you're looking for if you can't deal with loss of more tha=
n
>> 15 minutes worth of changes anyway.
>>
>> Be that as it may...
>>
>> Btrfs is definitely not yet optimized.  In many cases it reads or writ=
es
>> only one device at a time, for instance, even in RaidN configuration.
>> And there are definitely snapshot scaling issues altho at your newer 5=
00
>> snapshots total that shouldn't be /too/ bad.
> As an (relatively) early adopter I'm fine using experimental stuff with=
 extra safeties like backups (hey, I've used it even without those while =
back:)). I fully acknowledge what is current state of BTRFS and want to h=
elp make it even better by stressing issues that me and other users encou=
nter, searching for solutions, etc.
>
>> Dealing with reality, regardless of how or why, you currently have a
>> situation of intolerably slow receives that needs addressed.  From a
>> practical perspective you said an ssd for backups is ridiculous and I
>> can't disagree, but there's another "throw hardware at it" solution th=
at
>> might be a bit more reasonable...
>>
>> Spinning rust hard drives are cheap.  What about getting another one, =
and
>> alternating your backup receives between them?  That would halve the l=
oad
>> to one every thirty minutes, without changing your 15-minute snapshot =
and
>> backup policy at all. =3D:^)
>>
>> So that gives you two choices for halving the load to the spinning rus=
t.
>> Either decide you really can live with half-hour loss of data, or thro=
w
>> only a relatively small amount of money (well, as long as you have roo=
m
>> to plug in another sata device anyway, otherwise...) at it for a secon=
d
>> backup device, and alternate between them.
> Yes, I'm leaning toward earning new hardware right now, fortunately, la=
ptop allows me to insert 2 x mSATA + 2 x 2.5 SATA drives, so I have exact=
ly 2.5 SATA slot free.
>
>> OTOH, since you mentioned possible coding, optimization might not be a=

>> bad thing, if you're willing to put in the time necessary to get up to=

>> speed with the code and can work with the other devs in terms of timin=
g,
>> etc.  But that will definitely take significant time even if you do it=
,
>> and the alternating backup solution can be put to use as soon as you c=
an
>> get another device plugged in and setup. =3D:^)
> I'm not coding C/C++, so my capabilities to improve BTRFS itself are li=
mited, but I'm always trying to find the reason and fix it instead of liv=
ing with workarounds forever.
>
> I'll play with Seekwatcher and optimizing snapshots deletion and will p=
ost an update afterwards.
>
> Sincerely, Nazar Mokrynskyi
> github.com/nazar-pc
> Skype: nazar-pc
> Diaspora: nazarpc@diaspora.mokrynskyi.com
> Tox: A9D95C9AA5F7A3ED75D83D0292E22ACE84BA40E912185939414475AF28FD2B2A5C=
8EF5261249
>



--------------ms050401090301010805090608
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
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjA1MjcwMTU3MTFaMC8GCSqGSIb3
DQEJBDEiBCDRT4oNtGVG4bH1YP9QNPc/1kA+7YE2ljwpQo9b7sPoLDBsBgkqhkiG9w0BCQ8x
XzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwIC
AgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGaBgkrBgEEAYI3
EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNV
BAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENv
bSBDbGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTCBnAYLKoZIhvcNAQkQAgsx
gYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsT
IFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBD
bGFzcyAxIENsaWVudCBDQQIQZOr+k1bYeoai8pecbBX/jTANBgkqhkiG9w0BAQEFAASCAQBo
d/r7KA95gvK9RKHrTkf11jj7uo966eFjO+eog0jsTVuTb7x8oeVx6gOEVRtY3HotVuqphHg9
KWNsPv4zpyji60MhryDxz8JFGTge7MlxVXE7pfXGB3n83RCTA+m/r5ZDftPZfAGw6rl3+WPf
ezjq3xzerqFenbEs1+IUAmBTPrc3jZejw6FviVLCQb3Gexb00q6P/16Riz3ZDFVLfKLiHj5w
hNemxKMvF9oIOejT+Xo9hntEP52AK3c4cPqcnZIwqjSGz9JYD8499JY5oPsaRbRyIGrQLi0f
6E8jBy2c2Akz40G6ur9G9SU1QWyTOlI8Cmyy1ZAaC6cL8rG0WcKoAAAAAAAA
--------------ms050401090301010805090608--
