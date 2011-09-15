From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Fri, 16 Sep 2011 05:16:18 +0700
Message-ID: <CAG1y0sdv=GwgRAd1suTGhzVB=A1dUsZ=fjiE67QsuGQCCQwSjw@mail.gmail.com>
References: <4E64D3D5.7020407@petaramesh.org>
	<15663472.1RTxtZJx8a@tethys>
	<CAG1y0sd=fYDT4Z4J=HqYXSsuZGjyMbUgpbLiguqdnibwt9qqOw@mail.gmail.com>
	<1411501.d4mgBNBG2i@tethys>
	<4E7253F4.9020005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E7253F4.9020005@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2011 at 2:37 AM, Felix Blanke <felixblanke@gmail.com> wrote:
> I'm using btrfs since one year now and it's quite fast. I don't feel any
> differences to other filesystems. Never tried a benchmark but for my daily
> work it's nice.

Your workload must be light :)

> I also never had any issues with the memory. Imho nowadays
> memory isn't a problem at all in desktop computers. I bought 8gb of memory 2
> years before because it was so damn cheap. Never used that mutch, but it was
> almost for free :)

It might not be possible in some situations. For example, if:
- adding memory by yourself means voiding warranty (cause there's a
warranty sticker covering memory slot cover screw), while going to
official service shop means 1 full day wasted plus inflated price
- you're using $300 netbook with 1 or 2 GB RAM with only one memory slot

>
> The advantage to ext4 for me is the build in raid1 and the snapshots. I'm
> using the snapshot feature for my local backups. I like it because it's
> really easy and uses very few storage. A simple "Snapshot -> Rsync to a
> different disk -> Snapshot" script is the perfect local backup method.
>

you've never used zfs have you :)

For that purpose, think "same feature as btrfs snapshot + rsync" but
without needing rsync. This can be very useful as the process of rsync
determining what data to transfer can be quite CPU/disk intensive.

> I really appreciate the work of the developers! Btrfs is great and I'm 110%
> sure it will become better and better over the next month.

btrfs is great, but not quite production-ready yet, with lack of
working fsck being the greatest hurdle. I'm not complaining much about
the speed at this point though, being still in dev and all, and since
new features will have some performance cost.

-- 
Fajar
