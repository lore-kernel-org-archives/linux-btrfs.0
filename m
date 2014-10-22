Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:45494 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbaJVLav (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 07:30:51 -0400
Received: by mail-ig0-f178.google.com with SMTP id h3so682660igd.11
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 04:30:50 -0700 (PDT)
Message-ID: <54479563.1050401@gmail.com>
Date: Wed, 22 Oct 2014 07:30:43 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Arnaud Kapp <kapp.arno@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 5 _thousand_ snapshots? even 160?
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com> <5446BEC0.8070009@siedziba.pl> <5446C597.9080904@gmail.com> <54470403.8020904@pobox.com>
In-Reply-To: <54470403.8020904@pobox.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060002060407080103000300"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060002060407080103000300
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-21 21:10, Robert White wrote:
>
> I don't think balance will _ever_ move the contents of a read only
> snapshot. I could be wrong. I think you just end up with an endlessly
> fragmented storage space and balance has to take each chunk and search
> for someplace else it might better fit. Which explains why it took so l=
ong.
>
> And just _forget_ single-extent large files at that point.
>
> (Of course I could be wrong about the "never move" rule, but that would=

> just make the checksums on the potentially hundreds or thousands of
> references need to be recalculated after a move, which would make
> incremental send/receive unfathomable.)
>
Balance doesn't do anything different for snapshots from what it does=20
with regular data.  I think you are confusing balance with=20
defragmentation, as that does (in theory) handle snapshots differently.=20
  Balance just takes all of the blocks selected by the filters, and=20
sends the through the block allocator again, and then updates the=20
metadata to point to the new blocks.  It can result in some=20
fragmentation, but usually only for files bigger than about 256M, and=20
even then doesn't always cause fragmentation
>
> On 10/21/2014 01:44 PM, Arnaud Kapp wrote:
>> Hello,
>>
>> I would like to ask if the balance time is related to the number of
>> snapshot or if this is related only to data (or both).
>>
>> I currently have about 4TB of data and around 5k snapshots. I'm thinki=
ng
>> of going raid1 instead of single. From the numbers I see this seems
>> totally impossible as it would take *way* too long.
>>
>> Would destroying snapshots (those are hourly snapshots to prevent stup=
id
>> error to happens, like `rm my_important_file`) help?
>>
>> Should I reconsider moving to raid1 because of the time it would take?=

>>
>> Sorry if I'm somehow hijacking this thread, but it seemed related :)
>>
>> Thanks,
>>
>> On 10/21/2014 10:14 PM, Piotr Paw=C5=82ow wrote:
>>> On 21.10.2014 20:59, Tomasz Chmielewski wrote:
>>>> FYI - after a failed disk and replacing it I've run a balance; it to=
ok
>>>> almost 3 weeks to complete, for 120 GBs of data:
>>>
>>> Looks normal to me. Last time I started a balance after adding 6th
>>> device to my FS, it took 4 days to move 25GBs of data. Some chunks to=
ok
>>> 20 hours to move. I currently have 156 snapshots on this FS (nightly
>>> rsync backups).
>>>
>>> I think it is so slow, because it's disassembling chunks piece by pie=
ce
>>> and stuffing these pieces elsewhere, instead of moving chunks as a
>>> whole. If you have a lot of little pieces (as I do), it will take a
>>> while...
>>>



--------------ms060002060407080103000300
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDIyMTEzMDQz
WjAjBgkqhkiG9w0BCQQxFgQUZFEulT8oVs4SvZ/bk/+GyhcN94swbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAiLfwZuNK6xctQx2P+vQDcJLyuySf
HgYiiePkm9Qz7oyvmZ5b2Ul6pz9jt8vrRy6b3ugwT0/v12l/kZQKrp3iIdRFjn5In5hOVDyc
F0vamAEebusyGxqtBEi4cRkA7R3HPgdUzfFkgDFoESFWuUPDWGEYcDFKddFvNPSUe6ijJZ0y
8U9ktBOT5epqn1/vi6jg5+mXGUqxHLlAGyIOFVeF3knxuVmamzZj/nYICaqTJ9Bc+cL7uJcv
2Zu4sjIFRV7ry/s38CzX3i9b//dxFVaKIv8Zb3wMJc/KBWLlvacfW4rU8dxg5ShhRBd5oRzn
0g9q9F+mYe82izpEF+2IJ9T2ugAAAAAAAA==
--------------ms060002060407080103000300--
