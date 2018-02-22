Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:57321 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750776AbeBVSxc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 13:53:32 -0500
Received: from [192.168.3.1] ([79.211.68.40]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Mgwee-1fAz7n34Do-00M4I2 for
 <linux-btrfs@vger.kernel.org>; Thu, 22 Feb 2018 19:53:30 +0100
From: =?UTF-8?Q?Andr=c3=a9_Weidemann?= <Andre.Weidemann@web.de>
Subject: lots of data written, but no space occupied
To: linux-btrfs@vger.kernel.org
Message-ID: <ef59f4ee-f54d-81ea-c218-1dd4378e1ceb@web.de>
Date: Thu, 22 Feb 2018 19:53:05 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060004050400030500080608"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060004050400030500080608
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I've been using btrfs for some time now on my server and am pretty=20
satisfied with it's performance and features. I'm running Ubuntu 16.04=20
64bit with kernel 4.4.0-112.

The other day I installed collectd, InfulxDB and Grafana on my server.
I was surprised to see on the graphs, that there was data constantly=20
written to my btrfs RAID1 drives (about 2MB/s).

Since the RAID1 only contains /, /home and a docker container. There is=20
no application actually writing to the disks, only logs go to /var/log.=20
All other data goes to ZFS-storage.

So I dug out iotop in order to figure out what is writing to the disks.
The only process I could find is called "[btrfs-transacti]".
I let "iotop -o -a" run for about 3 hours and got this as a result:

Total DISK READ :      60.13 M/s | Total DISK WRITE :      17.96 M/s
Actual DISK READ:      37.67 M/s | Actual DISK WRITE:      10.32 K/s
     TID  PRIO  USER     DISK READ DISK WRITE>  SWAPIN      IO    COMMAND=

     419 be/4 root          4.16 M      9.59 G  0.00 %  2.26 %=20
[btrfs-transacti]

9.59GB were apparently written to my disk.
The interesting thing is, that the output of  "btrfs filesystem usage /"
has not changed within those 3 hours. It still looks exactly like this:

Overall:
       Device size:                   1.76TiB
       Device allocated:            408.12GiB
       Device unallocated:            1.36TiB
       Device missing:                  0.00B
       Used:                        394.78GiB
       Free (estimated):            698.69GiB      (min: 698.69GiB)
       Data ratio:                       2.00
       Metadata ratio:                   2.00
       Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:197.00GiB, Used:194.25GiB
      /dev/sda2     197.00GiB
      /dev/sdh2     197.00GiB

Metadata,RAID1: Size:7.00GiB, Used:3.14GiB
      /dev/sda2       7.00GiB
      /dev/sdh2       7.00GiB

System,RAID1: Size:64.00MiB, Used:48.00KiB
      /dev/sda2      64.00MiB
      /dev/sdh2      64.00MiB

Unallocated:
      /dev/sda2     695.94GiB
      /dev/sdh2     695.94GiB

Nothing has changed for the output of "btrfs filesystem df /" either:

Data, RAID1: total=3D197.00GiB, used=3D194.25GiB
System, RAID1: total=3D64.00MiB, used=3D48.00KiB
Metadata, RAID1: total=3D7.00GiB, used=3D3.14GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


These are my subvolumes: "btrfs subvolume list /":

ID 257 gen 626146 top level 5 path @
ID 258 gen 626146 top level 5 path @home
ID 660 gen 611310 top level 257 path=20
var/lib/docker/btrfs/subvolumes/05c868ba36d465647ee407f1b99a7115c249af680=
759e552fc1e9f0835e1c1d3
ID 661 gen 611310 top level 257 path=20
var/lib/docker/btrfs/subvolumes/7ff20b948f811be05dfae0ab331d1e7f28d3d9472=
536060f2bb4b1d2895c9ce7
ID 662 gen 611310 top level 257 path=20
var/lib/docker/btrfs/subvolumes/41bda929a8e4a8a0022e3caad3bd0108ac1d0db2d=
0a7484867872b86b4a89ad0
ID 663 gen 611310 top level 257 path=20
var/lib/docker/btrfs/subvolumes/7e315f9dbace5c5585e84ab39b22ad1aabd90f8da=
3637b09ca0526a5f4f0c904
ID 664 gen 611310 top level 257 path=20
var/lib/docker/btrfs/subvolumes/ab01bee8ce430c90bae89bfbf7252911478888fc5=
853eee1071dc841808a4092
ID 665 gen 611310 top level 257 path=20
var/lib/docker/btrfs/subvolumes/b853e32ba79c3fdd6fcf15769f4e2c8f546543aee=
edbe7b9a39011581a840dc5
ID 666 gen 611310 top level 257 path=20
var/lib/docker/btrfs/subvolumes/42cb357d696677255047ded26d604a53fac414e73=
8d18e97b55444abc877f155
ID 667 gen 611310 top level 257 path=20
var/lib/docker/btrfs/subvolumes/177558b388af2c6088286fb65cfab31422228f4f8=
3ec2f77214b208afc4dfc3e
ID 668 gen 611310 top level 257 path=20
var/lib/docker/btrfs/subvolumes/d89b36b29c6477c91ce73b9288e98684da8cdec80=
455d498fe7627281461b190-init
ID 669 gen 612469 top level 257 path=20
var/lib/docker/btrfs/subvolumes/d89b36b29c6477c91ce73b9288e98684da8cdec80=
455d498fe7627281461b190
ID 691 gen 611319 top level 257 path mnt/nextcloud-test


This is the output for all mounted BTRFS' on my machine: "grep btrf=20
/proc/mounts"
/dev/sdh2 / btrfs rw,relatime,space_cache,subvolid=3D257,subvol=3D/@ 0 0
/dev/sdh2 /home btrfs rw,relatime,space_cache,subvolid=3D258,subvol=3D/@h=
ome 0 0
/dev/sdh2 /var/lib/docker/btrfs btrfs=20
rw,relatime,space_cache,subvolid=3D257,subvol=3D/@/var/lib/docker/btrfs 0=
 0

To verify the Grafana output, I started this:
while (true); do awk '/sdh\ |sda\ / {print "disk: "$3"\tread:"$6 / 2 /=20
1024"\twritten:"$10 / 2 / 1024}' /proc/diskstats; date; sleep 3600; done
and let it run for a few hours. The results pretty much matched the=20
number in the Grafana graphs.

