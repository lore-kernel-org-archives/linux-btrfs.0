Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35398 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbKSM3Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 07:29:24 -0500
Received: by ioc74 with SMTP id 74so86743593ioc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 04:29:23 -0800 (PST)
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
To: linux-btrfs.tebulin@xoxy.net, linux-btrfs@vger.kernel.org
References: <564CC90F.3060703@gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <564DC072.4060508@gmail.com>
Date: Thu, 19 Nov 2015 07:28:34 -0500
MIME-Version: 1.0
In-Reply-To: <564CC90F.3060703@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090906050601040603080606"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090906050601040603080606
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-18 13:53, linux-btrfs.tebulin@xoxy.net wrote:
>
> P.S.: Just as user feedback: For /srv I'm using on the very same system=

> ZFS since the very first day. With snapshots & all the fancy stuff like=

> ZRAID-1, lz4, ... My number of Issues there: 0
Since other people have adequately answered the main questions, I'll=20
just comment on this.

In general, ZFS is not a good comparison to BTRFS for anything but=20
features.  Just the open source version of ZFS has been around for more=20
than a decade, and it existed as proprietary code for quite a while=20
before that.  As such, it's had a lot longer to stabilize, has had=20
exponentially more testing, and in general is a lot more reliable.  As=20
such, aside from feature comparisons, ZFS is going to win in almost all=20
tests of performance, reliability, and usability for the foreseeable=20
future.  This doesn't mean you shouldn't use BTRFS (ZFS got to where it=20
is now exactly because _a lot_ of people use it), it just means you need =

to do a lot of homework, and ideally keep you system actually up to date =

(having all updates installed on Ubuntu doesn't really count in this=20
case, they're pretty bad sometimes about not properly tracking upstream=20
development (although they are significantly better than regular Debian))=
=2E


--------------ms090906050601040603080606
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE5MTIyODM0WjBPBgkq
hkiG9w0BCQQxQgRAJcW1oUGXP+SGSi9ucGFzB+amK7ky7qeGIGPYEyyKL65puY57jIq2DG97
Evch5To9RpPTf+aCznZE6f+xLTgsvTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBD93u/fLm41ZeiyKMiEIkN9ee8DFwd/rf855C0xrPUelyt0UO0
957/3bsgLCl3qdMtcrIbLYRyPDbRlih2FtYiqo60h4odHQ7GF24f6R0ScqMth3uudDOH5lla
Ibg/ZtvddUEC2kUlRRA5IjVPZrSV6UGkNlpzkXSTK5LT9AiSKD7Jt2S/7rNefRn0RBd0Q8zY
EIPTiEmdRDse/VeVZtLToza4SK5afvobeT7//3oygfxCa3a8EqvZexObDSgkuwV27e8S2j+m
2yzvI71rqgFnCpExs1li0WTlo6RDti0RAMuGC0KV+4yEqgjIL4znvTs54GknkhAEzKKT9a5y
EWsXseFLXmuWh3nfNuOL6u2Zs9KOsXOJa3bPtSAVJ16dV3cGYCy/Un/rLmckpVRYYzCNMufr
ycAKPyr2CWYPoxW3zVGT3i+2sIaoBd1zKiZ4l4mj7O0EX8n2oYAiQO/KqBmSafbpdAu3KYTp
KFebpoTBXJUa0hsubZ03Rz1GSqN4Lp78s4TzoAZDlTuP+5vViaqiU09GqqRq2cFQCA06OKDd
tIhnU49CJAyQAMPFqzBkk8m7OC9TFd7faETGsO859Lr7Az3Vy7865grUKwDhyGkhwuGJXGbp
Q1W7YGVFhygxMldXxvdSbckEqdKHhogUB1rHCJV61u2fPbnL487xuDDnCgAAAAAAAA==
--------------ms090906050601040603080606--
