Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-6.smtp-out.eu-west-1.amazonses.com ([54.240.4.6]:49598 "EHLO
        a4-6.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933200AbdBHN0q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 08:26:46 -0500
Subject: Re: BTRFS for OLTP Databases
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Peter Zaitsev <pz@percona.com>, linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij3yQ83HQzN8VfzAaku6+HTcXEz+iqu5nV1=UVX6Gc4ddw@mail.gmail.com>
 <0102015a1da5be24-3fd02799-c4e0-461b-92d2-82131016432e-000000@eu-west-1.amazonses.com>
 <f96d3dff-97ad-561d-c7ef-cf9b51189bc1@gmail.com>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <0102015a1de76a82-da5513d7-1cd8-4eff-9e0a-e34aac752e1f-000000@eu-west-1.amazonses.com>
Date: Wed, 8 Feb 2017 13:26:29 +0000
MIME-Version: 1.0
In-Reply-To: <f96d3dff-97ad-561d-c7ef-cf9b51189bc1@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030503000301060800090207"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030503000301060800090207
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08.02.2017 14:08 Austin S. Hemmelgarn wrote:
> On 2017-02-08 07:14, Martin Raiber wrote:
>> Hi,
>>
>> On 08.02.2017 03:11 Peter Zaitsev wrote:
>>> Out of curiosity, I see one problem here:
>>> If you're doing snapshots of the live database, each snapshot leaves
>>> the database files like killing the database in-flight. Like shutting=

>>> the system down in the middle of writing data.
>>>
>>> This is because I think there's no API for user space to subscribe to=

>>> events like a snapshot - unlike e.g. the VSS API (volume snapshot
>>> service) in Windows. You should put the database into frozen state to=

>>> prepare it for a hotcopy before creating the snapshot, then ensure al=
l
>>> data is flushed before continuing.
>>>
>>> I think I've read that btrfs snapshots do not guarantee single point =
in
>>> time snapshots - the snapshot may be smeared across a longer period o=
f
>>> time while the kernel is still writing data. So parts of your writes
>>> may still end up in the snapshot after issuing the snapshot command,
>>> instead of in the working copy as expected.
>>>
>>> How is this going to be addressed? Is there some snapshot aware API t=
o
>>> let user space subscribe to such events and do proper preparation? Is=

>>> this planned? LVM could be a user of such an API, too. I think this
>>> could have nice enterprise-grade value for Linux.
>>>
>>> XFS has xfs_freeze and xfs_thaw for this, to prepare LVM snapshots. B=
ut
>>> still, also this needs to be integrated with MySQL to properly work. =
I
>>> once (years ago) researched on this but gave up on my plans when I
>>> planned database backups for our web server infrastructure. We moved =
to
>>> creating SQL dumps instead, although there're binlogs which can be us=
ed
>>> to recover to a clean and stable transactional state after taking
>>> snapshots. But I simply didn't want to fiddle around with properly
>>> cleaning up binlogs which accumulate horribly much space usage over
>>> time. The cleanup process requires to create a cold copy or dump of t=
he
>>> complete database from time to time, only then it's safe to remove al=
l
>>> binlogs up to that point in time.
>>
>> little bit off topic, but I for one would be on board with such an
>> effort. It "just" needs coordination between the backup
>> software/snapshot tools, the backed up software and the various snapsh=
ot
>> providers. If you look at the Windows VSS API, this would be a
>> relatively large undertaking if all the corner cases are taken into
>> account, like e.g. a database having the database log on a separate
>> volume from the data, dependencies between different components etc.
>>
>> You'll know more about this, but databases usually fsync quite often i=
n
>> their default configuration, so btrfs snapshots shouldn't be much behi=
nd
>> the properly snapshotted state, so I see the advantages more with
>> usability and taking care of corner cases automatically.
> Just my perspective, but BTRFS (and XFS, and OCFS2) already provide
> reflinking to userspace, and therefore it's fully possible to
> implement this in userspace.  Having a version of the fsfreeze (the
> generic form of xfs_freeze) stuff that worked on individual sub-trees
> would be nice from a practical perspective, but implementing it would
> not be easy by any means, and would be essentially necessary for a
> VSS-like API.  In the meantime though, it is fully possible for the
> application software to implement this itself without needing anything
> more from the kernel.

VSS snapshots whole volumes, not individual files (so comparable to an
LVM snapshot). The sub-folder freeze would be something useful in some
situations, but duplicating the files+extends might also take too long
in a lot of situations. You are correct that the kernel features are
there and what is missing is a user-space daemon, plus a protocol that
facilitates/coordinates the backups/snapshots.

Sending a FIFREEZE ioctl, taking a snapshot and then thawing it does not
really help in some situations as e.g. MySQL InnoDB uses O_DIRECT and
manages its on buffer pool which won't get the FIFREEZE and flush, but
as said, the default configuration is to flush/fsync on every commit.




--------------ms030503000301060800090207
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CuQwggT6MIID4qADAgECAhBuZlYKQ9u25a8FBnl/zd+MMA0GCSqGSIb3DQEBCwUAMHUxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBD
ZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGll
bnQgQ0EwHhcNMTYwOTE5MTMxNzAyWhcNMTcwOTE5MTMxNzAyWjBCMRwwGgYDVQQDDBNtYXJ0
aW5AdXJiYWNrdXAub3JnMSIwIAYJKoZIhvcNAQkBFhNtYXJ0aW5AdXJiYWNrdXAub3JnMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw/FqcYQTj3z2wO8ASP8j0Jvb4AbMNgB9
iv2PLMtAMzYmuW7w2VfUcXwWgM4Fkg6Nm33VhOK+Vryd2bj+jGNhm+DmbMZCfki/NrhdcHKH
AT7i1NL1lps8X3xJ7N0eJpghht9Wx5OAUfGv18HDD3yBUzqW4x7OaGoKqM0DwyUm9O/rUU6D
ugxVONmgprREB1JyJBAV8lgYbY0EEUFS1JECuxNcJQEY+G8EpUNCsZxc8nvROyRD72Aztuy2
qQj4Rs+FzQNCplzmvXot7W0T2KAH9gKb25Q5Lv0sFQEux1stcJc6KKNea21UufblNMLApQ2Z
cSNWwDF5R+YpUFW8HiBOmwIDAQABo4IBtzCCAbMwDgYDVR0PAQH/BAQDAgSwMB0GA1UdJQQW
MBQGCCsGAQUFBwMCBggrBgEFBQcDBDAJBgNVHRMEAjAAMB0GA1UdDgQWBBTKwa9D/4YV1XsZ
6affm7Wv4ykzdTAfBgNVHSMEGDAWgBQkgWw5Yb5JD4+3G0YrySi1J0htaDBvBggrBgEFBQcB
AQRjMGEwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbTA5BggrBgEFBQcw
AoYtaHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc2NhLmNsaWVudDEuY3J0MDgGA1Ud
HwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL3NjYS1jbGllbnQxLmNybDAe
BgNVHREEFzAVgRNtYXJ0aW5AdXJiYWNrdXAub3JnMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBHBgNVHSAEQDA+MDwGCysGAQQBgbU3AQIFMC0wKwYIKwYBBQUHAgEW
H2h0dHBzOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggEBADMT
EdZtz2a7sT3FDGszfzlAfmwVamtLbG5+O6NC5xc1n9AtWa7LdRPsQzgIROT/e84D+uTPAo1c
F6rEJ7oSqhgxJcAWgGN1G0KyEzSaFs+nLvfFN1LeaYQjElnmw87z6LGLvjOnfu01M0Atj+DR
DB3NyRoAn2/5yXHJKP7/mlUSXV/fiplcvP+TJbYJwrL7QDETySua89BU0oH3vtidOm8rlWzl
cZ4ug+kXzMMwjcwSIFb/P6LDZm3FMCNbg8sBt59+V5+Duk8y6aOcQ0GdGrIXMNs+oIKL5iQW
sP9+c55K9mJVl4+3J4sTcyT/L2EOXxEZY+zEhnJAds9dQJXkKfswggXiMIIDyqADAgECAhBr
p4p9CteI1lEK+Vnk57ThMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBT
aWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0x
NTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQC9fdr3w6J9g/Zbgv3bW1+uHht1wLUZr5gkrLtXedg17AkefMyU
GwrQdvwObhajcVmnKVxhrUwkZPXRAwZZosRHfEIi5FH7x6SV/8Sp5lZEuiMnvMFG2MzLA84J
6Ws5T4NfXZ0qn4TPgnr3X2vPVS51M7Ua9nIJgn8jvTra4eyyQzxvuA/GZwKg7VQfDCmCS+kI
CslYYWgXOMt2xlsSslxLce0CGWRsT8EpMyt1iDflSjXZIsE7m1uTyHaKZspMLyIyz6mySu8j
8BWWHpChNNeTrFuhVfrOAyDPFJVUvKZCLKBhibTLloyy+LatoWELrjdI4a8StZY8+dIR9t4A
PXGzAgMBAAGjggFkMIIBYDAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIG
CCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDov
L2NybC5zdGFydHNzbC5jb20vc2ZzY2EuY3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcw
AYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29tMDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0
YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0OBBYEFCSBbDlhvkkPj7cbRivJKLUnSG1o
MB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7yMD8GA1UdIAQ4MDYwNAYEVR0gADAs
MCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcN
AQELBQADggIBAIvj94fsAYuErQ8BAluc4SMnIwS9NPBwAm5SH9uh2NCXTq7im61g7F1LIiNI
/+wq37fUuaMbz4g7VarKQTgf8ubs0p7NZWcIe7Bvem2AWaXBsxsaRTYw5kG3DN8pd1hSEUuF
oTa7DmNeFe8tiK1BrL3rbA/m48jp4AiFXgvxprJrW7izsyetOrRHPbkW4Y07v29MdhaPv3u1
JELyszXqOzjIYo4sWlC8iDQXwgSW/ntvWy2n4LuiaozlCfXl149tKeqvwlvrla2Yklue/quW
p9j9ou4T/OY0CXMuY+B8wNK0ohd2D4ShgFlMSjzAFRoHGKF81snTr2d1A7Ew02oF6UQyCkC2
aNNsK5cWOojBar5c7HplX9aHYUCZouxIeU28SONJAxnATgR4cJ2jrpmYSz/kliUJ46S6UpVD
o/ebn9c6PaM/XtDYCCaM/7XX6wc3s++sbQ7CtCn1Ax7df6ufQbwyO0V+oFa9H0KAsjHMzcwk
3EV2B2NLatidKE/m7G+rB9m+FlVgIiSp0mGlg43QO9Kh1+JqvTCIzv2bJJkmPMLQJNuKKwHN
L8F4GGp6jbAV+WL+LDeGfVcq8DHS3LrD+xyYEXQBiqZEdiPVOMxLDSUCXsDO0uCWpaNQ8j6y
6S9p0xE/Ga0peVLadVHhqf9nXqKaxnr358VgfrxzUIrvOaOjMYIDzDCCA8gCAQEwgYkwdTEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29t
IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAxIENs
aWVudCBDQQIQbmZWCkPbtuWvBQZ5f83fjDANBglghkgBZQMEAgEFAKCCAhMwGAYJKoZIhvcN
AQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTcwMjA4MTMyNjI1WjAvBgkqhkiG
9w0BCQQxIgQgX68y1qlU2sL6+Xl9CNbHbjgBJJvJ8USYofuar9rnpVYwbAYJKoZIhvcNAQkP
MV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMC
AgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBmgYJKwYBBAGC
NxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRD
b20gQ2xhc3MgMSBDbGllbnQgQ0ECEG5mVgpD27blrwUGeX/N34wwgZwGCyqGSIb3DQEJEAIL
MYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQL
EyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMSBDbGllbnQgQ0ECEG5mVgpD27blrwUGeX/N34wwDQYJKoZIhvcNAQEBBQAEggEA
wCGRfpnRjoX+BpotjVkLX0HEjnaQwRSuzSmc04Ce/Yfc8No79J/nZJd/Cnz9qV2deSh0MpKN
bwJc6hgWSUYulROGnzFmWHAtjO7/GcyUGHOnasH7o70FT0CSBp/lrpTwCT/JNB0+YMjcSuEI
BmI+dpKTQf9T2Jsc2FghrgAYqeNmLtXGE3aWoHmjFstloi5RXcit55c39q7BGV6Y+qKFZFEp
eO6SbY3eLC6BhEkcOEg2lBdbLOlSBMcNcUB8OOXlQKM2NKoxqrvo076HvTb8mmK1SjQCgTqB
Qda6gLjT8Q59F9zP9RwDnm0WDlYjZVJYyvENTQEFb38he9DIjbKwogAAAAAAAA==
--------------ms030503000301060800090207--
