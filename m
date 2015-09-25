Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33990 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbbIYNF2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 09:05:28 -0400
Received: by iofb144 with SMTP id b144so110012023iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 06:05:27 -0700 (PDT)
Subject: Re: BTRFS as image store for KVM?
To: Rich Freeman <r-btrfs@thefreemanclan.net>, Jim Salter <jim@jrs-s.net>
References: <55F88ECC.1040604@menke.ac> <55FE0B42.50300@jrs-s.net>
 <CAGfcS_=bst0S8YLsr6y4oGDu7Gy-ox9ow5+_nD4c3zFdj-Y6ug@mail.gmail.com>
Cc: Gert Menke <gert@menke.ac>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56054665.1020608@gmail.com>
Date: Fri, 25 Sep 2015 09:04:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAGfcS_=bst0S8YLsr6y4oGDu7Gy-ox9ow5+_nD4c3zFdj-Y6ug@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050308070406020807090306"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050308070406020807090306
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-25 08:48, Rich Freeman wrote:
> On Sat, Sep 19, 2015 at 9:26 PM, Jim Salter <jim@jrs-s.net> wrote:
>>
>> ZFS, by contrast, works like absolute gangbusters for KVM image storag=
e.
>
> I'd be interested in what allows ZFS to handle KVM image storage well,
> and whether this could be implemented in btrfs.  I'd think that the
> fragmentation issues would potentially apply to any COW filesystem,
> and if ZFS has a solution for this then it would probably benefit
> btrfs to implement the same solution, and not just for VM images.
That may be tough to do however, the internal design of ZFS is _very_=20
different from that of BTRFS (and for that matter, every other=20
filesystem on Linux).  Part of it may just be better data locality (if=20
all of the fragments of a file are close to each other, then the=20
fragmentation of the file is not as much of a performance hit), and part =

of it is probably how they do caching (and I personally _do not_ want=20
BTRFS to try to do caching the way ZFS does, we have a unified pagecache =

in the VFS for a reason, we should be improving that, not trying to come =

up with multiple independent solutions).


Even aside from that however, just saying that ZFS works great for some=20
particular use case isn't giving enough info, it has so many optional=20
features and configuration knobs, you really need to give specifics on=20
how you have ZFS set up in that case.


--------------ms050308070406020807090306
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTI1MTMwNDM3WjBPBgkq
hkiG9w0BCQQxQgRAfBW6dcDT2ZjokPz9SPmzNcHC4MvInHk2S7tQ6RIWTFpUDzMQqLlHTP7P
Hsj7wr6aCD/FwWJY+pibqB6g/OkpWjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB40Qg56MuuUhT6yQS+g93+VR9eN6kctZsKG21fmCxF4m9fPDxy
7xZoqjRBE/dOmiQOKloSVXbpCO0r4AXnq0Yr880YSDRrt85EhtPDi+JZEyJ6ROZ4vjjof5YS
LkNyohgL1Rom3unfP+Gs7WXuT1S9gSWBteRrIFGtQGvamwetXvj9fD8gVHIhIU6gGjDUcnLq
JNv4gw8wLa+Atqp7mLs+52Il+rCvLKrAzCvtQbpfuSdMKbUH+/TKLBzDqvHk+ZXWy6VxVoij
e1oNzm1MRZ8cOcd/xylhK2UjONWzcfdFtRaYb18Q/M8Yo8dlV+lwoXNZwlkIA89FU25xdwHe
QLE4B7LHY/WaFqoyRB/WF53ZeJ1jb7GbCT7GyXBI2hqEuejW2D6zTsYgFEnVjQVe89vsUb9R
sTa25kA7Cao4Yl8zQJpeZHT4sp1GrIMpsIhRwiCP4TmmjfR7avSt+PvaboX+FnoJMjP32Ohj
4yTB+sVDWZO0puiwSTp+ZiUMpiXxIU5RaAVnc6rkFOjxkhDyUqofjB/wncI7u9t94RX54G38
NwjWtTzvSTXZJ2+TbSS4SHtK+DqZcrn2TH6xjjxyVyTAI0aWB2W6n6JJNlPyvfuo9zLfejpN
Wvx4Pco9AibCVauzp8cy0nBL6D+uZnUh8H1+uFws1GxG3MApVqXiuYB0bAAAAAAAAA==
--------------ms050308070406020807090306--
