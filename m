Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38122 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbbKLMdL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 07:33:11 -0500
Received: by igbxm8 with SMTP id xm8so39930350igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 04:33:10 -0800 (PST)
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: illegal snapshot, cannot be deleted
To: Vedran Vucic <vedran.vucic@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
Message-ID: <564486F3.5020804@gmail.com>
Date: Thu, 12 Nov 2015 07:32:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060805080803050505030401"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060805080803050505030401
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-11 17:11, Vedran Vucic wrote:
> Hello,
>
> I use OpenSuse 13.2 on my Toshiba Satellite laptop. I noticed that I ru=
n
> out of disk space, checked documentation and I realized that there were=

> many snapshots.  I used Yast Snapper to delete snapshots.
> I noticed that one snapshot  with number 748 could not be deleted.
> I entered terminal and after the command:
> snapper -c root delete 748
> I got message Illegal snapshot.
This sounds like some sort of issue with snapper, not BTRFS itself, but=20
see below for some suggestions.
> I woudl like to delete it since it is old one.
> Please find details about my system as requested on your wiki page.
> uname -a
> Linux linux-jjcc.site 3.16.7-29-desktop #1 SMP PREEMPT Fri Oct 23 00:46=
:04
> UTC 2015 (6be6a97) i686 i686 i386 GNU/Linux
>
> btrfs --version
> btrfs-progs v4.0+20150429
>
> btrfs fi show
> Label: none  uuid: d6934db3-3ac9-49d0-83db-287be7b995a5
>          Total devices 1 FS bytes used 10.98GiB
>          devid    1 size 18.71GiB used 18.71GiB path /dev/sda6
>
> btrfs fi df /
> Data, single: total=3D15.19GiB, used=3D10.37GiB
> System, DUP: total=3D8.00MiB, used=3D16.00KiB
> System, single: total=3D4.00MiB, used=3D0.00B
> Metadata, DUP: total=3D1.75GiB, used=3D622.53MiB
> Metadata, single: total=3D8.00MiB, used=3D0.00B
> GlobalReserve, single: total=3D208.00MiB, used=3D0.00B
> Please find attached dmesg.log as requested.
>
> Please advise what have to do in order to delete snapshot that is repor=
ted
> to be illegal.
Have you tried running 'btrfs subvolume delete' on the snapshot?  You'll =

have to find the full path to it first of course, but that shouldn't be=20
too hard.  Based on the lack of BTRFS error messages in the kernel log=20
you posted, I'm pretty certain that this isn't an issue with the=20
filesystem itself (although the filesystem doesn't look particularly=20
healthy, see further below), so manually deleting the snapshot using the =

regular BTRFS commands should work just fine.  That said, you may also=20
want to look into changing the config for snapper, as it has a=20
ridiculously aggressive retention policy for snapshots by default, which =

tends to lead to excessive space usage on filesystems smaller than about =

250GB.

You may also want to look at running a balance on the filesystem, the=20
numbers from btrfs fi show and btrfs fi df look somewhat worrying,=20
you've got all the space on the disk allocated as chunks by BTRFS, but=20
have a significant amount of empty space in those chunks.  Given that=20
fact, ENOSPC issues are a very real possibility, and you'll probably=20
have to run a series of partial balances to fix this (and it's important =

to do it before it becomes a visible issue also, because once you start=20
getting ENOSPC errors, it is a lot harder to fix).  Try running a=20
balance with '-dusage=3D0 -musage=3D0', then re-run repeatedly increasing=
=20
the number for both arguments by 5 each time until you get to 50.  If a=20
run complains about 'ENOSPC errors during balance', re-run it with the=20
same number for -dusage and -musage.  If you end up re-running with the=20
same value 3 times and keep getting the errors, then you're probably=20
beyond the point of this being fixable, and should just recreate the=20
filesystem (you do have backups, right?).  Otherwise, after finishing=20
the run with '-dusage=3D50 -musage=3D50' successfully, run a full balance=
=20
without the dusage and musage options.




--------------ms060805080803050505030401
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEyMTIzMjUxWjBPBgkq
hkiG9w0BCQQxQgRAkQEcPuUnLv/g1j2wdAh/CJKqRM+nxhlzW/tpR4OoMVKGRxuv4e/gl7y4
UGJMnFgYt5+deonr4K1LirfyPbQslTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBlbfuYILcoDnFiaWctD8gxjzzIqmA4hmWc/oCjjYFVu+4fI7nV
DXT0RdBsZdv+YCJML36MSv+tWGmerqPFvU63pEPIrIyIDdD+L0jBcVK/VnEGlWQRJIDN3/3o
5WIwN2jJ/wnPH469CMrUTpFstsB2k7dVRdZ7HcBy7si9i9Ra4BwvYxv/XebkWtnnLxoQXhkc
qpMSpTL40bNqcDTvbD4vdJ6yR50EfGlRkuVgjd6km+VQlaeoFCw1M5bQJcqSJK7Q4guscK9v
g0PAJNXVfYvE2lF6pFgpqimbLO4hjabrJCIfrOmtMnkAG7Wo97RFJmMDSU3rcRzvEuoi0pZj
3xkpx027rie/kjKoMWMIt19Bbe5mBA0BOMSfN0ebxZgOSX2kRbtccaYyosL5Iy+oXSJfCDIh
llxpYR9LfS2zHrBaBuMBhei565w4Yroqov89+dP5sTiMk9IDrOQ+vn8MaKsPBluybUm0IqHR
T4VORYkbIrymzHxb21bg1kFMJ6/O56xkZXeTPM4vw3oZ+NH/abFUZ4UV5BMag4pareIO7Gk9
En5EYL+b+lWvgHkHkd5fXqNFWzIaFqv7PaPxL8XpvzfBJoRd3a6wfMDUmFXBwyPlKEOyu4EI
WSPT841WuuJ/6KwyT941/0h6g2Rf/08Ly5ycp7l0JEclZB6BnY4Kc3c6/QAAAAAAAA==
--------------ms060805080803050505030401--
