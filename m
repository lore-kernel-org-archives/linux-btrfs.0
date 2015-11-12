Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34468 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbbKLR41 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 12:56:27 -0500
Received: by ioir85 with SMTP id r85so32070159ioi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 09:56:26 -0800 (PST)
Subject: Re: Potential to loose data in case of disk failure
To: Dmitry Katsubo <dma_k@mail.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
 <20151111202403.GA19245@wheatley.student.rit.edu>
 <56448A54.9020404@gmail.com> <5644CB2F.8010302@mail.ru>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5644D2AF.40904@gmail.com>
Date: Thu, 12 Nov 2015 12:55:59 -0500
MIME-Version: 1.0
In-Reply-To: <5644CB2F.8010302@mail.ru>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050804090207020101010007"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050804090207020101010007
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-12 12:23, Dmitry Katsubo wrote:
> On 2015-11-12 13:47, Austin S Hemmelgarn wrote:
>>> That's a pretty unusual setup, so I'm not surprised there's no quick =
and
>>> easy answer. The best solution in my opinion would be to shuffle your=

>>> partitions around and combine sda3 and sda8 into a single partition.
>>> There's generally no reason to present btrfs with two different
>>> partitions on the same disk.
>>>
>>> If there's something that prevents you from doing that, you may be ab=
le
>>> to use RAID10 or RAID6 somehow. I'm not really sure, though, so I'll
>>> defer to others on the list for implementation details.
>> RAID10 has the same issue.  Assume you have 1 block.  This gets stored=

>> as 2 copies, each with 2 stripes, with the stripes split symmetrically=
=2E
>>   For this, call the first half of the first copy 1a, the second half =
1b,
>> and likewise for 2a and 2b with the second copy.  1a and 2a have
>> identical contents, and 1b and 2b have identical contents.  It is full=
y
>> possible that you will end up with this block striped such that 1a and=

>> 2a are on one disk, and 1b and 2b on the other.  Based on this, losing=

>> one disk would mean losing half the block, which would mean based on h=
ow
>> BTRFS works that you would lose the whole block (because neither copy
>> would be complete).
>
> Does it equally apply to RAID1? Namely, if I create
>
> mkfs.btrfs -mraid1 -draid1 /dev/sda3 /dev/sda8
>
> then btrfs will "believe" that these are different drives and mistakenl=
y
> think that RAID pre-condition is satisfied. Am I right? If so then I
> think this is a trap, and mkfs.btrfs should at least warn (or require
> --force) if two partitions are on the same drive for raid1/raid5/raid10=
=2E
> In other words, the only scenario when this check should be skipped is:=

>
> mkfs.btrfs -mraid0 -draid0 /dev/sda3 /dev/sda8
>
Yes, BTRFS will assume you know what you are doing in that case and just =

do it.  We probably should have some kind of warning, but that gets=20
tricky when you throw in stuff like LVM (which can have any arbitrary=20
name for the logical volumes, and there isn't any way, even using the=20
tools, to easily figure out what disk a given LV is on).


--------------ms050804090207020101010007
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEyMTc1NTU5WjBPBgkq
hkiG9w0BCQQxQgRA2wCFVGESw6kJ4O0FuAI7WGuk8GiH7gkJetOX+2NW/VChS5SCyehiGDfC
jxwD1yOwwfoNQ4ytxg1IK85kAWgjEjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAyXQpBL9L3fAvPg13vRhjeGMP9Ec15PiwrP7iQj4HBEcdtwoDH
vq53jECMB8yVdM37nYFrPYLtUHXrFUdfvLh+G9QdEpvBqRcz8od8YzfMy5n4IPyc/nGRjHbW
W2aYjMg5y1IiIgM9Lo/WTLyGwRTtGs9iQ7A47D4ev2i78aA9ke1BsX5qdk5uqKXUKtEK5rxh
xAZhnUrVvZLD3iWszMv7IJGKwAZ5Dz0EtQv2bFoCIOftgSLtt3SVAne3V8TyZdTmrE8OROcJ
WrTuZjZzIn8XxcljgXxWCOcoZzM+9aikJiqkSemky2JgLyx+9ao251omC46iXxjbptLIrFNT
ni2p3PfuRxnc6WwappXRQNrijY10PZaidx/MjALftqVQgfWk/lvSz+3kEJ4NOU/USRSnycvD
MUsTdM4ryhZJhpgjdlPBaa0Kx2hXzAlBQ9QWlENGjT2LwYOAELlK/AwmiH8LgN/KBvUTWOx7
fVwXcSwNJY0UVK465qz5Io/GBZVDXQqgiz3eRxIM7AFqUppU1gLq8ua23rwI9DGD195UR/Yu
WKabcyCXbOoG+RII6SwNECPmtPxl5VVQP7MKVIoo9mObktH2cJsbzzhU/6Ps2RIbkPRv1BLK
EOI9RZ7mRB29y+pnvPHn7rkkxhOMEnokBwZg3ffS20i9/DsxRzGHp7fyZAAAAAAAAA==
--------------ms050804090207020101010007--
