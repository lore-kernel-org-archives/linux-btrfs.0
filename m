Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:32940 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbbLAPQz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 10:16:55 -0500
Received: by igcmv3 with SMTP id mv3so96029268igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Dec 2015 07:16:54 -0800 (PST)
Subject: Re: utils version and convert crash
To: Gareth Pye <gareth@cerberos.id.au>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
 <CA+WRLO-1K5sRYiVQ0tEF+WUHJFSe++3fWHaqZ7ZvkhopFaWcbw@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565DB9B6.6000602@gmail.com>
Date: Tue, 1 Dec 2015 10:16:06 -0500
MIME-Version: 1.0
In-Reply-To: <CA+WRLO-1K5sRYiVQ0tEF+WUHJFSe++3fWHaqZ7ZvkhopFaWcbw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060602000601070700060102"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060602000601070700060102
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-01 07:57, Gareth Pye wrote:
> Poking around I just noticed that btrfs de stats /data points out that
> 3 of my drives have some read_io_errors. I'm guessing that is a bad
> thing. I assume this would indicate bad hardware and would be a likely
> cause of system crashes.
In general, given that info, I would suggest that you do the following:
1. Run btrfs device stats -z to reset the counters (they're running=20
counts stored on disk, not counts of recent errors or errors since last=20
boot, so the numbers are probably over the lifetime of the filesystem=20
right now).
2. Run a scrub on the filesystem (if you add -Bd, you get stats=20
per-device when it's done, although it runs in the foreground).  If the=20
scrub reports no errors, it's less likely that the issue is hardware=20
than software (or just the system having crashed).
3. Regardless of the scrub results, use smartctl (usually found in a=20
package called smartmontools or something similar) to check what the=20
disk firmware thinks about how healthy the disk hardware is.=20
Interpreting anything beyond the SMART attributes and the SMART health=20
status is somewhat difficult without a lot of experience and some=20
significant low-level knowledge of the hardware and software, but if the =

disk says it's healthy (check smartctl -H, and possibly smartctl -A),=20
then it's _probably_ OK.
4. Check your kernel logs for messages about ATA link resets.  If you=20
see a number of these, check your cables.  If the cables are fine=20
(securely connected, don't appear damaged), then this may be an early=20
indication of failing hardware (although there are other non-failure=20
hardware issues this can be indicative of).

In general, read-errors are not a huge issue as long as you scrub the=20
filesystem regularly (unless you get a lot in a short period of time, in =

which case you should be worried).  When you start getting write errors=20
or link resets (like mentioned in step 4 above), or when the SMART=20
pre-failure attributes hit their thresholds is when you should be=20
getting worried and start actively looking for a replacement disk (and=20
verifying your backups).


--------------ms060602000601070700060102
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjAxMTUxNjA2WjBPBgkq
hkiG9w0BCQQxQgRAU/HdPrb74g8QSqc7C1wcqWJ3dGZXQFtdUqNKhJCDeUp0Ax+JDmvt3oeE
DNTOyhm2Y2okQQm4kv2UsBs/o/OYYTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAIZqGWKweu/DBAaPXPxxH9GvgVVKVpqKBKGbhHHhFTz2qGelzL
G7WqfrU4/sofIIxisxgGv3G9RQG/BUsVBNGLBIvvtsw2jFhgnjz3o+4GP5ut4XNqW68IynvV
dR4EHX6oUPbCSADvyW8m9WyEY4D1UtRxLNrMahXOzE/1onJKHMIfYKDdSl9uhN2pxZG2LTDg
OAxWHrpAKx3f7B6FMaP/u3rOLiNE8CcztZZdzxHLuKVdn3CjgXho/lyzmglcOQYVfkftliBE
/rOa7y+zT6QT0V+e/wBcyCzkg3ffGrY33dtKbB3zW8BaTrWgpeV4vOsarxX+y58L6neWmIx/
ae4yYT34dQSaj3nJPjbAYWsLDeodJUxmpyArQplN+YMxRjC6yf2AWdw2jmP/Q+M4yT7xfwFY
ox0czmOZ4lskig8TM2FR+wGgw5mD5NJTWARQcrtKaZSE6DR6DpsjaMNgf6R50V+x6kfmGzub
d4oWMo/85L97EG4NPguwxwBfL/CeCBi+bGrxke50qL+2PlpS349dX+qJSMkYJcJiL7U1szhv
5DQbfzgdJ0hnMImAms08PFzIpp1R3C3TftclOOzykQKVMwYGIcXDxCk81yRPs0Ztp5NPs2M2
NwQXA30x8//9HBvseFUczVWsmUMF91ybWcrJqf2QXi0qpIodbZqmMsxrwgAAAAAAAA==
--------------ms060602000601070700060102--
