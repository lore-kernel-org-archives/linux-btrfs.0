From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: Re: when/why to use diffferent raid values for btrfs data & metadata?
Date: Sat, 6 Feb 2010 06:57:30 -0800
Message-ID: <c67eed301002060657o1339fb67j317d56a1764e51c5@mail.gmail.com>
References: <c67eed301001232002o2f89f2fct4dc9fe8516b976bc@mail.gmail.com>
	 <c67eed301001240838y7fa0fe02o39326052a1c4679d@mail.gmail.com>
	 <c67eed301002051623v3946be29g1aa83a0f66ff6f18@mail.gmail.com>
	 <201002061416.48549.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002061416.48549.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 6, 2010 at 5:16 AM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>> anyone on when/why to use different RAID geometries for data & metadata?
>>
>
> I expected that the size of data and meta-data are different by several order
> of magnitude. So I can choice different trade-off between
> space/speed/reliability for data and/or metadata.
>
> If I need speed I can put the meta-data in a "fast" raid (like raid10) and put
> the data in a slow raid (like raid6).
> Or if I can tolerate the lost of data, I can put the meta-data in raid1 and
> the data in raid0. A fault of a disk, may lead to lost of data, but not to
> lost of the meta-data (the file-system is fully working).

sounds like there's no further, subtle considerations beyond the usual
 "which RAID" considerations.  then, i suppose that as long as i find
RAID-10 "good enough"(as it has been in the md-case), there's no
compelling reason NOT tp place both data/metadata in RAID-10
constructs in btrfs.

thanks.
