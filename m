Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.physik.uni-muenchen.de ([192.54.42.129]:36776 "EHLO
        mail.physik.uni-muenchen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751130AbdBAWEb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Feb 2017 17:04:31 -0500
Message-ID: <1485986636.6573.13.camel@lmu.de>
Subject: Re: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework
 update
From: Christoph Anton Mitterer <christoph.anton.mitterer@lmu.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <0715efbc-44cd-5f84-9870-938dd80b7ae3@cn.fujitsu.com>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
         <1485276845.12065.1.camel@scientia.net>
         <35be430d-1210-9b33-3b18-c22127cc64a7@cn.fujitsu.com>
         <1485305208.12065.9.camel@scientia.net>
         <8d21a04e-7035-5b5d-5b58-9ac0d7f93f02@cn.fujitsu.com>
         <1485399036.23328.7.camel@scientia.net>
         <bb42c075-fcbd-2248-8e9f-ea5d2a836273@cn.fujitsu.com>
         <1485473476.7613.12.camel@lmu.de>
         <7125b67b-1b7e-c191-290d-cf60e63ee93e@gmx.com>
         <1485745624.6333.1.camel@lmu.de>
         <0715efbc-44cd-5f84-9870-938dd80b7ae3@cn.fujitsu.com>
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-BNdhqDTTM1vLL47E6MSq"
Date: Wed, 01 Feb 2017 23:03:56 +0100
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-BNdhqDTTM1vLL47E6MSq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-02-01 at 09:06 +0800, Qu Wenruo wrote:
> https://github.com/adam900710/btrfs-progs/tree/lowmem_fixes
>=20
> Which is also rebased to latest v4.9.1.

Same game as last time, applied to 4.9, no RW mount between the runs.


btrfs-progs v4.9 WITHOUT patch:
*******************************
# btrfs check /dev/nbd0 ; echo $?
checking extents
137

=3D> would be nice if btrfs-progrs could give a message on why it failed,
i.e. "not enough memory" or so.


# btrfs check --mode=3Dlowmem /dev/nbd0 ; echo $?
checking extents
ERROR: block group[74117545984 1073741824] used 1073741824 but extent items=
 used 0
ERROR: block group[239473786880 1073741824] used 1073741824 but extent item=
s used 1207959552
ERROR: block group[500393050112 1073741824] used 1073741824 but extent item=
s used 1207959552
ERROR: block group[581997428736 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[626557714432 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[668433645568 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[948680261632 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[982503129088 1073741824] used 1073741824 but extent item=
s used 0
ERROR: block group[1039411445760 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1054443831296 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[1190809042944 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1279392743424 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1481256206336 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[1620842643456 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[1914511032320 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[3055361720320 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[3216422993920 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[3670615785472 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[3801612288000 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[3828455833600 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[4250973241344 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4261710659584 1073741824] used 1073741824 but extent ite=
ms used 1074266112
ERROR: block group[4392707162112 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4558063403008 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4607455526912 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4635372814336 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4640204652544 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[4642352136192 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[4681006841856 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[5063795802112 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[5171169984512 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[5216267141120 1073741824] used 1073741824 but extent ite=
ms used 1207959552
ERROR: block group[5290355326976 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[5445511020544 1073741824] used 1073741824 but extent ite=
ms used 1074266112
ERROR: block group[6084387405824 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[6104788500480 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[6878956355584 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[6997067956224 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[7702516334592 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: block group[8051482427392 1073741824] used 1073741824 but extent ite=
ms used 1084751872
ERROR: block group[8116980678656 1073741824] used 1073741824 but extent ite=
ms used 0
ERROR: errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
found 7519512838144 bytes used err is -5
total csum bytes: 7330834320
total tree bytes: 10902437888
total fs tree bytes: 2019704832
total extent tree bytes: 1020149760
btree space waste bytes: 925714197
file data blocks allocated: 7509228494848
=C2=A0referenced 7630551511040
1
=3D> error still occurs *without* patch

=3D> increased VM memory here

# btrfs check /dev/nbd0 ; echo $?
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
found 7519512838144 bytes used err is 0
total csum bytes: 7330834320
total tree bytes: 10902437888
total fs tree bytes: 2019704832
total extent tree bytes: 1020149760
btree space waste bytes: 925714197
file data blocks allocated: 7509228494848
=C2=A0referenced 7630551511040
0
=3D> same as before




btrfs-progs v4.9 WITH patches:
******************************
# btrfs check /dev/nbd0 ; echo $?
checking extents
checking free space
cache
checking fs roots
checking csums
checking root refs
Checking
filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
found
7519512838144 bytes used, no error found
total csum bytes: 7330834320
tot
al tree bytes: 10902437888
total fs tree bytes: 2019704832
total extent
tree bytes: 1020149760
btree space waste bytes: 925714197
file data
blocks allocated: 7509228494848
=C2=A0referenced 7630551511040
0
=3D> same as
before

# btrfs check --mode=3Dlowmem /dev/nbd0 ; echo $?
checking extents
checking free space cache
checking fs roots
ERROR: errors found in fs roots
Checking filesystem on /dev/nbd0
UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
found 7519512838144 bytes used, error(s) found
total csum bytes: 7330834320
total tree bytes: 10902437888
total fs tree bytes: 2019704832
total extent tree bytes: 1020149760
btree space waste bytes: 925714197
file data blocks allocated: 7509228494848
=C2=A0referenced 7630551511040
1

=3D> Unfortunately :-(



Cheers,
Chris.
--=-BNdhqDTTM1vLL47E6MSq
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCCrAw
ggVUMIIEPKADAgECAgcaxwkCGxwKMA0GCSqGSIb3DQEBCwUAMFgxCzAJBgNVBAYTAkRFMRMwEQYD
VQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJMSIwIAYDVQQDExlERk4tVmVyZWluIFBD
QSBHcmlkIC0gRzAxMB4XDTE2MDEyNjE1MDYyN1oXDTE3MDIyMjE1MDYyN1oweTELMAkGA1UEBhMC
REUxFDASBgNVBAoMC0dyaWRHZXJtYW55MTEwLwYDVQQLDChMdWR3aWctTWF4aW1pbGlhbnMtVW5p
dmVyc2l0YWV0IE11ZW5jaGVuMSEwHwYDVQQDDBhDaHJpc3RvcGggQW50b24gTWl0dGVyZXIwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDGxxmy4+et82RWI9HAk1bzXsQCBRXSRovVbhbc
EfHXqxnSbTwLFcKVtxGSPax6vJ2xijtusKNaocXRJ91Y5470twfPWWcZ+T5WN0mdPPJKcJc9D+EX
sNk6KTB9HJhqlxqOWv/AmXjYKQavy4i1ojMjB8RyFtzS2EFIrDJqpQnmhE8npXhnuFqYIm4+ByGh
83P1ni2KecLqrFzJ51bzH39aPIttW8YBKcBxJBsT9a+iOWocfKjOs/agrQwo6ntLOLjXtvTkX/TT
w6iRDM2CmukNRtZx+YsD491RroAxOkYQeEL2K8/0eRmOzP7FAmdOt8ihiXdABXnjm3qgmwGgqmnV
AgMBAAGjggIAMIIB/DAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIEsDAdBgNVHSUEFjAUBggr
BgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0OBBYEFG84ZPHmdMMOIKtYmsdzOhyRw2XeMB8GA1UdIwQY
MBaAFJbs3K2aw/5Qozwi5T3Cxf/K2SLGMCoGA1UdEQQjMCGBH2NocmlzdG9waC5hbnRvbi5taXR0
ZXJlckBsbXUuZGUwKgYDVR0gBCMwITARBg8rBgEEAYGtIYIsAQEDAQYwDAYKKoZIhvdMBQICATCB
gwYDVR0fBHwwejA7oDmgN4Y1aHR0cDovL2NkcDEucGNhLmRmbi5kZS9ncmlkLXJvb3QtY2EvcHVi
L2NybC9jYWNybC5jcmwwO6A5oDeGNWh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ3JpZC1yb290LWNh
L3B1Yi9jcmwvY2FjcmwuY3JsMIGeBggrBgEFBQcBAQSBkTCBjjBFBggrBgEFBQcwAoY5aHR0cDov
L2NkcDEucGNhLmRmbi5kZS9ncmlkLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEUGCCsG
AQUFBzAChjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dyaWQtcm9vdC1jYS9wdWIvY2FjZXJ0L2Nh
Y2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAKX99KphzebNy9XJEwAphG7eRywBPsOy8lhdIfrs
YJzDJcxMCJqesio4fZgrxCdbqoHl2ffbgTk6TlMsIdRHvZRWd4+fJv6HsKNJVJfoQ+rVinzRSOAr
sgKe4P+XejyJ1P0xferyxxHswE9ZvVnu5aRl2vRkjvLtxY0NsnN6Y0AlSY4KjaVfMG+nZ3XqNYni
hAejky5J25wg4dSNu2ZQECE9YGmVBA24jIKxFiroeGOm7nunzxitVRax1Kk9EmMXq97kEeVSWMfK
M+zjhYG0rpLcAxvdAZ38L5G+diH2eGTJIwZSJDJHyURzF9zWwxzjYpJ+3vZ7TCLbdN0IlPYIrv0w
ggVUMIIEPKADAgECAgcaxwkCGxwKMA0GCSqGSIb3DQEBCwUAMFgxCzAJBgNVBAYTAkRFMRMwEQYD
VQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJMSIwIAYDVQQDExlERk4tVmVyZWluIFBD
QSBHcmlkIC0gRzAxMB4XDTE2MDEyNjE1MDYyN1oXDTE3MDIyMjE1MDYyN1oweTELMAkGA1UEBhMC
REUxFDASBgNVBAoMC0dyaWRHZXJtYW55MTEwLwYDVQQLDChMdWR3aWctTWF4aW1pbGlhbnMtVW5p
dmVyc2l0YWV0IE11ZW5jaGVuMSEwHwYDVQQDDBhDaHJpc3RvcGggQW50b24gTWl0dGVyZXIwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDGxxmy4+et82RWI9HAk1bzXsQCBRXSRovVbhbc
EfHXqxnSbTwLFcKVtxGSPax6vJ2xijtusKNaocXRJ91Y5470twfPWWcZ+T5WN0mdPPJKcJc9D+EX
sNk6KTB9HJhqlxqOWv/AmXjYKQavy4i1ojMjB8RyFtzS2EFIrDJqpQnmhE8npXhnuFqYIm4+ByGh
83P1ni2KecLqrFzJ51bzH39aPIttW8YBKcBxJBsT9a+iOWocfKjOs/agrQwo6ntLOLjXtvTkX/TT
w6iRDM2CmukNRtZx+YsD491RroAxOkYQeEL2K8/0eRmOzP7FAmdOt8ihiXdABXnjm3qgmwGgqmnV
AgMBAAGjggIAMIIB/DAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIEsDAdBgNVHSUEFjAUBggr
BgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0OBBYEFG84ZPHmdMMOIKtYmsdzOhyRw2XeMB8GA1UdIwQY
MBaAFJbs3K2aw/5Qozwi5T3Cxf/K2SLGMCoGA1UdEQQjMCGBH2NocmlzdG9waC5hbnRvbi5taXR0
ZXJlckBsbXUuZGUwKgYDVR0gBCMwITARBg8rBgEEAYGtIYIsAQEDAQYwDAYKKoZIhvdMBQICATCB
gwYDVR0fBHwwejA7oDmgN4Y1aHR0cDovL2NkcDEucGNhLmRmbi5kZS9ncmlkLXJvb3QtY2EvcHVi
L2NybC9jYWNybC5jcmwwO6A5oDeGNWh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ3JpZC1yb290LWNh
L3B1Yi9jcmwvY2FjcmwuY3JsMIGeBggrBgEFBQcBAQSBkTCBjjBFBggrBgEFBQcwAoY5aHR0cDov
L2NkcDEucGNhLmRmbi5kZS9ncmlkLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEUGCCsG
AQUFBzAChjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dyaWQtcm9vdC1jYS9wdWIvY2FjZXJ0L2Nh
Y2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAKX99KphzebNy9XJEwAphG7eRywBPsOy8lhdIfrs
YJzDJcxMCJqesio4fZgrxCdbqoHl2ffbgTk6TlMsIdRHvZRWd4+fJv6HsKNJVJfoQ+rVinzRSOAr
sgKe4P+XejyJ1P0xferyxxHswE9ZvVnu5aRl2vRkjvLtxY0NsnN6Y0AlSY4KjaVfMG+nZ3XqNYni
hAejky5J25wg4dSNu2ZQECE9YGmVBA24jIKxFiroeGOm7nunzxitVRax1Kk9EmMXq97kEeVSWMfK
M+zjhYG0rpLcAxvdAZ38L5G+diH2eGTJIwZSJDJHyURzF9zWwxzjYpJ+3vZ7TCLbdN0IlPYIrv0x
ggMFMIIDAQIBATBjMFgxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQL
EwdERk4tUEtJMSIwIAYDVQQDExlERk4tVmVyZWluIFBDQSBHcmlkIC0gRzAxAgcaxwkCGxwKMA0G
CWCGSAFlAwQCAwUAoIIBczAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
Fw0xNzAyMDEyMjAzNTZaME8GCSqGSIb3DQEJBDFCBECVxKoTdvz5sq2xKwa7LmSh09D1vgZKzHTr
PL8B7CjC0EMWMevtxI0W58ubWXh2bDXC4qQkMuQdLIjfsiN2ja28MHIGCSsGAQQBgjcQBDFlMGMw
WDELMAkGA1UEBhMCREUxEzARBgNVBAoTCkRGTi1WZXJlaW4xEDAOBgNVBAsTB0RGTi1QS0kxIjAg
BgNVBAMTGURGTi1WZXJlaW4gUENBIEdyaWQgLSBHMDECBxrHCQIbHAowdAYLKoZIhvcNAQkQAgsx
ZaBjMFgxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJ
MSIwIAYDVQQDExlERk4tVmVyZWluIFBDQSBHcmlkIC0gRzAxAgcaxwkCGxwKMA0GCSqGSIb3DQEB
AQUABIIBACDKU/OvIcDpXNTLhzJn2Eygn1i8d8su4lVNvd0RhY4MgvQgr7v8VOBA+fjSkw/hZo/N
3obeetOLJGY/mmtLNB4CeaiJJzXSzr4K5QnRziJYZ3voY9aW+QjLdR2rwLwkOb//bbqHsDeU/e7K
aumgzdPWhI39q/vxo/A4SITdU8Hu/80BhVKr3IBwLM2LoUwn+HApPGaCAJ2EQMqoNQ+MFW4gvXr9
8yizpzuD/SJT+n1L1A7js5yivlVuG3ke+JQPfN1b4ez22jvk0OsdfytbIvVJAM5as2Leu7xBYcnO
olftZ41qhbWWrVRuWt40t1Z73Kzu5PrP83AbkTgQGhPtyxYAAAAAAAA=


--=-BNdhqDTTM1vLL47E6MSq--

