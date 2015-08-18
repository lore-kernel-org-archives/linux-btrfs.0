Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36441 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbbHRLnH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 07:43:07 -0400
Received: by igxp17 with SMTP id p17so78288109igx.1
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 04:43:06 -0700 (PDT)
Subject: Re: Btrfs is amazing! (a lack-of-bug report)
To: Tyler Bletsch <tyler.bletsch@gmail.com>, linux-btrfs@vger.kernel.org
References: <55D1567B.3030809@gmail.com> <55D1CA1E.1060103@gmail.com>
 <55D23397.6090404@gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D31A3C.3080208@gmail.com>
Date: Tue, 18 Aug 2015 07:42:52 -0400
MIME-Version: 1.0
In-Reply-To: <55D23397.6090404@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090603010503080504000002"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090603010503080504000002
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-17 15:18, Tyler Bletsch wrote:
> Thanks. I will be trying raid5 in production, but "production" in this
> case just means my home file server, with btrfs snapshot+sync for all
> data and appropriate offsite non-btrfs backups for critical data. If it=

> hoses up, I'll post a bug report.
So far, that's been my use case for btrfs raid6, and (barring one bug I=20
found involving an interaction between btrfs and thinly provisioned=20
storage that shouldn't be an issue for you if you're not using LVM thin=20
pools) I have yet to hit any bugs, although based on the lists, I've=20
probably been _very_ lucky in that respect.  If you're willing to take a =

marginal performance hit (about 1-3% in my experience, which is notably=20
less than the performance difference between MD-RAID5 and MD-RAID6), and =

have at least four disks, I'd suggest using btrfs's raid6 profile=20
instead of raid5, they use exactly the same code, it's just that raid6=20
has one more calculation involved and provides better protection against =

data corruption due to the double parity.
>
> Going to try to avoid LVM, since half the appeal of btrfs for me is
> getting away from the multiple duct-taped layers of indirection that I
> you get currently with ext4/MD/LVM setups.
Understandable, my main reasons for having LVM are storing virtual=20
machine disk images and the fact that MD/DM raid is still ridiculously=20
fast compared to btrfs raid (many of my btrfs raid volumes are=20
themselves on top of LVM managed software raid0 or raid1 volumes).



--------------ms090603010503080504000002
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODE4MTE0MjUyWjBPBgkq
hkiG9w0BCQQxQgRAsykLASHinjPdKk5EV+fG6fWeMHccAPQgXKSdGXYknABDKc91Z9FzRb3G
vK0oHhsnHG0kGz4pmgwXiczta4dCWzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBkeIoGK4glOHzKWubJG4iAqLPkUShmLA4rkn7ayYuJpl8G6cKQ
SjVvjQDtjH7oB9VoIYtsDXPTZHi83jS9UhG/GOYAySvh8cw9PYHZWdRvWqDWKI61VkSVVmJY
+8fBYZ7ORaRkVBAQwGSTQRZlMIlPJjjt7EBa2JtGLUGzxF83+Is191su7KVFAFj1OssMygzZ
zEs2pF3+fFkD8LqLqRYIRK+ejSAA5TOThTh/zKYjk7/pn/UznvA74d2tY5HvT4tbfA01T58t
YdTTrqfBMm3KQ2zFDf7enqBoMKe5UmX6nGv9wtme7xixcjJzhdTqiet9wNIunke6r610JcxJ
27d2JbnreqfmzdGtclm0QIGqVSlyPOQx1ajR8AHFyB+StXSMlCko6eKqKWsADNTjMou9tqNH
21hc4xGG2nxZZP5nNDo+8sX40ARCpOUzIlJoXiL/+Wqo1J2ANIxELs3hDeQKhWnw1qM0H1+l
zcQTYuVNxhuLlqKM4cNNHRiCLtH9OItv5gaqGscwoqw/IUnTKslQiKV2fpABfBAvSE/kmvR7
54Ym4mq1glShVSk7R2OEnZC3u3VFbyQ3P59AqdOyVoM2DTZZp7L57HdQq5xZlKms4mwmUnaD
1gzQEZwEbOCOA4E5XxJ0ZvjxWCBl0SoAqTP0ZLq3GOlhxJdSco2R7aZUiAAAAAAAAA==
--------------ms090603010503080504000002--
