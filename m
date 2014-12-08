Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:54791 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaLHO54 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 09:57:56 -0500
Received: by mail-ie0-f181.google.com with SMTP id tp5so4590919ieb.40
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Dec 2014 06:57:55 -0800 (PST)
Message-ID: <5485BC6E.8010604@gmail.com>
Date: Mon, 08 Dec 2014 09:57:50 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>, Robert White <rwhite@pobox.com>
CC: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com> <1610909.CxuY1Bb9iL@merkaba> <548537D1.7070602@pobox.com> <1447188.5moEuATfqD@merkaba>
In-Reply-To: <1447188.5moEuATfqD@merkaba>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080701000000070309030200"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080701000000070309030200
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-08 09:47, Martin Steigerwald wrote:
> Hi,
>
> Am Sonntag, 7. Dezember 2014, 21:32:01 schrieb Robert White:
>> On 12/07/2014 07:40 AM, Martin Steigerwald wrote:
>>> Well what would be possible I bet would be a kind of system call like=

>>> this:
>>>
>>> I need to write 5 GB of data in 100 of files to /opt/mynewshinysoftwa=
re,
>>> can I do it *and* give me a guarentee I can.
>>>
>>> So like a more flexible fallocate approach as fallocate just allocate=
s one
>>> file and you would need to run it for all files you intend to create.=
 But
>>> challenge would be to estimate metadata allocation beforehand accurat=
ely.
>>>
>>> Or have tar --fallocate -xf which for all files in the archive will f=
irst
>>> call fallocate and only if that succeeded, actually write them. But d=
ue
>>> to the nature of tar archives with their content listing across the w=
hole
>>> archive, this means it may have to read the tar archive twice, so ZIP=

>>> archives might be better suited for that.
>>
>> What you suggest is Still Not Practical=E2=84=A2 (the tar thing might =
have some
>> ability if you were willing to analyze every file to the byte level).
>>
>> Compression _can_ make a file _bigger_ than its base size. BTRFS decid=
es
>> whether or not to compress a file based on the results it gets when
>> tying to compress the first N bytes. (I do not know the value of N). B=
ut
>> it is _easy_ to have a file where the first N bytes compress well but
>> the bytes after N take up more space than their byte count. So to
>> fallocate() the right size in blocks you'd have to compress the input
>> and determine what BTRFS _would_ _do_ and then allocate that much spac=
e
>> instead of the file size.
>>
>> And even then, if you didn't create all the names and directories you
>> might find that the RBtree had to expand (allocate another tree node)
>> one or more times to accommodate the actual files. Lather rinse repeat=

>> for any checksum trees and anything hitting a flush barrier because of=

>> commit=3D or sync() events or other writers perturbing your results
>> because it only matters if the filesystem is nearly full and nearly fu=
ll
>> filesystems may not be quiescent at all.
>>
>> So while the core problem isn't insoluble, in real life it is _not_
>> _worth_ _solving_.
>>
>> On a nearly empty filesystem, it's going to fit.
>>
>> In a reasonably empty filesystem, it's going to fit.
>>
>> On a nearly full filesystem, it may or may not fit.
>>
>> On a filesystem that is so close to full that you have reason to doubt=

>> it will fit, you are going to have a very bad time even if it fits.
>>
>> If you did manage to invent and implement an fallocate algorythm that
>> could make this promise and make it stick, then some other running
>> program is what's going to crash when you use up that last byte anyway=
=2E
>>
>> Almost full filesystems are their own reward.
>
> So you basically say that BTRFS with compression  does not meet the fal=
locate
> guarantee. Now thats interesting, cause it basically violates the
> documentation for the system call:
>
> DESCRIPTION
>         The function posix_fallocate() ensures that disk space  is  all=
o=E2=80=90
>         cated for the file referred to by the descriptor fd for the byt=
es
>         in the range starting at offset and  continuing  for  len  byte=
s.
>         After  a  successful call to posix_fallocate(), subsequent writ=
es
>         to bytes in the  specified  range  are  guaranteed  not  to  fa=
il
>         because of lack of disk space.
>
> So in order to be standard compliant there, BTRFS would need to write
> fallocated files uncompressed=E2=80=A6 wow this is getting complex.
The other option would be to allocate based on the worst case size=20
increase for the compression algorithm, (which works out to about 5%=20
IIRC for zlib and a bit more for lzo) and then possibly discard the=20
unwritten extents at some later point.



--------------ms080701000000070309030200
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjA4MTQ1NzUw
WjAjBgkqhkiG9w0BCQQxFgQUR+pVD0HMElUCgttL2a6Ioiari0owbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAZxPsYW3wd2iMIepDkTpFgYP1i5UY
1luLq/iOtb8K3gZGGhJeIL9gmPTsXJxVB5oyyjy+E6AnX53G3wAyxPR5nEi4yZeiqbnI2zEn
OBXA7d6iMTI5rXSpZbIlUsl6nJYybBNxGiDcUpfguKJ1mCkrFvjVuuAxqKFFyETxeWVhpQHF
0x4WjJcGnm+Z3wmY2wXX08yH+QcVrq9FkoASBm10egMvH7HSfdWhVX+WgUPV5XIyjVBW5Piy
XW4s53utj3Swc6GD9fJFTh+0yFpwWbZvNgc30sKXGjcl6DWRdG+p1T+XZRF5jmVdsRklWZ0H
0c/nkltVrrlugvcFJY+f+zW/3wAAAAAAAA==
--------------ms080701000000070309030200--
