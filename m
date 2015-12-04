Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:32964 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbLDMYa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 07:24:30 -0500
Received: by igcmv3 with SMTP id mv3so34537682igc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 04:24:30 -0800 (PST)
Subject: Re: Bug/regression: Read-only mount not read-only
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Eric Sandeen <sandeen@redhat.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Russell Coker <russell@coker.com.au>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151201190018.GD8918@ret.masoncoding.com> <565DEF65.4080900@redhat.com>
 <201512021725.32750.russell@coker.com.au> <565EB480.4010509@cn.fujitsu.com>
 <565EB878.9090501@cn.fujitsu.com> <565F2260.1080004@redhat.com>
 <565F2EF7.5000109@gmail.com> <565F753B.5020000@redhat.com>
 <565F8158.4090304@gmx.com>
Cc: Chris Mason <clm@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <566185D8.8040303@gmail.com>
Date: Fri, 4 Dec 2015 07:23:52 -0500
MIME-Version: 1.0
In-Reply-To: <565F8158.4090304@gmx.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030608030608090008040604"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030608030608090008040604
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-02 18:40, Qu Wenruo wrote:
>
>
> On 12/03/2015 06:48 AM, Eric Sandeen wrote:
>> On 12/2/15 11:48 AM, Austin S Hemmelgarn wrote:
>>
>>> On a side note, do either XFS or ext4 support removing the norecovery=

>>> option from the mount flags through mount -o remount?  Even if they
>>> don't, that might be a nice feature to have in BTRFS if we can safely=

>>> support it.
>>
>> It's not remountable today on xfs:
>>
>>          /* ro -> rw */
>>          if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)=
) {
>>                  if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
>>                          xfs_warn(mp,
>>                  "ro->rw transition prohibited on norecovery mount");
>>                          return -EINVAL;
>>                  }
>>
>> not sure about ext4.
>>
>> -Eric
>
> Not remountable is very good to implement it.
> Makes things super easy to do.
>
> Or we will need to add log replay for remount time.
>
> I'd like to implement it first for non-remountable case as a try.
> And for the option name, I prefer something like "notreereplay", but I
> don't consider it the best one yet....
>
I entirely understand wanting a simple implementation first, my only=20
point is that it would be a potentially useful feature to have if we=20
could sanely implement it.



--------------ms030608030608090008040604
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA0MTIyMzUyWjBPBgkq
hkiG9w0BCQQxQgRAHDOTTiDqFUxg2OwKyoXfRrZURGNt/aPue7DsOiftYXXCYnPCwlTXSiTy
Ytkn2Qgh6lqPy6y9dEu3QSrcs/khgTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAr1/8JS+w3uyiNjbJxLVJo6PoDTJf1+auBH0uRPsz/ZWlghTc1
d2k/OqTHEe1BM61l10mvpIrDwfblxWI+7sFU1jA+9Zc/Bxtm68E2baCn0WC16hf5PmqNqMqV
1x3T37UpNiBWYfEq2s7NQsjOjZtcGM+yvw7g0tXJ1zTniYJxLyDErCpwBu1gQsMDXuMizXPV
tOmzXi9lEEOf+SVUghJsoVYH8X40MViQcGUvP2GT0dddWP3wCPDNRZGRewi4+LHXXf9wbveM
gjghiBnmpZNP7X5yI6aLLEYVZMrtLjJk3u5f8P4HnJpw5/q5q10krWfSFcCpwAUgbUBBr5SJ
bK0JBEd8bZitGBWZQfs1dKU9uvzQJ1UutBMjNsZCpnyW3RtmMBiXFnuCovlMXURLCEU5xhoG
Itp4JZWuBxMu8Qt6S26QkPSxrmj/9K9i8JlWtQpICoCMAQm1vYcPNh7hcRBkAts9q+mqk19u
FC/QO/7aAdxmMsZXh/7GSrXYGtxjySGfBwGAYb6dQY2fsOLUBhpkq/tj3rzkEMbRmT1jI/1I
u17olsWUSd5rBHAIA12fdmDhm0ewHKI2oBt5W8RZm+PNf6oehEV16en/DfVLj6nt9q99P3SJ
WBo++prXNRitVotSnPpKdYCHoN264a/q76lCvk1kHjv+b27VmsgQGQnYhwAAAAAAAA==
--------------ms030608030608090008040604--