Those are my calculations from above run:
bytes r	diff	MB/s		bytes w	diff	MB/s
490758				746976	=09
490793	35	0,009722222	753345	6369	1,769166667
490827	34	0,009444444	759868	6523	1,811944444
490867	40	0,011111111	766357	6489	1,8025
491551	684	0,19		775604	9247	2,568611111
491581	30	0,008333333	782609	7005	1,945833333
491638	57	0,015833333	789722	7113	1,975833333
491723	85	0,023611111	796819	7097	1,971388889
491804	81	0,0225		804167	7348	2,041111111


I also stopped docker after 4 hours of running above line because I=20
thought, that the disk writes might be related to it. But the behavior=20
did not change.

So my question is, what is writing to the disks all the time, but also=20
not writing, since there is no additional space occupied? I could=20
understand if btrfs had to relocate data and had to write it to disk,=20
but this seems unlikely since there is almost nothing read from the disks=
=2E..


Thank you a lot in advance.
   Andr=C3=A9


--------------ms060004050400030500080608
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CyUwggU3MIIEH6ADAgECAhBBzsM6DwXuBEHbuD+6KnX/MA0GCSqGSIb3DQEBCwUAMIGXMQsw
CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
b3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBD
bGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xNzExMTgwMDAw
MDBaFw0xODExMTgyMzU5NTlaMCcxJTAjBgkqhkiG9w0BCQEWFmFuZHJlLndlaWRlbWFubkB3
ZWIuZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQD3wXLZmXB1qLlUCibJFTuT
NrUNUjW2DoIc7qXndR9HJb5XjBqonnFV5P1fgFhpcJL4tD2cGK1IC9I0EeASP6OFBU7OV85x
SDn+X7VZ3UZs24mGirFw7qa6KPtU2UyADH82T316pVM5uCHAssmw/y1d+zvk2DZCjNXTlnpZ
czxdEdH7cqpUDxechUGlA3DwOQWFQZdMsR3bpKKWBNtfUzt0iHjsmMdzpYruQxeFbsIZpbmj
bRKq8SUi7/ueRV53pVcz79eVyJRuqvxn6R3ECah1GmCQS58Yy74ZW9LC/JA2gbDFeJKJUeJL
/dmcR3LP+Nm1vcM29rsnjt8d/0estnexAgMBAAGjggHsMIIB6DAfBgNVHSMEGDAWgBSCr2yM
+MX+lmF86B89K3FIXsSLwDAdBgNVHQ4EFgQU28GT8ydaZH9qFyxhGvIbzshcqvwwDgYDVR0P
AQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEB
AwUCMBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkG
CCsGAQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+g
TaBLhklodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNh
dGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKG
SWh0dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9u
YW5kU2VjdXJlRW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2Nh
LmNvbTAhBgNVHREEGjAYgRZhbmRyZS53ZWlkZW1hbm5Ad2ViLmRlMA0GCSqGSIb3DQEBCwUA
A4IBAQB4EtTh6tMgIeEc+shenBUoOihmeAH31eEO4tsKH53w4INWlFJg+aXL09LF+OUtMg/l
rKFtBSZmyJ0Vw5Y1VE5mS3q7Vq9+qb8SQNpTvbwqObr07h1gkaMqAeV9DvQRi5ToFiHFeUIF
L2/5x8gwExgOQYkfGjbSE2yOmYUCGpqgOfizbL6Vcbi4CAX+kopW6CY8WoCcWKuFpFapfHfX
oIT+vNpi1DxkaaNjQ8vdNYdBmkfIIIK7sCtk8oxhFRJzqy9zHoUb32zmu2CgNhhqwk2PrAfB
7/8cpcZBorHmNlh19gW/ipNOw+mYYk1RUnsLv6hrRAS3uW3fCcFGrbDWlpGiMIIF5jCCA86g
AwIBAgIQapvhODv/K2ufAdXZuKdSVjANBgkqhkiG9w0BAQwFADCBhTELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkwHhcNMTMwMTEwMDAwMDAwWhcNMjgwMTA5MjM1OTU5WjCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEa
MBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50
IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQC+s55XrCh2dUAWxzgDmNPGGHYhUPMleQtMtaDRfTpYPpynMS6n9jR2
2YRq2tA9NEjk6vW7rN/5sYFLIP1of3l0NKZ6fLWfF2VgJ5cijKYy/qlAckY1wgOkUMgzKlWl
VJGyK+UlNEQ1/5ErCsHq9x9aU/x1KwTdF/LCrT03Rl/FwFrf1XTCwa2QZYL55AqLPikFlgqO
tzk06kb2qvGlnHJvijjI03BOrNpo+kZGpcHsgyO1/u1OZTaOo8wvEU17VVeP1cHWse9tGKTD
yUGg2hJZjrqck39UIm/nKbpDSZ0JsMoIw/JtOOg0JC56VzQgBo7ictReTQE5LFLG3yQK+xS1
AgMBAAGjggE8MIIBODAfBgNVHSMEGDAWgBS7r34CPfqm8TyEjq3uOJjs2TIy1DAdBgNVHQ4E
FgQUgq9sjPjF/pZhfOgfPStxSF7Ei8AwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYB
Af8CAQAwEQYDVR0gBAowCDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmwu
Y29tb2RvY2EuY29tL0NPTU9ET1JTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHEGCCsG
AQUFBwEBBGUwYzA7BggrBgEFBQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RP
UlNBQWRkVHJ1c3RDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNv
bTANBgkqhkiG9w0BAQwFAAOCAgEAeFyygSg0TzzuX1bOn5dW7I+iaxf28/ZJCAbU2C81zd9A
/tNx4+jsQgwRGiHjZrAYayZrrm78hOx7aEpkfNPQIHGG6Fvq3EzWf/Lvx7/hk6zSPwIal9v5
IkDcZoFD7f3iT7PdkHJY9B51csvU50rxpEg1OyOT8fk2zvvPBuM4qQNqbGWlnhMpIMwpWZT8
9RY0wpJO+2V6eXEGGHsROs3njeP9DqqqAJaBa4wBeKOdGCWn1/Jp2oY6dyNmNppI4ZNMUH4T
am85S1j6E95u4+1Nuru84OrMIzqvISE2HN/56ebTOWlcrurffade2022O/tUU1gb4jfWCcyv
B8czm12FgX/y/lRjmDbEA08QJNB2729Y+io1IYO3ztveBdvUCIYZojTq/OCR6MvnzS6X72HP
0PRLRTiOSEmIDsS5N5w/8IW1Hva5hEFy6fDAfd9yI+O+IMMAj1KcL/Zo9jzJ16HO5m60ttl1
Enk8MQkz/W3JlHaeI5iKFn4UJu1/cP2YHXYPiWf2JyBzsLBrGk1II+3yL8aorYew6CQvdVif
C3HtwlSam9V1niiCfOBe2C12TdKGu05LWIA3ZkFcWJGaNXOZ6Ggyh/TqvXG5v7zmEVDNXFnH
n9tFpMpOUvxhcsjycBtH0dZ0WrNw6gH+HF8TIhCnH3+zzWuDN0Rk6h9KVkfKehIxggQ1MIIE
MQIBATCBrDCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQ
MA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMT
NENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EC
EEHOwzoPBe4EQdu4P7oqdf8wDQYJYIZIAWUDBAIBBQCgggJZMBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE4MDIyMjE4NTMwNVowLwYJKoZIhvcNAQkEMSIE
ILx4n9o7MoihJHydEl1eHdTw3pxGqEvIl8yB+q4WxcuVMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCB
rDCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
BxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9E
TyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEEHOwzoP
Be4EQdu4P7oqdf8wgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkG
A1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFD
T01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGlj
YXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIQQc7DOg8F7gRB27g/uip1/zANBgkqhkiG9w0B
AQEFAASCAQBHZYeGF0Yam/dJwRGKuctgbqr5xNzhdTOJXkgu9zdyPJeqXqvSFHTnVYu/DqQg
gD7AF92OAR4E2d2Hwl9OD9AKp4m6l5w0315tiY2FfBfWhjj/de3aCoT1zZPZ+rd47XvVGllr
MaOerGVG8dNe647hyxIrLyOWWhmIRPPnW2Y17yTU5bA7qwBhfaL7CMOG1woRiDV/gqF5PeF0
B7sQQLyOrt/2CWUPtUdZeevmogvGl9+MONvanQc3Yk2fqNqmnX44t03xfft6ViaJN+Xt6+oN
ryjX3x8e0EL2uPpapjZE7Pl+WJdHUod3qPw6IjwML290FOfc7hBKgjQU13wiZpOeAAAAAAAA

--------------ms060004050400030500080608--
