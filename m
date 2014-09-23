Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36866 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbaIWNiN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 09:38:13 -0400
Received: by mail-ig0-f174.google.com with SMTP id r10so4576181igi.7
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 06:38:12 -0700 (PDT)
Message-ID: <542177BF.2000808@gmail.com>
Date: Tue, 23 Sep 2014 09:38:07 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: lists@xunil.at, linux-btrfs@vger.kernel.org
Subject: Re: general thoughts and questions + general and RAID5/6 stability?
References: <8D1A2626CC69D79-11FC-A2C3@webmail-va141.sysops.aol.com> <pan$5a87e$97e2e260$54942ad0$cefe56f1@cox.net> <54208BBC.1000700@xunil.at> <542162A8.2010700@gmail.com> <5421706F.6070301@xunil.at>
In-Reply-To: <5421706F.6070301@xunil.at>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080503030502010106040804"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080503030502010106040804
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-09-23 09:06, Stefan G. Weichinger wrote:
> Am 23.09.2014 um 14:08 schrieb Austin S Hemmelgarn:
>> On 2014-09-22 16:51, Stefan G. Weichinger wrote:
>>> Is re-creating btrfs-filesystems *recommended* in any way?
>>>
>>> Does that actually make a difference in the fs-structure?
>>>
>> I would recommend it, there are some newer features that you can only
>> set at mkfs time.  Quite often, when a new feature is implemented, it =
is
>> some time before things are such that it can be enabled online, and ev=
en
>> then that doesn't convert anything until it is rewritten.
>
> What features for example?
Well, running 'mkfs.btrfs -O list-all' with 3.16 btrfs-progs gives the=20
following list of features:
mixed-bg		- mixed data and metadata block groups
extref			- increased hard-link limit per file to 65536
raid56			- raid56 extended format
skinny-metadata		- reduced size metadata extent refs
no-holes		- no explicit hole extents for files

mixed-bg is something that you generally wouldn't want to change after mk=
fs.
extref can be enabled online, and the filesystem metadata gets updated=20
as-needed, and dosen't provide any real performance improvement (but is=20
needed for some mail servers that have HUGE mail-queues)
I don't know anything about the raid56 option, but there isn't any way=20
to change it after mkfs.
skinyy-metadata can be changed online, and the format gets updated on=20
rewrite of each metadata block.  This one does provide a performance=20
improvement (stat() in particular runs noticeably faster).  You should=20
probably enable this if it isn't already enabled, even if you don't=20
recreate your filesystem.
no-holes cannot currently be changed online, and is a very recent=20
addition (post v3.14 btrfs-progs I believe) that provides improved=20
performance for sparse files (which is particularly useful if you are=20
doing things with fixed size virtual machine disk images).

It's this last one that prompted me personally to recreate my=20
filesystems most recently, as I use sparse files to save space as much=20
as possible.
>
> I created my main btrfs a few months ago and would like to avoid
> recreating it as this would mean restoring my root-fs on my main
> workstation.
>
> Although I would do it if it is "worth it" ;-)
>
> I assume I could read some kind of version number out of the superblock=

> or so?
>
> btrfs-show-super ?
>
AFAIK there isn't really any 'version number' that has any meaning in=20
the superblock (except for telling the kernel that it uses the stable=20
disk layout), however, there are flag bits that you can look for=20
(compat_flags, compat_ro_flags, and incompat_flags).  I'm not 100%=20
certain what each bit means, but on my system with a only 1 month old=20
BTRFS filesystem, with extref, skinny-metadata, and no-holes turned on,=20
i have compat_flags: 0x0, compat_ro_flags: 0x0, and incompat_flags: 0x16b=
=2E

The other potentially significant thing is that the default=20
nodesize/leafsize has changed recently from 4096 to 16384, as that gives =

somewhat better performance for most use cases.



--------------ms080503030502010106040804
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTIzMTMzODA3
WjAjBgkqhkiG9w0BCQQxFgQUNTCBFNymBtdN38E+30GC2iRNxAgwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAfdxyEucM1PNwdPPJ0u0LXABB/cl5
vCDf821aYgje4MANlJQ9YpLFXlAHXWkxLCr1Vm35SigLgfRFbHfqMQxMREMWsYIFw7+dG4bV
IPiDr5VLcZwFEHU+JWN1BlBpy6yQviXKUIbdouNwWeeCDC0jChCwWDBsvTuN5sEvDMuEXMjW
pq6GRwT3tjDw1bBDQH9nSKaifXoPX/9Q/X25WMlp0gE0qjNN1v7sCC3AvvVB8KSZCP7xVEUt
964eUgmFgVdbs4pkQutLX9JZvwcl0gzKSz5IsT6PKbxR0nmj6sIW/rD5o9WjsyATPdQzqWtL
H/LsNyxxGOVkpxctX3VAgtXQgAAAAAAAAA==
--------------ms080503030502010106040804--
