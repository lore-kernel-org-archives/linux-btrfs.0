Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloudserver020138.home.net.pl ([62.129.239.72]:44212 "EHLO
        cloudserver020138.home.net.pl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754476AbdFWRcI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 13:32:08 -0400
Message-ID: <594D4F03.5050507@sarach.com.pl>
Date: Fri, 23 Jun 2017 19:25:23 +0200
From: =?UTF-8?B?TWljaGHFgiBTb2tvxYJvd3NraQ==?= <michal@sarach.com.pl>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Exactly what is wrong with RAID5/6
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
In-Reply-To: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010604030309010409010705"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010604030309010409010705
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello group.

I am confused: Can somebody please confirm/deny, which RAID subsystem is
affected? BTRFS' RAID5/6 or mdadm (Linux kernel raid) RAID 5/6 ?

Are there some gotchas (in terms of broken reliability) when using
kernel one?

The web is full of legends, it seems that this confusion is quite common.=
=2E.

On 06/21/2017 12:57 AM, waxhead wrote:
> I am trying to piece together the actual status of the RAID5/6 bit of
> BTRFS.
> The wiki refer to kernel 3.19 which was released in February 2015 so I
> assume that the information there is a tad outdated (the last update
> on the wiki page was July 2016)
> https://btrfs.wiki.kernel.org/index.php/RAID56
>
> Now there are four problems listed
>
> 1. Parity may be inconsistent after a crash (the "write hole")
> Is this still true, if yes - would not this apply for RAID1 / RAID10
> as well? How was it solved there , and why can't that be done for RAID5=
/6
>
> 2. Parity data is not checksummed
> Why is this a problem? Does it have to do with the design of BTRFS
> somehow?
> Parity is after all just data, BTRFS does checksum data so what is the
> reason this is a problem?
>
> 3. No support for discard? (possibly -- needs confirmation with cmason)=

> Does this matter that much really?, is there an update on this?
>
> 4. The algorithm uses as many devices as are available: No support for
> a fixed-width stripe.
> What is the plan for this one? There was patches on the mailing list
> by the SnapRAID author to support up to 6 parity devices. Will the
> (re?) resign of btrfs raid5/6 support a scheme that allows for
> multiple parity devices?
>
> I do have a few other questions as well...
>
> 5. BTRFS does still (kernel 4.9) not seem to use the device ID to
> communicate with devices.
>
> If you on a multi device filesystem yank out a device, for example
> /dev/sdg and it reappear as /dev/sdx for example btrfs will still
> happily try to write to /dev/sdg even if btrfs fi sh /mnt shows the
> correct device ID. What is the status for getting BTRFS to properly
> understand that a device is missing?
>
> 6. RAID1 needs to be able to make two copies always. E.g. if you have
> three disks you can loose one and it should still work. What about
> RAID10 ? If you have for example 6 disk RAID10 array, loose one disk
> and reboots (due to #5 above). Will RAID10 recognize that the array
> now is a 5 disk array and stripe+mirror over 2 disks (or possibly 2.5
> disks?) instead of 3? In other words, will it work as long as it can
> create a RAID10 profile that requires a minimum of four disks?=20


--------------ms010604030309010409010705
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
CSqGSIb3DQEJBTEPFw0xNzA2MjMxNzI1MjNaMCMGCSqGSIb3DQEJBDEWBBTFEvEl350Zu1jc
g+lbcrsku3LhxzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIw
CgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0G
CCqGSIb3DQMCAgEoMIGaBgkrBgEEAYI3EAQxgYwwgYkwdTELMAkGA1UEBhMCSUwxFjAUBgNV
BAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQQIQZomB34SWuzck
NMxOBJ3R9DCBnAYLKoZIhvcNAQkQAgsxgYyggYkwdTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9y
aXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENsaWVudCBDQQIQZomB34SWuzckNMxO
BJ3R9DANBgkqhkiG9w0BAQEFAASCAQB+eX8h7wbfUbMkh8UuFuAokzlVi3Dg8uolZY7WrgHo
TeQDNs+mVmw+OgEWjhBC+icDGJ2BbSiWG9IuDYGXZ3gPPYfkh1YnOCKn+0B5NZTGhKdJ71yK
tb7XUHEDMtQQQsdGu1wqfDqp4TdvryGNfU3xjk/zSeWzo4M7TJLjWd/wIKaQXbYgc8DnpuEJ
c3ewda0Lk3IjcNRpe9YO8idikNpKt8akXr/0f1LUIkLRayNc1g4imqEFi9gDP75Z4I02fCH/
6tn1XIxs//1uvqtNxrx9qqcFCKKYMmlbEjkntiguo2RUQk0JPLwkoHEcZWhv331LODQ8YhSC
zKGcwInkoBJjAAAAAAAA
--------------ms010604030309010409010705--
