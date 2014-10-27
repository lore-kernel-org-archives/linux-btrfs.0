Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46391 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJ0MFB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 08:05:01 -0400
Received: by mail-ie0-f169.google.com with SMTP id tr6so4143132ieb.14
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 05:05:00 -0700 (PDT)
Message-ID: <544E34E8.2060103@gmail.com>
Date: Mon, 27 Oct 2014 08:04:56 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Larkin Lowrey <llowrey@nuclearwinter.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: Heavy nocow'd VM image fragmentation
References: <5449898B.4090708@nuclearwinter.com>	<20141024114916.GI12554@merlins.org> <544B0DDC.1020102@pobox.com> <pan$37631$612ebdea$68e82275$b6e96b7b@cox.net> <544D2D6D.6050301@nuclearwinter.com>
In-Reply-To: <544D2D6D.6050301@nuclearwinter.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030905060704000906050200"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030905060704000906050200
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-26 13:20, Larkin Lowrey wrote:
> On 10/24/2014 10:28 PM, Duncan wrote:
>> Robert White posted on Fri, 24 Oct 2014 19:41:32 -0700 as excerpted:
>>
>>> On 10/24/2014 04:49 AM, Marc MERLIN wrote:
>>>> On Thu, Oct 23, 2014 at 06:04:43PM -0500, Larkin Lowrey wrote:
>>>>> I have a 240GB VirtualBox vdi image that is showing heavy
>>>>> fragmentation (filefrag). The file was created in a dir that was
>>>>> chattr +C'd, the file was created via fallocate and the contents of=

>>>>> the orignal image were copied into the file via dd. I verified that=

>>>>> the image was +C.
>>>> To be honest, I have the same problem, and it's vexing:
>>> If I understand correctly, when you take a snapshot the file goes int=
o
>>> what I call "1COW" mode.
>> Yes, but the OP said he hadn't snapshotted since creating the file, an=
d
>> MM's a regular that actually wrote much of the wiki documentation on
>> raid56 modes, so he better know about the snapshotting problem too.
>>
>> So that can't be it.  There's apparently a bug in some recent code, an=
d
>> it's not honoring the NOCOW even in normal operation, when it should b=
e.
>>
>> (FWIW I'm not running any VMs or large DBs here, so don't have nocow s=
et
>> on anything and can and do use autodefrag on all my btrfs.  So I can't=

>> say one way or the other, personally.)
>>
>
> Correct, there were no snapshots during VM usage when the fragmentation=

> occurred.
>
> One unusual property of my setup is I have my fs on top of bcache. More=

> specifically, the stack is md raid6  -> bcache -> lvm -> btrfs. When th=
e
> fs mounts it has mount option 'ssd' due to the fact that bcache sets
> /sys/block/bcache0/queue/rotational to 0.
>
> Is there any reason why either the 'ssd' mount option or being backed b=
y
> bcache could be responsible?
>

Two things:
First, regarding your question, the ssd mount option "shouldn't" be=20
responsible for this, because it is supposed to spread out allocation=20
only at the chunk level, not the block level, but some recent commit may =

have changed that.  Are you using any kind of compression in btrfs?  If=20
so, then filefrag won't report the number of fragments correctly (it=20
currently reports the number of compressed blocks in the file instead),=20
and in fact, if you are using compression in btrfs, I would expect the=20
number of compressed blocks to go up as you use more space in the VM=20
image, long runs of zero bytes compress well, other stuff (especially=20
on-disk structures from encapsulated filesystems) doesn't.  You might=20
consider putting the vm images directly on the LVM layer instead, that=20
tends to get much better performance in my experience than storing them=20
on a filesystem.

Secondly, I'd recommend switching from using bcache under LVM to using=20
dm-cache on top of LVM, as it makes it much easier to recover from the=20
various failure modes, and also to deal with a corrupted cache, due to=20
the fact that dm-cache doesn't put any metadata on the backing device.=20
It takes longer to shutdown when in write-back mode, and isn't SSD=20
optimized, but has also been much more reliable in my experience.


--------------ms030905060704000906050200
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDI3MTIwNDU2
WjAjBgkqhkiG9w0BCQQxFgQUjqLiY6Mi+jVOWvgDF0bGnzjoeHIwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAu7TG75+zc43WiJymauVOsLJMCuJI
i9iULbqmETMGGdyRsPf44hFyUXpLiJDsBwjvi2bDWFrY9DYW7KTlNOQH7OqYFRXSQOAr1SYI
SzbU3ct79hoHYgHlc6268X5u6i1WwpJKIQqjXLmZTOtb4EPqAMg8MhncrLRrpiNoEn+/714p
uotcenb0g2HVfqH8AgxzHMwWr31YHmZEE9GQFL7BHQqxk1Y/GXQCNmV1QaZDZndLwBkBecFh
VYsAsl+PknHTOHAqqmuJ9nalOsJlsmgFGhByZfEk9Lh+ZQAoKgklnn8wu5d5ss7BrDeQYMe7
VsWacQ68GFC5Ayn7PtiBpV2vVQAAAAAAAA==
--------------ms030905060704000906050200--
