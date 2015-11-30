Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:32889 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbK3RIy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 12:08:54 -0500
Received: by iouu10 with SMTP id u10so183158212iou.0
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 09:08:54 -0800 (PST)
Subject: Re: Bug/regression: Read-only mount not read-only
To: Chris Mason <clm@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151130164801.GD2162@ret.masoncoding.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565C8298.9010006@gmail.com>
Date: Mon, 30 Nov 2015 12:08:40 -0500
MIME-Version: 1.0
In-Reply-To: <20151130164801.GD2162@ret.masoncoding.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070803020808000904080407"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070803020808000904080407
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-30 11:48, Chris Mason wrote:
> On Sat, Nov 28, 2015 at 01:46:34PM +0000, Hugo Mills wrote:
>>     We've just had someone on IRC with a problem mounting their FS. Th=
e
>> main problem is that they've got a corrupt log tree. That isn't the
>> subject of this email, though.
>>
>>     The issue I'd like to raise is that even with -oro as a point
>> option, the FS is trying to replay the log tree. The dmesg output from=

>> mount -oro is at the end of the email.
>>
>>     Now, my memory, experience and understanding is that the FS
>> doesn't, and shouldn't replay the log tree on a RO mount, because the
>> FS should still be consistent even without the reply, and
>> RO-means-actually-RO is possible and desirable. (Compared to a
>> journalling FS, where journal replay is required for a consistent,
>> usable FS).
>>
>>     So, this looks to me like a regression that's come in somewhere.
>>
>>     (Just for completeness, the system in question usually runs 4.2.5,=

>> but the live CD the OP is using is 4.2.3).
>
> We do need to replay the log tree, even on readonly mounts.  Otherwise
> files created and fsunk before crashing may not even exist.
I would argue that if a user is trying to mount read-only after a crash=20
(that is, the user requests a read-only mount, not if the kernel forces=20
it), then that probably means that the user has a specific reason for=20
doing so, and doesn't want us writing to the filesystem at all.  I=20
understand wanting consistency, but if your system just crashed and your =

FS won't mount RW, then it's probably not a good idea to do anything=20
that would cause it to be written to until you've figured out what's=20
wrong and fixed it.  Because of how BTRFS is designed, about half of the =

things that are needed for recovery on average, need a mounted=20
filesystem.  If you can't mount RW, then something _is_ broken, and you=20
shouldn't be doing anything to the FS unless the user tells you to.
>
> We'll bail out of the log replay on readonly media, but otherwise the
> replay always happens.
We have the ability to make a RO mount truly RO, so we should have some=20
way to do that without needing to jump through hoops to make the media=20
read-only.  Not needing to jump through hoops to do this is a BIG=20
selling point for some people (myself included) for a filesystem.=20
Perhaps we should provide an option to control if the log replay happens =

at all (and then we wouldn't need btrfs-zero-log)?  Or we could replay=20
the log in memory, and only write changes to disk if the FS is mounted RW=
=2E


--------------ms070803020808000904080407
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTMwMTcwODQwWjBPBgkq
hkiG9w0BCQQxQgRAitF+58CJDa0E/O+nht3L8T3dpkMKVMZOJ2rr/atcVmCXB02aRtUDxQS6
0IhrbYaA7bSF1LRMXBv9vG7FidWe3TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCYtqqwCmZIWRxAo0Zgmp2jfDMi0UH9T7X6qvkdkecUKf14kx63
Vnm1cAXbugKRVl7o8sovs+TvxXnlYLUppnKYOCdVBCb/whWS3WsUu3+spTn2kFpUmzE60CbV
mLNvens1Wq2z9AlQS6MMZO37gLERbbhJwuSRpxOB7GC+XwyisFPbbHR+ugEpLhYGopByJNSA
5wrwoNCC9BSoe4muSbFoNXilabY9fyImIBoZ/jfr3Tpb1fhftxRLHM9R01l4Sd7XvO2ytK+l
qyimP/ampvHSfUh1HkycWhCN2BIkm7eBtCmvsFVCdqtnYi2szjWeDNJe9pM4K4TDm6BBMgRV
t2sdOzyZr8IGAso3jaDq9nEHj0lKhSTH64g6exdNUl4NaAXTGKKekySirxVpKwnGmr7zVocG
Yf0Z6m8w90IwL4WyErPnFdfUKMyO03RpylgFAqYBVJe8dBM9MLruccnyeNBGHmLHE/9wR328
2itqYmNHYrcO7JYTTjt6lVhrg9Z58egBTWEbHqcUOu3ogxwz5P82IBUMxZ0RyBvH6xw2Dyi/
dEVE2e3vUKfe5+41f4o1i3Wp8u45NbK8+CaUujUjHFMKv/po4zKvibZSXxFlj9VlMum14ADo
JuN0C3xv/YyRaBpmc+1bBnMH2XonBww+5jWC1Wwk/bazdzLjHY/fhuNDkwAAAAAAAA==
--------------ms070803020808000904080407--
