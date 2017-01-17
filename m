Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:33946 "EHLO
        smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbdAQJS3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 04:18:29 -0500
From: Christoph Groth <christoph@grothesque.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unocorrectable errors with RAID1
References: <87o9z7dzvd.fsf@grothesque.org>
        <85a62769-0607-4be5-3c5b-5091bebea07e@gmail.com>
        <87fukjdna0.fsf@grothesque.org>
        <ab77b777-27d6-9943-adb2-b70b62a5ecb0@gmail.com>
Date: Tue, 17 Jan 2017 10:18:23 +0100
In-Reply-To: <ab77b777-27d6-9943-adb2-b70b62a5ecb0@gmail.com> (Austin
        S. Hemmelgarn's message of "Mon, 16 Jan 2017 11:29:38 -0500")
Message-ID: <87pojmavts.fsf@grothesque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Austin S. Hemmelgarn wrote:

> There's not really much in the way of great documentation that I=20
> know of.  I can however cover the basics here:
>
> (...)

Thanks for this explanation.  I'm sure it will be also useful to=20
others.

> If the chunk to be allocated was a data chunk, you get -ENOSPC=20
> (usually, sometimes you might get other odd results) in the=20
> userspace application that triggered the allocation.

It seems that the available space reported by the system df=20
command corresponds roughly to the size of the block device minus=20
all the "used" space as reported by "btrfs fi df".

If I understand what you wrote correctly this means that when=20
writing a huge file it may happen that the system df will report=20
enough free space, but btrfs will raise ENOSPC.  However, it=20
should be possible to keep writing small files even at this point=20
(assuming that there's enough space for the metadata).  Or will=20
btrfs split the huge file into small pieces to fit it into the=20
fragmented free space in the chunks?

Such a situation should be avoided of course.  I'm asking out of=20
curiosity.

>>>> * So scrubbing is not enough to check the health of a btrfs=20
>>>> file system?  It=E2=80=99s also necessary to read all the files?
>>
>>> Scrubbing checks data integrity, but not the state of the=20
>>> data. IOW, you're checking that the data and metadata match=20
>>> with the checksums, but not necessarily that the filesystem=20
>>> itself is valid.
>>
>> I see, but what should one then do to detect problems such as=20
>> mine as soon as possible?  Periodically calculate hashes for=20
>> all files? I=E2=80=99ve never seen a recommendation to do that for=20
>> btrfs.

> Scrub will verify that the data is the same as when the kernel=20
> calculated the block checksum.  That's really the best that can=20
> be done. In your case, it couldn't correct the errors because=20
> both copies of the corrupted blocks were bad (this points at an=20
> issue with either RAM or the storage controller BTW, not the=20
> disks themselves).  Had one of the copies been valid, it would=20
> have intelligently detected which one was bad and fixed things.

I think I understand the problem with the three corrupted blocks=20
that I was able to fix by replacing the files.

But there is also the strange "Stale file handle" error with some=20
other files that was not found by scrubbing, and also does not=20
seem to appear in the output of "btrfs dev stats", which is BTW

[/dev/sda2].write_io_errs   0
[/dev/sda2].read_io_errs    0
[/dev/sda2].flush_io_errs   0
[/dev/sda2].corruption_errs 3
[/dev/sda2].generation_errs 0
[/dev/sdb2].write_io_errs   0
[/dev/sdb2].read_io_errs    0
[/dev/sdb2].flush_io_errs   0
[/dev/sdb2].corruption_errs 3
[/dev/sdb2].generation_errs 0

(The 2 times 3 corruption errors seem to be the uncorrectable=20
errors that I could fix by replacing the files.)

To get the "stale file handle" error I need to try to read the=20
affected file.  That's why I was wondering whether reading all the=20
files periodically is indeed a useful maintenance procedure with=20
btrfs.

"btrfs check" does find the problem, but it can be only run on an=20
unmounted file system.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUimQV/rXmWU8TwiKw/FH9ZgPNTUFAlh94WAACgkQw/FH9ZgP
NTWgwBAAgEEYik5DnW/gWAi4zz7XUAlzBeONGB9rmKNmlkJdvKdaR4shS2dZfrmk
TRmm6hxtMVvEX76a9AGTMQ8QGKRyrgNmPlKgoopwK9UakEc/sXxSU1mfast3HD4e
lhAhjk3Q4KYMXlAH85tTDchR4nT5dnWw+8nM0C+xbh3zmmt4JKi6wrUKk8Cczy6h
5Pv5H/zOL4sIiKFYKcsnSYazloetJOmBtEhZW85AWUTQGAkWl/40+UaA98uT2qpA
PRJ9/Z3pWPtm84zyRLmETOsAT/KlV2wKtfr82JXZYvr2o1n0q93/ll4fA/+HoXtf
n995f7uWIXSfgiTQqsn3uGMfbxDDTyc34YnWh+asVDGSnYof0NNOVaTkRIpnmo14
ybxkEjL2LYPZZsofB99+ZK6YRtScgnFajwZtb24slsfKdsCnmRmwj4wCVvbe+TjT
eSf+TZ7zer+TN/d7c7OL4mLyfig7sR6laXii2u5DZKtxrJ8kAJeTZso3QkDSjU8j
15e5baX848WrcZ9MORUyCWkLcPyo0dFFxhSZnic3nIRj3KykMv8WEI+0Y9BBGOJa
kXFz8tVGZ8MaxzECXtgMmmNQ34sVLW1Bfh5p/wsvyhMYdb/lnBm9vWDIxjJkvsiA
kybJFlWV4b+AOTHO6x+ngUO9JY8g123Lt7ZowBDJU2EhdGJCbVQ=
=eCqf
-----END PGP SIGNATURE-----
--=-=-=--
