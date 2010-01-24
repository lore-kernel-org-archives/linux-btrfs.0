From: RK <rkasl@computer.org>
Subject: Re: when/why to use diffferent raid values for btrfs data & metadata?
Date: Sun, 24 Jan 2010 06:28:53 -0500
Message-ID: <4B5C2EF5.9010804@computer.org>
References: <c67eed301001232002o2f89f2fct4dc9fe8516b976bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301001232002o2f89f2fct4dc9fe8516b976bc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

try this article "Linux Don't Need No Stinkin' ZFS: BTRFS Intro &
Benchmarks"
http://www.linux-mag.com/id/7308/3/
, there is a benchmark table and speed analysis (very informative), but
all the benchmarks are done with same -m and -d mkfs.btrfs option


mail ignored wrote:
> Hi,
>
> Just getting started with btrfs.
>
> I understand that btrfs stores data/metadata in two different tree
> structures =96 one for file/directory names, and one for data blocks.
>
> Reading @,
>
>  http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Dev=
ices
>   Use raid10 for both data and metadata
>     mkfs.btrfs -m raid10 -d raid10 /dev/sdb /dev/sdc /dev/sdd /dev/sd=
e
>
> and @,
>
>  "Churning Butter(FS): An Interview with Chris Mason"
>   http://www.linux-mag.com/id/7329
>
>     CM Today you can do this:
>     mkfs.btrfs -m raid1 -d raid10 /dev/sda /dev/sdb /dev/sdc /dev/sdd
> And you=92ll get metadata on raid1 and data on raid10. The raid10 wil=
l
> use all four drives and the raid1 will use two drives at a time. Yes,
> btrfs allows you to pick different values for data or metadata.
>
> The fact that I *can* setup data & metadata differently is clear.  Bu=
t
> I'm not at all clear *why* I'd want to, or what the advantages are.
> I'd guess it's a balance/combination of performance & resiliency.
>
> Naively "-m raid10 -d raid10" seems to make the most sense -- if i
> have it, use it.
>
> Are there any benchmarks, guidelines or recommendations?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
