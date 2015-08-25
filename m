Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33447 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbbHYR7m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:59:42 -0400
Received: by iods203 with SMTP id s203so196479761iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 10:59:41 -0700 (PDT)
Subject: Re: Response to Bcachefs Claims
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1440516154.040713246@apps.rackspace.com>
 <CAJCQCtTSU08EjVrYGyL5TuXsEtTEmkAkpZ4XjM5rMXVZLQsjPA@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55DCAD07.1020500@gmail.com>
Date: Tue, 25 Aug 2015 13:59:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTSU08EjVrYGyL5TuXsEtTEmkAkpZ4XjM5rMXVZLQsjPA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000808070603060805060602"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000808070603060805060602
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-25 12:39, Chris Murphy wrote:
> On Tue, Aug 25, 2015 at 9:22 AM, Vincent Olivier <vincent@up4.com> wrot=
e:
>
>> For my own sake and other's I would like to maintain (if nobody is alr=
eady working on that nor needs any help) a centralized human-readable dig=
est of known issues that would be featured prominently on top of the Btrf=
s wiki. I would merge the Gotchas page and the various known issues pages=
 (including the various multi-device mount gotchas here and there).
>
> Some way to organize problems by distribution would be needed to be com=
plete.
>
> For example I don't have the discover & mount by label or uuid problem
> you mention on Fedora, since forever. I haven't experienced it on
> Fedora 19/20 which is approximately what CentOS 7 is based on. To
> figure that out means using one or more boot parameters:
> systemd.log_level=3Ddebug or rd.udev.debug or rd.debug to find out
> what's happening.
That would be because the Fedora initrd does a device scan before trying =

to mount root.  Most of the big distro's do this now, but of course you=20
need to be using an initrd for it to work.
> The one problem case I still have with the latest versions is multiple
> device Btrfs volume UUID doesn't exist when 1 or more devices are
> missing.
I've seen this myself, but only sometimes.  Based on my own testing, it=20
only seems to happen when one of the disks with a system chunk on it is=20
missing (for example, in a 3 device raid1 setup, one of the disks won't=20
have a system chunk on it, and if disk goes missing, I can still mount=20
by UUID fine).



--------------ms000808070603060805060602
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI1MTc1OTM1WjBPBgkq
hkiG9w0BCQQxQgRA10T/oZKS+RS2jnAbPuAVyMRV890CVzq4bmpA1soOR2mV0A3tfS0hABOz
KDP6fbU6XUh4B3Qrf6fvgS2r8tB26DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAFmOS9dEVWYNEqoTF/qX69yp1D9FNu6sEXJxjh1JoH4I9Nt4sj
jbnGT8Lwvuyff5JAmC2c5w+cFoSv5PU6MRCHebZ4eNR1X0Vo8oRD2j1n1DnMchChlfysMnwI
ha0k4mQDVCOQnw5ssnFZiRBy9kJI+IjRgBki/9rJgn8jZ8CgV1a0Ew353P5cF7r9r/ALQ+Xk
xQD9BOQxyRUbLHziWV3FYHmrqA6sopXHQguDUJTZm9hZ9cz299e7l25FuvM67X3fVcYqKCr6
PIG6YXXhxUGegYUUiDsSy4CnKi7247ysQXCVr02HiU25DUKPdrvW+aaJ51IcRlZfsOoaPrTF
B8RxFfdVdgXmZQdP7As4+KQQPRFDWeziPnGcB2m+HA85ztSpZYxsnJT1+C65xaV739Yw01dn
VawiboJHT+/v5hRHWPpCrHo7WDPXI4A8h/s+/2fi1/EFcCUdJ7G7DNiDeGHx9xPhiyCtnyDA
Z9t03jqHKx1ru5gxtqols+RE3y4xK/t+qTPAILYtsMCXHBgLZn2L52cMBtEWziav6RlkNF0y
14LG90KwH4SwtAC1VuRo1C+8OzvXueckJMSvvvieaDQOBeFOgyuOUrNcz2AlA4Eh5w4OYx6E
0rFxeaVXrzpBHbTVhEZtSmJh460QXCvtb70IHYdKm+eHmlteScBXuP63OQAAAAAAAA==
--------------ms000808070603060805060602--
