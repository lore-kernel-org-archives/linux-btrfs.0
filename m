Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37431 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162906AbbKFUgz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Nov 2015 15:36:55 -0500
Received: by igbhv6 with SMTP id hv6so43212140igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2015 12:36:54 -0800 (PST)
Subject: Re: Unable to allocate for space usage in particular btrfs volume
To: Calvin Walton <calvin.walton@kepstin.ca>,
        OmegaPhil <OmegaPhil@startmail.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
References: <563A7452.4050202@startmail.com>
 <20151104213039.GC27446@carfax.org.uk> <563A7E45.1050806@startmail.com>
 <pan$b856e$b1f161a7$4a31aba1$83a27ad@cox.net>
 <563B3323.8080609@startmail.com> <1446840956.3899.13.camel@kepstin.ca>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <563D0F2C.3080400@gmail.com>
Date: Fri, 6 Nov 2015 15:35:56 -0500
MIME-Version: 1.0
In-Reply-To: <1446840956.3899.13.camel@kepstin.ca>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020403090408080706030903"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020403090408080706030903
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-06 15:15, Calvin Walton wrote:
> On Thu, 2015-11-05 at 10:44 +0000, OmegaPhil wrote:
>> On 05/11/15 04:18, Duncan wrote:
>>> OmegaPhil posted on Wed, 04 Nov 2015 21:53:09 +0000 as excerpted:
>>> VM image files (and large database files, for the same reason) are
>>> a bit
>>> of a problem on btrfs, and indeed, any COW-based filesystem, since
>>> the
>>> random rewrite pattern matching that use-case is pretty much the
>>> absolute
>>> worst-case match for a COW-based filesystem there is.
>>> Since you're not doing snapshotting (which conflicts with this
>>> option,
>>> with an imperfect workaround), setting nocow on those files may
>>> well
>>> eliminate the problem, but be aware if you aren't already that (1)
>>> nocow
>>> does turn off checksumming as well, in ordered to avoid a race that
>>> could
>>> easily lead to data corruption, and (2) you can't just activate
>
>> So a couple of gig still unaccountable but irrelevant. Thanks,
>> problem
>> solved! Although hopefully checksumming will be allowed on nocow
>> files
>> in the future as thats currently 17% of all data unprotected and will
>> get worse...
>
> There's actually an interesting workaround to this: Although the VM
> disk images aren't checksummed on the host filesystem, you can use
> btrfs *inside* the VMs and enable checksumming there. The downside is
> that you can only verify the VM data by booting the VM and running a
> scrub from inside.
Actually, by using a combination of loop devices and kpartx, it's fully=20
possible to mount the FS and verify it without booting the VM.  Of=20
course, doing this usually requires root access on the host system, but=20
for most people I know, that's usually not an issue.  I do this on=20
occasion when I need to pull a file off of one of my VM disks on my=20
laptop and don't have the time to spin up the VM itself.

Another option if you're doing a direct boot of the kernel (for example, =

when using a fully paravirtualized domain on Xen, or using some of the=20
QEMU ARM systems) is to just do the volume management (partitioning and=20
such) on the host, and expose each filesystem to the guest as a separate =

disk.  I do this with most of my Linux VM's on my Xen system where I use =

LVM as the back-end storage for the virtual disk images, as it allows me =

to easily directly mount the VM's filesystems on the host if need be=20
(and let's you do all kinds of cool things like using a cluster-aware=20
filesystem for the VM's root so that you can mount it from the host=20
safely while the VM is still online).



--------------ms020403090408080706030903
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTA2MjAzNTU2WjBPBgkq
hkiG9w0BCQQxQgRA920HYqqNqTzvD4Vsz0trtLwJX2+Y2aVvq6/QLYPd88+PbbZbWo0Ku4Pi
xxIMujPCqeS27w/1qPCIq3aQYfVKoTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCA3XFmUD0bKO+uOkioIyi/Nwv222t3Prchct0f8fStJhs8relN
pLsCEGtXwmDKkk/au751At0H8gT5elnzL14jFbzvZy+Uz7+DB6tj6k1xx+1QYSedqVZBqyrA
75gGDZy9lBR8bG+1Pl8o3DzhQKNIo8Ym+wGKPUEnmZzvenZPUbjpBFp6+/G/ZWZlc+n+lxbL
fL/AN8KNGbEIMju0AzijVYU4TSSnSX3SF2cYnmj2BNCRrpAjUbGJxh1NsQNFs8v4OP7JcwpI
87UFscyq7k3C9bm8o/YtDEW/xVEqU5H3t7bUUVohKJZOjmUwtWi8bDZJQPyoy5s3WO5gCFje
JELjgCLJ1U7RgKmrD64D3aETilcJiUUWFMjncB3jffpuI2Y9Q2qgI4ImGoE2ryt/Su7WwxDK
MP3Qu9Z7U3xsC9H+Kap9hkRNS8Z2+t72+cTfGqhMxfGA1xA2vmrI+1NC7E7eP4UzQS2IrRLS
mnj6fKiZ3EzR2Bb6U9a18D7bmCfYLFmC9f/kGJkHW/mdUCg1TMxlF2YSxl07F4DE6O0sXpIl
xPJisTMiyLIFRgmOx9o00U7MarojV+6LzGxS0U7zZlyz1yL4f6HNu3k60r3ts359orwLKy3K
u/YyiZIZX7smK3mSClZDIh5Z/yPpD6M/JlluDQqf/jZPenbidR8U4ft+SgAAAAAAAA==
--------------ms020403090408080706030903--
