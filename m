Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46733 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbaIBTSA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 15:18:00 -0400
Received: by mail-ie0-f178.google.com with SMTP id at1so8345691iec.9
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 12:17:59 -0700 (PDT)
Message-ID: <540617DE.5070605@gmail.com>
Date: Tue, 02 Sep 2014 15:17:50 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>,
        Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Large files, nodatacow and fragmentation
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>	<20140812011401.568c16e6@natsu>	<AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>	<CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>	<9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com>	<CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>	<08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com>	<CADw2B2NJQYn_xkrAebmdu_c-7z7yFNZ1aDFS=jYmQcHfco2d+g@mail.gmail.com>	<5CE63712-2C3E-4BF3-B971-C6F17AE10E3D@colorremedies.com> <CADw2B2N4T_XWOWt++8wGhXk5WJmKgQGqhbt=m2JbQCO_ekfhxA@mail.gmail.com>
In-Reply-To: <CADw2B2N4T_XWOWt++8wGhXk5WJmKgQGqhbt=m2JbQCO_ekfhxA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080800050400090006060907"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080800050400090006060907
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-09-02 14:31, G. Richard Bellamy wrote:
> I thought I'd follow-up and give everyone an update, in case anyone
> had further interest.
>=20
> I've rebuilt the RAID10 volume in question with a Samsung 840 Pro for
> bcache front device.
>=20
> It's 5x600GB SAS 15k RPM drives RAID10, with the 512MB SSD bcache.
>=20
> 2014-09-02 11:23:16
> root@eanna i /var/lib/libvirt/images # lsblk
> NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> sda         8:0    0 558.9G  0 disk
> =E2=94=94=E2=94=80bcache3 254:3    0 558.9G  0 disk /var/lib/btrfs/data=

> sdb         8:16   0 558.9G  0 disk
> =E2=94=94=E2=94=80bcache2 254:2    0 558.9G  0 disk
> sdc         8:32   0 558.9G  0 disk
> =E2=94=94=E2=94=80bcache1 254:1    0 558.9G  0 disk
> sdd         8:48   0 558.9G  0 disk
> =E2=94=94=E2=94=80bcache0 254:0    0 558.9G  0 disk
> sde         8:64   0 558.9G  0 disk
> =E2=94=94=E2=94=80bcache4 254:4    0 558.9G  0 disk
> sdf         8:80   0   1.8T  0 disk
> =E2=94=94=E2=94=80sdf1      8:81   0   1.8T  0 part
> sdg         8:96   0   477G  0 disk /var/lib/btrfs/system
> sdh         8:112  0   477G  0 disk
> sdi         8:128  0   477G  0 disk
> =E2=94=9C=E2=94=80bcache0 254:0    0 558.9G  0 disk
> =E2=94=9C=E2=94=80bcache1 254:1    0 558.9G  0 disk
> =E2=94=9C=E2=94=80bcache2 254:2    0 558.9G  0 disk
> =E2=94=9C=E2=94=80bcache3 254:3    0 558.9G  0 disk /var/lib/btrfs/data=

> =E2=94=94=E2=94=80bcache4 254:4    0 558.9G  0 disk
> sr0        11:0    1  1024M  0 rom
>=20
> I further split the system and data drives of the VM Win7 guest. It's
> very interesting to see the huge level of fragmentation I'm seeing,
> even with the help of ordered writes offered by bcache - in other
> words while bcache seems to be offering me stability and better
> behavior to the guest, the underlying the filesystem is still seeing a
> level of fragmentation that has me scratching my head.
>=20
> That being said, I don't know what would be normal fragmentation of a
> VM Win7 guest system drive, so could be I'm just operating in my zone
> of ignorance again.
>=20
> 2014-09-01 14:41:19
> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
> atlas-data.qcow2: 7 extents found
> atlas-system.qcow2: 154 extents found
> 2014-09-01 18:12:27
> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
> atlas-data.qcow2: 564 extents found
> atlas-system.qcow2: 28171 extents found
> 2014-09-02 08:22:00
> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
> atlas-data.qcow2: 564 extents found
> atlas-system.qcow2: 35281 extents found
> 2014-09-02 08:44:43
> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
> atlas-data.qcow2: 564 extents found
> atlas-system.qcow2: 37203 extents found
> 2014-09-02 10:14:32
> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
> atlas-data.qcow2: 564 extents found
> atlas-system.qcow2: 40903 extents found
>=20
This may sound odd, but are you exposing the disk to the Win7 guest as a
non-rotational device? Win7 and higher tend to have different write
behavior when they think they are on an SSD (or something else where
seek latency is effectively 0).  Most VMM's (at least, most that I've
seen) will use fallocate to punch holes for ranges that get TRIM'ed in
the guest, so if windows is sending TRIM commands, that may also be part
of the issue.  Also, you might try reducing the amount of logging in the
guest.


--------------ms080800050400090006060907
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTAyMTkxNzUw
WjAjBgkqhkiG9w0BCQQxFgQUFx3fPo+ScvMnlnlqSac+orwl2EYwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAx0r/mOtgjW5x5UntJBRRWkLWD+Ew
GnrsLVNENAzGSxXSu1FdM3tMrhcymonQ5Hkfqr4LTuqJqJX/WZCNClhMm+efeRwkgr9nHuVM
kFoCW16lB4PtD/QWcvcC7bPs0v/8lhOcMJgqEzEIjclYTINpIuxedBqRdeadHsXSYlyLnWg1
1WRTCbWUfQW/9WPxEGCYXvfH8frXyyuPvvo3k4XmrfZDOepg6En9op/uvE3eqQobvoHHsJ+O
gYxF6y66p/KXJpyCb3thDWesl14l4UFSX66OZ1a17HFTD2+ot9CK9io2CnXLnyYiQcwuQqdB
VygZy59tIsIbPZpJE6qjctyfhwAAAAAAAA==
--------------ms080800050400090006060907--
