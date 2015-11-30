Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38888 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbbK3PHK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 10:07:10 -0500
Received: by igbxm8 with SMTP id xm8so73950041igb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 07:07:09 -0800 (PST)
Subject: Re: shall distros run btrfsck on boot?
To: Jeff Mahoney <jeffm@suse.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1448337754.14125.33.camel@scientia.net>
 <5659DBD9.1070802@suse.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565C6611.1000405@gmail.com>
Date: Mon, 30 Nov 2015 10:06:57 -0500
MIME-Version: 1.0
In-Reply-To: <5659DBD9.1070802@suse.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030508070401010502030400"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030508070401010502030400
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-28 11:52, Jeff Mahoney wrote:
> On 11/23/15 11:02 PM, Christoph Anton Mitterer wrote:
>> Hey.
>>
>> Short question since that came up on debian-devel.
>>
>> Now that btrfs check get's more and more useful, are the
>> developers going to recommend running it periodically on boot (of
>> course that wouldn't work right now, as it would *always* check)?
>
> Running fsck on boot is a holdover from an era where non-journaling
> file systems were the norm.  It persists in the ext* world mostly due
> to inertia, but it shouldn't be run on boot with ext3 or ext4 either.
>   As Eric noted, fsck.xfs is a no-op.  We have something similar for
> btrfs and have no intention of ever running fsck on boot with btrfs
> except in the case of a mount failure of the root file system.
The bit about ext* is debatable, the code doesn't appear to do any=20
automatic repairs on an online filesystem like XFS does (and BTRFS does=20
when you scrub it), which would indicate to me that it should be run,=20
but not forced on boot for ext3/4, assuming the FS is configured sanely=20
(which means on the systems I manage, it only gets run at most once=20
every 24 hours unless I break into the boot sequence and force it manuall=
y).
>
>> Plus... is btrfs check (without any arguments) non-desctructive, or
>> are there corner-cases where it may lead to any changes on the
>> devices?
>
> I haven't reviewed it in detail, but a quick glance makes it look like
> it will, minimally, create transactions even in check-only mode.
I agree with Qu here, if this is the case, it's a bug that needs to be=20
fixed.



--------------ms030508070401010502030400
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTMwMTUwNjU3WjBPBgkq
hkiG9w0BCQQxQgRAcQ5vyXQ29Q5M9KHE+oqBJbThl2Ski0vLpV/UqissGsWXRUvT0dYrQL7x
8nD8uMiROW3KgS0cNzhR6noR3KsM5jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCO0g+h2l/zCHPfiuqHOpa2xUDzxAiM6uZKaxbkOHYugyTI0i1J
/q8Ze9ckcOqwxAwmbe0OKHACJCL48zNWY8B+JV2BjulYzB3fFpRKQvP2cfR19V5a09a1Gzmt
Yre1Gtp1SCHReWlTxsJzmBP64owhWTkjzmphvvVkkgl857zRu4x8vwnzDWd9Bo/hMFcV3s5V
OPXMBc7v944mmWjfjJ8dGMsDuznVdHANKHlXrGLTumoOE635clFsvm9HWwV4QpmZidGAUrn6
IR9hdbEIBKXemM9ZiZT0uDJg3svEEFe/t1pzPK+qKOp4n1cOCzrpifwyqf+W2CAA1ljczrvA
7tNtJPe1foc89k1FuRpNMIi9fKfebns070wxjFNT8WBwRbg8TDgNMZtLyjb7+wnt5omZrzZ8
ze7XLGSyW7GMdENBrUWHp7up/kk10opoptQei8eGv/Nw9FSeYD76CtlG6F0qfbbIdJveO28Q
/OFtOO1LqfzaBH2hM6U0z49NZUmoh26aZYQc/QnUBib8yrpKd+hA8ODN1DlMTOsPFXpQh26F
KbeI63hujBVxFc8k9qQ9x4M8l3Oc5PPafvFQb7Y03y0rdPmiO5bXZaQZgnIsI7pqU8o6vmG1
wTaZICSP08yNlswt+vpq/FfdOBej/sO+HyyNbP15Mdy/qZ5D4RRUfyGVUwAAAAAAAA==
--------------ms030508070401010502030400--
