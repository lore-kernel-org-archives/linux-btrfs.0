Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:32883 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaKRMII (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 07:08:08 -0500
Received: by mail-ig0-f177.google.com with SMTP id uq10so5654909igb.10
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 04:08:08 -0800 (PST)
Message-ID: <546B36A4.2030101@gmail.com>
Date: Tue, 18 Nov 2014 07:08:04 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Brendan Hide <brendan@swiftspirit.co.za>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za>
In-Reply-To: <546AF572.2020101@swiftspirit.co.za>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010504050901000904070200"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010504050901000904070200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-11-18 02:29, Brendan Hide wrote:
> Hey, guys
>
> See further below extracted output from a daily scrub showing csum
> errors on sdb, part of a raid1 btrfs. Looking back, it has been getting=

> errors like this for a few days now.
>
> The disk is patently unreliable but smartctl's output implies there are=

> no issues. Is this somehow standard faire for S.M.A.R.T. output?
>
> Here are (I think) the important bits of the smartctl output for
> $(smartctl -a /dev/sdb) (the full results are attached):
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED
> WHEN_FAILED RAW_VALUE
>    1 Raw_Read_Error_Rate     0x000f   100   253   006    Pre-fail
> Always       -       0
>    5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
> Always       -       1
>    7 Seek_Error_Rate         0x000f   086   060   030    Pre-fail
> Always       -       440801014
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age
> Offline      -       0
> 202 Data_Address_Mark_Errs  0x0032   100   253   000    Old_age
> Always       -       0
>
>
>
> -------- Original Message --------
> Subject:     Cron <root@watricky> /usr/local/sbin/btrfs-scrub-all
> Date:     Tue, 18 Nov 2014 04:19:12 +0200
> From:     (Cron Daemon) <root@watricky>
> To:     brendan@watricky
>
>
>
> WARNING: errors detected during scrubbing, corrected.
> [snip]
> scrub device /dev/sdb2 (id 2) done
>      scrub started at Tue Nov 18 03:22:58 2014 and finished after 2682
> seconds
>      total bytes scrubbed: 189.49GiB with 5420 errors
>      error details: read=3D5 csum=3D5415
>      corrected errors: 5420, uncorrectable errors: 0, unverified errors=
:
> 164
> [snip]
>
In addition to the storage controller being a possibility as mentioned=20
in another reply, there are some parts of the drive that aren't covered=20
by SMART attributes on most disks, most notably the on-drive cache.=20
There really isn't a way to disable the read cache on the drive, but you =

can disable write-caching, which may improve things (and if it's a cheap =

disk, may provide better reliability for BTRFS as well).  The other=20
thing I would suggest trying is a different data cable to the drive=20
itself, I've had issues with some SATA cables (the cheap red ones you=20
get in the retail packaging for some hard disks in particular) having=20
either bad connectors, or bad strain-reliefs, and failing after only a=20
few hundred hours of use.


--------------ms010504050901000904070200
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMTE4MTIwODA0
WjAjBgkqhkiG9w0BCQQxFgQUACID/oyojtGVK7dkJ5/rUC5CHk4wbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEADr2NMLRvtECxmVHvoqi1gua5ZJas
sD1L7yCz4lT9WJpLSmdYaivbnFJCfHo0DCVqT127FX50jFjqcLNkXT3aKkqAoyjPQYuy6plO
HMIMPOTqA3kHVCz57AK7UMkLvC9lSS/u3oraqL2gONkpIGuGD2ThFa0n+gRq8XAhyhSNcSjl
LsqsnLOdg2jyl91iF53QW1JlwhovQu4pE0+m5nXa7qdRQscsylvEaf1BBKGYOTFxd5X0dZE7
WdqBWqS2LMKQRNhC+kUE5XgUBhaPoowXGY+GfkJYTMnjrJDT4DtvrfN3WGOTyNofm9vfR04F
cwLPQ+wtp4VGvNkylIXVTg7gfgAAAAAAAA==
--------------ms010504050901000904070200--
