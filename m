Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34454 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbbIJNra (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 09:47:30 -0400
Received: by igcpb10 with SMTP id pb10so20185995igc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2015 06:47:29 -0700 (PDT)
Subject: Re: Cancel device remove?
To: =?UTF-8?Q?Piotr_Paw=c5=82ow?= <pp@siedziba.pl>,
        Paul Jones <paul@pauljones.id.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <B7F2379062E32745A8651FBDB20F64596913D2BD@Server.waterlogic.com.au>
 <55F18310.9070907@siedziba.pl>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F189E7.8020509@gmail.com>
Date: Thu, 10 Sep 2015 09:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <55F18310.9070907@siedziba.pl>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060009040304090708090904"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060009040304090708090904
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-10 09:18, Piotr Paw=C5=82ow wrote:
> Hello,
>> Is there some way to cancel a device remove operation? I have
>> discovered that if I reboot that will cancel it, but that's not always=

>> possible. What I'm after is something the same as cancelling scrub.
>> I keep running into situations where I want to pause a remove
>> operation for speed reasons.
>
> Since removing a device involves shrinking it to 0 size first
> (http://lxr.free-electrons.com/source/fs/btrfs/volumes.c#L1743), I gues=
s
> you could just run "btrfs filesystem resize" in a loop as a workaround,=

> shrinking it incrementally, and then remove at the end.
OK, what I'm about to say may be absolutely totally wrong, you have been =

warned.  If I understand the code correctly, device remove is internally =

equivalent to shrinking the device to 0 size, and then running a=20
balance, then deleting the device from the FS metadata.  Based on this,=20
I 'think' than you may be able to use btrfs balance cancel on the FS to=20
stop the device remove, and then optionally do a resize to revert the=20
remove.  However, even it this does work, it probably isn't a=20
particularly good idea.  I would love to see some way in the tools to=20
pause/cancel this just like a scrub or balance however.

It is worth noting that you should be able to limit the disk=20
bandwidth/set the I/O priority of the operation by using either=20
cgroups/ionice respectively on the userspace command (unlike a replace=20
operation, a device removal is synchronous, and should inherit the I/O=20
scheduler parameters from the command that invoked it).


--------------ms060009040304090708090904
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTEwMTM0NzE5WjBPBgkq
hkiG9w0BCQQxQgRA7HQ/lOmjXvXGDaZbNe54J3zyepvI9NiZLdk/6awksOcZrStwoeKx0MWj
+sI3njlfukL6QFBejqkIDi1Tt6V1WzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBLPdvAVnpM1XCa80djyx5sj5YsVhLYgde3oyXTxMy4wDBNehn0
tSXMHetJYAhRl2m8ocl8IztoGKIDLZYrAzPA0hkrGtYZuafHEHciug1+FowAM1WFrAikSlqs
+pnKtabXMlxhsCUA2x0ZyRarNasViCUKWFTbXU1E+Lm5B9Wd1iPiFud6gUtmscd92taCnimh
+rvt52/8Av/ekftqKVU4XMA5E361s0oBpYPIlyF/nUM1plqRwtIN4pWDcc4prTY7bX4w5rI4
E4l+BcBL0TH4gLnIVti9DChx5mHqNroaVvV8VYRBVSNX5XRaI17pKzIIwSsBlVpifVcYeuxL
jgh3ohakcDWABpcduiGR0BIhzJ0iE8QELl8jUP6iDHVZOoraGgotuGtAepmzefkc4/P20U2U
nncrx4aNQ+T4DYzPc4c/Vzn8oldZ9zjPjcSlf/qb+9cV/q9rrRueBFl0p/XMdAdzdrU53T2M
KEUQZkjSUepAw8cCXmrwOZTO5Ausp69n4ovWWkgna5GuotzVGHLFT2gsHqi260SSBiS6Jtf8
8EhI2uEdFNPdfHVAWcMDSbJ5e8OLQhHs480zYk3LrnMslDSpawY4u6fa1NLECk8w4YtqO0Y7
44KWlgI8Lk1l3feXXxzm+n7LjQlW/1ZJqTMjLuTtbOh7bz0h1rZRA1QMbwAAAAAAAA==
--------------ms060009040304090708090904--
