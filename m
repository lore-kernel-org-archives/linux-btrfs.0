Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35772 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbbDQLb6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 07:31:58 -0400
Received: by iejt8 with SMTP id t8so69886069iej.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 04:31:57 -0700 (PDT)
Message-ID: <5530EF28.4060209@gmail.com>
Date: Fri, 17 Apr 2015 07:31:52 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: =?windows-1252?Q?Miguel_Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: corruption in USB harddrive - backup via send/receive - question
References: <loom.20150416T202016-456@post.gmane.org>
In-Reply-To: <loom.20150416T202016-456@post.gmane.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020200050002030407000607"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020200050002030407000607
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-04-16 14:48, Miguel Negr=E3o wrote:
> Hello,
>
> I'm running a laptop, macbook pro 8,2, with ubuntu, on kernel
> 3.13.0-49-lowlatency. I have a USB enclosure containing two harddrives
> (Icydock JBOD). Each harddrive runs their own btrfs file system, on top=
 of
> luks partitions. I backup one harddrive to the other using btrfs
> send/receive with incremental sends (tests that I did indicated this se=
tup
> was too fragile for running btrfs RAID).
>
> I've noticed that files on one of the harddrive start to get corrupted
> sometimes. It's not many files, but it does happen from time to time. O=
n the
> irc I was told it could be the USB enclosure, it could be memory, etc. =
The
> SMART data of the harddrives say they are fine, the quick SMART tests a=
lso
> pass without problems.
>
>
>   - Given that I'm running a laptop and comunicating with the harddrive=
s via
> USB, is it expected that I will get some corruption from time to time o=
r is
> this abnormal and there is something very wrong with some of my equipme=
nt
> and if so how can track what is responsible ?
>   - Is it possible to extract a file that has csum errors ? I work with=
 audio
> files, if I don't have a backup of file I would still like to get full
> corrupted version, since most of the audio might still be perfectly fin=
e.
> Can I tell btrfs to do a new csum of the file has it is now, and just l=
ive
> with the corruption ?
>
> I've copied a file to the main USB harddrive on 2015-02-21, the file wa=
s
> backed up to the other harddrive via send/receive on 2015-02-23. Now
> (yesterday) when I try to access the file on the main harddrive it is c=
orrupted:
>
> Apr 16 19:20:35 miguel-MacBookPro kernel: [  835.944606] BTRFS info (de=
vice
> dm-1): csum failed ino 136726 off 1067679744 csum 4135207512 expected c=
sum
> 1128560616
> Apr 16 19:20:35 miguel-MacBookPro kernel: [  835.948431] BTRFS info (de=
vice
> dm-1): csum failed ino 136726 off 1067761664 csum 730461863 expected cs=
um
> 1924299628
> Apr 16 19:20:36 miguel-MacBookPro kernel: [  836.395372] BTRFS info (de=
vice
> dm-1): csum failed ino 136726 off 1067679744 csum 4135207512 expected c=
sum
> 1128560616
> Apr 16 19:20:36 miguel-MacBookPro kernel: [  836.396682] BTRFS info (de=
vice
> dm-1): csum failed ino 136726 off 1067679744 csum 4135207512 expected c=
sum
> 1128560616
>
> I can access it fine on the backup harddrive.
>
> Questions:
>
> - Can I assume that that the corruption happened after the file was sen=
t to
> the backup hardrive ?
> - Will btrfs send ever send a file with corrupted blocks ?
> - I kept running more backups, but that particular file was not changed=

> since. I'm I correct in assuming that since the file was not changed it=
 was
> not sent again to the backup disk and that therefore the version I have=
 in
> the backup should be a good copy ?
>
> Best regards,
> Miguel
>
> Label: 'huge-new'  uuid: 21d841c9-7c30-4d1b-b4c2-8c0e59e8959a
> 	Total devices 1 FS bytes used 1.04TiB
> 	devid    1 size 2.73TiB used 1.06TiB path /dev/mapper/huge-new
>
> [/dev/mapper/huge-new].write_io_errs   0
> [/dev/mapper/huge-new].read_io_errs    0
> [/dev/mapper/huge-new].flush_io_errs   0
> [/dev/mapper/huge-new].corruption_errs 1970
> [/dev/mapper/huge-new].generation_errs 0
>
> Btrfs v0.20-rc1-335-gf00dd83
>
> Label: 'huge-new-backup'  uuid: 9af299bc-48b0-4e52-8078-82749627d9f4
> 	Total devices 1 FS bytes used 1.04TiB
> 	devid    1 size 2.73TiB used 1.05TiB path /dev/mapper/huge-new-backup
>
> [/dev/mapper/huge-new-backup].write_io_errs   0
> [/dev/mapper/huge-new-backup].read_io_errs    0
> [/dev/mapper/huge-new-backup].flush_io_errs   0
> [/dev/mapper/huge-new-backup].corruption_errs 0
> [/dev/mapper/huge-new-backup].generation_errs 0
>
> Btrfs v0.20-rc1-335-gf00dd83
>

First, as mentioned in another reply to this, you should update your=20
kernel.  I don't think that the kernel is what is causing the issue, but =

it is an old kernel by BTRFS standards, and keeping up to date is=20
important with a filesystem under such heavy development.  The same=20
actually goes for the userspace components as well, although that is=20
less critical than the kernel side.

As to the corruption, this sounds like some kind of hardware issue to=20
me.  Assuming that you can afford to wipe the filesystems, I would=20
suggest running some tests on the disks with the program 'badblocks'=20
(found in the e2fsutils).  The fact that it is only the first disk that=20
is having issues would seem to indicate that either that port on the=20
enclosure is intermitently bad, or the disk itself is having issues.=20
The SMART tests passing just indicate that the disk doesn't think it is=20
failing, not that it is perfectly reliable (I've had disks that pass all =

the SMART tests, and then just randomly reset themselves from time to=20
time).  I would also look into what manufacturer and firmware version=20
the drives are, as I do know that some of the early Seagate and WD=20
multi-terabyte drives had some serious firmware bugs that could cause=20
data corruption similar to this.



