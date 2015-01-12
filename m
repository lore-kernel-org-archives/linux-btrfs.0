Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:56490 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbALQcm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 11:32:42 -0500
Received: by mail-ie0-f181.google.com with SMTP id rl12so26062015iec.12
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 08:32:41 -0800 (PST)
Message-ID: <54B3F720.4070805@gmail.com>
Date: Mon, 12 Jan 2015 11:32:32 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs performance - ssd array
References: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com>	<54B3E03E.80606@gmail.com> <CAA7pwKN0-EtPA7Z+2AKSSzOqBOpUGETFFxm-U0umQcAzOkNxYA@mail.gmail.com>
In-Reply-To: <CAA7pwKN0-EtPA7Z+2AKSSzOqBOpUGETFFxm-U0umQcAzOkNxYA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090100020605020805070300"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090100020605020805070300
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-01-12 10:11, Patrik Lundquist wrote:
> On 12 January 2015 at 15:54, Austin S Hemmelgarn <ahferroin7@gmail.com>=
 wrote:
>>
>> Another thing to consider is that the kernel's default I/O scheduler a=
nd the default parameters for that I/O scheduler are almost always subopt=
imal for SSD's, and this tends to show far more with BTRFS than anything =
else.  Personally I've found that using the CFQ I/O scheduler with the fo=
llowing parameters works best for a majority of SSD's:
>> 1. slice_idle=3D0
>> 2. back_seek_penalty=3D1
>> 3. back_seek_max set equal to the size in sectors of the device
>> 4. nr_requests and quantum set to the hardware command queue depth
>>
>> You can easily set these persistently for a given device with a udev r=
ule like this:
>>    KERNEL=3D=3D'sda', SUBSYSTEM=3D=3D'block', ACTION=3D=3D'add', ATTR{=
queue/scheduler}=3D'cfq', ATTR{queue/iosched/back_seek_penalty}=3D'1', AT=
TR{queue/iosched/back_seek_max}=3D'<device_size>', ATTR{queue/iosched/qua=
ntum}=3D'128', ATTR{queue/iosched/slice_idle}=3D'0', ATTR{queue/nr_reques=
ts}=3D'128'
>>
>> Make sure to replace '128' in the rule with whatever the command queue=
 depth is for the device in question (It's usually 128 or 256, occasional=
ly more), and <device_size> with the size of the device in kibibytes.
>>
>
> So is it "size in sectors of the device" or "size of the device in
> kibibytes" for back_seek_max? :-)
>
size in kibibytes, sorry about the confusion, I forgot to correct every=20
instance of saying it was size in sectors after I reread the documentatio=
n.


--------------ms090100020605020805070300
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMTEyMTYzMjMy
WjAjBgkqhkiG9w0BCQQxFgQU83dwhh+/ONcJmlkzzZ+WO+JjRH8wbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAgJr8uxZLKdCfbfyxNb35KTl1GLF2
PCVZNDzenCQdx4dWxZ+L3lZu8VZwLf5XEIiVbMouM4L3bGDDyVDMq7dPqAaLwLsJW5mqn3a2
OQwxISi86UHgimJsIdawT+J2j+cd+XVSwq1STUf9SbrVySqsAxtfy80B03EDJ0ZoysDeQjmo
0Lq916jvx8HLlMDrdb0jsQbY6plcrwdt1yJbZsEYN37RdaSNyBx9sfCdx8irrWFcwYR2jg5i
3CWNQ72X3DsmILmpsOUPDGorLb9BdSaeZJm2LMzPqBMqVXJOgoo+WIVH2P+mZ1xrie9748Nj
PRq4q8P4DEv8QdtjB7a9ig97GQAAAAAAAA==
--------------ms090100020605020805070300--
