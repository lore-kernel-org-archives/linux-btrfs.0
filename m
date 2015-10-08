Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37572 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbbJHLsb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Oct 2015 07:48:31 -0400
Received: by igcpe7 with SMTP id pe7so10594446igc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2015 04:48:30 -0700 (PDT)
Subject: Re: BTRFS RAID1 behavior after one drive temporal disconection
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>, linux-btrfs@vger.kernel.org
References: <201510052226.47051.pisa@cmp.felk.cvut.cz>
 <201510081028.02178.pisa@cmp.felk.cvut.cz>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <561657D5.1070809@gmail.com>
Date: Thu, 8 Oct 2015 07:47:33 -0400
MIME-Version: 1.0
In-Reply-To: <201510081028.02178.pisa@cmp.felk.cvut.cz>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030004060100050809070605"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030004060100050809070605
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-08 04:28, Pavel Pisa wrote:
> Hello everybody,
>
> On Monday 05 of October 2015 22:26:46 Pavel Pisa wrote:
>> Hello everybody,
> ...
>> BTRFS has recognized appearance of its partition (even that hanged
>> from sdb5 to sde5 when disk "hotplugged" again).
>> But it seems that RAID1 components are not in sync and BTRFS
>> continues to report
>>
>> BTRFS: lost page write due to I/O error on /dev/sde5
>> BTRFS: bdev /dev/sde5 errs: wr 11021805, rd 8526080, flush 29099, corr=
upt
>> 0, gen
>>
>> I have tried to find the best way to resync RAID1 BTRFS partitions.
>> But problem is that filesystem is the root one of the system.
>> So reboot to some rescue media is required to run btrfsck --repair
>> which is intended for unmounted devices.
>>
>> What is behavior of BTRFS in this situation?
>> Is BTRFS able to use data from not up to date partition in these
>> cases where data in respective files have not been modified?
>> The main reason for question is if such (stable) data can be backuped
>> by out of sync partition in the case of some random block is wear
>> out on another device. Or is this situation equivalent to running
>> with only one disk?
>>
>> Are there some parameters/solution to run some command
>> (scrub balance) which makes devices to be in the sync again
>> without unmount or reboot?
>>
>> I believe than attaching one more drive and running "btrfs replace"
>> would solve described situation. But is there some equivalent to
>> run operation "inplace".
>
> It seems that SATA controller is not able to activate link which
> has not been connected at BIOS POST time. This means that I cannot add =
new drive
> without reboot.
Check your BIOS options, there should be some option to set SATA ports=20
as either 'Hot-Plug' or 'External', which should allow you to hot-plug=20
drives without needing a reboot (unless it's a Dell system, they have=20
never properly implemented the SATA standard on their desktops).
>
> Before reboot, the server bleeds with messages
>
> BTRFS: bdev /dev/sde5 errs: wr 11715459, rd 8526080, flush 29099, corru=
pt 0, gen 0
> BTRFS: lost page write due to I/O error on /dev/sde5
> BTRFS: bdev /dev/sde5 errs: wr 11715460, rd 8526080, flush 29099, corru=
pt 0, gen 0
> BTRFS: lost page write due to I/O error on /dev/sde5
Even aside from the below mentioned issues, if your disk is showing that =

many errors, you should probably run a SMART self-test routine on it to=20
determine whether this is just a transient issue or an indication of an=20
impending disk failure.  The commands I'd suggest are:
smartctl -t short /dev/sde
That will tell you some time to wait for the test to complete, after=20
waiting  that long, run:
smartctl -H /dev/sde
If that says the health check failed, replace the disk as soon as=20
possible, and don't use it for storing any data you can't afford to lose.=

>
> that changed to next mesages after reboot
>
> Btrfs loaded
> BTRFS: device label riki-pool devid 1 transid 282383 /dev/sda3
> BTRFS: device label riki-pool devid 2 transid 249562 /dev/sdb5
> BTRFS info (device sda3): disk space caching is enabled
> BTRFS (device sda3): parent transid verify failed on 44623216640 wanted=
 263476 found 212766
> BTRFS (device sda3): parent transid verify failed on 45201899520 wanted=
 282383 found 246891
> BTRFS (device sda3): parent transid verify failed on 45202571264 wanted=
 282383 found 246890
> BTRFS (device sda3): parent transid verify failed on 45201965056 wanted=
 282383 found 246889
