Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37613 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440AbbGVLQb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 07:16:31 -0400
Received: by igbpg9 with SMTP id pg9so130310973igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2015 04:16:31 -0700 (PDT)
Subject: Re: Can't mount btrfs volume on rbd
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Steve Dainard <sdainard@spd1.com>
References: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
 <557A890D.8080306@cn.fujitsu.com>
 <CAEMJtDu2zZJc-dg9opj0xHaKyeL78H0ppivb8mJFhChJ4J63uA@mail.gmail.com>
 <557E877E.2060704@cn.fujitsu.com>
 <CAEMJtDusywPEnDcNcMvvFKQsuZyTmSMXXgJT=eBZX1F+R8RM8w@mail.gmail.com>
 <557F7B82.2060203@cn.fujitsu.com>
 <CAEMJtDv1Tm7-O2mU03kZhPDkaSj7nVi+VAZVhPfh7BN8AuF2Bg@mail.gmail.com>
 <55A46473.8070106@cn.fujitsu.com> <55AE04EF.6040807@cn.fujitsu.com>
 <55AE29DA.4050201@gmail.com>
 <CAEMJtDuaOYPomha_VbTah521BZTYzmrg2D5tk6N4rd1Y8UPaog@mail.gmail.com>
 <55AEF984.9080706@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55AF7B84.9000009@gmail.com>
Date: Wed, 22 Jul 2015 07:16:20 -0400
MIME-Version: 1.0
In-Reply-To: <55AEF984.9080706@cn.fujitsu.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020104050500060902000307"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020104050500060902000307
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-21 22:01, Qu Wenruo wrote:
> Steve Dainard wrote on 2015/07/21 14:07 -0700:
>> I don't know if this has any bearing on the failure case, but the
>> filesystem that I sent an image of was only ever created, subvol
>> created, and mounted/unmounted several times. There was never any data=

>> written to that mount point.
>>
> Subvol creation and rw mount is enough to trigger 2~3 transaction with
> DATA written into btrfs.
> As the first rw mount will create free space cache, which is counted as=

> data.
>
> But without multiple mount instants, I really can't consider another
> method to destroy btrfs so badly but with all csum OK...
>
I know that a while back RBD had some intermittent issues with data=20
corruption in the default configuration when the network isn't=20
absolutely 100% reliable between all nodes (which for ceph means not=20
only no packet loss, but also tight time synchronization between nodes=20
and only very low network latency).

I also heard somewhere (can't remember exactly where though) of people=20
having issues with ZFS on top of RBD.

The other thing to keep in mind is that Ceph does automatic background=20
data scrubbing (including rewriting stuff it thinks is corrupted), so=20
there is no guarantee that the data on the block device won't change=20
suddenly without the FS on it doing anything.



--------------ms020104050500060902000307
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwNzIyMTExNjIwWjBPBgkq
hkiG9w0BCQQxQgRAd62+uZB5PGvotqeRWObdBWRnsPRQs2dpEdMduEK4eDY4QpzvtDAVnnP4
PCcd5VeEX49c7giLw7FFa50FZvxuXDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAOSrTzd/oq64ZN65CYDE2isV1zTmuvK4EwX+5FshfTiJuJbGGl
zABXAed3wIZXhq/4Gb93HJT0GuqSdszE5AoBmQVFqezA7E8c3L3kMbBzo/fsPV2v6F+L/fVc
aiFpFQhGRLo6DngOonJxKfODbwJfQ9tNWmhxtTmWLOrVmJZllJilZopBet7Cpj2I9eZucmbZ
E7RXQEN76N3At+N+Bzh1pMlNQoOVJP+QshzTSz3luuBtR10a6L6ivvW939zWYaWijUeLouFu
YwgUsMghud/yg4q/CkZtTvqLr67IAr6CaW0P9GLMAv14bm7C+VQyn4x+2Mvg7wuUunrAA/4+
xqbgpSRdUP8LpaXM09el8IDfnCTf8pAa7Ke1WfFb+soP3V0kCSlos1mEPe5TvCZcJ08wDv3z
Ap9FRE3nP5BxPGjBQU4NmZbdJqi4AsrhZ3pIeK+SKXCmSzYq5awoFyv+aeYl1wr9dYmsqj4w
HOk44xlPN3i0x5rpQ3FO5qsOkS4YUdHdjH6DzVmbd5qBPzzASk7b0lJra5KtuCyC4G2w2/BV
DAK6VksAnjvQaVOA68Y3Q9LiE2B8OzKjzbkWuisTm8SLgSkEgJ/25feJaJBAzKNs45YSqxPe
41waXsxmkQxPzx17AS/hFmtBBynaUSVSWcElSMA767+6BF683roK8YSWKgAAAAAAAA==
--------------ms020104050500060902000307--
