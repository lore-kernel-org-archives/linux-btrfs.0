Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35351 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbLDNAb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 08:00:31 -0500
Received: by ioc74 with SMTP id 74so114527530ioc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 05:00:31 -0800 (PST)
Subject: Re: Very various speed of grep operation on btrfs partition
To: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CABXGCsMYdfSpZeUbWut1p542XA-L99iXM0Ero8tAFVhU9xhzkw@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56618E4A.2000905@gmail.com>
Date: Fri, 4 Dec 2015 07:59:54 -0500
MIME-Version: 1.0
In-Reply-To: <CABXGCsMYdfSpZeUbWut1p542XA-L99iXM0Ero8tAFVhU9xhzkw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040804050300050708080203"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040804050300050708080203
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-03 14:36, =D0=9C=D0=B8=D1=85=D0=B0=D0=B8=D0=BB =D0=93=D0=B0=D0=
=B2=D1=80=D0=B8=D0=BB=D0=BE=D0=B2 wrote:
> Today on work I needed searching some strings in repository. Only
> machine with windows was available. I am was using grep from Cygwin
> for this task and I am was surprised about speed of NTFS partition.I
> decided to repeat this task on my home Linux workstation.
>
[...snip...]
>  From results we see that search goes sometimes instantly less than a
> second, and sometimes lasts 4 minutes. /home partition formatted in
> BTRFS filesystem. I would be interested investigate what is related to
> search speed. And make that search was always goes less than a second.
>
> Here is my mount options:
> UUID=3D82df2d84-bf54-46cb-84ba-c88e93677948 /home btrfs
> subvolid=3D5,autodefrag,noatime,space_cache,inode_cache,nodatacow 0 0
>
> # uname -a
> Linux localhost.localdomain 4.2.6-301.fc23.x86_64+debug #1 SMP Fri Nov
> 20 22:07:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> How to start investigation?
>
Well, what other things are accessing the filesystem at the same time?=20
If you've got something like KDE running with the 'semantic desktop'=20
stuff turned on, than that will seriously impact the performance of=20
other things using that filesystem.

The other thing to keep in mind, is that caching may be impacting things =

somewhat.  To really get a good idea of performance for something like=20
this, you should run 'sync' followed by 'echo 3 >=20
/proc/sys/vm/drop_caches' (you'll need to be root for the second one)=20
prior to each run, and ideally have nothing else running on that filesyst=
em.

On a separate note, if you're either running on a 64-bit system, or have =

less than about 2^31 files on the FS, inode_cache will slow things down. =

  It's intended for stuff like mail spools where you have billions of=20
files being created and deleted over a few weeks, and quickly use up the =

inode numbers.  On almost all systems, it will make things run slower,=20
and possibly result in non-=3Ddeterministic filesystem performance like=20
what you are seeing here.

Additionally, do you have some particular reason that you absolutely=20
_need_ nodatacow to be enabled for the FS?  It usually has no impact on=20
performance, but it removes any kind of error correction for file data=20
(checksums can't be used safely without COW semantics).  It probably has =

no direct impact on what you're seeing here, but it is something that=20
really shouldn't be used in most cases at the filesystem level (it can=20
be done on given subvolumes or directories, and that's the recommended=20
way to do it if you don't want to go down to the per-file level).


--------------ms040804050300050708080203
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA0MTI1OTU0WjBPBgkq
hkiG9w0BCQQxQgRAKpzISKwq76Qf3b2/8wuHikwB+jLzaUJztXSp7J1vY+ZLrkrxa7iE85xN
a1jsT4ZWIPyRafDwzahr2Kn+JY0aUzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCItost5qb3WcFuMlbs7uYxmX7ISw8pg/RD7MhVi6p9txGP2YHy
hdlVkudgJYQw/IUCp6tv8fVTyo06qw6YJcc082ywOpE96bRedDnLjaI6U48arePxewU8c8FR
5Okeh8trbOTDLxt547ti6uubS1pauqGY3lFxoD+ECIgMGWtVrvaUAuIFK5qsY1Qjw+LG0osw
JnJ6+A+iDqR320mBa89rT5g8zIYfZJiGJnNPorOWmeaBKGFa+gpG1rsV5mgsF93bFMQjxPh8
LI/Tp87NjvaYvRFOGGeF4xhtjf5mp/mlumSrO2jas8HopwiFtrK6MYH1po8I6Cds1vPQHrpZ
JA5lCwMmD21y+r+yiZlOTm1FXh5rGBEMTXIBW0d3mRs1fh8bcKmgOMHo0tjLJbNvz65SMTWG
lW4mIwGbS5M+MU8AL6XOWjGVfOhuvPr+A5SFVVGZeobDtAXBen64z29Y3S30xmTzPL5Xamtm
Eiq5Hd3+nOx23mIF5zeYfCqWph4TPUbB4VY0FKKYhl6UoQ8MOKjjiym4pYMjSZqHMu2T3b3w
sAMzdHJLfl8jJ8/6OB3V/OR6wd9ryXf6mkWLh1zjFcDswawbXtKW9veNpPsWvV+sipB4RtV4
vgoRfkV+fx3kvOzedczWcuLsZMj1z8K/CUmZLHSu7vfNJvW7VQzq7bBbbQAAAAAAAA==
--------------ms040804050300050708080203--