> BTRFS (device sda3): parent transid verify failed on 45202505728 wanted=
 282383 found 246890
> BTRFS (device sda3): parent transid verify failed on 45202866176 wanted=
 282383 found 246890
> BTRFS (device sda3): parent transid verify failed on 45207126016 wanted=
 282383 found 246894
> BTRFS (device sda3): parent transid verify failed on 45202522112 wanted=
 282383 found 246890
> BTRFS: bdev /dev/disk/by-uuid/1627e557-d063-40b6-9450-3694dd1fd1ba errs=
: wr 11723314, rd 8526080, flush 2
> BTRFS (device sda3): parent transid verify failed on 45206945792 wanted=
 282383 found 67960
> BTRFS (device sda3): parent transid verify failed on 45204471808 wanted=
 282382 found 67960
>
> which looks really frightening to me. Temporary disconnected drive has =
old transid
> at start (OK). But what means the rest of the lines. If it means that f=
iles with
> older transaction ID are used from temporary disconnected drive (now /d=
ev/sdb5)
> and newer versions from /dev/sda3 are ignored and reported as invalid t=
hen this means
> severe data lost and may it be mitchmatch because all transactions afte=
r disk disconnect
> are lost (i.e. FS root has been taken from misbehaving drive at old ver=
sion).
>
> BTRFS does not fall even to red-only/degraded mode after system restart=
=2E
This actually surprises me.
>
> On the other hand, from logs (all stored on the possibly damaged root F=
S) it seems
> that there there are not missing messages from days when discs has been=
 out of sync,
> so it looks like all data are OK. So should I expect that BTRFS managed=
 problems
> well and all data are consistent?
I would be very careful in that situation, you may still have issues, at =

the very least, make a backup of the system as soon as possible.
>
> I go to use "btrfs replace" because there has not been any reply to my =
inplace correction
> question. But I expect that clarification if possible/how to resync RAI=
D1 after one
> drive temporal disappear is really important to many of BTRFS users.
As of right now, there is no way that I know of to safely re-sync a=20
drive that's been disconnected for a while.  The best bet is probably to =

use replace, but for that to work reliably, you would need to tell it to =

ignore the now stale drive when trying to read each chunk.

It is theoretically possible to wipe the FS signature on the out-of sync =

drive, run a device scan, then run 'replace missing' pointing at the now =

'blank' device, although going that route is really risky.


--------------ms030004060100050809070605
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDA4MTE0NzMzWjBPBgkq
hkiG9w0BCQQxQgRAeFwSYp92NLJsZsFH4dr+4FPGw5e1crnMWn7vKUbAUjaVjfCTjBF+cSzw
pp0QrItGmiL1GASuEj8EbQNhw8UnZjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBB/V25xpyql5hhZJXTfpZxbxt6+RVGzItH/nbZHeWWsj2Ot1wL
IJhDN51kykg1EYYgJalZbCZ5hJSkystFgdoC3swpRTRlh1r0bRqmKzn2e5IOZ9JALaWY31kS
eXXS//AstQbA2L2gz2/V2T+4lYH3D8/gbiO29P/T5EfGEnK8J8yhbVJVvge7MTpJVSzp2UXP
CHClzks1uJhI8hx8ZqI6Hsn1I8PuRLTFVhDa7f+o6g8nfuKanF/XjUeRhAAsnipoXqKK5Tka
Crb9B5YqDg88mD7SjeMEJnFLknf+bzIAvYJn9FOGHjJrpYzWBNkIgVOUNOvJQkbMr2R29jwx
/0aNh3GKJmpxOQ8dxmA2jb6qkkz0VkTMrFIE5FZNm5nR5StLsdvP39k3TBIkda6s2Ko/YutH
9BVPDSLttsaYpvijECCx5G7GB+wPKWzqNVMaMbs+iSMB8UAwj3LK3vvnfOhdA5HdbXnC4k2I
hXIUYz6JSkzfGCPExgoFfZYWRiHgoQ0zMF5YTCpnOB2YLw1JRbrk/HdW/RZeH+gGu41tttGR
kcHfb8eE2HbYvMmJ6FmQcC+xKrCkrUBa/dK4G3+BQVIGAaugel/FeIwmpsZds9ibCxzBidVK
yCEXCGkDvl90GHd6R5drINZrN+Pg0mtDzJgXUN6Ap/gKV7joEGVvOP+mGAAAAAAAAA==
--------------ms030004060100050809070605--
