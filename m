Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35382 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbbLHU3e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 15:29:34 -0500
Received: by ioc74 with SMTP id 74so36665798ioc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 12:29:33 -0800 (PST)
Subject: Re: [PATCH] btrfs: Introduce new mount option to disable tree log
 replay
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Eric Sandeen <sandeen@redhat.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <1449468402-27914-1-git-send-email-quwenruo@cn.fujitsu.com>
 <5665B359.2050906@redhat.com> <2856934.1tulUexfpA@localhost.localdomain>
 <5665C1F2.8020407@redhat.com> <1449521684.6881.13.camel@scientia.net>
 <566610FA.1080408@redhat.com> <5666C9F7.2030509@gmail.com>
 <1449602402.6649.6.camel@scientia.net>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56673DA5.9030607@gmail.com>
Date: Tue, 8 Dec 2015 15:29:25 -0500
MIME-Version: 1.0
In-Reply-To: <1449602402.6649.6.camel@scientia.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060508040003060304020307"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060508040003060304020307
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-08 14:20, Christoph Anton Mitterer wrote:
> On Tue, 2015-12-08 at 07:15 -0500, Austin S Hemmelgarn wrote:
>> Despite this, it really isn't a widely known or well documented
>> behavior
>> outside of developers, forensic specialists, and people who have had
>> to
>> deal with the implications it has on data recovery.  There really
>> isn't
>> any way that the user would know about it without being explicitly
>> told,
>> and it's something that can have a serious impact on being able to
>> recover a broken filesystem.  TBH, I really feel that _every_
>> filesystem's documentation should have something about how to make it
>> mount truly read-only, even if it's just a reference to how to mark
>> the
>> block device read-only.
> Exactly what I've meant.
>
> And the developers here, should definitely consider that every normal
> end-user, may easily assume the role of e.g. a forensics specialist
> (especially with btrfs ;-) ), when recovery in case of corruptions is
> tried.
>
>
> I don't think that "it has always been improperly documented" (i.e. the=

> "ro" option) is a good excuse to continue doing it that way =3D)
Agreed, 'but it's always been that way' is never a valid argument, and=20
the fact that people who have been working on UNIX for decades know it=20
doesn't mean that it's something that people will just inherently know.=20
  The only reason it was that way to begin with is because it was=20
assumed that everyone dealing with computers had a huge amount of domain =

specific knowledge of them (this was a valid assumption back in 1970, it =

hasn't been a valid assumption since at least 1990).

Stuff that seems obvious to people who have been working on it for years =

isn't necessarily obvious to people who have limited experience with it=20
(I recently had to explain to a friend who had almost no networking=20
background how IP addresses are just an abstraction for MAC addresses,=20
and how it's not possible to block WiFi access based on an IP address;=20
it took me three tries and eventually making the analogy of street=20
addresses being an abstraction for geographical coordinates before he=20
finally got it).

TBH, the only reason I knew about this rather annoying detail of=20
filesystem implementation before using BTRFS is because of dealing with=20
shared storage on VM's (that was an interesting week of debugging and=20
restoring backups before I finally figured out what was going on).



--------------ms060508040003060304020307
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA4MjAyOTI1WjBPBgkq
hkiG9w0BCQQxQgRAP2JTsj+MGSt14hhc6R78pyNPwSoadW3TvOOjc7BYV8Ztq1s1Pb/SACWV
cO7CHqWZz6j/KymJlhFFGft1jo6fiTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBTynTmQsHA0WVv04LMzztdxyhEAWdE3RIdhlc6A7d/LYUct48x
P5wj0Yym5iLLpWeTlpPu5fHDL9zyqBZ9/HzmHurFvfoVMMxm2GYEIeSTN8DXba/PHEzDmEe2
fOHhaoOSQCJXjSPyXzBvlqQxqk9EzvTViRaJKln7fjb/i2yRMP0APqv/KfZr6jtdX83qWvPw
+EyzKQGRgLzWNFYCGWE0jzX8TSbYKakirsM3ZuQQEn/AYmnFeXQOtABYOEhAmNL/EftyfNh1
A5o8kmQpk4ofYDME/ZI8Wa2E9Vwezzpwq6DpocBBUBvsLvpdPprwGJ+nDMWXLmNDF6qOrYtd
f4sUlkPpVPl30qM8leV8pt79bkH1qoEwXscpwfjA00SY1G6ax7GzwL+5HJ7gmf56jNQ9FR6c
QvbkhlkuVMmj9TDVSKle/I35EzjyKhsUnpH/FJOW1lqA/27BGG/G4m++zW2oceuxCQ0tcCBu
n/AFlE3REG9G5iYvVWKzGMtM+mo26omN2PZXWQHYGFrADkpeXEELDKbEIjdzdKgQTUn5/oKP
ct455SJ27aSEojRpWvXw8xiPYGBGIb5mV2xMyL86wZQJ7xEJQ0fGa9h+9JDf6RcM7//AMVLN
L80MbWh33ZrqrVHOkZUMAHBigUVTr8BI9Y8Rf/V9/AhmfbwFrYuUB0mfTgAAAAAAAA==
--------------ms060508040003060304020307--
