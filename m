Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33197 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbbKMSKp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 13:10:45 -0500
Received: by iouu10 with SMTP id u10so98185380iou.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 10:10:45 -0800 (PST)
Subject: Re: illegal snapshot, cannot be deleted
To: Vedran Vucic <vedran.vucic@gmail.com>
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
 <564486F3.5020804@gmail.com>
 <CAHTEL3mEGmc5BhbGMEAbyPNU90nFQGZprLkWrh1WaEh5sSiH8w@mail.gmail.com>
 <56461034.3070209@gmail.com>
 <CAHTEL3m0uGWZGWUH_SLmg8TqMe4DcXU77p+S=4Aebukr1BZ-Bg@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56462784.2060601@gmail.com>
Date: Fri, 13 Nov 2015 13:10:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAHTEL3m0uGWZGWUH_SLmg8TqMe4DcXU77p+S=4Aebukr1BZ-Bg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010708020001020508080500"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010708020001020508080500
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-13 12:30, Vedran Vucic wrote:
> Hello,
>
> Here are outputs of commands as you requested:
>   btrfs fi df /
> Data, single: total=3D8.00GiB, used=3D7.71GiB
> System, DUP: total=3D32.00MiB, used=3D16.00KiB
> Metadata, DUP: total=3D1.12GiB, used=3D377.25MiB
> GlobalReserve, single: total=3D128.00MiB, used=3D0.00B
>
> btrfs fi show
> Label: none  uuid: d6934db3-3ac9-49d0-83db-287be7b995a5
>          Total devices 1 FS bytes used 8.08GiB
>          devid    1 size 18.71GiB used 10.31GiB path /dev/sda6
>
> btrfs-progs v4.0+20150429
>
Hmm, that's odd, based on these numbers, you should be having no issue=20
at all trying to run a balance. You might be hitting some other bug in=20
the kernel, however, but I don't remember if there were any known bugs=20
related to ENOSPC or balance in the version you're running.  You might=20
see if trying to re-run the balance with '-dusage=3D40 -musage=3D40' work=
s=20
correctly (I've seen cases where the first run fails, but subsequent=20
ones work because the first one made some progress despite failing).
> On Fri, Nov 13, 2015 at 5:30 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-11-13 11:12, Vedran Vucic wrote:
>>>
>>> Hello,
>>>
>>> I succeeded to delete illegal snapshot with command:
>>> btrfs subvolume delete /.snapshots/741/snapshot
>>> When I have done
>>> btrfs balance / -dusage=3D0 -musage=3D0
>>> increasing value up to 4o I did not have issues.
>>> But on value 4- for-dusage=3D and -musage=3D
>>> I got message that there is no space left on disk.
>>> Do you have any advice how to manage that?
>>
>>
>> Can you post the output of 'btrfs fi df' and 'btrfs fi show' again? Bo=
th
>> should have changed after the balance, and I'd need to see what it loo=
ks
>> like now to be able to give any reasonable advice.
>>
>>



--------------ms010708020001020508080500
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEzMTgxMDEyWjBPBgkq
hkiG9w0BCQQxQgRAuBptp/e5SgA9zEMEzUIDp23QVPinsV/9B9xgzaVVmuccjDwaJrUE4EPn
waCEuChpscQQUscJBz/44pNB+RWoczBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAEvbj7Zt18pI+JtH86IkzvT46zwO5TCkGTqIvq2fG0rR+ZDwXJ
3C2tFYrr3kYtQ5nstW92az2Q+i4IXX3sG/WjG8eRypaB8AXrCKb+wwuSyD8DqjA4iw45h7nn
beEKSUnarnGpHxsNeNkCz6xQm6fBPKOXZ5FL68zi3Jk2kOVBdqnV4RpAbwUU2tLn7Mz/VccN
7LC2bngef9VF9C5uh8wyZj5w9Md5W+RsMoBR19k5PZHGS1J1iSjCVglf7VmEPLeKZ96B08KP
PZJrLQz8mNQPrfbAJrNpgsrAe0N8aBs+Yepa5jcnT4xoudv3lqGvWdeDOhyYpuUuT/h2fsCj
NGn7THg95TS2+E81ZolPKexW2+TlGFmiq1eWpZmtCgblzUnCMEMiXtA+Cb+9aBnw7hZj8g63
NqOFO6/rm6I2pwwIHo/u5mtLMLEjSDrag8e49Gwsnau0t7x/7IDXinIvzWZCmR42WqiZ46SI
DqlXBUJfSj0hr8G/vg3lGcOqT70Je2mQWoSZ90hQxkGx+v8pDE+Co/3AYKAvwSa3mavZiL+B
jtc8pG60nIob7eDI1sHiqUTT1Rhqy7WKqZw3BNVTR9WgBlEsZ4zEp99LAVbZYoDVFa5w5/QJ
U7PUu7uF1IZWwSrmvNA3ynrtB9IF/OI9mbXXsDokzBqQPRWaGoa79VOc0QAAAAAAAA==
--------------ms010708020001020508080500--
