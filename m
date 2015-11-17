Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37154 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbKQMjf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Nov 2015 07:39:35 -0500
Received: by igcto18 with SMTP id to18so12157913igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2015 04:39:34 -0800 (PST)
Subject: Re: BTRFS Error - Rockstor
To: Scotty Edmonds <scotty@scottyedmonds.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Hugo Mills <hugo@carfax.org.uk>,
        Donald Pearson <donaldwhpearson@gmail.com>
References: <SN2PR07MB013A0D1DE3EC69CFAD9885ACF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <CAC=t97BwoMcqE978Fcdu3keN4UNtxqoBDPdbYb_T0C-wR-CBsg@mail.gmail.com>
 <SN2PR07MB013F045DB3B42E4AD8AA3D6CF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <CAC=t97Cv01-8z-oA_pGea9RHQ6d53w=FLbuvpadB=m_LtTPiXw@mail.gmail.com>
 <SN2PR07MB01362A586F4293204E66FCFCF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <CAC=t97AUVQ_Jk1aSmhHodF-Db7NjaUvD1pfbFokx+q_bg3QtxA@mail.gmail.com>
 <20151112225701.GD24333@carfax.org.uk>
 <SN2PR07MB01305858FEC051F986D3546CF110@SN2PR07MB013.namprd07.prod.outlook.com>
 <5645492B.9080808@cn.fujitsu.com>
 <SN2PR07MB013024CC746A3302C8FB614CF110@SN2PR07MB013.namprd07.prod.outlook.com>
 <56492C32.5000107@cn.fujitsu.com>
 <SN2PR07MB0138346652867F9CF76D90BCF1D0@SN2PR07MB013.namprd07.prod.outlook.com>
 <564AD8C5.2040609@cn.fujitsu.com>
 <SN2PR07MB0138CA2787C4F7D11B7CECDCF1D0@SN2PR07MB013.namprd07.prod.outlook.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <564B1FD5.4060101@gmail.com>
Date: Tue, 17 Nov 2015 07:38:45 -0500
MIME-Version: 1.0
In-Reply-To: <SN2PR07MB0138CA2787C4F7D11B7CECDCF1D0@SN2PR07MB013.namprd07.prod.outlook.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090408040208000609090605"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090408040208000609090605
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-17 03:08, Scotty Edmonds wrote:
> Sorry, I'm not at all familiar with backtrace.
>
General procedure to get a backtrace on a system without core files:
1. Make sure you have debugging symbols installed for the program you=20
want the backtrace for, and ideally any libraries it uses.  (These=20
usually are in packages with names ending in -dbg or -debug.  In the=20
case of btrfs, you'll probably need symbols for glibc, lzo, and zlib).
2. Start the program under gdb ('gdb /sbin/btrfs')
3. When gdb is done loading, type in 'start' followed by the arguments=20
for the program (in this case, 'rescue chunk-recover -y /dev/sdg')
4. If gdb then says something about stopping at a breakpoint, enter the=20
command 'continue'.
5. When the program being debugged crashes, you should get a backtrace=20
from gdb, if not, you can enter the command 'bt' to tell it to dump a=20
backtrace.
6. After copying the backtrace somewhere you can put it in an e-mail,=20
you can exit gdb with the 'exit' command, it may complain about=20
something still running, it's safe to tell it to kill this process.

If instead you have your system configured for core dumps:
1. Make sure you have debugging symbols installed for the program you=20
want the backtrace for, and ideally any libraries it uses.
2. Run gdb with the program and core file ('gdb /sbin/btrfs=20
/path/to/core/file').
3. Enter the command 'bt to get a backtrace.


--------------ms090408040208000609090605
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE3MTIzODQ1WjBPBgkq
hkiG9w0BCQQxQgRAA8RxeX7hKcSJH4IyaFDKkmhERXu1y0/+HWzQ0na9zLOLEZT+lurzGaYc
FDYsq42ijb241ktLc+wwVCSCJmVOsDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAm2nKu7yO7OH74YuDPTFfNp5Nj9iJ2zBK0umlAuzIxoKp5vYBX
we0MsYoRl2EQtWzZUVR72+Gz2/fgvILcQG8TsE7ChKQUR8DQONPkdrXAhhR+qA+78rQ+UDBS
gwZWHZDhfvuPlnT70rN1SHD4HfDiD86E7jJouQO33qut3GdE7uHfES2YyNVDE4bsdakTwqgv
Q6rcHKL8/bvJ0vn+niLVqIhmoFmT8qmZkhzQXHjsRixlZDE8I34rswQDvrkV/h0/eTGncsDT
gEVDK3E7IhDkeIrzpLFu31E4jDJig/7UKkiR+KzMhnXdj2T7wIUllA11oT78S70OoXNVpy1g
/TOIBcEGesPXOpiiByIPqhg3IUEA9xOeAtnch5mPDG80fStG+cQE9Qt5t8lRRvTlrPR6gYQ9
++m2lGqxAlDiJ9ziqY0FiHMZbMkV0LriDLbP7Ya+l7/l9Go0wSZzGNXMX+lI8Ey6TUgT9ka+
Yy5EJLZy4MnEpfp7A+IkZMlk9PggRVmZ5DqX63ANLfH2OrsNgTzwniP8xGuzU6CbMOOkY4+Q
gHOSVswxWevSkXFHkZjkM3VouQnSlazd0eSilh0sLY8Lk2ajzMu9dMJlfvUcZNrNm1yDanAO
MvLcv0crRLkH9hHE0/3bp5Bp5HHEpsxopbSdAakB53a7jqgcGrHfJLZJGwAAAAAAAA==
--------------ms090408040208000609090605--
