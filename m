Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloudserver020138.home.net.pl ([62.129.239.72]:52086 "EHLO
        cloudserver020138.home.net.pl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751259AbdIOOLu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 10:11:50 -0400
Message-ID: <59BBDFA6.4020500@sarach.com.pl>
Date: Fri, 15 Sep 2017 16:11:50 +0200
From: =?UTF-8?B?TWljaGHFgiBTb2tvxYJvd3NraQ==?= <michal@sarach.com.pl>
MIME-Version: 1.0
To: =?UTF-8?B?VG9tYXN6IEvFgm9jemtv?= <kloczko.tomasz@gmail.com>
CC: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: defragmenting best practice?
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170912162843.GA32233@rus.uni-stuttgart.de> <20170914133824.5cf9b59c@jupiter.sol.kaishome.de> <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com> <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com> <59BBB15E.8010002@sarach.com.pl> <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
In-Reply-To: <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030807000906030401020700"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030807000906030401020700
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/15/2017 03:07 PM, Tomasz K=C5=82oczko wrote:
> [...]
> Case #1
> 2x 7200 rpm HDD -> md raid 1 -> host BTRFS rootfs -> qemu cow2 storage
> -> guest BTRFS filesystem
> SQL table row insertions per second: 1-2
>
> Case #2
> 2x 7200 rpm HDD -> md raid 1 -> host BTRFS rootfs -> qemu raw storage -=
>
> guest EXT4 filesystem
> SQL table row insertions per second: 10-15
> Q -1) why you are comparing btrfs against ext4 on top of the btrfs
> which is doing own COW operations on bottom of such sandwiches ..  if
> we SUPPOSE to be talking about impact of the fragmentation on top of
> btrfs?

Tomasz,
you seem to be convinced that fragmentation does not matter. I found
this (extremely bad, true) example says otherwise.

> Q 0) what do you think that you measure here?

Cow's fragmentation impact on SQL write performance.

> Q 1) how did you produce those time measurements? time command?
> looking on the watch?

Time command (real) of bash script inserting 1000 rows (index and 128B
random string).

> Q 2) why there are ranges of timings? did you repeat some operations
> few times (how many times and with or without dropping caches or doing
> reboots?)

Yes, we've repeated it. With and without flushing cache (it didn't seem
to have any impact). I cannot remember whenever there were any reboots.
Those big time ranges are because, I don't have exact numbers on me. It
was quick and dirty task to find, prove and remove performance
bottleneck at minimal cost. AFAIR removing storage cow2 and guest BTRFS
storage gave us ~ 10 times boost. Surprisingly for us this boost seems
to be consistent (it does not degrade noticeably over time - 2 months
from the change).

> Q 3) What kind of SQL engine? with what kind of settings? with what
> kind of tables? (indexes? foreign keys?) What kind of transactions
> semantics?

PostgreSQL and MySQL both gave us those results. *

> Q 4) where is the example set of inserts which I can replay in my
> setup? did you drop caches before batch of inserts? (do you know that
> every insert generates as well some number of read IOs so information
> is something is already cached before batch of inserts is *crucial*)
> Did you restart SQL engine?
> Q 5) are both test have been executed on the same box? if not which
> one version of the kernel(s) have been used?

Same distribution, machine and kernel. *

> Q 6) ) effectively how many IOs have been done during those tests? how
> did you measured those numbers (dtrace? perf? systemtap?)

I didn't check that. *

> Q7) why you are running your tests over qemu? Is it anything more
> running on the host system during those tests?

Because of "production" environment location. No, there was not.

*) If you're really interested in (which I doubt), then I can put
example environment somewhere and gather more data.


