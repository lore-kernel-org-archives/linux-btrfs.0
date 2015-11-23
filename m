Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36289 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbbKWQFk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 11:05:40 -0500
Received: by iofh3 with SMTP id h3so191934995iof.3
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 08:05:39 -0800 (PST)
Subject: Re: [PATCH v2 3/5] btrfs-progs: kernel based default features for
 mkfs
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <1448283378-10579-4-git-send-email-anand.jain@oracle.com>
 <1448294271.2100.3.camel@scientia.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56533951.7090208@gmail.com>
Date: Mon, 23 Nov 2015 11:05:37 -0500
MIME-Version: 1.0
In-Reply-To: <1448294271.2100.3.camel@scientia.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030903030903090406030904"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030903030903090406030904
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-23 10:57, Christoph Anton Mitterer wrote:
> Hey.
>
> On Mon, 2015-11-23 at 20:56 +0800, Anand Jain wrote:
>> This patch disables default features based on the running kernel.
> Not sure if that's very realistic in practise (most people will have
> some distro, whose btrfsprogs version probably matches the kernel), but=

> purely from the end-user PoV:
>
> I would find it useful if btrfs gives a warning if it creates a
> filesystem which (because unsupported in the current kernel) lacks
> features which are considered default by then.
It should give a warning if the user requests a feature that is=20
unsupported by the kernel it's being run on, but it should not by=20
default try to enable something that isn't supported by the kernel it's=20
running on.
>
>
> AFAIU, really "clonding" (I mean including all snapshots, subvols,
> etc.) a btrfs is not possible right now (or is it?), so a btrfs is
> something that rather should stay longer (as one cannot easily
> copy&swap it to/with a new one)... so for me as an end-user, it may be
> easier to switch to a newer kernel, in order to get a feature which is
> default, than to migrate the fs later.
It is actually possible to clone a btrfs filesystem, just not in a way=20
that people used to stuff like ext4 would recognize.  In essence, you=20
need to take the FS mostly off-line, force all subvolumes to read-only,=20
then use send-receive to transfer things, and finally make the=20
subvolumes writable again.  I've been considering doing a script to do=20
this automatically, but have never gotten around to it as it's not=20
something that is quick to code, and it's not something I do very often.



--------------ms030903030903090406030904
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTIzMTYwNTM3WjBPBgkq
hkiG9w0BCQQxQgRAjYedALKfquTWeN4ooRTJ7QFpxF+6NL1A/W42XyNaAW7IXsvN1oBaM0aE
VpUK3o+hJecBT/k+dcCrjM6clOWULTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAJJ/g89dmhkAuEv8+X04hW1Jcmjwtu4toyyHnXhQfWwFuYngE4
vQ7jBqT7gkmPZM203RsnX+uVv5o3xZcqv/I6Zd7aZnFts8h0pM+v1URLqVqKmaSEybne2Kl5
4176POfI8dEEhencts7vxsGv96m0rZm11K840+ZixkhTrTHm2wVI38Qj2W1ncnSoLg4tNmFb
vME3UyMe3V7Zc6VKzc8y9b1kCMNgSDTWQHQFpVs/JQoEE5k5mH5ar0bWxseBmEOwXyCz4ps6
hIQQt8knoCPkSYZ7QTBJlUmxrN8kii9dTnxoP/Ti//zzEPbAFV3RJi7gVBOKZYV16aWfnZiA
fayDWRTuWd1mi3Hi94iHzwMbJYA1lcqtX95TwDXxp74tUK7hvsGLo/mXjaBcbtQXo82pwE/3
WBRiEhQrkLE3vcK9KL9+FSxCb2KCfXwAi0tiE8Z4vHCaOjUmpnedC4HxWopYCPvoGBjS4HY/
F5u80Dxdr1SRe3K6xX96t9JlasD8CPF8756twk2nMdEGKRjDOgudvshvSTR4KH+IAQmtclsW
QLpfkOv9Ji6JM2ylg98o6b4kj3RZ8AqJzBG4hF3EB67lpaU/JSLTG5wdN6JKzg+dHqqCcdXt
Eu1XfycA8webE240mtmUdl6PpBCWSUnaZPqZ2ZlxZ9kOK1YDUioKhZiHSgAAAAAAAA==
--------------ms030903030903090406030904--
