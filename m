Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35324 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbbHFLNQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Aug 2015 07:13:16 -0400
Received: by iodd187 with SMTP id d187so77360577iod.2
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Aug 2015 04:13:15 -0700 (PDT)
Subject: Re: BTRFS disaster (of my own making). Is this recoverable?
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAP5+4qewgAhZ=1qKyDMMAsHC39CH36VmuaEuyaaaTAWHeqzmYw@mail.gmail.com>
 <CAP5+4qfi4UdfMmNdC2XizTG0au-btnKBqSmg1rUaW=EJApZkmA@mail.gmail.com>
 <CAP5+4qdmjkniaoY6+FCL4OTAYQjpU=DOWBRv-3FkEvFN=TAeRw@mail.gmail.com>
 <20150803152835.GF14352@carfax.org.uk>
 <CAP5+4qfmXdMvBaVK1KqUfBRfM447ASJ4U0OqRxhsOw2r4WE1fQ@mail.gmail.com>
 <CAP5+4qd2-kKEG5y2gEphQ=5A4+B+=2teMxiZJc-vDHZ1_-t8OQ@mail.gmail.com>
 <CAP5+4qceVW2JbAteuRQUK+5mdwWcp8fF0QUk6Q87nqCw5P5wRw@mail.gmail.com>
 <CAP5+4qfLEqvGQhCkzQWPLy-dtAS7GjSfDy5Oo=6OXL1zohrc=Q@mail.gmail.com>
 <CAP5+4qcdn9eeHk=EgpUjNC2T+fxwimRit+BRsxQDv6k1Bb=Gqg@mail.gmail.com>
 <pan$f64e$1c059550$ef240e25$d6d81c77@cox.net>
 <CAP5+4qcfn_nPwD0eeMGJGuB5nEkSg0rbjnV6AUnCmEnJ5qu20w@mail.gmail.com>
 <CAP5+4qePXJuxv4FRdNSy-wsHTSr=iuJYrqdOwfYw4tOESiCCug@mail.gmail.com>
 <CAJCQCtSFcXhC9xBLia0uns64PdLPQXwEPin=sxSOsdhW+tD2Yg@mail.gmail.com>
 <B7F2379062E32745A8651FBDB20F64596115AB1F@Server.waterlogic.com.au>
 <CAJCQCtTzV-YsBVRUAYqZVNP2M3QZfx9gGbOJ3ZY6ZrjEEWvvfQ@mail.gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55C3413D.6010202@gmail.com>
Date: Thu, 6 Aug 2015 07:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTzV-YsBVRUAYqZVNP2M3QZfx9gGbOJ3ZY6ZrjEEWvvfQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080100070004000502050709"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080100070004000502050709
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-05 22:13, Chris Murphy wrote:
> On Wed, Aug 5, 2015 at 6:45 PM, Paul Jones <paul@pauljones.id.au> wrote=
:
>> Would it be possible to store this type of critical information twice =
on each disk, at the beginning and end? I thought BTRFS already did that,=
 but I might be thinking of some other filesystem. I've had my share of t=
hese types of oops! moments as well.
>
> That option is metadata profile raid1. To do an automatic
> -mconvert=3Draid1 when the user does 'btrfs device add' breaks any use
> case where you want to temporarily add a small device, maybe a USB
> stick, and now hundreds of MiBs possibly GiBs of metadata have to be
> copied over to this device without warning. It could be made smart,
> autoconvert to raid1 when the added device is at least 4x the size of
> metadata allocation, but then that makes it inconsistent. OK so it
> could be made interactive, but now that breaks scripts. So... where do
> you draw the line?
>
> Maybe this would work if the system chunk only was raid1? I don't know
> what the minimum necessary information is for such a case.
>
> Possibly it make more sense if 'btrfs device add' always does
> -dconvert=3Draid1 unless a --quick option is passed?
>
Perhaps we could print out a big noisy warning that could be silenced?


--------------ms080100070004000502050709
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODA2MTExMzAxWjBPBgkq
hkiG9w0BCQQxQgRAtSK8K+5yucZ61SiEKhno9MstsFsUWC1NjqJAAyJEFxt1UWKp0ncoB9cD
A0YfmOPj/sNRLWn5QUpYwoql4iBjejBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAC+oMzIwsOuIuOBg1X9BlgLALlAb8rF9181z1boWtKMKb9jdfL
qScCbKN2WdW0bD1RTQu0vHOhJx3dmKcD0DR5wXaVbsmGHbCbl9QVR8LqzuudmnWZgoG3E6s7
Ggm3ui6/ZZeXPGgrhO7YcIMj1heLGfmvO2dPKXGtA1lATRzfdbwtzKVvymLb8AWwF36+8/1J
hGaIqvDdkoPTzvqXn9LcOslDD2NI9vKkBbMVoGOKweVHHMJF7T1VWoH1thocS25H0DULuxQ6
Z+/wspALq2EYMwuUd1JVtcTrTD2oIStOAU1I+CczKKNg4Pir35fWdInpeBHlggabidueKNMH
7LFZQhwHDiEleMVu0fgLSOTygS9pWqYu347ZobMGUcTeJg9TJczv91BqERbg75rmumWv2gi8
SjyQlf86fjXd1sx+do4tfrTMXrFfYcWooSku9kTokDSy2fhSOFH6egUyFZZoT0DwJvpOYqAs
0+g7ipwQRbeMrBfMZzNVfSYXtVVLS2z652LAxz/8j1AAtSFKBe5C9HltwjtIlssgVoZKApbb
UdWiREh+2OYwQOk2e5gFPkpM7gS5LcD42wNut7DMY+aoC6rvc7KzAJ92ODfOszcti/MUzhmg
BNbIg/nfjyCgOeolKIQU59z5ZYAvfUx9cghx0yJ+9Cko77SqIAIl35tpAwAAAAAAAA==
--------------ms080100070004000502050709--
