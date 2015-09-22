Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35898 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557AbbIVTpG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 15:45:06 -0400
Received: by qkcf65 with SMTP id f65so8804982qkc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 12:45:05 -0700 (PDT)
Subject: Re: RAID1 storage server won't boot with one disk missing
To: Chris Murphy <lists@colorremedies.com>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
 <55FAD9CC.5060206@oracle.com> <pan$5cdb2$42505f02$e2b552bf$4a4e51e@cox.net>
 <CA+WRLO94UekKmT1cy3+t4+pHSCMj=HRoEF4oqtJDimS=EWnbhA@mail.gmail.com>
 <m49fv27cxyc.fsf@coffee.modeemi.fi> <56013C3C.6010005@gmail.com>
 <56014ECA.1050002@gmx.com> <560155C4.2080701@gmail.com>
 <CAJCQCtSK0AyjS8WX2V0K6nMgM3AmhFjTT6s5GcPF8EW8eKFN9Q@mail.gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Erkki Seppala <flux-btrfs@inside.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5601AFC1.8070006@gmail.com>
Date: Tue, 22 Sep 2015 15:45:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSK0AyjS8WX2V0K6nMgM3AmhFjTT6s5GcPF8EW8eKFN9Q@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090005020004080207060303"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090005020004080207060303
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-22 14:35, Chris Murphy wrote:
> On Tue, Sep 22, 2015 at 7:21 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> It's not a bad idea, except that it changes established usage, and the=
re are
>> probably some people out there who depend on the current behavior. If =
we do
>> go that way, mount needs to spit out a big obnoxious warning (as in, n=
ot
>> through dmesg or mount options, but directly on stderr) if the filesys=
tem
>> gets mounted degraded automatically.
>
> Definitely there needs to be a user space message. Even now when
> trying to mount a volume with a missing device without -o degraded the
> generic fs type unrecognized message is misleading.
I agree that it's confusing for many users, but from the point of view=20
of someone who's been doing system administration for a few years, the=20
'or incorrect mount options' bit does kind of make sense given the contex=
t.


--------------ms090005020004080207060303
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTIyMTk0NTA1WjBPBgkq
hkiG9w0BCQQxQgRAICcfwirerMd8GGHuGASuQObzI2z+V6sUEYaxdURHFPfrwkl8Ckpelw+s
A8lnKrd3omMAHn3XBs1oO30JgReoXjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBJ4rdbb91gP+kDzdxetNeHnYqOO4VARG9lMKXUWqL4iRY2MhPl
H4IfixUZhnAFNbazURneQZY9GG5KTycsteJ0BLUycqXzC5q6teequnZQ7o1xs3e449EOdOzX
usHGlw/+EugU54jzUj48ryUzesL3u2s4TXanuyh1G8rripGnfex+bWX6qLYJv627TgeuRWqc
8yBfYxAlVWSvWBtch//3iWfW3ADd+tgGYQTkVnHCCkKJJ0AaoAGNety4sim4dz2uOgaJxHZj
BqY3s0yY31Lb4kmX66bHNsEp52XxqGF6kE8+rxWJnlfJxsfsvxTJBxJiwPUZm/IFUd2peCmm
RBKihYcSviBBasuAeHif0kEV2B/PcvbNmNDVAXdGfOdobd42CBRMqQZs9dvTLBxHSDLbzfW+
sRItWyTg/kmafkaWed5/zveYQ/KrTI6LVBcZhVptdFgzZ8UaCt46mkJH8yVu+PJzd6DBj6Wh
8en+8WKQHSGuJ1OQWkUwnmFz9Z68e3VRuQHqS768cYPVpnIlTLicAEZKVJzZ4+UVkQ/JTeOR
T9XzdJFaXZDA2CBNnh2SPBvCAGOV3HgxBrg2gW2DgMZtJnqDfkt1rsL9STK5JISxMqV1SkE6
knkwuxh/Ut3sTyY3c1sBvrHXMlN9vbd2gOFE3wFd19zvP+8nLM6X9MGL+AAAAAAAAA==
--------------ms090005020004080207060303--
