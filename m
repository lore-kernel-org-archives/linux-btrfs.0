Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:56935 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaJML0S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 07:26:18 -0400
Received: by mail-ig0-f176.google.com with SMTP id hn15so9952321igb.15
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 04:26:17 -0700 (PDT)
Message-ID: <543BB6D2.9040205@gmail.com>
Date: Mon, 13 Oct 2014 07:26:10 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, Bob Marley <bobmarley@shiftmail.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com> <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com> <5437BAB2.1040605@shiftmail.org> <93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com> <54381ADB.2030002@shiftmail.org> <543834FC.9050409@gmail.com> <5438581D.5060102@redhat.com>
In-Reply-To: <5438581D.5060102@redhat.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030300010401010709070503"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030300010401010709070503
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-10 18:05, Eric Sandeen wrote:
> On 10/10/14 2:35 PM, Austin S Hemmelgarn wrote:
>> On 2014-10-10 13:43, Bob Marley wrote:
>>> On 10/10/2014 16:37, Chris Murphy wrote:
>>>> The fail safe behavior is to treat the known good tree root as
>>>> the default tree root, and bypass the bad tree root if it cannot
>>>> be repaired, so that the volume can be mounted with default mount
>>>> options (i.e. the ones in fstab). Otherwise it's a filesystem
>>>> that isn't well suited for general purpose use as rootfs let
>>>> alone for boot.
>>>>
>>>
>>> A filesystem which is suited for "general purpose" use is a
>>> filesystem which honors fsync, and doesn't *ever* auto-roll-back
>>> without user intervention.
>>>
>>> Anything different is not suited for database transactions at all.
>>> Any paid service which has the users database on btrfs is going to
>>> be at risk of losing payments, and probably without the company
>>> even knowing. If btrfs goes this way I hope a big warning is
>>> written on the wiki and on the manpages telling that this
>>> filesystem is totally unsuitable for hosting databases performing
>>> transactions.
>> If they need reliability, they should have some form of redundancy
>> in-place and/or run the database directly on the block device;
>> because even ext4, XFS, and pretty much every other filesystem can
>> lose data sometimes,
>
> Not if i.e. fsync returns.  If the data is gone later, it's a hardware
> problem, or occasionally a bug - bugs that are usually found & fixed
> pretty quickly.
Yes, barring bugs and hardware problems they won't lose data.
>
>> the difference being that those tend to give
>> worse results when hardware is misbehaving than BTRFS does, because
>> BTRFS usually has a old copy of whatever data structure gets
>> corrupted to fall back on.
>
> I'm curious, is that based on conjecture or real-world testing?
>
I wouldn't really call it testing, but based on personal experience I=20
know that ext4 can lose whole directory sub-trees if it gets a single=20
corrupt sector in the wrong place.  I've also had that happen on FAT32=20
and (somewhat interestingly) HFS+ with failing/misbehaving hardware; and =

I've actually had individual files disappear on HFS+ without any=20
discernible hardware issues.  I don't have as much experience with XFS,=20
but would assume based on what I do know of it that it could have=20
similar issues.  As for BTRFS, I've only ever had any issues with it 3=20
times, one was due to the kernel panicking during resume from S1, and=20
the other two were due to hardware problems that would have caused=20
issues on most other filesystems as well.  In both cases of hardware=20
issues, while the filesystem was initially unmountable, it was=20
relatively simple to fix once I knew how.  I tried to fix an ext4 fs=20
that had become unmountable due to dropped writes once, and that was=20
anything but simple, even with the much greater amount of documentation.


--------------ms030300010401010709070503
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDEzMTEyNjEw
WjAjBgkqhkiG9w0BCQQxFgQUjpp4zsBUwsPexdrt61P5b18wCqowbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAzaeEN3gs3sMRni7Ufs0pOxgzyfov
9BsTKMQK92QZnuzNasvx2k5mYmRc8hVw50VE6pyJYe8qhoasLJLWIZ5OP9SCvU22wJdXUrLI
oEXplL+eb7X5Oja6bwUEAdJOGr0qTHo1nfId9dza1OpqsdYiH2XdAR4Rq+2hcS40NjWuUU4I
ekuJokWMXDKE+7PwP10vewneo2JWNBFXSZpAP8GpQeJAkRTQMmbj5ngllNQk3Dfx7i2XBFlp
AwZoSWyFQ325FQ6T5xU2I3t0nEZ6roGDC3nSMZK2c6SozVInrd0RBjr7fAME86WdWe9Hoctw
6xPNHMXMdSxD3WO1kmeqKdBOlAAAAAAAAA==
--------------ms030300010401010709070503--
