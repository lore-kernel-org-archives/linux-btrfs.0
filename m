Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33085 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbbJ1MIY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 08:08:24 -0400
Received: by iodd200 with SMTP id d200so7705363iod.0
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 05:08:23 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.googlemail.com with ESMTPSA id ie20sm9849332igb.10.2015.10.28.05.08.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Oct 2015 05:08:21 -0700 (PDT)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: How to replicate a Xen VM using BTRFS as the root filesystem.
Message-ID: <5630BA78.1090804@gmail.com>
Date: Wed, 28 Oct 2015 08:07:20 -0400
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010507070902060004080406"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010507070902060004080406
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

I would put this on the wiki in the stuff about use cases, but I don't=20
have a wiki account and don't really have the time or interest right now =

in getting one, so I'm posting it here instead.

This is a rather interesting use case for send/receive that I've never=20
seen discussed anywhere else.  In essence, it lets you take a working=20
Xen user domain which uses BTRFS as the root filesystem, and use that as =

a template for new VM's without having to deal with seed devices (which=20
means you can do it with the source domain online with only minimal=20
service degradation).

These steps assume you have a minimal working knowledge of Xen and=20
BTRFS, as well as access to both Domain-0 and the user domain you are=20
copying (refereed to below as the 'source domain'.  I've only used this=20
myself with Gentoo, but it should work for almost any Linux distro.=20
I've also only done this with fully paravirtualized domains, it's a lot=20
more involved to do it with hardware virtualized domains, although PVH=20
domains should work with exactly the same steps as regular PV domains.=20
Your source domain's root also needs to be in a subvolume on the root=20
filesystem, this won't work if it isn't.

1. Create your backend storage devices for the new domain.
2. Attach the storage device (or devices) that will hold the root=20
filesystem for the new domain to the source domain.  Using xl, this=20
translates to something similar to: 'xl block-attach source=20
"/dev/vg/target-disk,raw,xvdz"'
3. From the source domain, use mkfs.btrfs to create a BTRFS filesystem=20
on the target disk (be careful, if you specify the wrong disk you may=20
cause serious issues).
4. On the source domain, mount both the root filesystem (don't bind=20
mount it, and make sure that you are mounting the top-level, not a=20
subvolume) and the target filesystem.
5. Create a read-only snapshot of the root subvolume from the source=20
filesystem.
6. Use btrfs send piped to btrfs receive to copy the snapshot from the=20
source filesystem to the target filesystem.  This will likely take quite =

some time (on the low-end server equivalent hardware I have, it takes=20
about 2o-25 minutes for a somewhat minimalistic Gentoo installation).
7. While btrfs send/receive is running, prepare the configuration file=20
for the target domain (I usually just copy the config from the source=20
domain, and then change only what I need to).
8. Once the send/receive operation is complete, use btrfs property set=20
to change the snapshot on the target to be writable, then rename it to=20
whatever you want the root subvolume to be called on the target system.
9. In the newly created root subvolume, change any system specific=20
configuration to what is needed for the new system (at a bare minimum,=20
you probably need to change the hostname and networking configuration,=20
and should verify that /etc/fstab and /etc/localtime are correct for the =

target system).
10. Unmount the target filesystem in the source domain.
11. Use 'xl block-detach' to detach the target device from the source=20
domain.
12. Use your regular tools to start your new domain, log in, and preform =

any final configuration needed.

Using this methodology, I can have a new Gentoo PV domain running in=20
about half an hour, whereas it takes me at least two and a half hours=20
(and often much longer than that) when using the regular install process =

for Gentoo.


--------------ms010507070902060004080406
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDI4MTIwNzIwWjBPBgkq
hkiG9w0BCQQxQgRAof12mSB3Z7D9F9YgRSb+RFNQzDZ2o1HzDPQKsqKQoPlzdtqJpvjTlNly
PbH18QUR/ggH3h4M364sOjjcwdGinTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBtmJ6YcTXAVJSot62J53Hj5qe8w0swRGSE0VKzNEOaaH27zyNx
VCmxX1Sb9Y74hbMhUA7AXbFm2hXZNz+ZS/ZRs4o81jfG41gfu5yJcLfLt96yCju4khmuBKty
qtZ1jerXXkEmHpcWYnF/q0LidtxK5gDnrT1vT8pOeCcTpUFOC9MTR/YgzAO/9DnAyxzM66Mv
Obr7/n7ryMYsI9qVRTmNHM+RZ1E+smgDYH7XkQFNrKjOlgqPzBF+JpgVb2zS02B7gy+jMhP6
vsrHQ6wBOFwd7wbcuvNaXt6PIWrZX04SNZe6n94cnemq0C2jWvLn5eu+TOhh6bccu+iaslR4
SCuiamgX7QBwnq0W+aSChEGpgp1UMj3VNJ5Sk3QmDqddfc+2nDqMakB1w+CO5sIGir/QxERf
XIBQYYluXI2A0i2zryLYQiPFkHzcP/N+QgiyytaWMuLGMobR7U1jlyWJGac0qPrt9PGIlMj7
AjgL6Q+zCl+9D2RNj1cyRj4gkw1JsDkdyvbM3flEjRP5fgoeSFlc8VozS6Nlv31QCJWrG7uL
f474MiwyZ4lai+LFDRjkGvhBB8Ru2jrsG1J85SsSae4sGYvrsaQbBQW1e95ZLFDQTUUmCl6B
/r5qQUsg8v+ErkqSRjUCwqWAcHhehDlc/cXzRqQHg+ZvQ3WrEulyDxNJ2gAAAAAAAA==
--------------ms010507070902060004080406--
