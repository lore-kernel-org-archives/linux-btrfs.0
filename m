Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33188 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029AbbLBRtL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 12:49:11 -0500
Received: by iouu10 with SMTP id u10so54999966iou.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 09:49:11 -0800 (PST)
Subject: Re: Bug/regression: Read-only mount not read-only
To: Eric Sandeen <sandeen@redhat.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Russell Coker <russell@coker.com.au>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151201190018.GD8918@ret.masoncoding.com> <565DEF65.4080900@redhat.com>
 <201512021725.32750.russell@coker.com.au> <565EB480.4010509@cn.fujitsu.com>
 <565EB878.9090501@cn.fujitsu.com> <565F2260.1080004@redhat.com>
Cc: Chris Mason <clm@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565F2EF7.5000109@gmail.com>
Date: Wed, 2 Dec 2015 12:48:39 -0500
MIME-Version: 1.0
In-Reply-To: <565F2260.1080004@redhat.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080700080505060006080201"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080700080505060006080201
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-02 11:54, Eric Sandeen wrote:
> On 12/2/15 3:23 AM, Qu Wenruo wrote:
>>
>>
>> Qu Wenruo wrote on 2015/12/02 17:06 +0800:
>>>
>>>
>>> Russell Coker wrote on 2015/12/02 17:25 +1100:
>>>> On Wed, 2 Dec 2015 06:05:09 AM Eric Sandeen wrote:
>>>>> yes, xfs does; we have "-o norecovery" if you don't want that, or n=
eed
>>>>> to mount a filesystem with a dirty log on a readonly device.
>>>>
>>>> That option also works with Ext3/4 so it seems to be a standard way =
of
>>>> dealing
>>>> with this.  I think that BTRFS should do what Ext3/4 and XFS do in t=
his
>>>> regard.
>>>>
>>> BTW, does -o norecovery implies -o ro?
>>>
>>> If not, how does it keep the filesystem consistent?
>>>
>>> I'd like to follow that ext2/xfs behavior, but I'm not familiar with
>>> those filesystems.
>>>
>>> Thanks,
>>> Qu
>>>
>>
>> OK, norecovery implies ro.
>
> For XFS, it doesn't imply it, it requires it; i.e. both must be stated =
explicitly:
>
>          /*
>           * no recovery flag requires a read-only mount
>           */
>          if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
>              !(mp->m_flags & XFS_MOUNT_RDONLY)) {
>                  xfs_warn(mp, "no-recovery mounts must be read-only.");=

>                  return -EINVAL;
>          }
>
> ext4 is the same, I believe:
>
>          } else if (test_opt(sb, NOLOAD) && !(sb->s_flags & MS_RDONLY) =
&&
>                     ext4_has_feature_journal_needs_recovery(sb)) {
>                  ext4_msg(sb, KERN_ERR, "required journal recovery "
>                         "suppressed and not mounted read-only");
>                  goto failed_mount_wq;
>
> so if you'd like btrfs to be consistent with these, I would not make
> norecovery imply ro; rather, make I would make it require an explicit r=
o, i.e.
>
> mount -o ro,norecovery
Agreed, with something like that, it should as blatantly obvious as=20
possible that you can't write to the FS.

On a side note, do either XFS or ext4 support removing the norecovery=20
option from the mount flags through mount -o remount?  Even if they=20
don't, that might be a nice feature to have in BTRFS if we can safely=20
support it.



--------------ms080700080505060006080201
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjAyMTc0ODM5WjBPBgkq
hkiG9w0BCQQxQgRAKxOGniLwHfvI0RKKgQI5UBx8JGpcq1+P9ktxYZSXqIssErvMWGXN6wn5
v6xpUZ3Xc3XEvRUHGgGCa1nDMyqavjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBPLZOlSkawmyQiQDNJKO4+0gZVoooY1+cZuYuIVkpFtRnWEcXI
0tCGPE7PZ7AGC/hv8g7oT9CmA1oh1WTgzsiWDWf7gtot+4sig/HA1UnjMWozaVJele9BkHrr
xpp2ce0M2g9gKLDbyQMMx2eYV18HPY9p0kNUR8aKglHe2BjbP0Uz2u1hD5Ahi+KoMgPkOunr
Qx8h+0inxK68OXB3H86dqrDkpcxJLTaw7hj4PzyGmuXFWj9zX37pTeqW8X/SE3swYKFrrhlQ
CCGeW2rVy5xztOFPD1oVvP25e6Roa4YcCX5pa3y9mBjwzjt6GXESuqajf6mH5hnKptATYvC5
nMvz0voy7bOvIOy7euz75TVwSB1E4E4BbKMtFLYxHlbU1IIsLKkJJR8oxtTfc69V5wFxKPiA
uh4MAPOqLZnUrA9s36Ia/CnSkT/2DVkF6XNM0rwrGwROrCsXV/lr6ujnxOyUHctnBG1fFb7p
BDuTrVlfeNFyEfgGzEkI05O4mJn6TZLBvsArh2Sij2KxeQGb51COMmGSLJ9aydMr6UXjlJjZ
hovZaqZTGXYmJglwk/z3iL7GBdfbIrkV8ZqihrP4WfljQcotAgxS2xmXkBVCRwDTOhyaEPL6
0sEpsokrrqCPdO9pq9jUJ4l0mtcTTipF2tG981zHQxYT3OoVRtDZS3wv7QAAAAAAAA==
--------------ms080700080505060006080201--
