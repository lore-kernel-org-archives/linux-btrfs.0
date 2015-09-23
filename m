Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:36579 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbbIWNcm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 09:32:42 -0400
Received: by qgx61 with SMTP id 61so18973205qgx.3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 06:32:41 -0700 (PDT)
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com> <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk> <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk> <20150923131226.GA12815@twin.jikos.cz>
 <5602A6EA.8050107@gmx.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5602A9F8.80802@gmail.com>
Date: Wed, 23 Sep 2015 09:32:40 -0400
MIME-Version: 1.0
In-Reply-To: <5602A6EA.8050107@gmx.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020101020806020509040103"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020101020806020509040103
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-23 09:19, Qu Wenruo wrote:
>
>
> =E5=9C=A8 2015=E5=B9=B409=E6=9C=8823=E6=97=A5 21:12, David Sterba =E5=86=
=99=E9=81=93:
>> On Tue, Sep 22, 2015 at 02:36:02PM +0000, Hugo Mills wrote:
>>>> Yeah, right now there's no persistent default for the allocator. I'm=

>>>> still hoping that the object properties will magically solve that.
>>>
>>>     There's no obvious place that filesystem-wide properties can be
>>> stored, though. There's a userspace tool to manipulate the few curren=
t
>>> FS-wide properties, but that's all special-cased to use the
>>> "historical" ioctls for those properties, with no generalisation of a=

>>> property store, or even (IIRC) any external API for them.
>>
>>  From the UI point, we proposed to add a specifier that would route th=
e
>> property to either subvolume or the filesystem:
>>
>> $ btrfs prop set -t filesystem bgtype raid0
>> $ btrfs prop set -t subvolume bgtype raid1
>>
>
> BTW, is btrfs going to support different chunk/bg type for subvolume?!
> I thought data/meta/system chunk types are all per filesystem level,
> and was planning to use superblock to record it...
>
> If really to support that, does it mean we will have different meta/dat=
a
> type for each subvolume?
> That's a little too flex for me....
>
This has actually been a planned feature for a while, and really is=20
needed to compete with the flexibility that ZFS gives for this kind of=20
thing.  System chunk types should still be set separately (although,=20
once we have n-way replication, they really should be set separately=20
from metadata to at least one copy per device in multi-device filesystems=
).



--------------ms020101020806020509040103
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTIzMTMzMjQwWjBPBgkq
hkiG9w0BCQQxQgRAqZQtIYsFG4NmI/3xKSskIYv/5lH0UPJYk0ZqEjKbwqi3SacszVqX1WyD
XFDvWlSzZ6Ag4b0FdMAQyQT3saJK8DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBP5ObG9xlkiJ5mjkEz2dSQfwfs0vPZVVhknr65JQXMKzfQKCeO
Vrv69rdJIuD0fmHoqOSL6aCKfXMjN6a4wYpX3YsHSi/G9kgUy4Vf2e71g41nQCBe5rY8TzHJ
pS8w+jvuE+89NLbt/XkKYjNTDiIvja+N1/xdrDCbZGxpISaYVkKxiqXbaq5hqX2hgG8/YtbT
ZOzkcjaH/ivCQJJYbO2W4uFpnovojjIv0mZZWAisydHrIt7FMiHvSlcg8WCEHti8HkmA4tek
SzoSzItswWK1G5YEug29xLeoEUWA6RbFKYrUxWufuxgrgK+BrHfe3xC4BnOWfoaYwayIkNGI
nxbscbx1MqNhZGutUem6oIN0RckoL7fE0DHfo06ZDk/0KiHeOzFzTIgxFG4aqJZCq0VbvHOg
kuMQw61KfTGibc03SBQkaTZ5du5hWBc+M+Sh8WaV/osEbG5mOr2aZziqX4AbWBiEZGT3ZbwY
g6F4oo3gJ+PwTB6loVkrucl9WaYLZJRVtEIMfElWj9K2p0s8jS/Px2wojFZSVITZvVdME/Ga
ymyZwFDVX9GvaWJyzWcbKLtEuWLmdb4b2ShxQeedbNgLG6/mqOKhHo3kIEhI4tdwBsJYSA4w
FlluaoubR4hP2hlRUiDrPWL0QxHgfv/bVqW7eYQbQd+6agSWLhBWXDSZdgAAAAAAAA==
--------------ms020101020806020509040103--
