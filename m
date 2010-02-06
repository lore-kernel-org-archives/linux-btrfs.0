From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: when/why to use diffferent raid values for btrfs data & metadata?
Date: Sat, 6 Feb 2010 14:16:48 +0100
Message-ID: <201002061416.48549.kreijack@libero.it>
References: <c67eed301001232002o2f89f2fct4dc9fe8516b976bc@mail.gmail.com> <c67eed301001240838y7fa0fe02o39326052a1c4679d@mail.gmail.com> <c67eed301002051623v3946be29g1aa83a0f66ff6f18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301002051623v3946be29g1aa83a0f66ff6f18@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 06 February 2010, 0bo0 wrote:
> anyone on when/why to use different RAID geometries for data & metadata?
> 

I expected that the size of data and meta-data are different by several order 
of magnitude. So I can choice different trade-off between 
space/speed/reliability for data and/or metadata.

If I need speed I can put the meta-data in a "fast" raid (like raid10) and put 
the data in a slow raid (like raid6). 
Or if I can tolerate the lost of data, I can put the meta-data in raid1 and 
the data in raid0. A fault of a disk, may lead to lost of data, but not to 
lost of the meta-data (the file-system is fully working).


> On Sun, Jan 24, 2010 at 8:38 AM, 0bo0 <0.bugs.only.0@gmail.com> wrote:
> > hi
> >
> > On Sun, Jan 24, 2010 at 3:28 AM, RK <rkasl@computer.org> wrote:
> >> try this article "Linux Don't Need No Stinkin' ZFS: BTRFS Intro &
> >> Benchmarks"
> >> http://www.linux-mag.com/id/7308/3/
> >> , there is a benchmark table and speed analysis (very informative), but
> >> all the benchmarks are done with same -m and -d mkfs.btrfs option
> >
> > that's one of the articles i' read.  it also does mention that you can
> > define data/metadata as differnt RAID, afaict, it doesn't (?) say
> > anything about the what/why you would ... which is what i'm unclear
> > about.
> >
> > thanks!
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
