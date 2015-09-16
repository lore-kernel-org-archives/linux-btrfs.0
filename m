Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34212 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbbIPPUM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 11:20:12 -0400
Received: by iofb144 with SMTP id b144so234429123iof.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 08:20:12 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.googlemail.com with ESMTPSA id n14sm10557211ioi.15.2015.09.16.08.20.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2015 08:20:10 -0700 (PDT)
Subject: Re: FYIO: A rant about btrfs
To: linux-btrfs@vger.kernel.org
References: <20150916144355.GA1285@invalid>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F988A6.8070109@gmail.com>
Date: Wed, 16 Sep 2015 11:20:06 -0400
MIME-Version: 1.0
In-Reply-To: <20150916144355.GA1285@invalid>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030107090405080000020709"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030107090405080000020709
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-16 10:43, M G Berberich wrote:
> Hello,
>
> just for information. I stumbled about a rant about btrfs-performance:
>
>   http://blog.pgaddict.com/posts/friends-dont-let-friends-use-btrfs-for=
-oltp
>
> 	MfG
> 	bmg
>
It is worth noting a few things that were done incorrectly in this testin=
g:
1. _NEVER_ turn off write barriers (nobarrier mount option), doing so=20
subtly breaks the data integrity guarantees of _ALL_ filesystems, but=20
especially so on COW filesystems like BTRFS.  With this off, you will=20
have a much higher chance that a power loss will cause data loss.  It=20
shouldn't be turned off unless you are also turning off write-caching in =

the hardware or know for certain that no write-reordering is done by the =

hardware (and almost all modern hardware does write-reordering for=20
performance reasons).
2. He provides no comparison of any other filesystem with TRIM support=20
turned on (it is very likely that all filesystems will demonstrate such=20
performance drops.  Based on that graph, it looks like the device=20
doesn't support asynchronous trim commands).
3. He's testing it for a workload is a known and documented problem for=20
BTRFS, and claiming that that means that it isn't worth considering as a =

general usage filesystem.  Most people don't run RDBMS servers on their=20
systems, and as such, such a workload is not worth considering for most=20
people.

His points about the degree of performance jitter are valid however, as=20
are the complaints of apparent CPU intensive stalls in the BTRFS code,=20
and I occasionally see both on my own systems.


--------------ms030107090405080000020709
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE2MTUyMDA2WjBPBgkq
hkiG9w0BCQQxQgRA+UaC3UtgeqTU76DRUz+D2RI6scbEhIeIC/mzBLLaj70xUiqcNzw/d7Og
hNT3fkdQxDzH0vyQ4md4y5pqcxJqXjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBarBgAba4F0+0/3XGm+t/NKiqsHxecnm4z6KDLlyoDRzMAOxOC
708sZSrPSpR2sJz894KoQ/U8goh6yT1WQ/yzXUxf0PqMnTitrskgCOe/kYgF20aEiu3R8+MV
6D5BsYtW7F9LtECuRcb6SeKOP5585ZeRzULR4fEIR+h9U/QHFaN9fwFU3UhmgEo2pLn9dV39
Zw5NJr6EkDNwqB7urCfGtglA9X4CUNN/jDNNwDsP/YjH8e/llFr4ya5HNJC4G122qw7r+ngm
X8jswlZ8+mOq1WIlX8WpCSEQ5p5vNyE3iRrKlMshs6VOziPaldYIZ8HN/sIUVhu4QxEm4yA2
l+LlgttXg3JIAlbtW4Uelw0p2QSewUIY6fQFs3sINrlKHzztPOK1HbZPD5Zo1zyUe2YfeAVH
cCKttlkuoCArtGAz5Pq16SBD1PJhX6cmfdAprEqvsUqR8MhEAvBdFqhcEZ96cqwAF+qvelZu
CS3CKXyKWd/cjDa8RcUGjGI4DruMvsKKdRFsmLsICP2HIEOiEDKgNtjsBHpRrnoitOEmmdmq
oYKPOPhmcIr6lLUEcGu15tl/8oFch3wMIMZd/uLdctb2XH3+XLGF0ujTh3w22+ABn77zmXUm
+Rhi4igaHGER8w1LQnrYRbgCIxTGbSfJQ4sfLluYYrK7KWNo1f2thwFlygAAAAAAAA==
--------------ms030107090405080000020709--
