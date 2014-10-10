Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:62787 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaJJTfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 15:35:41 -0400
Received: by mail-ig0-f180.google.com with SMTP id uq10so4003664igb.13
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 12:35:41 -0700 (PDT)
Message-ID: <543834FC.9050409@gmail.com>
Date: Fri, 10 Oct 2014 15:35:24 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Bob Marley <bobmarley@shiftmail.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com> <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com> <5437BAB2.1040605@shiftmail.org> <93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com> <54381ADB.2030002@shiftmail.org>
In-Reply-To: <54381ADB.2030002@shiftmail.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090202010902060707020606"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090202010902060707020606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-10 13:43, Bob Marley wrote:
> On 10/10/2014 16:37, Chris Murphy wrote:
>> The fail safe behavior is to treat the known good tree root as the
>> default tree root, and bypass the bad tree root if it cannot be
>> repaired, so that the volume can be mounted with default mount options=

>> (i.e. the ones in fstab). Otherwise it's a filesystem that isn't well
>> suited for general purpose use as rootfs let alone for boot.
>>
>
> A filesystem which is suited for "general purpose" use is a filesystem
> which honors fsync, and doesn't *ever* auto-roll-back without user
> intervention.
>
> Anything different is not suited for database transactions at all. Any
> paid service which has the users database on btrfs is going to be at
> risk of losing payments, and probably without the company even knowing.=

> If btrfs goes this way I hope a big warning is written on the wiki and
> on the manpages telling that this filesystem is totally unsuitable for
> hosting databases performing transactions.
If they need reliability, they should have some form of redundancy=20
in-place and/or run the database directly on the block device; because=20
even ext4, XFS, and pretty much every other filesystem can lose data=20
sometimes, the difference being that those tend to give worse results=20
when hardware is misbehaving than BTRFS does, because BTRFS usually has=20
a old copy of whatever data structure gets corrupted to fall back on.

Also, you really shouldn't be running databases on a BTRFS filesystem at =

the moment anyway, because of the significant performance implications.
>
> At most I can suggest that a flag in the metadata be added to
> allow/disallow auto-roll-back-on-error on such filesystem, so people ca=
n
> decide the "tolerant" vs. "transaction-safe" mode at filesystem creatio=
n.
>

The problem with this is that if the auto-recovery code did run (and=20
IMHO the kernel should spit out a warning to the system log whenever it=20
does), then chances are that you wouldn't have had a consistent view if=20
you had prevented it from running either; and, if the database is=20
properly distributed/replicated, then it should recover by itself.



--------------ms090202010902060707020606
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDEwMTkzNTI0
WjAjBgkqhkiG9w0BCQQxFgQUfGdGHQhprgVwMYaJqG9dt5B/zXEwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAAJ5i0P2AurdB68PM+3FmK2ezE2DA
njBNEea6UYrqCp5xm4m0KOY+f3eiVajcd+9ikTEzrKe1hcOU4gLObHkAy0IXwNdXoxafwP7l
R4FGHRpPh8eS0ivRBOCqY6Tzai9KMIugAVkTh4Gf7XcohhGMLd73xbH0Slc+OiSObJjOt4oA
HDXE5u3xCrde36O6yRRaf3cVPpUqtmfAfBptVaM5/zt6gNlcolrbN1nx7W4VGehpx5ZKL7x/
bsHkaH6HzZZOd7FXFQtD8L7gs+CAdwxlvkIMfUbC/cAnHBiYDwhVHDLsl0epuTUgwT/B8/kv
vAxl6Xdv+YHjlzE8gbICRrw81gAAAAAAAA==
--------------ms090202010902060707020606--
