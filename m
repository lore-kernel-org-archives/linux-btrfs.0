Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mta-2.ms.rz.rwth-aachen.de ([134.130.7.73]:52784 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754218Ab2GDP0g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 11:26:36 -0400
MIME-version: 1.0
Received: from mx-out-1.rwth-aachen.de ([134.130.5.186])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0M6N0028P5IAQG50@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-btrfs@vger.kernel.org; Wed, 04 Jul 2012 16:56:34 +0200 (CEST)
Received: from [137.226.154.136] ([unknown] [137.226.154.136])
 by relay-auth-2.ms.rz.rwth-aachen.de
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec  9 2008))
 with ESMTPA id <0M6N00AME5IA2030@relay-auth-2.ms.rz.rwth-aachen.de> for
 linux-btrfs@vger.kernel.org; Wed, 04 Jul 2012 16:56:34 +0200 (CEST)
Message-id: <4FF459A6.9080403@umic.rwth-aachen.de>
Date: Wed, 04 Jul 2012 16:56:38 +0200
From: Bernd Kohler <kohler@umic.rwth-aachen.de>
Reply-to: kohler@umic.rwth-aachen.de
To: linux-btrfs@vger.kernel.org
Subject: df shows wrong infos on btrfs raid (5gb and 3gb hdd)
Content-type: multipart/signed; protocol="application/pkcs7-signature";
 micalg=sha1; boundary=------------ms010602060606070203070407
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010602060606070203070407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

this is not really a bug in btrfs but to spread the info I will just
drop this short message:

My System (VirtualBox VM, 3 virtual HDDs with 10G, 5G and 3G) is today
installed Ubuntu 12.04 LTS 64bit with Kernel 3.2.0-26 generic, a
/dev/sda hdd containing /boot with ext4 and / with btrfs.

After installation update/upgrade process I created a new partition on
/dev/sdb and /dev/sdbc with max available size - 5G for sdb1 and 3G for
sdc1.

Now I made my RAID:
mkfs.btrfs -L MYRAID -d raid1 -m raid1 /dev/sdb1 /sdc1

and made this RAID available to the filesystem
mount /dev/sdc1 /mnt

The infos, given by "btrfs fi show  /dev/sdb1" and "btrfs fi df /mnt"
are ok, but df is "lieing":

Filesystem Size Used Avail Use% Mounted on
/dev/sdc1  8.0G 5.2G 56k   100% /mnt

Don't get confused about used space, tried to write a 4G file on this
RAID, which ended with "write error: no space left on device" - as expect=
ed

FYI

best

Bernd Kohler

--=20
UMIC - RWTH Aachen
http://www.umic.rwth-aachen.de

Mies-van-der-Rohe Str. 15
52074 Aachen

Tel.:   +49 241 80 20791
Fax:    +49 241 80 22731
E-Mail: kohler@umic.rwth-aachen.de

The future started 6/6/12
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
0100 1001 0101 0000 0111 0110 0011 0110



