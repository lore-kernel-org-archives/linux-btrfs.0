Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47830 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaIJNGm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 09:06:42 -0400
Received: by mail-ie0-f173.google.com with SMTP id x19so3401051ier.4
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 06:06:41 -0700 (PDT)
Message-ID: <54104CD6.3030604@gmail.com>
Date: Wed, 10 Sep 2014 09:06:30 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Bob Williams <linux@barrowhillfarm.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Is it necessary to balance a btrfs raid1 array?
References: <541043B8.7010601@barrowhillfarm.org.uk>
In-Reply-To: <541043B8.7010601@barrowhillfarm.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040603030506040709050603"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040603030506040709050603
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-09-10 08:27, Bob Williams wrote:
> I have two 2TB disks formatted as a btrfs raid1 array, mirroring both
> data and metadata. Last night I started
>=20
> # btrfs filesystem balance <path>
>=20
In general, unless things are really bad, you don't ever want to use
balance on such a big filesystem without some filters to control what
gets balanced (especially if the filesystem is more than about 50% full
most of the time).

My suggestion in this case would be to use:
# btrfs balance start -dusage=3D25 -musage=3D25 <path>
on a roughly weekly basis.  This will only balance chunks that are less
than 25% full, and therefore run much faster.  If you are particular
about high storage efficiency, then try 50 instead of 25.
> and it is still running 18 hours later. This suggests that most stuff
> only gets written to one physical device, which in turn suggests that
> there is a risk of lost data if one physical device fails. Or is there
> something clever about btrfs raid that I've missed? I've used linux
> software raid (mdraid) before, and it appeared to write to both
> devices simultaneously.
The reason that a full balance takes so long on a big (and I'm assuming
based on the 18 hours it's taken, very full) filesystem is that it reads
all of the data, and writes it out to both disks, but it doesn't do very
good load-balancing like mdraid or LVM do.  I've got a 4x 500Gib BTRFS
RAID10 filesystem that I use for my home directory on my desktop system,
and a full balance on that takes about 6 hours.
>=20
> Is it safe to interrupt [^Z] the btrfs balancing process?
^Z sends a SIGSTOP, which is a really bad idea with something that is
doing low-level stuff to a filesystem.  If you need to stop the balance
process (and are using a recent enough kernel and btrfs-progs), the
preferred way to do so is to use the following from another terminal:
# btrfs balance stop <path>
Depending on what the balance operation is working when you do this, it
may take a few minutes before it actually stops (the longest that I've
seen it take is ~200 seconds).
>=20
> As a rough guide, how often should one perform
>=20
> a) balance
> b) defragment
> c) scrub
>=20
> on a btrfs raid setup?
In general, you should be running scrub regularly, and balance and
defragment as needed.  On the BTRFS RAID filesystems that I have, I use
the following policy:
	1) Run a 25% balance (the command I mentioned above) on a weekly basis.
	2) If the filesystem has less than 50% of either the data or metadata
chunks full at the end of the month, run a full balance on it.
	3) Run a scrub on a daily basis.
	4) Defragment files only as needed (which isn't often for me because I
use the autodefrag mount option).
	5) Make sure than only one of balance, scrub or defrag is running at a
given time.
Normally, you shouldn't need to run balance at all on most BTRFS
filesystems, unless your usage patterns vary widely over time (I'm
actually a good example of this, most of the files in my home directory
are relatively small, except for when I am building a system with
buildroot or compiling a kernel, and on occasion I have VM images that
I'm working with).


--------------ms040603030506040709050603
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTEwMTMwNjMw
WjAjBgkqhkiG9w0BCQQxFgQU5KUG9+G2uu+il2kqhNHe2xB6GvswbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAVnpII54G0FZGdD5ynlshHsatR+sz
wuYJjctC56Q2JUQB81uKX/FQ9HdHPa8Uho816YbQtfYP9N4pe2lsIUkMr8MqbFbewT0y1TXE
auIYJMPJOJ6V/aZS06jgg3YlgWypLq8C1+4+1kvGTYmdMVNikK5fiH0uy0bUf9qKKaNtIJnD
y0+sQIbx77Nwf2cgZZ7kA1yrZTk0ego+lLgeL3j3R4wuD6xo9j8EJWFbkyaTjueI5kPgi0Ni
4eHgffMshdnAnYorzsRFRQiKZpwvunIymHTRNVBKD9bZtRboAGrJqtiRRmnzAR2t4D9JBZrG
vjv0dT6qnZg4XdEPK6MOBBh8AAAAAAAAAA==
--------------ms040603030506040709050603--
