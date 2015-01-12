Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:49455 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbbALOzD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 09:55:03 -0500
Received: by mail-ig0-f182.google.com with SMTP id hn15so11892680igb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 06:55:02 -0800 (PST)
Message-ID: <54B3E03E.80606@gmail.com>
Date: Mon, 12 Jan 2015 09:54:54 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: "P. Remek" <p.remek1@googlemail.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs performance - ssd array
References: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com>
In-Reply-To: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080109030509080404040708"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080109030509080404040708
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2015-01-12 08:51, P. Remek wrote:
> Hello,
>=20
> we are currently investigating possiblities and performance limits of
> the Btrfs filesystem. Now it seems we are getting pretty poor
> performance for the writes and I would like to ask, if our results
> makes sense and if it is a result of some well known performance
> bottleneck.
>=20
> Our setup:
>=20
> Server:
>     CPU: dual socket: E5-2630 v2
>     RAM: 32 GB ram
>     OS: Ubuntu server 14.10
>     Kernel: 3.19.0-031900rc2-generic
>     btrfs tools: Btrfs v3.14.1
>     2x LSI 9300 HBAs - SAS3 12/Gbs
>     8x SSD Ultrastar SSD1600MM 400GB SAS3 12/Gbs
>=20
> Both HBAs see all 8 disks and we have set up multipathing using
> multipath command and device mapper. Then we using this command to
> create the filesystem:
>=20
> mkfs.btrfs -f -d raid10 /dev/mapper/prm-0 /dev/mapper/prm-1
> /dev/mapper/prm-2 /dev/mapper/prm-3 /dev/mapper/prm-4
> /dev/mapper/prm-5 /dev/mapper/prm-6 /dev/mapper/prm-7
You almost certainly DO NOT want to use BTRFS raid10 unless you have know=
n good backups and are willing to deal with the downtime associated with =
restoring them.  The current incarnation of raid10 in BTRFS is much worse=
 than LVM/MD based soft-raid with respect to data recoverability.  I woul=
d suggest using BTRFS raid1 in this case (which behaves like MD-RAID10 wh=
en used with more than 2 devices), possibly on top of LVM/MD RAID0 if you=
 really need the performance.
>=20
>=20
> We run performance test using following command:
>=20
> fio --randrepeat=3D1 --ioengine=3Dlibaio --direct=3D1 --gtod_reduce=3D1=

> --name=3Dtest1 --filename=3Dtest1 --bs=3D4k --iodepth=3D32 --size=3D12G=

> --numjobs=3D24 --readwrite=3Drandwrite
>=20
>=20
> The results for the random read are more or less comparable with the
> performance of EXT4 filesystem, we get approximately 300 000 IOPs for
> random read.
>=20
> For random write however, we are getting only about 15 000 IOPs, which
> is much lower than for ESX4 (~200 000 IOPs for RAID10).
>

While I don't have any conclusive numbers, I have noticed myself that ran=
dom write based AIO on BTRFS does tend to be slower on other filesystems.=
  Also, LVM/MD based RAID10 does outperform BTRFS' raid10 implementation,=
 and probably will for quite a while; however, I've also noticed that fas=
ter RAM does provide a bigger benefit for BTRFS than it does for LVM (~2.=
5% greater performance for BTRFS than for LVM when switching from DDR3-13=
33 to DDR3-1600 on otherwise identical hardware), so you might consider l=
ooking into that.

Another thing to consider is that the kernel's default I/O scheduler and =
the default parameters for that I/O scheduler are almost always suboptima=
l for SSD's, and this tends to show far more with BTRFS than anything els=
e.  Personally I've found that using the CFQ I/O scheduler with the follo=
wing parameters works best for a majority of SSD's:
1. slice_idle=3D0
2. back_seek_penalty=3D1
3. back_seek_max set equal to the size in sectors of the device
4. nr_requests and quantum set to the hardware command queue depth

You can easily set these persistently for a given device with a udev rule=
 like this:
  KERNEL=3D=3D'sda', SUBSYSTEM=3D=3D'block', ACTION=3D=3D'add', ATTR{queu=
e/scheduler}=3D'cfq', ATTR{queue/iosched/back_seek_penalty}=3D'1', ATTR{q=
ueue/iosched/back_seek_max}=3D'<device_size>', ATTR{queue/iosched/quantum=
}=3D'128', ATTR{queue/iosched/slice_idle}=3D'0', ATTR{queue/nr_requests}=3D=
'128'

Make sure to replace '128' in the rule with whatever the command queue de=
pth is for the device in question (It's usually 128 or 256, occasionally =
more), and <device_size> with the size of the device in kibibytes.



--------------ms080109030509080404040708
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMTEyMTQ1NDU0
WjAjBgkqhkiG9w0BCQQxFgQUlgWcQ1O3AoztFjvPVMZLoOdV7BgwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAaxQ8VaezmR6K80e8Dylkjqv+2WxJ
M2A5KkYVrWmJxF6qWemZ8J9WFEApBKrDke4srfEaLSogL3HNNDsJ9iG1mwTren7BBAifTGnm
HY9k3+rR+pp4RBTY8vFsDxw7smYzbjNbvLllYNciXXb9r1zHzPC6dmvkuvE9lnodi9vhAYRq
cCzIV4hEEDKw+I28/FdU7B5084H3qea/v9twF/1RzJ8W2gfPTIPpXOUXK5wwKJ2UbTEfdpGu
lhRr9yh/5DJ+eUW4ActaQnH19eu71PUEACAL55EQXuVuZhTqzbZRdNHHbI+1yW0g/DS083GP
+IyUXbKdycVA82MuXpUOBCxj1QAAAAAAAA==
--------------ms080109030509080404040708--
