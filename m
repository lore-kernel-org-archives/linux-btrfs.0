Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:41627 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaIQLYB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 07:24:01 -0400
Received: by mail-ie0-f177.google.com with SMTP id x19so1435917ier.36
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 04:24:00 -0700 (PDT)
Message-ID: <54196F42.4030101@gmail.com>
Date: Wed, 17 Sep 2014 07:23:46 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Problem with unmountable filesystem.
References: <54184BD2.7000300@gmail.com> <2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com>
In-Reply-To: <2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010103040807030806060900"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010103040807030806060900
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2014-09-16 16:57, Chris Murphy wrote:
>=20
> On Sep 16, 2014, at 8:40 AM, Austin S Hemmelgarn <ahferroin7@gmail.com>=
 wrote:
>=20
>> Based on the kernel messages, the primary issue is log corruption, and=

>> in theory btrfs-zero-log should fix it.
>=20
> Can you provide a complete dmesg somewhere for this initial failure, ju=
st for reference? I'm curious what this indication looks like compared to=
 other problems.
>=20
Okay, I can't really get a 'complete' dmesg, because the system panics=20
on the mount failure (the filesystem in question is the system's root=20
filesystem), the system has no serial ports, and I didn't think to=20
build in support for console on ttyUSB0.  I can however get what the=20
recovery environment (locally compiled based on buildroot) shows when I=20
try to mount the filesystem:
[   30.871036] BTRFS: device label gentoo devid 1 transid 160615 /dev/sda=
3
[   30.875225] BTRFS info (device sda3): disk space caching is enabled
[   30.917091] BTRFS: detected SSD devices, enabling SSD mode
[   30.920536] BTRFS: bad tree block start 0 130402254848
[   30.924018] BTRFS: bad tree block start 0 130402254848
[   30.926234] BTRFS: failed to read log tree
[   30.953055] BTRFS: open_ctree failed
>>  The actual issue however, is
>> that the primary superblock appears to be pointing at a corrupted root=

>> tree, which causes pretty much everything that does anything other tha=
n
>> just read the sb to fail.  The first backup sb does point to a good
>> tree, but only btrfs check and btrfs restore have any option to ignore=

>> the first sb and use one of the backups instead.
>=20
> Maybe use wipefs -a on this volume, which removes the magic from only t=
he first superblock by default (you can specify another location). And th=
en try btrfs-show-super -F which "dumps" supers with bad magic.
>=20
Thanks for the suggestion, I hadn't thought of that...
> I just tried this:
> # wipefs -a /dev/sdb
> /dev/sdb: 8 bytes were erased at offset 0x00010040 (btrfs): 5f 42 48 52=
 66 53 5f 4d
