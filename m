Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42437 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaLEMfJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Dec 2014 07:35:09 -0500
Received: by mail-ie0-f174.google.com with SMTP id rl12so576754iec.33
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 04:35:08 -0800 (PST)
Message-ID: <5481A678.8040006@gmail.com>
Date: Fri, 05 Dec 2014 07:35:04 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Recent issues with btrfs fi df
References: <5480704F.6000302@gmail.com> <548161FE.3030301@jp.fujitsu.com> <5481A2D0.2050203@gmail.com>
In-Reply-To: <5481A2D0.2050203@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090707020409010305020904"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090707020409010305020904
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-05 07:19, Austin S Hemmelgarn wrote:
> On 2014-12-05 02:42, Satoru Takeuchi wrote:
>> Hi Austin,
>>
>> (2014/12/04 23:31), Austin S Hemmelgarn wrote:
>>> I've recently noticed on some of my systems, that btrfs fi df
>>> doesn't consistently show all of the chunk types.
>>> I'll occasionally not see the GlobalReserve, or even anything
>>> but System,
>>
>> For one Btrfs file system, "how inconsistent" is the same even if
>> time passes? In other word,
>>
>>    a) Once "GlobalReserve" becomes to be not shown, it keep as is
>>       after tha, or
>>    b) Oneday "GlobalReserver" disappeared. Howevert it appear again
>>       at the next day or so.
>>
> In general, once it changes the first time, things don't seem to change=

> again afterwards.
>>> although the behavior seems to be consistent for
>>> a given filesystem.
>>
>> Did you confirm the following things for your Btrfs file system?
>>
>>    a) btrfs scrub finishes without any problem, and
>>    b) dmesg doesn't show any suspicious message.
>>
> Scrub and dmesg both look fine, I've also run btrfsck in no-op mode and=

> that doesn't report any errors either.
>>> I'm using btrfs-progs 3.17.1 and kernel 3.17.4
>>> with grsecurity patches (although with much of the grsec stuff disabl=
ed)
>>> on all such systems.  I'd be happy to provide kernel .config or other=

>>> information for debugging on request.
>>
>> Could you tell me the following information, if possible?
>>
>>    - mkfs options and mount options
> In both cases that I currently have access to, I created the fs with:
> mkfs.btrfs -O extref,skinny-metadata,no-holes -F <device-name>
> and the mount option strings for the devices in question are:
> noatime,space_cache,ssd,autodefrag
> for /
> and:
> noatime,sync,nosuid,nodev,noexec,compress=3Dzlib,ssd,space_cache,autode=
frag for
> /boot
>>    - The output of btrfs fi df
> For /, I get:
>    Data, single: total=3D43.00GiB, used=3D40.76GiB
>    System, DUP: total=3D32.00MiB, used=3D16.00KiB
>    Metadata, DUP: total=3D1.50GiB, used=3D1.05GiB
> For /boot, I get:
>    System, single: total=3D32.00MiB, used=3D4.00KiB
>>    - .config
> I've attached a gzipped copy.
>>    - Any possible trigger to cause this problem
> There aren't any that I know of.
>>    - Btrfs specific operations, for example weekly btrfs scrub
> I run scrub weekly, and balance and fstrim as needed.
>>    - Do you have any system which works fine and uses a kernel
>>      without grsecurity patches?
> Yes, although said system has exclusively multi-device filesystems,
> while the affected one is all single device filesystems.
>>
>> In addition, running one of your system with
>>
>>    - upstream kernel without grsecurity, and
>>    - btrfs file system with which btrfs fi df works correctly,
>>
> I've got a recovery environment built using buildroot that is based on
> the same kernel version without grsec patches, I'll reboot into that an=
d
> see what it says.
OK, so it definitely appears to be a kernel issue, as btrfs fi df=20
reports everything correctly when used from the recovery environment,=20
both with the copy of btrfs-progs in the recovery environment, and the=20
copy from the root filesystem of the affected system.  I'm going to try=20
to bisect down to what option in my kernel config is actually causing=20
this, although it may be next week before I can actually do so.
>> can help to distinguish whether the problem comes from
>> upstream kernel (of course it includes btrfs) or grsecurity.
>> I'm not sure about grsecurity. however, I have encountered
>> many problems caused by security modules.
> I do have one other local kernel patch that I use, I've attached that a=
s
> well, although it should have no effect whatsoever on the fs code.
>
>



--------------ms090707020409010305020904
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjA1MTIzNTA0
WjAjBgkqhkiG9w0BCQQxFgQUgRA+n+LhMTSfJmlzGsQwDDa6JCowbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEA2LXn4URnBRF8JoJ8CDRo387Kgscp
dGthoe/vwDhA8BnZm/Vp9GFZ3jL7XejlZriApuwbLJGHCtj6G/bL1dFLURYS6jMdziIPUxlf
iiU0BvP1eNvR55d+ZE7gV9gn5XhuS5ueMwsonOaJYzhpFk6UkGPiIoheooki18pDLfWMPRa2
CKBsfPXzzXiKmoxsMbSPJN01WjGDUoXxsXWPvyOozCwEMckfM5Bhu43/WqdNN+eKE/yMQlJp
rwXGxreCN7lVGzHGAiN8XGBWJQMU5FnNeYTERxuanpO7zwjN7n3SspfA+DazuY6yui7nGKvX
Zt0GFLSdtTso61kqQ0GfEr32OwAAAAAAAA==
--------------ms090707020409010305020904--
