Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:53301 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaHNQwk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 12:52:40 -0400
Received: by mail-yk0-f169.google.com with SMTP id 131so1183401ykp.14
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 09:52:40 -0700 (PDT)
Message-ID: <53ECE953.70009@gmail.com>
Date: Thu, 14 Aug 2014 12:52:35 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org, jbacik@fb.com,
        clm@fb.com
CC: takeuchi_satoru@jp.fujitsu.com
Subject: Re: btrfs-zero-log fails, can't mount FS
References: <20140814160902.GA25370@merlins.org>
In-Reply-To: <20140814160902.GA25370@merlins.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030902090708060102090801"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030902090708060102090801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-08-14 12:09, Marc MERLIN wrote:
> Running 3.15.5, laptop hung overnight, I was forced to reboot with sysr=
q.
>=20
> After that, it wouldn't mount anymore:
> [  689.366125] BTRFS: device label btrfs_pool1 devid 1 transid 237214 /=
dev/dm-1
> [  716.384377] BTRFS info (device dm-1): disk space caching is enabled
> [  716.566974] BTRFS: detected SSD devices, enabling SSD mode
> [  716.567106] BTRFS: bad tree block start 8622613565695139001 49500766=
208
> [  716.567220] BTRFS: bad tree block start 10955809011958619003 4950076=
6208
> [  716.567224] BTRFS: failed to read log tree
> [  716.638634] BTRFS: open_ctree failed
>=20
> Ok, btrfs-zero-log usually helps with this, but not this time:
> legolas:~# btrfs-zero-log /dev/mapper/disk1=20
> Check tree block failed, want=3D49500766208, have=3D8622613565695139001=

> Check tree block failed, want=3D49500766208, have=3D8622613565695139001=

> Check tree block failed, want=3D49500766208, have=3D1095580901195861900=
3
> Check tree block failed, want=3D49500766208, have=3D1095580901195861900=
3
> Check tree block failed, want=3D49500766208, have=3D1095580901195861900=
3
> read block failed check_tree_block
> Couldn't setup log root tree
> legolas:~#=20
>=20
> It's recent:
> legolas:~# btrfs-zero-log=20
> usage: btrfs-zero-log dev
> Btrfs v3.14.1
>=20
> mount -o ro,recovery /dev/mapper/disk1 /mnt/mnt
> does not work either, but that's expected.
>=20
> I can probably use some recovery tools to get data off it, but I alread=
y
> have a backup.
> I'd much rather not have to destroy and rebuild this partition.
>=20
> Worst thing is that it happened with 3.15 and I had just changed it to
> compress=3Dnone (although there was existing data was compresssed).
>=20
> Do you have any suggestions on how to repair this partition so that it'=
s
> mountable again?
>=20
> This is a good SSD (samsung evo 840), I'm not sure it's to blame for
> corrupting data or writing it out of order and lying to the OS about it=
=2E
> If that is not the case, does it mean btrfs is still getting into state=
s
> where it mangles the filesystem in a way that it can't mount it anymore=
?
>=20
> Thanks,
> Marc
>=20
I don't think it is likely that the Samsung SSD is to blame, in my
experience Samsung's SSD's are better than almost every other brand
except Intel, and I know that they honor write-barriers correctly.
The likely issue is that the system hung during the process of a commit,
which is one of the few things that I know of that consistently corrupts
the filesystem.  There isn't really anything I know of to prevent it,
except for making your system as stable as possible.
Interestingly, this type of thing is the only issue I've ever had with
BTRFS that wasn't traceable to hardware problems.


--------------ms030902090708060102090801
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwODE0MTY1MjM1
WjAjBgkqhkiG9w0BCQQxFgQU9ufFI3RtfuSyjuoaY3lGDVpvSoowbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAZX7oEFAeUQtdx0/FD4GtkDuL2UR9
06cyV4Dj2DVr+/lIlasJdUB2OoZDtN5Syu8NZAxS3w5edTQvL4DUyYzJRaD4+UY9iob/Fn//
ZLG9chx+1f1Dmn9rYLC/Vk0bxJDWuRcAgR2qtlNmqlZxwu+z09/hddpaUANnHfX7RwQqHY7o
CAmxOsF6ui13CHUqluukgiJTWPzjQWaP2MZEonCy5hquSIaVAdu/S0qobjIv/9SsMhDl41Ir
46myh7V+iva5JUIcLtonSzix2n9TB1DkWYO5BLW8HyDathqLQIlxbXJwSLucU/JfTUHI2zLX
Ss7YWco8i6hfmt1VhQF2u0WxSgAAAAAAAA==
--------------ms030902090708060102090801--
