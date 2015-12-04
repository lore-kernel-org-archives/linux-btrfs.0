Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38751 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbbLDMdR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 07:33:17 -0500
Received: by igbxm8 with SMTP id xm8so35512968igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 04:33:16 -0800 (PST)
Subject: Re: Bug/regression: Read-only mount not read-only
To: Hugo Mills <hugo@carfax.org.uk>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Eric Sandeen <sandeen@redhat.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Russell Coker <russell@coker.com.au>, Chris Mason <clm@fb.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151201190018.GD8918@ret.masoncoding.com> <565DEF65.4080900@redhat.com>
 <201512021725.32750.russell@coker.com.au> <565EB480.4010509@cn.fujitsu.com>
 <565EB878.9090501@cn.fujitsu.com> <565F2260.1080004@redhat.com>
 <565F2EF7.5000109@gmail.com> <565F753B.5020000@redhat.com>
 <565F8158.4090304@gmx.com> <20151202235155.GM8775@carfax.org.uk>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <566187E7.6050402@gmail.com>
Date: Fri, 4 Dec 2015 07:32:39 -0500
MIME-Version: 1.0
In-Reply-To: <20151202235155.GM8775@carfax.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010906030402030304070008"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010906030402030304070008
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-02 18:51, Hugo Mills wrote:
> On Thu, Dec 03, 2015 at 07:40:08AM +0800, Qu Wenruo wrote:
>>
>>
>> On 12/03/2015 06:48 AM, Eric Sandeen wrote:
>>> On 12/2/15 11:48 AM, Austin S Hemmelgarn wrote:
>>>
>>>> On a side note, do either XFS or ext4 support removing the norecover=
y
>>>> option from the mount flags through mount -o remount?  Even if they
>>>> don't, that might be a nice feature to have in BTRFS if we can safel=
y
>>>> support it.
>>>
>>> It's not remountable today on xfs:
>>>
>>>          /* ro -> rw */
>>>          if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY=
)) {
>>>                  if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
>>>                          xfs_warn(mp,
>>>                  "ro->rw transition prohibited on norecovery mount");=

>>>                          return -EINVAL;
>>>                  }
>>>
>>> not sure about ext4.
>>>
>>> -Eric
>>
>> Not remountable is very good to implement it.
>> Makes things super easy to do.
>>
>> Or we will need to add log replay for remount time.
>>
>> I'd like to implement it first for non-remountable case as a try.
>> And for the option name, I prefer something like "notreereplay", but
>> I don't consider it the best one yet....
>
>     Thinking out loud...
>
> no-log-replay, no-log, hard-ro, ro-log,
> really-read-only-i-mean-it-this-time-honest-guvnor
>
> Delete hyphens at your pleasure.
>
Personally, I think no-log-replay (with or without hyphens) is the most=20
concise option name.  With something like this, it should be as clear as =

possible what is being done.



--------------ms010906030402030304070008
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA0MTIzMjM5WjBPBgkq
hkiG9w0BCQQxQgRA2o/JFrhgo+h8JxcGWq0o5hyiUW6hnVwXttfMnJkBN07+QwJUNyPqAvzm
sR8ayGWju+t7YtiipuuE7vGGR9UGdDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB7fHm49Pip42PCTBqGZlwpP7kLWUlB/JtkCRKILmOxBldyx6yI
PJnrWccLmFDlU/cXpvGIqNXjOysn5Yo9Ktj3MzlqFMX8J48/rzRAHbQ0OHglGBITeipZYsnh
0pAhahOb+nWZI39OQKDmnx/qySUTu4ydXT4f+fDt22yIIaaHWlqkF/sR8zv3hEkG4ajIxxyt
0Z49C/sooQ80kRPqEgY1DLlVQzMSX5pBOMCeRjyDGNPuunw9S1DT2lG+RG2dBn6J4Kql6PE1
TYYwROOFFkXYz3Krb/VT1+3+BfOFcPCT1dyMrRIHCl3dj8dN9CN78kNH1qUqJc0jcrpAgK9Y
Kt6Pgji4MjwyEJuWgddsj18USfKV+c3X0GAHzIkY8rxa4aJWAPu+QRP8clirFUzzJ4NNGLTE
R5XX13gxH+r6G8nc0oER+SlGqTluzGlvBIYBG0OdHDHPTX2J3ZjlYseBI5ufGgRNmxpyK8H0
7wbrT7rIo+bOxRkwyW3zCbTLeWxXA34oIFY75IP/t2aJgdxOXxGVpHXu3ZIG8yYkDEnUdt9S
pjOSc/0k9e5phQDDvjfMNGH6+71v+aJb7gzYAUJ64MSk+o8u0WmxLXN5sSPP9sHs8+sLX/dW
SxM4EcZoQ1/mq9BxlQnbzBbGJihzTWB1cxRHCXYbdC9epXWaAlwVcAWVQAAAAAAAAA==
--------------ms010906030402030304070008--
