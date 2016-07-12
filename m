Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgateway3.uni-freiburg.de ([132.230.2.213]:58687 "EHLO
	mailgateway3.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933190AbcGLMFf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 08:05:35 -0400
Received: from ms2.uni-freiburg.de ([132.230.2.3] helo=uni-freiburg.de) port 46244
	by mailgateway3.uni-freiburg.de with esmtp
	(Exim 4.85 #2 built 17-Dec-2015 15:40:08 running on Gentoo)
	id 1bMw9W-0006P8-0g
	for linux-btrfs@vger.kernel.org; Tue, 12 Jul 2016 13:47:02 +0200
Received: from [132.230.9.129] (account tamas.baumgartner-kis@rz.uni-freiburg.de [132.230.9.129] verified)
  by rz.uni-freiburg.de (CommuniGate Pro SMTP 6.1.6b)
  with ESMTPSA id 289749595 for linux-btrfs@vger.kernel.org; Tue, 12 Jul 2016 13:46:56 +0200
To: linux-btrfs@vger.kernel.org
From: Tamas Baumgartner-Kis <Tamas.Baumgartner-Kis@rz.uni-freiburg.de>
Subject: ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt": Read-only file
 system
Message-ID: <d10c846e-36a4-44b6-1d59-65fae30d8e59@rz.uni-freiburg.de>
Date: Tue, 12 Jul 2016 13:46:56 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms000607030309020100070305"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000607030309020100070305
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,


I have a problem with the current BTRFS 4.6


I'm running a Archlinux in a KVM to test BTRFS.

First I played with one device and subvolumes.

After that I added a second device to make a raid1.

# btrfs device add /dev/sdb /mnt
# btrfs balance start -dconvert=3Draid1 -mconvert=3Draid1 /mnt


To make a stresstest I removed the first device and wanted to
boot, but unfortunately the system couldn't boot.

So I booted into a liveSystem:

#uname -a
Linux archiso 4.6.3-1-ARCH #1 SMP PREEMPT Fri Jun 24 21:19:13 CEST 2016
x86_64 GNU/Linux

First I tried to mount the "leftover" device with the degraded option

# mount -o degraded /dev/sda /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sda,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.


but this works only if I also use the read-only option.

# mount -oro,degraded /dev/sda /mnt

If I try then to replace the missing device I got an error

# btrfs replace start -B 1 /dev/sdb /mnt
ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt": Read-only file system

Hire are some additional info about the system

#  btrfs --version
btrfs-progs v4.6



# btrfs fi show
Label: 'hdd0'  uuid: 97b5c51a-65d3-4a84-9382-9b99756ca4ab
	Total devices 2 FS bytes used 1.09GiB
	devid    2 size 10.00GiB used 3.56GiB path /dev/sda
	*** Some devices missing



# btrfs fi df /mnt
Data, RAID1: total=3D2.00GiB, used=3D1.04GiB
Data, single: total=3D1.00GiB, used=3D640.00KiB
System, RAID1: total=3D32.00MiB, used=3D16.00KiB
System, single: total=3D32.00MiB, used=3D0.00B
Metadata, RAID1: total=3D256.00MiB, used=3D54.02MiB
Metadata, single: total=3D256.00MiB, used=3D256.00KiB
GlobalReserve, single: total=3D32.00MiB, used=3D0.00B



# dmesg
[ 9753.746858] BTRFS info (device sda): allowing degraded mounts
[ 9753.746863] BTRFS info (device sda): disk space caching is enabled
[ 9753.746865] BTRFS: has skinny extents
[ 9753.819035] BTRFS: missing devices(1) exceeds the limit(0), writeable
mount is not allowed
[ 9753.838758] BTRFS: open_ctree failed
[ 9800.077556] BTRFS info (device sda): allowing degraded mounts
[ 9800.077561] BTRFS info (device sda): disk space caching is enabled
[ 9800.077562] BTRFS: has skinny extents


Is this a mistake I'm doing or is this some how a bug?

Kind Regards
    Tamas Baumgartner-Kis

--=20
Tam=C3=A1s Baumgartner-Kis
Rechenzentrum der Universit=C3=A4t Freiburg
Phone: +49 761 203 4605
E-Mail: Tamas.Baumgartner-Kis@rz.uni-freiburg.de


--------------ms000607030309020100070305
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5szt+FWGSSC/GcdWvWZwYZi+NnH0CKhJxCAgrtB+ZxMYWwffMFQxBAbwpg7hPOzlAgMBAAGj
ggIDMIIB/zASBgNVHRMBAf8ECDAGAQH/AgEBMA4GA1UdDwEB/wQEAwIBBjARBgNVHSAECjAI
MAYGBFUdIAAwHQYDVR0OBBYEFDNnqdbxk1U2rKEyvcHkljn/THAxMB8GA1UdIwQYMBaAFEm3
xs/oPR9/6kR7Eyn38QpwPt5kMCEGA1UdEQQaMBiBFnBraUByei51bmktZnJlaWJ1cmcuZGUw
gYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290
LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2ds
b2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIHXBggrBgEFBQcBAQSByjCBxzAzBggr
BgEFBQcwAYYnaHR0cDovL29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEcGCCsG
AQUFBzAChjtodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jYWNl
cnQvY2FjZXJ0LmNydDBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9i
YWwtcm9vdC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAI5e
ehxKszyHlsTZT6HAsPFfy3gDN9HE8xKrRfPqhylVNkdGde7i09sg442UWg2PmglUq7BCxGu3
9suSY9iQEZzdX5CspktFgfa8O2KYa/Z+7/K0xopyY6JzZ9EIXHppmiYXE8ZYomPErxaKdWT6
WGwRAKUL4FY8n+TbDlrDcK85ebQcU18F397S8gph6EAlk0/Lo81IP3RxoxLUX9Bs8YUWQQ2G
hryQZfIlEqpRIBRSsd1zSxgHCYvgQTs5saJ4jK/6NZjO56cWaGP0HZ564UuGS2lPD4OYyLUG
gh80K8YgeOJHcxOP5940F6ESRFsPUmaROi8s7eUGqI6Wetc/DiEwggYfMIIFB6ADAgECAgcZ
mMnpsr3HMA0GCSqGSIb3DQEBCwUAMIGGMQswCQYDVQQGEwJERTEeMBwGA1UEChMVVW5pdmVy
c2l0YWV0IEZyZWlidXJnMRYwFAYDVQQLEw1SZWNoZW56ZW50cnVtMRgwFgYDVQQDEw9Vbmkt
RlIgQ0EgLSBHMDIxJTAjBgkqhkiG9w0BCQEWFnBraUByei51bmktZnJlaWJ1cmcuZGUwHhcN
MTUwNjExMDg1MjQyWhcNMTgwNjEwMDg1MjQyWjCBsDELMAkGA1UEBhMCREUxHjAcBgNVBAoM
FVVuaXZlcnNpdGFldCBGcmVpYnVyZzEoMCYGA1UECwwfUmVjaGVuemVudHJ1bS9OZXR6d2Vy
a2FidGVpbHVuZzEeMBwGA1UEAwwVVGFtYXMgQmF1bWdhcnRuZXItS2lzMTcwNQYJKoZIhvcN
AQkBFihUYW1hcy5CYXVtZ2FydG5lci1LaXNAcnoudW5pLWZyZWlidXJnLmRlMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwjNXe6i6WvLI8mVqzexGGHp2yXyQwlfdxx9vLDvg
96BbUbD3N4/z2I9uVE5cqZcNMX59ZfyCP4hTj4IPp8MyV0jWBj/UBY+yZYS5N/hpL7MppqMM
X3KHOfO/uP/sfLAN8iwlUez5Va37P6tNnMNOkpcn9D9tPQWD7luxXUNeezae7y42uC+j55Qs
AR2eZMR3WLdpVfeTri4aOYf8LYrhgIl9CokC5cE3Tq919VhFQGPQGpkT+6RhQ+ewRB2iW6NM
ntCp3QNh5/nNAHyGb6YnxOZAdKAkr1mQ/EHaSL4wxYdIaWOrykI+daxVTTSGlWYk+fcvG0CA
N2NVl+ywkartlQIDAQABo4ICZDCCAmAwQAYDVR0gBDkwNzARBg8rBgEEAYGtIYIsAQEEAwMw
EQYPKwYBBAGBrSGCLAIBBAMBMA8GDSsGAQQBga0hgiwBAQQwCQYDVR0TBAIwADALBgNVHQ8E
BAMCBeAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBTkYSs1FbVG
owlcee1Vn0Wol1fgNzAfBgNVHSMEGDAWgBQzZ6nW8ZNVNqyhMr3B5JY5/0xwMTAzBgNVHREE
LDAqgShUYW1hcy5CYXVtZ2FydG5lci1LaXNAcnoudW5pLWZyZWlidXJnLmRlMIGPBgNVHR8E
gYcwgYQwQKA+oDyGOmh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdW5pLWZyZWlidXJnLWNhL3B1
Yi9jcmwvZ19jYWNybC5jcmwwQKA+oDyGOmh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvdW5pLWZy
ZWlidXJnLWNhL3B1Yi9jcmwvZ19jYWNybC5jcmwwgd0GCCsGAQUFBwEBBIHQMIHNMDMGCCsG
AQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwSgYIKwYB
BQUHMAKGPmh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdW5pLWZyZWlidXJnLWNhL3B1Yi9jYWNl
cnQvZ19jYWNlcnQuY3J0MEoGCCsGAQUFBzAChj5odHRwOi8vY2RwMi5wY2EuZGZuLmRlL3Vu
aS1mcmVpYnVyZy1jYS9wdWIvY2FjZXJ0L2dfY2FjZXJ0LmNydDANBgkqhkiG9w0BAQsFAAOC
AQEAcXClGLGLb48f9kVEmVw2yWQ/ORmZXS2PN5OdPkcsXtCmRhnpolscqYniF8Jv9re2QeEe
7WMiWkpLbmtmmfgzlIu+LaKrGYyGvVkU5YyE0m0/897JfscnqYSve3w98O0CTaYG8nAyhLSI
0/b6gtaqrsC35sxgDlaqLZcrjtzGH5HNzaC/Ir+HVJ+6Q4Mm5jkK371nm2xfH12FqXbmrJGl
V1xoTlGKnz/X+Nc+7AQ4wAiCIxT70pxvCOURNHydeUM6vuM2dh9vwKOaiyOWHUQfwsoP3z17
1rL+xsJky5VrQIVMRkWPEFVi6H8dlVnlGPF35w4rL+oRHahMqGndYEQZ4TGCA+cwggPjAgEB
MIGSMIGGMQswCQYDVQQGEwJERTEeMBwGA1UEChMVVW5pdmVyc2l0YWV0IEZyZWlidXJnMRYw
FAYDVQQLEw1SZWNoZW56ZW50cnVtMRgwFgYDVQQDEw9VbmktRlIgQ0EgLSBHMDIxJTAjBgkq
hkiG9w0BCQEWFnBraUByei51bmktZnJlaWJ1cmcuZGUCBxmYyemyvccwDQYJYIZIAWUDBAIB
BQCgggIlMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE2MDcx
MjExNDY1NlowLwYJKoZIhvcNAQkEMSIEIJdp6JG2NEunUC+x/mHzjtGJCNmxLAozBp8tYz6i
tJMtMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG
9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcN
AwICASgwgaMGCSsGAQQBgjcQBDGBlTCBkjCBhjELMAkGA1UEBhMCREUxHjAcBgNVBAoTFVVu
aXZlcnNpdGFldCBGcmVpYnVyZzEWMBQGA1UECxMNUmVjaGVuemVudHJ1bTEYMBYGA1UEAxMP
VW5pLUZSIENBIC0gRzAyMSUwIwYJKoZIhvcNAQkBFhZwa2lAcnoudW5pLWZyZWlidXJnLmRl
AgcZmMnpsr3HMIGlBgsqhkiG9w0BCRACCzGBlaCBkjCBhjELMAkGA1UEBhMCREUxHjAcBgNV
BAoTFVVuaXZlcnNpdGFldCBGcmVpYnVyZzEWMBQGA1UECxMNUmVjaGVuemVudHJ1bTEYMBYG
A1UEAxMPVW5pLUZSIENBIC0gRzAyMSUwIwYJKoZIhvcNAQkBFhZwa2lAcnoudW5pLWZyZWli
dXJnLmRlAgcZmMnpsr3HMA0GCSqGSIb3DQEBAQUABIIBAFXkOXzMhDXqTh+PqXh6GV85C1zU
xO3Rt/CQMSrW/Zra5k3aRReDt5gbZtqQpoWiSV02H9zpDZF2oUkOt178f5HH3PoU0Zw8Symw
oQlBoaW4dG/3Ll+bFmLtn/Dpdl5LTorwfkVrCpL2qPoigaSlS6sTybb2irCt2tALyZvaSlBW
o58VrJYLWsE/qWvhCbk1lACzrGv/9yTYcvEmToYf3copHkkgtFvFApdpLzsA8aHJ8jiLPUdW
glCh/jWk2D/hsBW9Z+UVF21vlnCAVmca8GGBbU840WAQxyoXbp59OHBZozR28fke1pCGbXOk
/VUEUCCGll8JNQDZrF6u8a0A2IQAAAAAAAA=
--------------ms000607030309020100070305--
