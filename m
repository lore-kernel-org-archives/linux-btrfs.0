Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34566 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaLVT4x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 14:56:53 -0500
Received: by mail-ig0-f170.google.com with SMTP id r2so5790424igi.3
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 11:56:52 -0800 (PST)
Message-ID: <5498777F.8070808@gmail.com>
Date: Mon, 22 Dec 2014 14:56:47 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>	<54982A79.1090102@gmail.com>	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>	<54985E4C.40003@gmail.com> <CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>
In-Reply-To: <CAJCQCtRyiGU65cGWW=QCoGeqmUFi=GY5YraqadLaOpjHUGSh8g@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080802020700070400040004"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080802020700070400040004
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-22 13:43, Chris Murphy wrote:
> On Mon, Dec 22, 2014 at 11:09 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> Personally, I'd love to see unlimited length xattr's like NTFS and HFS=
+ do,
>> as that would greatly improve interoperability (both Windows and OS X =
use
>> xattrs, although they call them 'alternative data streams' and 'forks'=

>> respectively), and provide a higher likelihood that xattrs would start=

>> getting used more.
>
> This is two years old, but it looks like NFS will not support xattr.
> http://comments.gmane.org/gmane.linux.nfs/53259
>
> It looks like SMB does support xattr (and sometimes requires it) but I
> have no idea to what degree, including the host/client preservation on
> different filesystems. [1] It would still be helpful for cp and rsync
> to be able to preserve xattr, however Apple has moved to a new on-disk
> format that makes the future of reading OS X volumes on Linux an open
> question. [2]
>
>
>
>
> [1]e.g. Btrfs > Samba- server > SMB over TCP > "Apple SMB2" > HFS+.
> And then the OS X client pushing a file to the server is a separate
> test. Next test would be OS X as server and Linux as client to do HFS+
>> "Apple SMB2" > SMB over TCP > Samba-client > Btrfs, and then Linux
> client pushing a file to OS X is a separate test. So it's four tests
> for any combination of filesystems.
>
> [2] Apple has a logical volume manager called CoreStorage. Until
> recently it's mainly used to implement full disk (volume) encryption,
> but encryption is actually optional. It's also used to combine SSD+HDD
> partitions into a single logical volume using the SSD as a cache.
> Starting with 10.10 "Yosemite" it's used by default for the main
> HFSJ/X volume for system/apps/user data, and even legacy OS X only
> installations are converted to a CoreStorage logical volume upon
> upgrading. There's no pre-baked support on linux for this right now,
> and I'm not really sure if/when we'd ever see this in a distribution
> by default.
> http://www.cl.cam.ac.uk/~osc22/docs/cl_fv2_presentation_2012.pdf
> https://github.com/libyal/libfvde/
>
>
I'm more thinking along the lines of not having to jump through hoops to =

get _ALL_ the data in a tar file from OS X to extract on a Linux box.=20
Also, Windows has been using it's 'alternative data streams'=20
functionality from NTFS more in recent years (the new 'file history'=20
functionality in Win8/8.1 uses ADS for storing old copies of files), and =

these are essentially just forks with a extra compatibility interface.=20
There are other potentially interesting uses though, for example,=20
storing multiple localized versions of a text file as a single=20
user-visible 'file'.


--------------ms080802020700070400040004
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjIyMTk1NjQ3
WjAjBgkqhkiG9w0BCQQxFgQULWs+wZh9NqqxWp6J6ARJ2nyny/IwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAJqBqEeNR3C3PQ9LIbXpnPE4CO7PR
4GVfmj8D2SIfL7vKViFbK9n2Oz5BrtvPzkG6zvLz0iZ1i4qZ71gW9t7NOfWOUbkkaAjqZPIp
CghuJkmXPgISvzjhOUl5CA3FIHaEj8NpYHAMc4N8cE/ZlwRtEoVeLlk/3WoLTJ24YY79vVjk
ZAL54XHtD+Y9U2K8cyl05zvGAq9MW6/y05TpuioHIryicSR9P+vr4qTQRffB7Wq2YpRY24Ag
3ruukWbEwDmcRtYfBle6Rz/UH7d8L7OlJazI0LQYRdUQCqh6xaQX/KKcpry87lovloVgbveZ
qzkhu3scLZ9edKSTiz39GDyPgQAAAAAAAA==
--------------ms080802020700070400040004--
