From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: Re: when/why to use diffferent raid values for btrfs data & metadata?
Date: Fri, 5 Feb 2010 16:23:05 -0800
Message-ID: <c67eed301002051623v3946be29g1aa83a0f66ff6f18@mail.gmail.com>
References: <c67eed301001232002o2f89f2fct4dc9fe8516b976bc@mail.gmail.com>
	 <4B5C2EF5.9010804@computer.org>
	 <c67eed301001240838y7fa0fe02o39326052a1c4679d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: RK <rkasl@computer.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301001240838y7fa0fe02o39326052a1c4679d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

anyone on when/why to use different RAID geometries for data & metadata=
?

On Sun, Jan 24, 2010 at 8:38 AM, 0bo0 <0.bugs.only.0@gmail.com> wrote:
> hi
>
> On Sun, Jan 24, 2010 at 3:28 AM, RK <rkasl@computer.org> wrote:
>> try this article "Linux Don't Need No Stinkin' ZFS: BTRFS Intro &
>> Benchmarks"
>> http://www.linux-mag.com/id/7308/3/
>> , there is a benchmark table and speed analysis (very informative), =
but
>> all the benchmarks are done with same -m and -d mkfs.btrfs option
>
> that's one of the articles i' read. =A0it also does mention that you =
can
> define data/metadata as differnt RAID, afaict, it doesn't (?) say
> anything about the what/why you would ... which is what i'm unclear
> about.
>
> thanks!
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
