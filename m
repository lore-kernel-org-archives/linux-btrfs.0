Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35510 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbbKWUPQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 15:15:16 -0500
Received: by igl9 with SMTP id 9so59114510igl.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 12:15:14 -0800 (PST)
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any kernel
 version
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <20151123175608.GI31035@twin.jikos.cz>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565373B4.2070907@gmail.com>
Date: Mon, 23 Nov 2015 15:14:44 -0500
MIME-Version: 1.0
In-Reply-To: <20151123175608.GI31035@twin.jikos.cz>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080306060805050100000103"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080306060805050100000103
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-23 12:56, David Sterba wrote:
> On Mon, Nov 23, 2015 at 08:56:13PM +0800, Anand Jain wrote:
>> Btrfs-progs is a tool for the btrfs kernel and we hope latest btrfs-pr=
ogs
>> be compatible w any set of older/newer kernels.
>>
>> So far mkfs.btrfs and btrfs-convert sets the default features, for eg,=

>> skinny-metadata even if the running kernel does not supports it, and
>> so the mount fails on the running.
>
> So the default behaviour of mkfs will try to best guess the feature set=

> of currently running kernel. I think this is is the most common scenari=
o
> and justifies the change in default behaviours.
I feel that Christoph's suggestion in the other sub-thread to have it=20
spit out a notice that it disabled something because of the kernel it's=20
running on is worth adding also.  We should probably also spit out a=20
warning if the user asks for a feature that isn't supported on the=20
current kernel (but still let them create the filesystem regardless).
>
> For the other cases I'd like to introduce some human-readable shortcuts=

> to the --features option. Eg. 'mkfs.btrfs -O compat-3.2' will pick all
> options supported by the unpatched mainline kernel of version 3.2. This=

> would be present for all version, regardless if there was a change in t=
he
> options or not.
>
> Similarly for convenience, add 'running' that would pick the options
> from running kernel but will be explicit.
Is the intent to enable stuff that the devs consider stable that's=20
supported by the running kernel, or all the features supported by the=20
running kernel?  It's probably best to use the first as the defaults,=20
and then have an option to pull in everything the running kernel=20
supports (possibly name that option something like 'running-all').
>
> A remaining option should override the 'running' behaviour and pick the=

> latest mkfs options. Naming it 'defaults' sounds a bit ambiguous so the=

> name is yet to be determined.
Maybe something like 'recommended' or 'suggested'?

It might also be nice to have an option to tell it to turn on everything =

the tools support (possibly call that one something like=20
'max-features'), though this is probably less useful due to the fact=20
that most mkfs features in BTRFS are incompat features.


--------------ms080306060805050100000103
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTIzMjAxNDQ0WjBPBgkq
hkiG9w0BCQQxQgRAi2d3kjRTE/ib0fTxlPw0/SxiTUmjORWFnLg8SjWogqV1MOi2Vpq5+m1O
mD/cfKIwruvxLW7N89uYlDC0RUFavDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBSGVAgIBuKUiKJ/IbjECfSlFkWF0gVBQWvtfCWP9F+G1kyq8sT
P9T9JXzn91yMWIzaBR6b6HMHszRp0HRKgDoIhTbfmx4PiSubcT+Xk1QVD89p2qBOFje+IXv2
Mx0JoK0jGIIDCnJ8Ef3aBRtUGV7E0pfDhACr4PPqPe2AQHBIaRX1QxzBcwGLOmGqgJkseHRM
NtCvbgTYhVXZG2cSYBBYRwcW2dg+DAhYLGa49qqUZ0YgAfrtYSqYN7Q+JaKvFPhxUKMBbwKz
UCFxKkBdVJ+A8Hjr2y/g6lbYKpUsRdzWc7uRV7mByweAcC/xA7nSxJpNqVbT4y8FeAcLbE0s
pWSTH0t0G9vpmutjJyEsyP9F1MlDP/kkHYVSAr9l5Lavjo1X7D6kI69dwlYxzaMlHLaVGBmE
X7obqKDzy0ERyAo2YiGtfGz+oJScTly05BEP667E4DhQ+50LK97VeCmmRF/u+yCtCrC59427
FZr6p9agYxwZk7E5/XMTR8vhjrH6gEqDObdxeQQI4xplybH9dB5nBiVsFrV5Nq2BiUkNO3Mu
8Wbb+o5KTh0K9Sxfpwyh/UdTIZAOfIoGgHCGRc2DLHhdJz6s6peIIZMmMOlfmJXYIe1CmqXf
gtsmCcKveVV6IG1BCx0c9/WtmWTFA+Zfr8uHJoza4jlsW123syNqnmR9hgAAAAAAAA==
--------------ms080306060805050100000103--
