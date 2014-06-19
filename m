Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:41152 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaFSLQF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 07:16:05 -0400
Received: by mail-ig0-f178.google.com with SMTP id hn18so1846707igb.5
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 04:16:04 -0700 (PDT)
Message-ID: <53A2C651.5080907@gmail.com>
Date: Thu, 19 Jun 2014 07:15:29 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        =?UTF-8?B?RGFuaWVsIENlZ2llxYJrYQ==?= <daniel.cegielka@gmail.com>
Subject: Re: btrfs on whole disk (no partitions)
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com> <33D49915-811C-459F-B221-3F342F6D4944@colorremedies.com>
In-Reply-To: <33D49915-811C-459F-B221-3F342F6D4944@colorremedies.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090605060905000403010005"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090605060905000403010005
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-06-18 16:10, Chris Murphy wrote:
>=20
> On Jun 18, 2014, at 1:29 PM, Daniel Cegie=C5=82ka <daniel.cegielka@gmai=
l.com> wrote:
>=20
>> Hi,
>> I created btrfs directly to disk using such a scheme (no partitions):
>>
>> dd if=3D/dev/zero of=3D/dev/sda bs=3D4096
>> mkfs.btrfs -L dev_sda /dev/sda
>> mount /dev/sda /mnt
>>
>> cd /mnt
>> btrfs subvolume create __active
>> btrfs subvolume create __active/rootvol
>> btrfs subvolume create __active/usr
>> btrfs subvolume create __active/home
>> btrfs subvolume create __active/var
>> btrfs subvolume create __snapshots
>>
>> cd /
>> umount /mnt
>> mount -o subvol=3D__active/rootvol /dev/sda /mnt
>> mkdir /mnt/{usr,home,var}
>> mount -o subvol=3D__active/usr /dev/sda /mnt/usr
>> mount -o subvol=3D__active/home /dev/sda /mnt/home
>> mount -o subvol=3D__active/var /dev/sda /mnt/var
>>
>> # /etc/fstab
>> UID=3DID    /    btrfs rw,relative,space_cache,subvol=3D__active/rootv=
ol    0 0
>> UUID=3DID    /usr    btrfs rw,relative,space_cache,subvol=3D__active/u=
sr    0 0
>> UUID=3DID    /home    btrfs rw,relative,space_cache,subvol=3D__active/=
home    0 0
>> UUID=3DID    /var    btrfs rw,relative,space_cache,subvol=3D__active/v=
ar    0 0
>=20
> rw and space_cache are redundant because they are default; and relative=
 is not a valid mount option. All you need is subvol=3D=20
>=20
>> Everything works fine. Is such a solution is recommended? In my
>> opinion, the creation of the partitions seems to be completely
>> unnecessary if you can use btrfs.
>=20
> It's firmware specific. Some BIOS firmwares will want to see a valid MB=
R partition map at LBA 0, not just boot code. Others only care to blindly=
 execute the boot code which would be put in the Btrfs bootloader pad (64=
KB). I don't know if parted 3.1 recognizes partitionless disks with Btrfs=
 though so it might slightly increase the risk that it's treated as somet=
hing other than what it is.
>=20
> For UEFI firmware, it would definitely need to be partitioned since an =
EFI System partition is required.
>=20
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
On most hardware, I would definitely suggest at least adding a minimal
sized partition table, the people who design the BIOS code on most
systems make too many assumptions to trust their code to work correctly.
 That said, I regularly use BTRFS on flat devices for the root
filesystems for Xen PV Guest systems, systems that boot from SAN, and
secondary disks on other systems with no issues whatsoever.


