Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3095 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753330AbaBYUa7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 15:30:59 -0500
Message-ID: <530CFD66.7060006@fb.com>
Date: Tue, 25 Feb 2014 15:30:30 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marcus Sundman <sundman@iki.fi>, <linux-btrfs@vger.kernel.org>
CC: Hugo Mills <hugo@carfax.org.uk>, Jim Salter <jim@jrs-s.net>
Subject: Re: No space left on device (again)
References: <530CC9B0.1080703@iki.fi> <530CDB7F.9020807@jrs-s.net> <20140225201921.GB13899@carfax.org.uk> <530CFCCE.5060707@iki.fi>
In-Reply-To: <530CFCCE.5060707@iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/25/2014 03:27 PM, Marcus Sundman wrote:
> On 25.02.2014 22:19, Hugo Mills wrote:
>> On Tue, Feb 25, 2014 at 01:05:51PM -0500, Jim Salter wrote:
>>> 370GB of 410GB used isn't really "fine", it's over 90% usage.
>>> 
>>> That said, I'd be interested to know why btrfs fi show
>>> /dev/sda3 shows 412.54G used, but btrfs fi df /home shows 379G
>>> used...
>> This is an FAQ...
>> 
>> btrfs fi show tells you how much is allocated out of the
>> available pool on each disk. btrfs fi df then shows how much of
>> that allocated space (in each category) is used.
> 
> What is the difference between the "used 371.11GB" and the "used 
> 412.54GB" displayed by "btrfs fi show"?
> 
>> The problem here is also in the FAQ: the metadata is close to
>> full -- typically something like 500-750 MiB of headroom is
>> needed in metadata. The FS can't allocate more metadata because
>> it's allocated everything already (total=used in btrfs fi show),
>> so the solution is to do a filtered balance:
>> 
>> btrfs balance start -dusage=5 /mountpoint
> 
> Of course that was the first thing I tried, and it didn't help *at*
> *all*:
> 

The -dusage=<number> is a means to an end, so if that doesn't work try
a larger number, up to 100.  Really once you pass 50 and it's not
working then it's time to just do a balance.  The next thing is to use
compression (too late for this option really) or add another disk.
Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTDP1mAAoJEANb+wAKly3BQooQAMjRfSc0fJcrVFhNqAXvuxKO
f9ALYcENk7mVEMiyPg9v/7oiHW+FSQuJxaJ+yPlLTvepFmh3VE00t4PHsTCheAld
KdIoP9KzvCrmPSH5YxBg9Tmk60lonYnGfCsggK3kgRP8JIHUcBRKzlFKAc3p8vzY
UEEYLS0AYXvBAPdY3bUwhB5txMDvNbetew8ak5nUgZaC1J4rWe7LL6ccv845hhf5
OHcKLu3MjR6ejW9qDK9RC2ryjCY+vDCUMO4VPpma3OZ6OHA3g7niaXYqBEvht7O0
yNeGQA54O1goIFo9knPG4XE7WurlF69n+knQA7dsqjux9bIXHVClCCwsrUpXJIY3
98KigtPVz737j1dNqaeQdn6xl6kwRpj2lRhWuPBZ1AnJNWr1cLK2jmWOuFmyrdi8
vTNJJvUlpwGnnUHdXu8WjMCSNgXX9pIXDZIC/f22wjZFyY23yfSYOTCXTEOlpH8b
b4R7VnZ6QfxGgJnqhHPWBE7FRaekI2MLfT6aYVL2sNvVPZoMo0wzjnxshwp2+8dK
C0j2sNsoRdKPlGECYuh2eG40JQG2JKnZr2bMSwDI40GvDcQmyG7gD+jouOtei/vv
KUDDfhNGnv0SdqmAk/UC4Cl1dDD9Y4Z0kAuAd7iTJhAcLszteeGqiDvdvtup5o7i
HZcFmZX6EPBZXKrIcnzJ
=+Oe0
-----END PGP SIGNATURE-----
