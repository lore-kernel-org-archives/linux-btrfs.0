Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35086 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbbJTNBj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 09:01:39 -0400
Received: by igbkq10 with SMTP id kq10so74034878igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 06:01:39 -0700 (PDT)
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
To: Russell Coker <russell@coker.com.au>,
        james harvey <jamespharvey20@gmail.com>
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
 <201510201545.50705.russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56263B0B.4050502@gmail.com>
Date: Tue, 20 Oct 2015 09:00:59 -0400
MIME-Version: 1.0
In-Reply-To: <201510201545.50705.russell@coker.com.au>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000002070301080107030903"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000002070301080107030903
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-20 00:45, Russell Coker wrote:
> On Tue, 20 Oct 2015 03:16:15 PM james harvey wrote:
>> sda appears to be going bad, with my low threshold of "going bad", and=

>> will be replaced ASAP.  It just developed 16 reallocated sectors, and
>> has 40 current pending sectors.
>>
>> I'm currently running a "btrfs scrub start -B -d -r /terra", which
>> status on another term shows me has found 32 errors after running for
>> an hour.
>
> https://www.gnu.org/software/ddrescue/
>
> At this stage I would use ddrescue or something similar to copy data fr=
om the
> failing disk to a fresh disk, then do a BTRFS scrub to regenerate the m=
issing
> data.
>
> I wouldn't remove the disk entirely because then you lose badly if you =
get
> another failure.  I wouldn't use a BTRFS replace because you already ha=
ve the
> system apart and I expect ddrescue could copy the data faster.  Also as=
 the
> drive has been causing system failures (I'm guessing a problem with the=
 power
> connector) you REALLY don't want BTRFS to corrupt data on the other dis=
ks.  If
> you have a system with the failing disk and a new disk attached then th=
ere's
> no risk of further contamination.
BIG DISCLAIMER: For the filesystem to be safely mountable it is=20
ABSOLUTELY NECESSARY to remove the old disk after doing a block level=20
copy of it.  By all means, keep the disk around, but do not keep it=20
visible to the kernel after doing a block level copy of it.  Also, you=20
will probably have to run 'btrfs device scan' after copying the disk and =

removing it for the filesystem to work right.  This is an inherent=20
result of how BTRFS's multi-device functionality works, and also applies =

to doing stuff like LVM snapshots of BTRFS filesystems.
>
>> Question 2 - Before having ran the scrub, booting off the raid with
>> bad sectors, would btrfs "on the fly" recognize it was getting bad
>> sector data with the checksum being off, and checking the other
>> drives?  Or, is it expected that I could get a bad sector read in a
>> critical piece of operating system and/or kernel, which could be
>> causing my lockup issues?
>
> Unless you have disabled CoW then BTRFS will not return bad data.
It is worth clarifying also that:
a. While BTRFS will not return bad data in this case, it also won't=20
automatically repair the corruption.
b. In the unlikely event that both copies are bad, trying to read the=20
data will return an IO error.
c. It is theoretically possible (although statistically impossible) that =

the block could become corrupted, but the checksum could still be=20
correct (CRC32c is good at detecting small errors, but it's not hard to=20
generate a hash collision for any arbitrary value, so if a large portion =

of the block goes bad, then it can theoretically still have a valid=20
checksum).
>
>> Question 3 - Probably doesn't matter, but how can I see which files
>> (or metadata to files) the 40 current bad sectors are in?  (On extX,
>> I'd use tune2fs and debugfs to be able to see this information.)
>
> Read all the files in the system and syslog will report it.  But really=
 don't
> do that until after you have copied the disk.
It may also be possible to use some of the debug tools from BTRFS to do=20
this without hitting the disks so hard, but it will likely take a lot=20
more effort.


--------------ms000002070301080107030903
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIwMTMwMDU5WjBPBgkq
hkiG9w0BCQQxQgRASXBX/WJpIZiy0GncUM4MGyWS7ncqoVrCHAe6rB5Yh0xRkEGNVoL3ySiO
dhIoVISPOBXQ7ENbsjzxrhkdUeSM+jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBJfooW1UeKKhc24fvLmjBEnzQK5CValr1QofBsalAroHjZRUQy
7BiU+G8Vjm4pJ1DzdHRohY/i3/X94wnk/JGwboOj2QqGPLGcxOrX1kt6lqdx5W2K4GtXJo6V
55Ujikmjf1gidCNW3GJBQ9j6+IlC/ap4h1sZ7O59tGHtFx71gsoovYFoLwl0eyWaqtj1bZTi
hXhWCJuk5OKt8T5s5Dlb2ByCUb7Pe4cx7YxqCSop3RYtSbF9INqd4h3J4jPt2X/i+dTGyqr5
CilyrOZrocwkyLF1pxS/gHghckGv2de+wIANpGiCJW+qy24ujv3ZHxLSagHbytIXzqQz3FMk
lJJsgkv0hqm+EV9/Wa4B3+iRaEMYVm+sWLJR+AfdzA0/6XuuezDa74kjfbgtdPVICOBmseUy
Ej8F/AcCO81WbTcz5x/Mps0ueQn1i13bMBzPsB0dFuq0yEXjSTK/qpbcIjPumYSDi+9xYLrg
05tD897Ynr5G2AUtuynmYdA2PcEaTQYePLozr4yxnDUGVTbJK/n32fbdqtA7WgZ0bPP0+2S/
jyM+VE4ftWYIGhZMjwF92oMPhs6m6DvtdIplOFU4+7LzKg1Hbzft67rVisKFuyOcn1VkHK+F
H/f4JOqgJX3FGKVg73+EsJretQxSe/wg4KtTA6d4hRaK0XUo80YGHXYg3QAAAAAAAA==
--------------ms000002070301080107030903--
