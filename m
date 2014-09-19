Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38073 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbaISM7m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 08:59:42 -0400
Received: by mail-ig0-f182.google.com with SMTP id hn15so3298352igb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 05:59:41 -0700 (PDT)
Message-ID: <541C28AF.2010607@gmail.com>
Date: Fri, 19 Sep 2014 08:59:27 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: rob@robspanton.com, linux-btrfs@vger.kernel.org
Subject: Re: Performance Issues
References: <1411129114.1811.7.camel@zarniwoop.blob> <541C264E.106@gmail.com>
In-Reply-To: <541C264E.106@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030402070005000106060403"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030402070005000106060403
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-09-19 08:49, Austin S Hemmelgarn wrote:
> On 2014-09-19 08:18, Rob Spanton wrote:
>> Hi,
>>
>> I have a particularly uncomplicated setup (a desktop PC with a hard
>> disk) and I'm seeing particularly slow performance from btrfs.  A `git=

>> status` in the linux source tree takes about 46 seconds after dropping=

>> caches, whereas on other machines using ext4 this takes about 13s.  My=

>> mail client (evolution) also seems to perform particularly poorly on
>> this setup, and my hunch is that it's spending a lot of time waiting o=
n
>> the filesystem.
>>
>> I've tried mounting with noatime, and this has had no effect.  Anyone
>> got any ideas?
>>
>> Here are the things that the wiki page asked for [1]:
>>
>> uname -a:
>>
>>          Linux zarniwoop.blob 3.16.2-200.fc20.x86_64 #1 SMP Mon Sep 8
>>          11:54:45 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>>
>> btrfs --version:
>>
>>          Btrfs v3.16
>>
>> btrfs fi show:
>>
>>          Label: 'fedora'  uuid: 717c0a1b-815c-4e6a-86c0-60b921e84d75
>>              Total devices 1 FS bytes used 1.49TiB
>>              devid    1 size 2.72TiB used 1.50TiB path /dev/sda4
>>
>>          Btrfs v3.16
>>
>> btrfs fi df /:
>>
>>          Data, single: total=3D1.48TiB, used=3D1.48TiB
>>          System, DUP: total=3D32.00MiB, used=3D208.00KiB
>>          Metadata, DUP: total=3D11.50GiB, used=3D10.43GiB
>>          unknown, single: total=3D512.00MiB, used=3D0.00
>>
>> dmesg dump is attached.
>>
>> Please CC any responses to me, as I'm not subscribed to the list.
>>
>> Cheers,
>>
>> Rob
>>
>> [1] https://btrfs.wiki.kernel.org/index.php/Btrfs_mailing_list
>>
>>
> WRT the performance of Evolution, the issue is probably fragmentation o=
f
> the data files.  If you run the command:
> # btrfs fi defrag -rv /home
> you should see some improvement in evolution performance (until you get=

> any new mail that is).  Evolution (like most graphical e-mail clients
> these days) uses sqlite for data storage, and sqlite database files are=

> one of the known pathological cases for COW filesystems in general; the=

> solution is to mark the files as NOCOW (see the info about VM images in=

> [1] and [2], the same suggestions apply to database files).
>
> As for git, I haven't seen any performance issues specific to BTRFS; ar=
e
> you using any compress=3D mount option? zlib based compression is known=
 to
> cause serious slowdowns.  I don't think that git uses any kind of
> database for data storage.  Also, if the performance comparison is from=

> other systems, unless those systems have the EXACT same hardware
> configuration, they aren't really a good comparison.  Unless the pc thi=
s
> is on is a relatively recent system (less than a year or two old), it
> may just be hardware that is the performance bottleneck.
>
Realized after I sent this that I forgot the links for [1] and [2]

[1] https://btrfs.wiki.kernel.org/index.php/UseCases
[2] https://btrfs.wiki.kernel.org/index.php/FAQ


--------------ms030402070005000106060403
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTE5MTI1OTI3
WjAjBgkqhkiG9w0BCQQxFgQUBFvpt4fmmwAk6YDFTA75Qeb1TZ0wbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAwzwHghlgoyhtUvHdJEuysLLvOUCv
pZ5ty7+QySHMF8zBBPiA7ClAw4bv6gSJ9NK8b/n2BBTNT49f9TQvkP8yY/laLlwBmWTa8fLD
moSVfgn81Ec4Sbnnz5OFAiPimD6KVklfi8UdWh7C+jc5jIeO57lqgx0iE/4hs1reTJHp8F6l
4iyuXC993GCZF6LLl3ffCRNAu2FDDETYkRcfc/SHbVgBvkDk9r7/G3o6OnBn2CFBbSeqinKg
DbfveMlEKXapHGX/5DQGcTmHPdQ9RB+2WJ98BYWAbnguHWNIXLUQu45zCW52hyIFPvKLvYTc
4ArUlslV9PNXhioRvI9DF5J4VgAAAAAAAA==
--------------ms030402070005000106060403--
