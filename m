Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:55680 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaIJOlT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 10:41:19 -0400
Received: by mail-ig0-f182.google.com with SMTP id h18so1153705igc.15
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 07:41:18 -0700 (PDT)
Message-ID: <54106303.60906@gmail.com>
Date: Wed, 10 Sep 2014 10:41:07 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Rich Freeman <r-btrfs@thefreemanclan.net>
CC: Bob Williams <linux@barrowhillfarm.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is it necessary to balance a btrfs raid1 array?
References: <541043B8.7010601@barrowhillfarm.org.uk>	<54104CD6.3030604@gmail.com> <CAGfcS_=DKk1g87mvKBRyXmycjMjoSFbi3P6Qrrn5KQ0nD0HStg@mail.gmail.com>
In-Reply-To: <CAGfcS_=DKk1g87mvKBRyXmycjMjoSFbi3P6Qrrn5KQ0nD0HStg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000402010408030006090303"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000402010408030006090303
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-09-10 09:48, Rich Freeman wrote:
> On Wed, Sep 10, 2014 at 9:06 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> Normally, you shouldn't need to run balance at all on most BTRFS
>> filesystems, unless your usage patterns vary widely over time (I'm
>> actually a good example of this, most of the files in my home director=
y
>> are relatively small, except for when I am building a system with
>> buildroot or compiling a kernel, and on occasion I have VM images that=

>> I'm working with).
>=20
> Tend to agree, but I do keep a close eye on free space.  If I get to
> the point where I'm over 90% allocated to chunks with lots of unused
> space otherwise I run a balance.  I tend to have the most problems
> with my root/OS filesystem running on a 64GB SSD, likely because it is
> so small.
>=20
> Is there a big performance penalty running mixed chunks on an SSD?  I
> believe this would get rid of the risk of ENOSPC issues if everything
> gets allocated to chunks.  There are obviously no issues with random
> access on an SSD, but there could be other problems (cache
> utilization, etc).
There shouldn't be any more performance penalty than for normally
running mixed chunks.  Also, a 64GB SSD is not small, I use a pair of
64GB SSD's in a BTRFS RAID1 configuration for root on my desktop, and
consistently use less than a quarter (12G on average) of the available
space, and that's with stuff like LibreOffice and the entire OpenClipart
distribution (although I'm not running an 'enterprise' distribution, and
keep /tmp and /var/tmp on tmpfs).
>=20
> I tend to watch btrfs fi sho and if the total space used starts
> getting high then I run a balance.  Usually I run with -dusage=3D30 or
> -dusage=3D50, but sometimes I get to the point where I just need to do =
a
> full balance.  Often it is helpful to run a series of balance commands
> starting at -dusage=3D10 and moving up in increments.  This at least
> prevents killing IO continuously for hours.  If we can get to a point
> where balancing can operate at low IO priority that would be helpful.
>=20
> IO priority is a problem in btrfs in general.  Even tasks run at idle
> scheduling priority can really block up a disk.  I've seen a lot of
> hurry-and-wait behavior in btrfs.  It seems like the initial commit to
> the log/etc is willing to accept a very large volume of data, and then
> when all the trees get updated the system grinds to a crawl trying to
> deal with all the data that was committed.  The problem is that you
> have two queues, with the second queue being rate-limiting but the
> first queue being the one that applies priority control.  What we
> really need is for the log to have controls on how much it accepts so
> that the updating of the trees/etc never is rate-limiting.   That will
> limit the ability to have short IO write bursts, but it would prevent
> low-priority writes from blocking high-priority read/writes.

You know, you can pretty easily control bandwidth utilization just using
cgroups.  This is what I do, and I get much better results with cgroups
and the deadline IO scheduler than I ever did with CFQ. Abstract
priorities are a not bad for controlling relative CPU utilization, but
they really suck for IO scheduling.


--------------ms000402010408030006090303
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTEwMTQ0MTA3
WjAjBgkqhkiG9w0BCQQxFgQUqwkU4kK2EiD1RgMzDlEPPnfb5JEwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEApNhzGL5L1BBrArFYNDEDugAuYamr
qsAX9bMlP0MdaH9/n9S9GBdlG/IKal8HDr2bu6fdSTXQfRoRstAtB+mFGtUZfaUInniFZk+r
oG8YacGVpgdbF6RwN5IDiZbnjfgMn/jrs0mcmCWHQoYudbwKtDUrJw2+v4GmCMh5Ihh9NVv4
OnlayLngFOp/NWNITCBWfQ/TusMvJr1Dd6VrHZjgZoEGr4NRwY4iupt9hHhj98Psk2VNaf0o
dcNag+cdZymgMWBiMB4AMiwbDNJJMiEkgk4Bb8GEskUhd5STsuHH0LyrtxREpCgLaOux71tl
02gEXoTH/4NOAYvlOZlTRHQc4wAAAAAAAA==
--------------ms000402010408030006090303--
