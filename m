Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33179 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbbIRN3v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 09:29:51 -0400
Received: by igbkq10 with SMTP id kq10so35613936igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 06:29:50 -0700 (PDT)
Subject: Re: RAID1 storage server won't boot with one disk missing
To: Chris Murphy <lists@colorremedies.com>, Roman Mamedov <rm@romanrm.net>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
 <55FAD9CC.5060206@oracle.com> <55FAF198.2060106@libero.it>
 <20150918000205.6e8f3998@natsu>
 <CAJCQCtQ10SJAPca8quhdi-oK1rJV2rcfY0QZFqx11u9ntyDRYA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55FC11C4.60506@gmail.com>
Date: Fri, 18 Sep 2015 09:29:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ10SJAPca8quhdi-oK1rJV2rcfY0QZFqx11u9ntyDRYA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030007080401000505060808"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030007080401000505060808
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-17 16:18, Chris Murphy wrote:
> On Thu, Sep 17, 2015 at 1:02 PM, Roman Mamedov <rm@romanrm.net> wrote:
>> On Thu, 17 Sep 2015 19:00:08 +0200
>> Goffredo Baroncelli <kreijack@libero.it> wrote:
>>
>>> On 2015-09-17 17:18, Anand Jain wrote:
>>>>   it looks like -o degraded is going to be a very obvious feature,
>>>>   I have plans of making it a default feature, and provide -o
>>>>   nodegraded feature instead. Thanks for comments if any.
>>>>
>>> I am not sure if there is a "good" default for this kind of problem
>>
>> Yes there is. It is whatever people came to expect from using other RA=
ID
>> systems and/or generally expect from RAID as a concept.
>>
>> Both mdadm software RAID, and I believe virtually any hardware RAID co=
ntroller
>> out there will let you to successfully boot up and give read-write(!) =
access
>> to a RAID in a non-critical failure state, because that's kind of the =
whole
>> point of a RAID, to eliminate downtime. If the removed disk is later r=
e-added,
>> then it is automatically resynced. Mdadm can also make use of its 'wri=
te
>> intent bitmap' to resync only those areas of the array which were in a=
ny way
>> touched during the absence of the newly re-added disk.
>>
>> If you're concerned that the user "misses" the fact that they have a d=
isk
>> down, then solve *that*, make some sort of a notify daemon, e.g. mdadm=
 has a
>> built-in "monitor" mode which sends E-Mail on critical events with any=
 of the
>> arrays.
>
> Given the current state: no proposal and no work done yet, I think
> it's premature to change the default.
>
> It's an open question what a modern monitoring and notification
> mechanism should look like. At the moment it'd be a unique Btrfs thing
> because the mdadm and LVM methods aren't abstracted enough to reuse. I
> wonder if the storaged and/or openlmi folks have some input on what
> this would look like. Feedback from KDE and GNOME also, who rely on at
> least mdadm in order to present user space notifications. I think
> udisks2 is on the way out and storaged is on the way in, there's just
> too much stuff that udisks2 doesn't do and is getting confused about,
> including LVM thinly provisioned volumes, not just Btrfs stuff.
>
>
The problem with that is that storaged (from what I understand) is=20
systemd dependent, and there are too many people out there who don't=20
want systemd.  udisks2 will almost certainly live on (just like=20
consolekit has).  And if it's something systemd integrated, I can=20
already tell you it will look like the OS X solution.  Now, what I think =

it should look like is a different story, I'd say that:
1. It should give the option to either:
     a. Refuse to boot degraded.
     b. Ask the operator if he wants to boot degraded
     c. Just automatically boot degraded, and probably send a=20
notification about it.
2. Provide some service (sadly probably dbus based) to schedule=20
scrub/balance/re-sync operations and get info about ENOSPC/sync=20
failure/parity mismatch/device failure/SMART status failure.
3. Provide a consistent interface to such operations on hardware RAID=20
controllers that support them.
4. Provide the ability to notify via arbitrary means on any of the above =

mentioned issues.
5. Have the ability to turn anything not needed off on a given system.


--------------ms030007080401000505060808
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE4MTMyOTQwWjBPBgkq
hkiG9w0BCQQxQgRAqMteNDupid+g7wHJI8ndX7U6A239SDVyt+Nizi0u9ldKC3HO4BH95iV5
pzaCI5wB10hjsozzjBHDqgt9GnY/lzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBu7JOkWj+vb1pbNoOD9/nD9DRciYF4ULSZEN9lnfr5PPetdPXF
BagGtXICQoqYQKALX9R432t2R2EanzqWnRJjP7cE7lRKhyj0cq9vni1p2dB6RMBA41oLM1dV
EXDjSZG46kGNXUdAq+aQjVW3zENZSHmx+IuCfHjc58w+YZ5f2s93PWBEQS2jXbfYpHWb4c5n
c9mxxDS/n+i3DY/UNVsq8nJrvZZ2gaFx66Zcm+ghDfbKqF5zjuboLTg39mY+NF62wetv6930
5TllOKnVWXoUxLE1nNfss86jT3cVyvBteaH9cCe2sOp8o1HaLfwSv4AWoYWpcShd6JvOEFdx
sxKtAfhiGsdiKqhmWfZdBw17HlEJo0TU8hR2RrZAtwlGVn1EOCVCM6E3zoSeeGPDLwNb4WoO
hHfewdpkknHD73GIMNXVaXh+KK22zpsRAWLKT1q8TMNKqowTTQV3rrVC6DWGb0K0Dji2DOD/
fzCizCCKvx3oo5EBdDDbmME+65SMBLlwI/NUyEDCXHL4nGq36zf969IXbzZoeR97IF2qGJTq
6VF3TrSRdjRNyn6UekqzOGxmYQIz9ivQKwA4yT6AS24k+hQgaIXUgC27heiYThAFYkRe19uL
KKWlCkJIlmppHGHOWXfS48mLNatlrDnn1v7Lb3my7Fd1C//WzJVvLTP3QQAAAAAAAA==
--------------ms030007080401000505060808--