--------------ms090605060905000403010005
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAw8BRDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA1
MTIxNDEwMzJaFw0xNDExMDgxNDEwMzJaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDbLUaL
Gs4JTdU7sgr0MzD57CMUAv307ddC9pxooDMN3PiUvzEd5kLtBCh8KDB1wbMdfm4hte2rDd+j
hM1tIq67BvNbdDPztOcBZwT2/3OVyyG4B1ddCqUyt03zGKw6Y34eHNfapsZiiItX0GBNfjHU
Wv+WDo+XNha/WmGSSMv21HkftF9XA1KC9Bpr9JJI23MKK7T2g/7b3KoGZlx3ekLIJsF5B7+B
DMPPDqOHQbRnccyOHEMyhM13g6WoAbU+3aKYc+C/9UsYtDV+xlvBLWagky1acstD5wOA35V6
uDRbUhD+vOjuMRMCj9jJOIYqa6AeSagBjxRnisJr0RFzQ4f+NjGCHPaFTvRvbkiXh4q22doT
0SxbNBUm7B9ANugIOtS9/VQhTWKDi//WTqZQ7Ecl4yVJbMCUg/iaRHMCGS41vqMICPszRidW
rL04NwS9D2cREEY1y/xrNo0ZvKPZu6tLhxhPf7w+5rsN3+wWxGaR1hNpnVUT9AeacLKZO6W9
FsRT3Unkr91IhQATHTKYr4EAkjN/5lgvA+sxp5TxxsUnoJYrD8IHf8aYfJsAHMleBwx4xSeZ
tw/n5iIjJjFZq9IRZ1zQhK62p+a5vJ2vlJHjTgavhQrfb1pUOjbqsnI4ndQ5hNosL9el4Kxq
Yko+HsxVEmSwSsjq6cV2L3oz0z8NUwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAIokFPcW8+cO2Clu0Ei+ehAmQRBHfV5RWJ8aMVLXOCfiJX0ch
IjVSIt6I3uQaR4J1ZIAjCSPkbpfZQDaLoGFI5j8aYEQhOeKxrvOMzY9/aSUYabCJIhE/sX64
klFV0bzm+PR9cDMWeQ9BoZf0m8UROPSfDnrjEk+p04hGg3pAZMcSwCzxdb604NHjgHJmf2xG
UQVzQgC6Ek/BKat0xuPTuPmtPv9OicK75CPmLZKYW3rFpCD6bhb1mm+ROcCNhniRY2LYm9YN
QdlHQUzTFqj0tvuYrzNI3LNV4PjEfN8z6omPCT2Rq8/uKLseN+m8F0ioqm+cphqpmzKoDUpN
nePLkqDFUFWCeWRxSjBTy4IMVUfdNXriVGihH8hyIICQiOfmmBOzhzUifdomJuTGtoXRuHVT
R2f/YdrJrLnKI4f+Othdp7F3KhB4c6JiOnTEH5J8n9q3rFjt4MPRwcjIHMhmF5nZVQlgxEMo
1cPCmvG1D9tcgXbH79jjqydo9SDXhzLQob7axkzGRY96IstNcvoQ/UNsdPPfFMYlHtGz4TxT
DhBjv4ERskGmKBZrfmxkXkcuTV/gcykct6Xvw9YXb8WTL4qSYHSYk9fReVLgE/L4RBUpX2JJ
QvIR0AJLER165/aZlQXZtuJjnfxJtJTJZZ+Gor9h0G2kuR5Dy0JuYdBO4t4xggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFEMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDYxOTExMTUyOVowIwYJKoZIhvcNAQkE
MRYEFCrAKmtUcAfvaKWmxfp/MRKK04dPMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICADnKhzE91gBIPAc34Oy+z5lp+zAjAbjWORanYHndnFn6Dl6r
DHfZldIys9wrIHrx8CRpQJRGSkuuVmgo1c0CtaErVTFElUOciCiu4EBxlWEKJeW5ch5QqMo5
yDYGlxas3JV3Pzp53PTK9EaQHW9FHIw8bYlf/5CE4Q1DZvkTta5YmHl0yDgMl5XmGBaf8+P6
gk3r+x6u2W6zHYkPYjrY4AtshIfoJTCZSOAww5t5RBlpxZj1TXZTyohR+zWFTfyGAiXy5y1e
M6UnTV1o7hJsjAfzsQ7VmEVmaArv0AdsI/UoYQjBqGf3wyNckJupkdG1beZXbUywmZFiyfmH
IhyM8nPIKBFMmoyu4U+rH4qrc63SnQtFUc32eZ44j6o678j7Bpc0FVcthdE6THPiLQmJsoCV
ISeUHZgLxSKrkexQEa5iBz44v5T6r8xxmd4BzvGyvYKsO7Q2fo1kqI3V/1P3r2ca4/xogs/S
55YM9Kpy6odbYTIq78uCWSQdGwAE7RoKV8Tq6uOuNeCZgbbpcO1H5a+ozCFTpxX5E2lLZV0D
FCfm2OwskrW+5psvy2hVZSXEz2s0FChHL4bQTtQ6sddkXnBi1XGQfrAbbqHFH3tN7mc+rGsV
kjYrV39r6ilQVfGmVxN7fdcmubYgp6pYWY6qFXm9HiMvCKlp4PWMp6Kgv1/kAAAAAAAA
--------------ms090605060905000403010005--
