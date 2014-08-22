Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:52661 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaHVTSt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 15:18:49 -0400
Received: by mail-ig0-f174.google.com with SMTP id c1so169245igq.7
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 12:18:48 -0700 (PDT)
Message-ID: <53F79794.1060307@gmail.com>
Date: Fri, 22 Aug 2014 15:18:44 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Rich Freeman <r-btrfs@thefreemanclan.net>
CC: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Distro vs latest kernel for BTRFS?
References: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>	<53F731BC.6000200@gmail.com> <CAGfcS_=ArzTNUGCmyhcOSL-acTgfThF5XVu_-AHVaCssmsuKkQ@mail.gmail.com>
In-Reply-To: <CAGfcS_=ArzTNUGCmyhcOSL-acTgfThF5XVu_-AHVaCssmsuKkQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080108090205030006010403"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080108090205030006010403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-08-22 14:22, Rich Freeman wrote:
> On Fri, Aug 22, 2014 at 8:04 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>>>
>> I personally use Gentoo Unstable on all my systems, so I build all my
>> kernels locally anyway, and stay pretty much in-line with the current
>> stable Mainline kernel.
>=20
> "Gentoo Unstable" probably means gentoo-sources, testing version,
> which follows the stable kernel branch, but the most recent stable,
> and not the long-term stable.  gentoo-sources stable version generally
> follows the most recent longterm stable kernel (so 3.14 right now).
> I'm not sure what the exact policy is, but that is my sense of it.
>=20
> So, you're still running a stable kernel most likely.  If you really
> want mainline then you want git-sources.  That follows the most recent
> mainline I believe.  Of course, if you're following it that closely
> then you probably should think about just doing a git clone and
> managing it yourself, since then you can handle patches/etc more
> easily.
>=20
> I think the best option for somebody running btrfs is to stick with a
> stable kernel branch, either the current stable or a very recent
> longterm.  I wouldn't go back into 3.2 land or anything like that.
>=20
> But, yes, if you had stuck with 3.14 and not gone to the current
> stable then you would have missed the compress=3Dlzo deadlock.  So, pic=
k
> your poison.  :)
>=20
> Rich
>=20
By saying 'unstable' I'm referring to the stuff delimited in portage
with the ~ARCH keywords.  Personally, I wouldn't use that term myself
(all of my systems running on such packages have been rock-solid stable
from a software perspective), but that is how the official documentation
refers to things with the ~ARCH keywords.  There are a lot of Gentoo
users who don't know about the keyword thing other than as an occasional
inconvenience when emerging certain packages, so I just use the same
term as the documentation.

For the record, I am using the gentoo-sources package, but instead of
using what they mark as stable (which is 3.14), I'm using the most
recent version (which is 3.16.1).


--------------ms080108090205030006010403
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwODIyMTkxODQ0
WjAjBgkqhkiG9w0BCQQxFgQUl8MNh87k0TkcpiLScl9yDEjXsIAwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAquxZYKwq/m81ATpr5pC7UTEyYoG7
jjuRDyxxf6iO/ww14rdvoqN4kCzKz3C+NywKQaz7/qx6K7j09mCBokwEpR+OaFEIqTdDX7KB
ks/xBWPuRsTHS76ngHSLgdyvJqeJ5C5WFIxOaLYv4kOqgrmhgBNqvdnlQp5bZkkhcnv9e+Qc
E5nn/P7wcWICnRfZxtahVYNEehCfJgDlxK9G5E5cgb0Q087m1WHGDjfnSBTYqbNk6y+EbDgG
yv3pxAwxe93yx61aPJ6i5VAie+KAGZiuzvWvD1WG99GV34dpv2UxnfokfSAYWCycgHv2RVij
mcAimu96eehEdmpvVZbRSJB1ZgAAAAAAAA==
--------------ms080108090205030006010403--