--------------ms030807000906030401020700
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIILDzCC
BSUwggQNoAMCAQICEGaJgd+Elrs3JDTMTgSd0fQwDQYJKoZIhvcNAQELBQAwdTELMAkGA1UE
BhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBD
QTAeFw0xNjA3MjkxMjA0MjRaFw0xOTEwMjkxMjA0MjRaMGwxJjAkBgNVBA0MHUZvciBsb2dp
biBhdXRoZW50aWNhdGlvbiBvbmx5MR0wGwYDVQQDDBRtaWNoYWxAc2FyYWNoLmNvbS5wbDEj
MCEGCSqGSIb3DQEJARYUbWljaGFsQHNhcmFjaC5jb20ucGwwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDD6nNl0HXUSQbyTtcgn6++PUyDTzlkutl1Gao/bT1OMbapBroQoMNr
431UUq7TWlaVkQoHojWOr5xZPXCjg3g9lL8CaT/r07K/dy6M9kKTFRB30QFFqEDNNuToGm0p
pjLdgXz1KZoXb47gAR5zo7nuDOyTRUHPNXHibYcJ/t9qVSzTl2F5pvgiePAJ+znZR3lQzWor
omYsYBpMaC8oxOEl4IZRVnd+0iyrXND/4g8qQj93OakyJiW17n6hh5PAdRLwt37t6qmX6suv
wLw3MjITsmoNLEcsNIOoaX57OOB7WdxhWrzLsrhZRVfmyC6BIxKd5DvvG7Tq9l+ieSnNvCdZ
AgMBAAGjggG4MIIBtDAOBgNVHQ8BAf8EBAMCBLAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsG
AQUFBwMEMAkGA1UdEwQCMAAwHQYDVR0OBBYEFA8czJfA8oqHl1tdqBjuSetTl9ZOMB8GA1Ud
IwQYMBaAFCSBbDlhvkkPj7cbRivJKLUnSG1oMG8GCCsGAQUFBwEBBGMwYTAkBggrBgEFBQcw
AYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDkGCCsGAQUFBzAChi1odHRwOi8vYWlhLnN0
YXJ0c3NsLmNvbS9jZXJ0cy9zY2EuY2xpZW50MS5jcnQwOAYDVR0fBDEwLzAtoCugKYYnaHR0
cDovL2NybC5zdGFydHNzbC5jb20vc2NhLWNsaWVudDEuY3JsMB8GA1UdEQQYMBaBFG1pY2hh
bEBzYXJhY2guY29tLnBsMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzBH
BgNVHSAEQDA+MDwGCysGAQQBgbU3AQIFMC0wKwYIKwYBBQUHAgEWH2h0dHBzOi8vd3d3LnN0
YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggEBAAoJvbh14v6Pji08WKR4nVub
FOGh8+7Sme/HalNJzNk2tTScivwvp8+pamict5BkBhM2W9tLIrHCzo0Gb06sF0idqCwzuhBl
XKzjOKI4dLZXZDCgBvEfMcOQSvwkHglw6Q1WAgpfXaP/ALw9gvvwh1OUQt+9GgQrxf3HKBbp
YtM2PddIV1Zi4fdwYNQ/AlM9smKl0DhU3Akj0EBjdKwPVEya2jbUMQI7YbM1I1p1c/s+OUOw
EPagagPVkx0SaWu5ySNe3aFIqvTyma+U4zNn34iVR05X7I5UeceLmOkWducPTQo//ZrHNn0o
ll6mlU8bF51YGULZdGvev1K6Ob0p/kcwggXiMIIDyqADAgECAhBrp4p9CteI1lEK+Vnk57Th
MA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQu
MSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQD
EyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xNTEyMTYwMTAwMDVaFw0z
MDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkw
JwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3Rh
cnRDb20gQ2xhc3MgMSBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQC9fdr3w6J9g/Zbgv3bW1+uHht1wLUZr5gkrLtXedg17AkefMyUGwrQdvwObhajcVmnKVxh
rUwkZPXRAwZZosRHfEIi5FH7x6SV/8Sp5lZEuiMnvMFG2MzLA84J6Ws5T4NfXZ0qn4TPgnr3
X2vPVS51M7Ua9nIJgn8jvTra4eyyQzxvuA/GZwKg7VQfDCmCS+kICslYYWgXOMt2xlsSslxL
ce0CGWRsT8EpMyt1iDflSjXZIsE7m1uTyHaKZspMLyIyz6mySu8j8BWWHpChNNeTrFuhVfrO
AyDPFJVUvKZCLKBhibTLloyy+LatoWELrjdI4a8StZY8+dIR9t4APXGzAgMBAAGjggFkMIIB
YDAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5j
b20vc2ZzY2EuY3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Au
c3RhcnRzc2wuY29tMDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0
cy9jYS5jcnQwHQYDVR0OBBYEFCSBbDlhvkkPj7cbRivJKLUnSG1oMB8GA1UdIwQYMBaAFE4L
7xqkQFulF2mHMMo0aEPQQa7yMD8GA1UdIAQ4MDYwNAYEVR0gADAsMCoGCCsGAQUFBwIBFh5o
dHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggIBAIvj94fs
AYuErQ8BAluc4SMnIwS9NPBwAm5SH9uh2NCXTq7im61g7F1LIiNI/+wq37fUuaMbz4g7VarK
QTgf8ubs0p7NZWcIe7Bvem2AWaXBsxsaRTYw5kG3DN8pd1hSEUuFoTa7DmNeFe8tiK1BrL3r
bA/m48jp4AiFXgvxprJrW7izsyetOrRHPbkW4Y07v29MdhaPv3u1JELyszXqOzjIYo4sWlC8
iDQXwgSW/ntvWy2n4LuiaozlCfXl149tKeqvwlvrla2Yklue/quWp9j9ou4T/OY0CXMuY+B8
wNK0ohd2D4ShgFlMSjzAFRoHGKF81snTr2d1A7Ew02oF6UQyCkC2aNNsK5cWOojBar5c7Hpl
X9aHYUCZouxIeU28SONJAxnATgR4cJ2jrpmYSz/kliUJ46S6UpVDo/ebn9c6PaM/XtDYCCaM
/7XX6wc3s++sbQ7CtCn1Ax7df6ufQbwyO0V+oFa9H0KAsjHMzcwk3EV2B2NLatidKE/m7G+r
B9m+FlVgIiSp0mGlg43QO9Kh1+JqvTCIzv2bJJkmPMLQJNuKKwHNL8F4GGp6jbAV+WL+LDeG
fVcq8DHS3LrD+xyYEXQBiqZEdiPVOMxLDSUCXsDO0uCWpaNQ8j6y6S9p0xE/Ga0peVLadVHh
qf9nXqKaxnr358VgfrxzUIrvOaOjMYIDvDCCA7gCAQEwgYkwdTELMAkGA1UEBhMCSUwxFjAU
BgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24g
QXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQQIQZomB34SW
uzckNMxOBJ3R9DAJBgUrDgMCGgUAoIICBzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0xNzA5MTUxNDExNTBaMCMGCSqGSIb3DQEJBDEWBBQFymGxjRqkM0LJ
+vMN04uoEKp/TTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIw
CgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0G
CCqGSIb3DQMCAgEoMIGaBgkrBgEEAYI3EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNV
BAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQQIQZomB34SWuzck
NMxOBJ3R9DCBnAYLKoZIhvcNAQkQAgsxgYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9y
aXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQQIQZomB34SWuzckNMxO
BJ3R9DANBgkqhkiG9w0BAQEFAASCAQAAyPIqgHAguyiFh5Wp6PRtcP9EzX+mKzZi2wCbkpJJ
AjPUZZDVRycFTUa6J/RcYdsk+uzrF7ftF/g86TH1708+eU4j8zqSzex2IYUsAXVe/fA85xt/
zLgSUlAMxAVhb7B6FDi7AIfHVXh6RBN/SToZNcwDlsuMcgyaMQ4j9aELH1Did1PolnevMR9H
2Bc4wc9HmD1JG/zOaqBGk7TLSPZ3Xr+funJM11IJwcprx/ZTvhYDyv2r+4bcSYwYU8KRIgrX
/Hwe/ijiJfvUPgMiZYAAvJxbONaBv6mgB/lbjawRwAeVzf5BisL5gz7+ykqH44QdlUuAQJQu
Y1/KQYNrUyPkAAAAAAAA
--------------ms030807000906030401020700--