--------------ms020200050002030407000607
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAxBuVTANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNTAz
MjUxOTM0MzhaFw0xNTA5MjExOTM0MzhaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCdD/zW
2rRAFCLnDfXpWxU1+ODqRVUgzHvrRO7ADUxRo1CBDc3JSX5TIW2OGmQ3DAKGOACp8Z0sgxMc
B05tzAZ/M7m4jajVrwwdVCdrwVGxTdAai7Kwg4ZCVfyMVhcwo8R2eW3QahBx34G0RKumK9sZ
ZQSQ+zULAzpY6uz7T1sAk/erMoivRXF6u8WvOsLkOD1F/Xyv1ZccSUG5YeDgZgc0nZUBvyIp
zXSHjgWerFkrxEM3y2z/Ff3eL1sgGYecV/I1F+I5S01V7Kclt/qRW10c/4JEGRcI1FmrJBPu
BtMYPbg/3Y9LZROYN+mVIFxZxOfrmjfFZ96xt/TaMXo8vcEKtWcNEjhGBjEbfMUEm4aq8ygQ
4MuEcpJc8DJCHBkg2KBk13DkbU2qNepTD6Uip1C+g+KMr0nd6KOJqSH27ZuNY4xqV4hIxFHp
ex0zY7mq6fV2o6sKBGQzRdI20FDYmNjsLJwjH6qJ8laxFphZnPRpBThmu0AjuBWE72GnI1oA
aO+bs92MQGJernt7hByCnDO82W/ykbVz+Ge3Sax8NY0m2Xdvp6WFDY/PjD9CdaJ9nwQGsUSa
N54lrZ2qMTeCI9Vauwf6U69BA42xgk65VvxvTNqji+tZ4aZbarZ7el2/QDHOb/rRwlCFplS/
z4l1f1nOrE6bnDl5RBJyW3zi74P6GwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAGvl7xb42JMRH5D/vCIDYvFY3dR2FPd5kmOqpKU/fvQ8ovmJa
p5N/FDrsCL+YdslxPY+AAn78PYmL5pFHTdRadT++07DPIMtQyy2qd+XRmz6zP8Il7vGcEDmO
WmMLYMq4xV9s/N7t7JJp6ftdIYUcoTVChUgilDaRWMLidtslCdRsBVfUjPb1bF5Ua31diKDP
e0M9/e2CU36rbcTtiNCXhptMigzuL3zJXUf2B9jyUV8pnqNEQH36fqJ7YTBLcpq3aYa2XbAH
Hgx9GehJBIqwspDmhPCFZ/QmqUXCkt+XfvinQ2NzKR6P3+OdYbwqzVX8BdMeojh7Ig8x/nIx
mQ+/ufstL1ZYp0bg13fyK/hPYSIBpayaC76vzWovkIm70DIDRIFLi20p/qTd7rfDYy831Hjm
+lDdCECF9bIXEWFk33kA97dgQIMbf5chEmlFg8S0e4iw7LMjvRqMX3eCD8GJ2+oqyZUwzZxy
S0Mx+rBld5rrN7LsXwZ671HsGqNeYbYeU25e7t7/Gcc6Bd/kPfA+adEuUGFcvUKH3trDYqNq
6mOkAd8WO/mQadlc3ztS++XDMhmIpfBre9MPAr6usqf+wc+R8Nk9KLK39kEgrqVfzc/fgf8L
MaD4rHnusdg4gca6Yi+kNrm99anw7SwaBrBvULYBp7ixNRUhaYiNW4YjTrYxggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5VMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDQxNzExMzE1MlowIwYJKoZIhvcNAQkE
MRYEFP5VJLmy4lbsbiDDO9mxRpfAMBkqMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAFtbx3Rws2gqqNcRfmANkQwnruENdp4S2BHniJ1T4uMLZdyl
3S2AFMbVrcZrT15WwxLekZUwIi13hDB9GBs1+BS7IPaWS2Kq3/vRq/XdGxKuBwIDkz1e6j+N
nRbor/ch/B5NehDKPAwtL1pNPM8fh1dPlDKgrpUC8tx8FV8sWdZVRCnCApCjwyh0fOKX4tgq
vFfsJfzOVCf446EWICLhph0xgETQGbThm9NVPquexxEn5PRF0VUoJ3xz5haEDz/Y8znf6h+W
q/9e4nKKDiXXhn6Hu4J44CD3sO/Cl0hoo303p90Yxfubtk+hGgvcqlfRDc8IuG1ozI3Ag88a
BHrsIrJcZ+bPsjIt3wcZEwLAaI1tq50SCm7+jGUMhr14PBERqq6J0Y3HPXq4NqsUy741YoiN
6yUGn0lIvB7b7AcTtZ/yJ1T4/7YeS9KeFQupO7kcc2LuL7ThcqYvLJj9uJogjRLfF1eT6/3k
mwWhAFVdbtLe5sx2vw1BiEl0df/1xv4EDug0RuTLZvllv89d1SLrfMLHCGA3oNBc/l3yWBAX
rfUaBt8IhULN41vPgkj9Jl5QGUUTVomOfGXZibmda++cYvxjiLRaQd4v9nybzzs5oiMB0YKq
UURZeSCdTQPEz6jvwlVaBqdmc8v+GSFk/oDCCZAwePiZMXVvgX/DTIpcHoOZAAAAAAAA
--------------ms020200050002030407000607--
