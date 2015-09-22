Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34863 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711AbbIVNVL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:21:11 -0400
Received: by qgt47 with SMTP id 47so115546507qgt.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 06:21:10 -0700 (PDT)
Subject: Re: RAID1 storage server won't boot with one disk missing
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Erkki Seppala <flux-btrfs@inside.org>,
        linux-btrfs@vger.kernel.org
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
 <55FAD9CC.5060206@oracle.com> <pan$5cdb2$42505f02$e2b552bf$4a4e51e@cox.net>
 <CA+WRLO94UekKmT1cy3+t4+pHSCMj=HRoEF4oqtJDimS=EWnbhA@mail.gmail.com>
 <m49fv27cxyc.fsf@coffee.modeemi.fi> <56013C3C.6010005@gmail.com>
 <56014ECA.1050002@gmx.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <560155C4.2080701@gmail.com>
Date: Tue, 22 Sep 2015 09:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <56014ECA.1050002@gmx.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030602010204080905050404"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030602010204080905050404
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-22 08:51, Qu Wenruo wrote:
>
>
> =E5=9C=A8 2015=E5=B9=B409=E6=9C=8822=E6=97=A5 19:32, Austin S Hemmelgar=
n =E5=86=99=E9=81=93:
>> On 2015-09-21 16:35, Erkki Seppala wrote:
>>> Gareth Pye <gareth@cerberos.id.au> writes:
>>>
>>>> People tend to be looking at BTRFS for a guarantee that data doesn't=

>>>> die when hardware does. Defaults that defeat that shouldn't be used.=

>>>
>>> However, data is no more in danger at startup than it is at the momen=
t
>>> when btrfs notices a drive dropping, yet it permits IO to proceed. Is=

>>> there not a contradiction?
>>>
>>> Personally I don't see why system startup should be a special case, i=
n
>>> particular as it can be very stressful situation to recover from when=

>>> RAID is there just to avoid the immediate reaction when hardware brea=
ks;
>>> and when in practice you can do the recovery while the system is runn=
ing
>>> in systems where short service interruptions matter.
>>>
>> The difference is that we have code to detect a device not being prese=
nt
>> at mount, we don't have code (yet) to detect it dropping on a mounted
>> filesystem.  Why having proper detection for a device disappearing doe=
s
>> not appear to be a priority, I have no idea, but that is a separate
>> issue from mount behavior.
>>
>
> Sorry for jumping out for such a sudden, but I submitted a patchset
> which is somewhat related to such degraded case.
>
> [PATCH 0/5] Btrfs: Per-chunk degradable check
>
> With that patchset, btrfs can do quite good check for degradable and
> mount/remount and even mounted time.
> (Return value of btrfs_check_degradable() will indicate all devices OK,=

> or not all OK but degradable, or not writable degradable)
>
> And with that patchset, it's quite easy to add support for btrfs to
> sliently switch to degraded mount option if possible.
> (Along with other improvement of course)
>
>
> For the original feedback from end user, personally I understand users
> who don't want to add degraded mount option manually when a device
> fails, nor don't want to add a permanent mount option info fstab, just
> in case of failure.
>
> So personally, I'd like to add a new mount option "nodegraded", to allo=
w
> user to force no degraded mount.
> And if neither "degraded" nor "nondegraded" is given, let btrfs to
> automatically switch to degraded if possible.
>
> And it should also still be able to info user, either by the easily
> igored dmesg, or easier to notice mount option change.
>
> How about this method to solve the problem?
It's not a bad idea, except that it changes established usage, and there =

are probably some people out there who depend on the current behavior.=20
If we do go that way, mount needs to spit out a big obnoxious warning=20
(as in, not through dmesg or mount options, but directly on stderr) if=20
the filesystem gets mounted degraded automatically.  A better option=20
might be to add a compat feature bit, and if that bit is set, then use=20
the above logic, otherwise use the current logic.



--------------ms030602010204080905050404
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTIyMTMyMTA4WjBPBgkq
hkiG9w0BCQQxQgRAQbxzuPcDDAUE5/37a3VzXZ2u5YYbD/pcYn6WpDP++QiPusL8CKCZSfSb
JcX/10tMvnPE/fK9E8p2yec6bmgmnzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB+PuNUIFKW4b2jQbfExwYWSXW5pxB4BnZW2yLlVf6SNyAkvKfa
A6nEuzqlD5OVZjJuvpI0eF6sWrs2JW18vLVGAb9+cx1CoBiKOHl1IH0WzM1b8Mb0p9PcCCxv
Knx6AnPHiNdWjfV6GqKEwZnwJwoTNHYlVFH852OXX43YNi72MtCI1rFf7LfApZr2Ddolm6Ap
tAc0WewKJTqi22K0AuGVkh3Vi372uZlBDxZ+OcgBtmmLENxNzZtwRT0JVfH7wvuxPrIfa3ML
hTMIWPH11fLfgvYRgb8h2pQlvrysOTaUcAmGikkJt9mX0oaPT+yXGN0PWx59cVj6XUb7LKwp
EW7HdsZsvUIlQRIfoWkmUGJ9rtOIzQQoJ0Kh7ZR0GpckDrOlJdZROx89CalVUmAAIC6Tga06
0JwK4sAgYMH125iJ+n/M8iDc7I8H4MQ+8f9D7mwx2J+LT0AlxH8O7bztJ10UVNTEgLx0nwBa
J9Gt+Z5AmHrFaA+OPJIul2ggmY9sJSykX8MxLDqZvcLv5vCTZ+Dc97IcRF+Ctzqa5o1zB+gH
XPiqt4GLImTmgP5wmTZ79WmKjfuDiqzItXby7q3EXICW2S0vtu8KopWfL4SYbTxASiYJvRc6
FcbC1FBBL5EZgqwM3eYF6byRTRRtEO5A1vpbT0PRZQaqQUXaL/ULlvA2kgAAAAAAAA==
--------------ms030602010204080905050404--
