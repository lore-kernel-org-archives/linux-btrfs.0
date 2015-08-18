Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36157 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbbHRSgZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 14:36:25 -0400
Received: by iodv127 with SMTP id v127so184155232iod.3
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 11:36:25 -0700 (PDT)
Subject: Re: chattr +C on subvolume
To: Timothy Normand Miller <theosib@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAK7bmU8CM59URzw1VzpbZEKCTKSakwaRyv0NJ9N0vV3dVyFC9g@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D37B04.30404@gmail.com>
Date: Tue, 18 Aug 2015 14:35:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7bmU8CM59URzw1VzpbZEKCTKSakwaRyv0NJ9N0vV3dVyFC9g@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040101030301040406040809"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040101030301040406040809
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-18 13:36, Timothy Normand Miller wrote:
> Maybe this is a dumb question, but there are always corner cases.
>
> I have a subvolume where I want to disable CoW for VM disks.  Maybe
> that's a dumb idea, but that's a recommendation I've seen here and
> there.  Now, in the docs I've seen, +C applies to a directory.  Does
> it apply to subvolumes?  And do I apply it to the subvolume within the
> main volume, or do I apply it to the mount point where I've mounted
> the subvolume separately?  Are there any cases where the flag applies
> or not depending on how you access the files?
>
> The same subvolume for me is accessible via /mnt/btrfs/vms (via the
> /mnt/btrfs mount point) and /mnt/vms (where the subvolume is mounted).
> I applied +C to /mnt/btrfs/vms.  So what I'm trying to find out is if
> it also applies when files are accessed via /mnt/vms.
>
> Thanks.
>
>
In theory, barring any undiscovered corner cases, yes that will work the =

way you want it to (assuming that I'm interpreting how you want it to=20
work correctly).  As of right now, attributes changed via chattr on=20
subvolumes work just like on directories, so the NOCOW attribute will be =

inherited by the files created in that directory.

One more bit of advice that I don't see mentioned very often, if you=20
have the space, you should pre-allocate the VM disk image files before=20
using them (although make sure it's after the NOCOW attribute is set on=20
them), as this will significantly reduce the degree of fragmentation.=20
If you do decide to do so, fallocate is preferable to dd for this, as it =

works a lot faster.

Depending on your use case though, I'd almost suggest storing the disk=20
images on another FS still (ext4 would be my recommendation), or if=20
possible, directly on block devices (LVM would be my recommendation in=20
this case, as it still provides the same data migration abilities as=20
btrfs (albeit slightly more convoluted in some cases)).  Btrfs has very=20
poor overall performance compared to most other Linux filesystems still=20
(except on SSD's when TRIM is working properly, as the COW nature of=20
btrfs actually helps with the wear-leveling), and this can significantly =

hurt VM performance.


--------------ms040101030301040406040809
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODE4MTgzNTQ4WjBPBgkq
hkiG9w0BCQQxQgRA6YqUskxFXZF75s8WyoEVzM372OGjOV/3JvUuAjwNgQOD9xkaBeyC4l/U
81fxnpXMOsIk+6p7ijpYQs+Sd3o6NjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAjgHkiJp9MpbT1LpIV8TqnZJ48OiUm2VRmNiCa87yJTXVRFBb9
tHUH0j9MII6g4ZpBFxtiszHtEKPRJLYbWSeYozOyoyb78QdT8Ewmr5qJo0pifiDzlcSadDhk
ECxmu1gB1a9mssQPyAI2h6AhFqptlcNUjRP3gyj4T/LKmuMf3UyersNmw8OnS36CNZNmLJ9M
sqFA/B5Vg6baKC6L+dEpsN8byDRAcYWkqzaWRbQO3fKPxisgEbaY3bjMTOzVg/4EXd4T7ULd
pcx2X3nk6l7c122OyKF3A0Xl63F7eTntgIQzdu4YkPaFMjkz0aDHIeLKhRzLeaAU74wEHtxc
+5Jwr+iZ9e16mpg7yYHb1imkmghbp5obFX3hdmSq+D0XgkU7gAzfiMVw3zFB6QlJV8vftALF
c4FscsVzsN5cjG9ZFmwsckFUuvu6wNJ1t0xiDVaiktCETqnGxvGcMIoy2o2maTJjNrRTKhYZ
QBpJqSdoUceQhG0SXJYi3uPdnHyYXEZbS9iuGpFThOMy5BmxXpwp+JiuxOT8ADIKgtOI4+DS
oLSD7u2whmIEg+4uhzsda6o8ouP+qqU39egma7nmzZ6Evz7gJ5P97ysuvrWu/2EFIjpseUMK
3Qg3DzMKrugYoNyepgts0zzS2hdblFERh7awuoohtPhvZTZukcnpZnZcugAAAAAAAA==
--------------ms040101030301040406040809--
