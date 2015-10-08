Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36777 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbbJHL1J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 07:27:09 -0400
Received: by ioii196 with SMTP id i196so53828691ioi.3
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2015 04:27:09 -0700 (PDT)
Subject: Re: Using BtrFS and backup tools for keeping two systems in sync
To: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAH-HCWV2mO1FFRGPh+jh2TrZMYV-7w7MwytSV4WZ33-9PW=qRw@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <561652D3.1020606@gmail.com>
Date: Thu, 8 Oct 2015 07:26:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAH-HCWV2mO1FFRGPh+jh2TrZMYV-7w7MwytSV4WZ33-9PW=qRw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000200050601080808060300"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000200050601080808060300
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-07 22:35, Shriramana Sharma wrote:
> Hello. I see there are some backup tools taking advantage of BtrFS's
> incremental send/receive feature:
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup. [BTW Ames
> Cornish's ButterSink (https://github.com/AmesCornish/buttersink) seems
> to be missing from that page.]
>
> Now I'd like to know if anyone has evolved some good practices w.r.t
> maintaining the data of two systems in sync using this feature of
> BtrFS. What I have in mind is: I work on my desktop by default, and
> for ergonomics reasons only use my laptop when I need the mobility.
> I'd like to keep the main data (documents I create, programs I write
> etc) in sync between the two. (The profile data such as in the ~/.*
> hidden folders had better stay separate though, I guess.)
>
> I figure with the existing tools it would not be too difficult to
> maintain a synced set of snapshots between the two systems if I only
> use the desktop vs laptop alternatingly and sync at each switchover,
> but the potential problem only would come if I modify both (something
> like having to do git merge, I guess).
>
> Has anyone come across this situation and evolved any policies to handl=
e it?
>
Personally, while I use BTRFS on all of my systems, I usually use=20
Dropbox for synchronizing data between them.  While the Linux client for =

it isn't perfect, it is significantly easier than something like a=20
regularly scheduled rsync or btrfs send/receive.  It's also kind of nice =

because multiple clients bound to the same account will sync across the=20
local network without needing to talk to the servers if they can avoid=20
it.  Of course, it costs money if you want a decent amount of storage=20
space, but it's pretty reasonable for the degree of reliability I've=20
observed.


--------------ms000200050601080808060300
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDA4MTEyNjExWjBPBgkq
hkiG9w0BCQQxQgRAMMRQ9HmSq/9TkX9KNTxHR+jGSwfqO7o6x6K6vyr/jGKTNVSXQIsnB8Iz
eGrO7zvl9Ah0jQszKl3i6OUaeDRyCTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCKD4ESGsPTYWNRGC9567YBTQotQZ3PCp3tQ2FlJamqViHAxvkn
Pm4G1niIH+T4Y5s3pwihv0MisCWKUzjyzH05U5Mkl3Sr+oTAYu53+6lhHfmmVvGMcX4cdx1s
GVL5dsrkSooBe7Qpj0xbuYu+y2M/EPdI23+i0vzLJR9XJo5kwo+g6MP6mSqnJmsb+OtGARCU
x2Imaxnidylyinxo1q/Bp8+g2jIwvXBReDtEQaIsEqugnEaBqLaf3XQqzakyUjc6BNgzL875
C0sq74BDtmgCeyl44m9LCoKRO7lHjTFZuMJ8Gq1bopEkz7od6877idrMmyJGNpgsxusHhQSz
TfNCP7vuyhtpSLlgzU3fSjJf/B+hM/xoO4rdB/QCP++n1ZEAaWa76NWFhzz4YJvIbMIug+ad
KDY/r5h+xa7zPXnvYIuTLaEoa6yZ+tshfXOYAp9NXpHqjTiwu/oRMq4RAHb6en8cCcSdqHMP
fTG7i4dlv9EJIe0OB21r/hmTvjo5e4E143NBZ0nH9aYZFvxd3+WDe39TtwYErUakSK1lF+w/
lddEAxtTL5lnEcGHBccoyTILMIOBLw2WZHggT1reUqTqDCnotuQ7H4qLCkVZumkcCz9yZEIi
Dmkg67weHRKixT0Fr8iFgaJV6a5lZal+jPNB3iusNLvzXDbwKkTIhJ7FFwAAAAAAAA==
--------------ms000200050601080808060300--