> # btrfs-show-super -F /dev/sdb
> superblock: bytenr=3D65536, device=3D/dev/sdb
> ---------------------------------------------------------
> csum			0x5c1196d7 [DON'T MATCH]
> bytenr			65536
> flags			0x1
> magic			........ [DON'T MATCH]
> [=85]
> # btrfs-show-super -i1 /dev/sdb
> superblock: bytenr=3D67108864, device=3D/dev/sdb
> ---------------------------------------------------------
> csum			0xfc70be19 [match]
> bytenr			67108864
> flags			0x1
> magic			_BHRfS_M [match]
>=20
> So the mirror is definitely there and valid.
> # btrfs rescue super-recover -yv /dev/sdb
> No valid Btrfs found on /dev/sdb
> Usage or syntax errors
>=20
> Not expected at all, man page says "Recover bad superblocks from good c=
opies." There's a good copy, it's not being found by btrfs rescue super-r=
ecover. Seems like a bug.
>=20
>=20
> # btrfs check /dev/sdb
> No valid Btrfs found on /dev/sdb
> Couldn't open file system
>=20
> # btrfs check -s1 /dev/sdb
> using SB copy 1, bytenr 67108864
> Checking filesystem on /dev/sdb
> UUID: 9acf13de-5b98-4f28-9992-533e4a99d348
> [snip]
> OK it finds it, maybe a --repair will fix the bad first one?
> # btrfs check -s1 /dev/sdb
> using SB copy 1, bytenr 67108864
> enabling repair mode
> Checking filesystem on /dev/sdb
> UUID: 9acf13de-5b98-4f28-9992-533e4a99d348
> [snip]
> No indication of repair
> # btrfs check /dev/sdb
> No valid Btrfs found on /dev/sdb
> Couldn't open file system
> # btrfs check /dev/sdb
> No valid Btrfs found on /dev/sdb
> Couldn't open file system
> [root@f21v ~]# btrfs-show-super -F /dev/sdb
> superblock: bytenr=3D65536, device=3D/dev/sdb
> ---------------------------------------------------------
> csum			0x5c1196d7 [DON'T MATCH]
> bytenr			65536
> flags			0x1
> magic			........ [DON'T MATCH]
>=20
>=20
> Still not fixed. Maybe I needed to corrupt something else in the superb=
lock other than the magic and this behavior is intentional, otherwise wip=
efs -a, followed by btrfsck would resurrect an intentionally wiped btrfs =
fs, potentially wiping out some newer file system in the process.
>=20
=2E..though maybe it's a good thing I didn't.
>=20
>=20
>> I'm fine using dd to replace the primary sb with one of the
>> backups, but don't know the exact parameters that would be needed.
>=20
> Here's an idea:
>=20
> # btrfs-show-super /dev/sdb
> superblock: bytenr=3D65536, device=3D/dev/sdb
> ---------------------------------------------------------
> csum			0x92aa51ab [match]
> [snip]
> So I know what I'm looking for starts at LBA 65536/512
>=20
> # dd if=3D/dev/sdb skip=3D128 count=3D4 2>/dev/null | hexdump -C
> 00000000  92 aa 51 ab 00 00 00 00  00 00 00 00 00 00 00 00  |..Q=85....=
=2E.....|
> [snip]
>=20
> And as it turns out the csum is right at the beginning, 4 bytes. So use=
 bs of 4 bytes, seek 65536/4, count of 1. This should zero just 4 bytes s=
tarting at 65536 bytes in.
>=20
> # dd if=3D/dev/zero of=3D/dev/sdb bs=3D4 seek=3D16384 count=3D1
>=20
> Checked it with the earlier skip=3D128 command and it looks like everyt=
hing else is intact.
>=20
> # btrfs-show-super -F /dev/sdb
> superblock: bytenr=3D65536, device=3D/dev/sdb
> ---------------------------------------------------------
> csum			0x00000000 [DON'T MATCH]
> bytenr			65536
> flags			0x1
> magic			_BHRfS_M [match]
> [snip]
> OK so the csum is bad, the magic is good. Now see if btrfs rescue super=
-recover does anything
> # btrfs rescue super-recover /dev/sdb
> Make sure this is a btrfs disk otherwise the tool will destroy other fs=
, Are you sure? [y/N]: Y
> Recovered bad superblocks successful
> *** Error in `btrfs': corrupted double-linked list: 0x0000000002289e40 =
***
> =3D=3D=3D=3D=3D=3D=3D Backtrace: =3D=3D=3D=3D=3D=3D=3D=3D=3D
> /lib64/libc.so.6(+0x7a77e)[0x7f388663977e]
> /lib64/libc.so.6(+0x80b03)[0x7f388663fb03]
> /lib64/libc.so.6(+0x81c88)[0x7f3886640c88]
> /lib64/libc.so.6(cfree+0x4c)[0x7f38866456ec]
> btrfs[0x425ec6]
> btrfs[0x406902]
> /lib64/libc.so.6(__libc_start_main+0xf0)[0x7f38865df0e0]
> btrfs[0x406a04]
> =3D=3D=3D=3D=3D=3D=3D Memory m
> [snip]
>=20
> kaboom!
>=20
> But was it really successful?
> # btrfs-show-super -F /dev/sdb
> superblock: bytenr=3D65536, device=3D/dev/sdb
> ---------------------------------------------------------
> csum			0x92aa51ab [match]
> [skip]
> Looks fixed. And it mounts.
>=20
> NOW, I didn't actually have my first superblock pointing to a corrupt r=
oot tree. So it's possible that while the csum was fixed in my case, that=
 the subsequent crash has not properly copied all good parts of superbloc=
k1 to superblock0. *shrug*
>=20
> And since it crashes, looks like I found a bug.
>=20
>> I'm using btrfs-progs 3.16 and
>> kernel 3.16.1.
>=20
> So did I for all of the above.
>=20
>=20
Since posting this, I realized that the recovery environment I'm working =
from is actually btrfs-progs 3.14.1 and kernel 3.14.5, I need to make a p=
oint to update that once I get the system working again.

I've also discovered, when trying to use btrfs restore to copy out the da=
ta to a different system, that 3.14.1 restore apparently chokes on filesy=
stem that have lzo compression turned on.  It's reporting errors trying t=
o inflate compressed files, and I know for a fact that none of those file=
s were even open, let alone being written to, when the system crashed.  I=
 don't know if this is a known bug or even if it is still the case with b=
trfs-progs 3.16, but I figured I'd comment about it because I haven't see=
n anything about it anywhere.

Also, I interestingly didn't get the crash you saw above with btrfs rescu=
e super-recover, so that might be a regression in 3.16 btrfs-progs.

Thanks for all the help.


--------------ms010103040807030806060900
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTE3MTEyMzQ2
WjAjBgkqhkiG9w0BCQQxFgQU4qXUiN6qcYofcKRqnNPRGezszQEwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEADriEi/QsOp5JiXsyk0cG5Q2IGWp8
85SXgLLF90RvRATC6MSh/2uYeGnjKgOzpnMoplHoZ8T21A2JpW1e6aHlYI2LmwcLVfvm4RKF
aRYLetFBL9oV4O+NNodSuEf4IExQ1EcLEFeKIikTdbqB5KMyuUba/X736oX0VCWynHxjNoKY
4sf0ZW1NhgzzHZlDK2cEdUywjxSmnY25PM4tWac22PnuJrh4AKxwUrlOSvk1SRlPxqeNnetC
DCVJmTKD2UyGj+FU+dP5jSw3YU3N2SxmX2WJ7kn28POzl28cEi+RnqYhjsHybrsPc7aTCtCE
FLsw1jpSga5ePtlkh5CnVX9mRgAAAAAAAA==
--------------ms010103040807030806060900--
