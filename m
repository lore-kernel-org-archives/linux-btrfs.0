Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34553 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbbK3MaQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 07:30:16 -0500
Received: by igvg19 with SMTP id g19so68846405igv.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 04:30:15 -0800 (PST)
Subject: Re: [PATCH v2 1/5] btrfs-progs: introduce framework to check kernel
 supported features
To: dsterba@suse.cz, Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <1448283378-10579-2-git-send-email-anand.jain@oracle.com>
 <CAMU1PDita6iet1xg97RfCDPWuVUaq=dYBO_eM3ZDQtvLRPcHCw@mail.gmail.com>
 <5654C6BF.8010502@gmail.com> <20151126173850.GV31035@twin.jikos.cz>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565C4152.8040103@gmail.com>
Date: Mon, 30 Nov 2015 07:30:10 -0500
MIME-Version: 1.0
In-Reply-To: <20151126173850.GV31035@twin.jikos.cz>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000002030008010409070108"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000002030008010409070108
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-26 12:38, David Sterba wrote:
> On Tue, Nov 24, 2015 at 03:21:19PM -0500, Austin S Hemmelgarn wrote:
>>> I think you mean 2.6.37 here.
>>> 67377734fd24c3 "Btrfs: add support for mixed data+metadata block grou=
ps"
>> This brings up a rather important question:
>> Should compat-X.Y mean features that were considered usable in that
>> version, or everything that version offered?  I understand wanting
>> consistency with the kernel versions, but we shouldn't be creating
>> filesystems that we know will break on the specified kernel even if it=

>> is mountable on it.
>
> IMO compat refers to the compatibility feature bits so it's whether the=

> filesystem is mountable on a given version. Usability can be subjective=
=2E
> I assume the kernel versions in wide use match some of the long term
> branches. If it's k.org, we can submit the fixes and distros update
> their long term branches.
My point was that if we know that there's a significant chance of either =

data corruption or a kernel crash when using a given feature with a=20
given kernel, we should not turn on that feature for that kernel.  For=20
every other project I've ever seen, compatible means that you can be=20
fairly certain that it won't crash, and won't destroy data.  There is no =

excuse for knowingly making filesystems that will break the system.

Also, expecting the distros to keep up with development given the pace=20
at which BTRFS is moving is not all that realistic.  Secondarily, at=20
least Ubuntu has a habit of picking kernel versions that aren't marked=20
LTS by kernel.org.
>
> A table of "is the feature usable" would be interesting but I think it'=
s
> for wiki.
I'd say it would be a lot more helpful in the manpage than in the wiki=20
(if you're reprovisioning a system, you don't necessarily have access to =

the wiki).


--------------ms000002030008010409070108
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTMwMTIzMDEwWjBPBgkq
hkiG9w0BCQQxQgRArdfLQ8U5gC/kFMUZ6k74bQbv9Kj4qyo4di6TbzIYeznXg97T15HlPPlf
1JLd57Tgdghr84u+QNyaWszwrWh/FjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCMmvyPGW0nqQcE/O66sbuUVC1lzQlNJ7ouXa68l0ZcpB5tMtEp
Jv50Li/24yOP6Gz4AlobflSHQEvo7qNUBy1MCBjFPZz9HSG6GjtTTh3fkCipmVM6OYRPOH+D
7fZ91/cHeYLDQocUCjYrWQWa1UUqKpgsdqwiZa8nvaAP/H4GIOBUFYevV1WoUFQzMXw8/1ve
V3pPA1L6c8n477qchqPidCqrXDHbDI4xa9HYZwgGn9eSW6sTtLKrQVJYSYkte+hMG8w5haLZ
5iYDbbK3lsLAxorPCjsTk5YRxKJZbFKgc5EiZYUz9vapQXdDn1j9H+CnHImAgpou+NCcKA/T
Ko9ctzcyb8aYnsfoqur2ojzuRYepaWX8o9XlZNv8uGzjgtmujyZ80mPELrmHvG9ItjmxcE/r
qFFcifXRf5KxQL/vK+JrRj5PkGjFahxwV6Dj0loBgLe6vdrT5oj9LRcdlt2d57A2fTnMgL37
n+fcH2zGe0llbFFurnGTxJHfkLYxEsK6OcXwirCpzuzghPrq3EXClS0EEoMpsqfeK7fctegI
ZlPy6X+JHtRkUFOnJZdQsJnj7+/atiwAYEpXHsx1qn25NgNrYOTxtYdLX/QOpEXJMKXzalqr
8wFZ4v1NidCMXJz5wagwg7DRVp08wWXqfqDtPE+2pvY/aps90J42q+tuywAAAAAAAA==
--------------ms000002030008010409070108--
