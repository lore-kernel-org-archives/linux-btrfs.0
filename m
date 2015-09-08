Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36498 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbbIHM41 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Sep 2015 08:56:27 -0400
Subject: Re: mkfs.btrfs cannot find rotational file for SSD detection for a
 pmem device
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
References: <94D0CD8314A33A4D9D801C0FE68B40295BD1BF1F@G4W3202.americas.hpqcorp.net>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "util-linux@vger.kernel.org" <util-linux@vger.kernel.org>,
        "Kani, Toshimitsu" <toshi.kani@hpe.com>,
        "Knippers, Linda" <linda.knippers@hpe.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55EEDAE8.1060905@gmail.com>
Date: Tue, 8 Sep 2015 08:56:08 -0400
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BD1BF1F@G4W3202.americas.hpqcorp.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070103030706090507060402"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070103030706090507060402
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-06 13:51, Elliott, Robert (Persistent Memory) wrote:
> mkfs.btrfs does not detect pmem devices as being SSDs in kernel 4.2.
>
> Label:              (null)
> UUID:               46603efe-728c-43fe-8241-ffc125e1a7ed
> Node size:          16384
> Sector size:        4096
> Filesystem size:    8.00GiB
> Block group profiles:
>    Data:             single            8.00MiB
>    Metadata:         DUP             417.56MiB
>    System:           DUP              12.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>     ID        SIZE  PATH
>      1     8.00GiB  /dev/pmem0
>
> mkfs.btrfs opens "/sys/block/%s/queue/rotational" and looks for
> 0 (non-rotational - an SSD) or non-zero (rotational - a HDD).
While not directly related in this case, it's worth pointing out that=20
there are lots of things that are not SSD's that get listed as=20
non-rotational by default (and you can in fact change the value of this=20
file from userspace), such as: virtualized block storage (xvdb and=20
virtio at least, not sure about vmware or hyperv), and some networked=20
block devices (NBD may or may not, depends on server side configuration, =

ATAoE did at least at one point, RBD gets listed as non-rotational, DRBD =

tracks underlying storage on the local node).
>
> However, strace shows it is having trouble creating that path.
> The blkid_devno_to_wholedisk function from libblkid leads it to
> this path:
> 	/sys/block/LNXSY/queue/rotational
> which doesn't exist.
>
> That is based on:
> $ realpath /sys/block/pmem0
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus1/region0/namespa=
ce0.0/block/pmem0
>
> $ realpath /sys/dev/block/259:0
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus1/region0/namespa=
ce0.0/block/pmem0
>
> The impact looks limited to the print and causing it to not
> automatically disable "metadata duplication on a single device."
This is an issue inherent in the current pmem driver however, it should=20
be fixed there and not in mkfs.btrfs, as other filesystems make=20
decisions based on this file also, as does the I/O scheduler, and some=20
block storage servers.  This gets tricky though because pmem isn't=20
technically a block device at the low level, and doesn't use some parts=20
of the block layer that most other block devices do.

On that note however, if the pmem device is backed by actual RAM and not =

flash storage (and most of them are from what I've seen), then the only=20
advantage of using single metadata mode over dup is space savings, as=20
RAM is not (usually) write limited.


--------------ms070103030706090507060402
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTA4MTI1NjA4WjBPBgkq
hkiG9w0BCQQxQgRAoJpHF/879Qo46j8xZoxs/HYQ+CKOVq4xCVtodLKe60xAcUOwyq0OVDAP
Zvkw0+W2bea0jJoC6M8dW4jd50nT7jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgArTUig6jm5D1SHwTrJNKXVGARR5zrBtnjpYDcJr5tc+fafCmY4
6wTOnQdoPVhKrqzWdaHhu8XW5S07ZpbBwNPwFt/KwKz0JrrB1kF7Nfbvf6ywF3/7TzEdoMRs
WKG6vCpbbWwnThhbmMGW4Xz1gBD5amDPhd6w9k69E59JX0SPYtBX5PEz0mTjuMi7gQPYFF68
tlFq5jVPxY8n876peYEy4n1gA6hSi9+2fesq2Ad4nfyluMCMMP4rJzaduR4LF4Rb/KjKkl8+
25gqXL4G6KYCA4I3vomcsDU6NXi7PRKXvYxwzgysEu88NxVCxqen5JZ6FZO3mzqDnjpC+Nbl
PSBxe/gnNH5JFMnF2Z+KSTlRKjeJXchtQ7jTTITS4jInH4zkdSAL8t5uO9HoplvZPdY3aHm9
tXuixzGAR5IBcbsAboX2yKyCUvuQuBbx/y0ORifmeyR33xFaf6E6NpIkwx30GaGa+cfFTrt3
y0aCXHVRZIBPL76My7h8Pc0N3KKObgu0F/XSq0JGz7/G3Xw671TuWYRZfDYsTXmjO5/+mjNW
u9YowQ3h16na0wn/FsWAdJau6A3dDQX5ErFhOJTNQH8YI23FUccOApAvxe2stCwfCmYoMZcG
YdyNZBFEpwqsJT0dcqLuuv2AtW/4xXhwCGGgfy6jqrPxeK/9QxQYyv3J8gAAAAAAAA==
--------------ms070103030706090507060402--