--------------ms010602060606070203070407
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOGzCC
BCEwggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBa
Fw0xOTA2MzAyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAw
DgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U
1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6
fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869
080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqD
oZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkh
nSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDov
L3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNy
bF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYDVR0OBBYEFEm3xs/oPR9/
6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB
/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IBAQA74Vp3wEgX
3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvhERHua3iR
M347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0Ja6ba
hWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyH
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIE6DCCA9CgAwIBAgIECfJ04DAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTA3MDIxNDExNDkzOFoXDTE5MDIxMzAwMDAwMFowXjELMAkGA1UEBhMCREUxFDASBgNVBAoT
C1JXVEggQWFjaGVuMRcwFQYDVQQDEw5SV1RIIEFhY2hlbiBDQTEgMB4GCSqGSIb3DQEJARYR
Y2FAcnd0aC1hYWNoZW4uZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC4MAhk
48jcelLfNUI5kvMv+CF54xJnL4x/cJQnN2NId6CJ3fqs0siO2exIACfzdjxOUpQ6ZFOn5pdT
vTi7stnk8WAaP/d9LFd8k9Gbxjh7xh3L+0a3ac+/tHJcX564ntUxGtVGMuShEoUaZUT5fw97
TL36UJ8OqXLrqpdAKcFKaJ+pgRp2gTLj4MNUMPjA4GlstpjoLnT++qFm7t/ZS92/E3OqNJUw
HH6C35vSroVscmg+a7XxT6U4JO99MYxNcTIMzhPS9Ytp+302w7i51daBjr0hFGPK0nLSV6gv
77zBSFJ7AVGJJxBSUzDn0xkDLYvZwqaeYkj8kDB2oSeRyfGjAgMBAAGjggGwMIIBrDAPBgNV
HRMBAf8EBTADAQH/MAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQUbtU+wBwvcck8v0lO72pVSOzR
8jgwHwYDVR0jBBgwFoAUSbfGz+g9H3/qRHsTKffxCnA+3mQwHAYDVR0RBBUwE4ERY2FAcnd0
aC1hYWNoZW4uZGUwgYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRl
L2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5w
Y2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGiBggrBgEFBQcB
AQSBlTCBkjBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBj
YS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3
DQEBBQUAA4IBAQAXh37GLAscIHrVqQYrG5P/dYULxAseU6xuXKnSpVTnMWVFf1TtN/p2D+8X
TKtl/A4WlYa9np+ONblWcS1nJsuYf7N9wrO4zCEcVBNLIAHCY3ZXG+IoNHwgXqSYqXHzrAQZ
jkSJr1RfbFE4njUy0nNhtC51HX0ongWfqODc6z7aF9we20615Mh8Kk8uox4XgjLLV/UjPVlw
RAnuYIeF0wycvQ6jz/PJMuOrXShpqejpaiRXqKx8oPXAlCcnoqRLlQc1L0iwQHBn0Em6tDmM
Hcahbf9SBOWiZ8+O0av4ly8CQ95okz9hto9UErXUIzNea2AQXBtlIyLLKgVuYPf4i3IyMIIF
BjCCA+6gAwIBAgIHEsixbM/zMDANBgkqhkiG9w0BAQUFADBeMQswCQYDVQQGEwJERTEUMBIG
A1UEChMLUldUSCBBYWNoZW4xFzAVBgNVBAMTDlJXVEggQWFjaGVuIENBMSAwHgYJKoZIhvcN
AQkBFhFjYUByd3RoLWFhY2hlbi5kZTAeFw0xMTEwMjcxMDM1MDhaFw0xNDEwMjYxMDM1MDha
MGUxCzAJBgNVBAYTAkRFMRQwEgYDVQQKEwtSV1RIIEFhY2hlbjEpMCcGA1UECxMgVU1JQyBS
ZXNlYXJjaCBDZW50cmUgUldUSCBBYWNoZW4xFTATBgNVBAMTDEJlcm5kIEtvaGxlcjCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANJtMwFqmb/1e+ZomvsMQeXmenSpu5Lutgpw
UHwRdbiCHl6/qyycwJGsbBYkrc798FETwbxa/DLrSktk+QbgG/IorKIC1XnlmAtcUlQN4dP1
9ggKTXjSy36BolgyonjLdXIR3iWOGrNHIR6N0vc8aoRVpeCK2b/j/XMkt8VKTCTlDxPZ1PWj
Pxoxmtcqu+4e6EMkxSiG/34zND2qXAQgNfLzK3kZzbFIo8xq8SKQvy8Ofwdki2Ce3eurgRI3
Ultj17GBKJqD7zlT51rntJXiVdZ9Bj19IQ2pyXaCX+DAKKGCSxvMr+Dj2L8rAmG+YHAz1y6s
4dVwrV2E9qFiLul5pJUCAwEAAaOCAcAwggG8MAkGA1UdEwQCMAAwCwYDVR0PBAQDAgXgMCkG
A1UdJQQiMCAGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAjAdBgNVHQ4EFgQUFMTE
XPFwMM5VaCsH9KlcdzvYjNUwHwYDVR0jBBgwFoAUbtU+wBwvcck8v0lO72pVSOzR8jgwJQYD
VR0RBB4wHIEaa29obGVyQHVtaWMucnd0aC1hYWNoZW4uZGUweQYDVR0fBHIwcDA2oDSgMoYw
aHR0cDovL2NkcDEucGNhLmRmbi5kZS9yd3RoLWNhL3B1Yi9jcmwvY2FjcmwuY3JsMDagNKAy
hjBodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3J3dGgtY2EvcHViL2NybC9jYWNybC5jcmwwgZQG
CCsGAQUFBwEBBIGHMIGEMEAGCCsGAQUFBzAChjRodHRwOi8vY2RwMS5wY2EuZGZuLmRlL3J3
dGgtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEAGCCsGAQUFBzAChjRodHRwOi8vY2RwMi5w
Y2EuZGZuLmRlL3J3dGgtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUA
A4IBAQCPpwZ22zQ8fxDyeHwvq8sypO58qJf7ZBfRptJi0HMdhAZV9xwzbd+Fz/g13dt0ktm2
4Ha5d2vulFqGDP4RfoNadXQLWpa1ZSOuDmFmsIzIPcL1FAan0Q4A9llTKfG8fda+bosqI76n
T0QMMltEc5Tg5/HSZvfR/zDtwaqDru6XQzyvUbVp52c9Ga0LNoxqKOSx+z9vTOciroyqknwF
Mige8o/qfVk2Asmqno48DdFp+M1qtqNovrlN/YCPVipeRjl53rfFalneOP6sXCZsZIgF3gX+
onMvosdZCilqQ7Jdu0PZ0+kDzI/WDEzXuhIO4pyZfIHS9EHjrDbPqWE89y9DMYIDVTCCA1EC
AQEwaTBeMQswCQYDVQQGEwJERTEUMBIGA1UEChMLUldUSCBBYWNoZW4xFzAVBgNVBAMTDlJX
VEggQWFjaGVuIENBMSAwHgYJKoZIhvcNAQkBFhFjYUByd3RoLWFhY2hlbi5kZQIHEsixbM/z
MDAJBgUrDgMCGgUAoIIBwTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0xMjA3MDQxNDU2MzhaMCMGCSqGSIb3DQEJBDEWBBRlVGe6UQPseFvroKOJhOaunPnL
HzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcN
AwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMC
AgEoMHgGCSsGAQQBgjcQBDFrMGkwXjELMAkGA1UEBhMCREUxFDASBgNVBAoTC1JXVEggQWFj
aGVuMRcwFQYDVQQDEw5SV1RIIEFhY2hlbiBDQTEgMB4GCSqGSIb3DQEJARYRY2FAcnd0aC1h
YWNoZW4uZGUCBxLIsWzP8zAwegYLKoZIhvcNAQkQAgsxa6BpMF4xCzAJBgNVBAYTAkRFMRQw
EgYDVQQKEwtSV1RIIEFhY2hlbjEXMBUGA1UEAxMOUldUSCBBYWNoZW4gQ0ExIDAeBgkqhkiG
9w0BCQEWEWNhQHJ3dGgtYWFjaGVuLmRlAgcSyLFsz/MwMA0GCSqGSIb3DQEBAQUABIIBAGiQ
NH3BX7wAGVmpoefYdaEgIBr08CjF28s8DPYr5+muFBe4cHO0HAysW1/KN/8S792Q7O0WF8HU
c2+FJ5At+hsAYfWivGGwLqDyq2IvjhcTIDEBXU4b6WZExye1+WKtz4BEtw74r+aU0mY6gS2O
tI5/LOI+YNYtXwtaXExsXRLzM1fXuu+jjg+fIv612MyAQ+Ijqr+A7t8VvyiukWtSAef8gfj2
EILtTCocbNZR3Xf1RI/O12SquIPc41RBlvnKHiXI0JPWoslnbF171GWgddmXif8+aSZ6ElNj
SSJYlAj/Dw9gv5X0/h93u0DqQazcBiDHQxz7Av1jsK6kW0zpOpAAAAAAAAA=
--------------ms010602060606070203070407--
