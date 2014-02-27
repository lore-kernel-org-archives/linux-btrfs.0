Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8066 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751989AbaB0BSJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 20:18:09 -0500
Message-ID: <530E9217.4060701@fb.com>
Date: Wed, 26 Feb 2014 20:17:11 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marcus Sundman <sundman@iki.fi>, <linux-btrfs@vger.kernel.org>
CC: Jim Salter <jim@jrs-s.net>, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: No space left on device (again)
References: <530CC9B0.1080703@iki.fi> <530CDB7F.9020807@jrs-s.net> <20140225201921.GB13899@carfax.org.uk> <530CFCCE.5060707@iki.fi> <530CFD66.7060006@fb.com> <530E83C7.5080101@iki.fi>
In-Reply-To: <530E83C7.5080101@iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/26/2014 07:16 PM, Marcus Sundman wrote:
> On 25.02.2014 22:30, Josef Bacik wrote:
>> On 02/25/2014 03:27 PM, Marcus Sundman wrote:
>>> On 25.02.2014 22:19, Hugo Mills wrote:
>>>> On Tue, Feb 25, 2014 at 01:05:51PM -0500, Jim Salter wrote:
>>>>> 370GB of 410GB used isn't really "fine", it's over 90%
>>>>> usage.
>>>>> 
>>>>> That said, I'd be interested to know why btrfs fi show 
>>>>> /dev/sda3 shows 412.54G used, but btrfs fi df /home shows
>>>>> 379G used...
>>>> This is an FAQ...
>>>> 
>>>> btrfs fi show tells you how much is allocated out of the 
>>>> available pool on each disk. btrfs fi df then shows how much
>>>> of that allocated space (in each category) is used.
>>> What is the difference between the "used 371.11GB" and the
>>> "used 412.54GB" displayed by "btrfs fi show"?
>>> 
>>>> The problem here is also in the FAQ: the metadata is close
>>>> to full -- typically something like 500-750 MiB of headroom
>>>> is needed in metadata. The FS can't allocate more metadata
>>>> because it's allocated everything already (total=used in
>>>> btrfs fi show), so the solution is to do a filtered balance:
>>>> 
>>>> btrfs balance start -dusage=5 /mountpoint
>>> Of course that was the first thing I tried, and it didn't help
>>> *at* *all*:
>>> 
>> The -dusage=<number> is a means to an end, so if that doesn't
>> work try a larger number, up to 100.  Really once you pass 50 and
>> it's not working then it's time to just do a balance.  The next
>> thing is to use compression (too late for this option really) or
>> add another disk.
> 
> So it relocates some chunks. What will that do? Does it mean I can
> now use the remaining 45 GB? Or will it run out of "disk space"
> again after using a gig or two? If it's the allocated metadata
> space that is the problem then how can I pre-allocate more of it so
> it won't run out of it?
> 
> 

It will allocate more as it sees fit, there is a metadata_ratio=N
option which lets you force it to allocate a metadata chunk for every
N data chunk allocations, but that shouldn't be needed in this case.
What does btrfs fi df and btrfs show look like now?  Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTDpIMAAoJEANb+wAKly3BfKUQAK/WzvL/SENlUhruUoL7ADid
tM6ivq2BZOwmlw+CzOIzjrwv9gwRe+UAfjKjGstueLoVY+lHNYaCC5OI94OOWDPo
SyLJdJhcA3FYYBlyz7EC6gG4fNFyJg6egshoyMmWJuny5ivfnltdQhLLz2IQIHek
Ud9ElN+SMvCeQmGZxdKg5yc2oIgBdc5xGfegtfuCqFkdhu+BZTbcXFsOD4Pjnsg0
Mtw8H5YBeXcFBV34I8F6l+O3AGjDl8jF/cFuCEbRTJQFkvpKhoHMw+O2AWykDQqc
xw3H1YghGeY1fqN2geyYSYVGVOGxWeO2kju7Itom8Ph5AinMPMf8lpe97nChp2hr
D3T1QwhkmMD9T1O02hvF9C8E46q2iyjOrPxPU8z3LsRTKaNXNzJ+u1P2ac7kIQSk
x2stB9u0Qluut+5twzLQuefzoCNf/2RtAlL2cPXyq6ikLHBSNkebqbGBD2IpTsa7
5TsXNHWbIc0maDdXrJ0BYJ7obEaU/2nBCkSA3DaGBupTtC3vwSWAoAEw8/JtVeQr
ARXSIPblXZqwrGyJyvtNmC8zjDGAD93H/xr0+oCOzHqPIr7NvTT9vZKfENmblsfm
vx8wmgbSBzWp9W9YpUO5X0ZjLestPzOziIesCrMJ2yKBUEUtafiFdbT5D7e9dn8x
7Z2MZcYyk5H7QF65+IWt
=8iSO
-----END PGP SIGNATURE-----
