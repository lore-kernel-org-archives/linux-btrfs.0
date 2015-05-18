Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34668 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbbERL6T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 07:58:19 -0400
Received: by igbhj9 with SMTP id hj9so8691959igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 04:58:18 -0700 (PDT)
Message-ID: <5559D3D7.4020405@gmail.com>
Date: Mon, 18 May 2015 07:58:15 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs and integration with GNU ++
References: <1761734734.45679.1431891207641.JavaMail.zimbra@karlsbakk.net> <pan$87dbc$361c1d30$d0fc2fb2$5646ab5d@cox.net> <1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <1042503921.46602.1431940928643.JavaMail.zimbra@karlsbakk.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050803020600090103060004"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050803020600090103060004
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-05-18 05:22, Roy Sigurd Karlsbakk wrote:
>>> For btrfs to be accepted as a primary filesystem in major distros, I'=
d
>>> think it should integrate with existing tools.
>>
>> Well, fortunately or unfortunately, btrfs is already being accepted as=
 a
>> primary fs in major distros.
>
> Interesting - which ones is it that's doing this?
>
While I don't know of any that use it by _default_ yet, I do know that=20
it is an easy to use option on most of the big non-comercial distros=20
already (Debian, Fedora, Ubuntu, etc.), and a couple (Gentoo, Arch, and=20
possibly Slackware) have had the option to use it since it went mainline =

(although that is just a side effect of the installation procedures, not =

any kind of active attempt at support).
>>> Currently, df seems to show good data, while du doesn't.
>>
>> There has been some work put into what df returns to make it so, while=

>> similar work to du has not yet been released, and in fact only quite
>> recently (within the last month) has been proposed on the list.
>>
>> Maturity of the filesystem, again...
>
> hehe
>
>>> Lastly - I just did a small test on a 6 drive RAID-6, turned on
>>> compression and started cat /proc/zero > testfile - let this run unti=
l
>>> the filesize was 500GB and stopped it. Made some other test files and=
 a
>>> copy of these with --reflink=3Dauto just for kicks. rm test* and wait=
ed.
>>> While waiting, did a 'echo b > /proc/sysrq-trigger' and fsck started =
on
>>> bootup and took a minute or so to complete. Since the filesystem is
>>> rather small (6x8GB VDEVs on top of ZFS with SSD caching, kvm as
>>> hypervisor), I wonder how long this fsck job would take if it were on=
 a
>>> system with, say, 6 4TB drives. RHEL/CentOS7 just moved to XFS to all=
ow
>>> for system crashes without this hour-long fsck job, and I somewhat do=
ubt
>>> that btrfs will be the chosen one if it requires the same amount of t=
ime
>>> as of ext4.
>>
>> As Qu mentions, on-mount fsck is not needed on btrfs, as assuming no b=
ugs
>> (filesystem maturity, again), due to btrfs' COW nature, commits are
>> atomic and the filesystem is self-consistent at every commit.  Commits=

>> occur every 30 seconds by default (it's a mount option), and there's o=
nly
>> a very limited journal of fsynced transactions kept since the last
>> commit, to be sure they are recoverable even when the filesystem crash=
es
>> between commits, that automatically replays on mount.  So no on-mount =
fsck
>> needed.
>
> I didn't run it. Some part of the Jessie startup did, and 1 minute for =
just 6x8GB (not TB) seems a lot=E2=80=A6
>
To me, this sounds like some sort of systemd issue, I have heard of it=20
having issues occasionally with long delays when handling btrfs=20
filesystems with more than 4 devices.


--------------ms050803020600090103060004
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
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDUxODExNTgxNVowIwYJKoZIhvcNAQkE
MRYEFL7mQ+LX/hRNZ/+8kRvtFcNdhK+XMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAHia9tSb6sd7cB8bT657ydJVPu7IttxqCu1sRKYtD4Q5vTco
MJT6OCnf50Y/m9weGxH0ta73C9LuVdCQBjKvK8w5jLcI0RDswA7Ym69Womloy6SWnSUNrb4g
6BYQKz9kTnTrVjg1DRXH6vCt7+u3ZmzESM1VENFDk1SOtzdDT//pHeX6mUX2GDq+ej8nEVRy
bOoNUI5UHfId4Lu+gyRdg4G2E1xJB6QljeeCYdSpZitoGbMGVmwDUC7VtHANoxeQMoczlA3y
YjEtYOGAJ5C2aCQlNRtxepSkOf1VzYV7XybRpzOs/g2/QfYWGRsPSsmsxE9RtVjCVpWYhIPW
MO6nbIca35W7TozbPH1EQvyf+PH5TyYJ9eDBKTjECUEP8KONBmR9annwhEGS2P+TB2+SHER+
vzSov/n1pjIhZh6cE45c5i6Ol3jhl8JpsP9RMGvZQ2nYtKM8Q5sjQLt3PCmDJHBibVl4f1PZ
MYj6mR5Zm89P031853IiQ2a+OZj+nuVMPCKIAlHh8h8mYi+gbmnaCeGyIkWdTaLjev3Rjwrc
L6zPDcU8HT1b+f3nHi44DlPXo1yHoFBOXIvhoGJB6kBcoD4F75O6wih/kNUpa38fswOSNLpz
hphyTcUQ6N5NZpAryqW8bwxx3aMJpg9GMdfrqwO++qIiUIelZC0NgsowO0bWAAAAAAAA
--------------ms050803020600090103060004--
