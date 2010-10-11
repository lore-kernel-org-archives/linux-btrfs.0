From: Chester <somethingsome2000@gmail.com>
Subject: Re: Horrible btrfs performance on cold cache
Date: Mon, 11 Oct 2010 11:24:16 -0500
Message-ID: <AANLkTinYz59U1hZd=C=zaTkJOvU93Vnb31bS1GkAHByA@mail.gmail.com>
References: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
	<1286811979.9645.5.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Calvin Walton <calvin.walton@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1286811979.9645.5.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

I think I read/heard somewhere that snapshots can cause pretty bad
fragmentation, because it causes your system to write changes to files
to random locations on the disk, leaving the original inodes intact..
=46or that reason, I have replaced the directories ~/.config/chromium ,
/var , /usr/portage with subvolumes, so they will not be included in
snapshots.

It seems like chromium opens much quicker now, but it's still a long
way from what it was on ext4

On Mon, Oct 11, 2010 at 10:46 AM, Calvin Walton <calvin.walton@gmail.co=
m> wrote:
>
> On Mon, 2010-10-11 at 03:30 +0300, Felipe Contreras wrote:
> > Hi,
> >
> > I use btrfs on most of my volumes on my laptop, and I've always fel=
t
> > booting was very slow, but definitely sure is slow, is starting up
> > Google Chrome:
> >
> > encrypted ext4: ~20s
> > btrfs: ~2:11s
> >
> > I have tried different things to find out exactly what is the issue=
,
> > but haven't quite found it yet.
>
> If you've been using this volume for a while, it could just have beco=
me
> badly fragmented. You could try btrfs's fancy online defragmentation
> abilities to see if that'll give you an improvement:
>
> # btrfs filesystem defragment /mountpoint/of/volume
>
> Let us know if that helps, of course :)
>
> --
> Calvin Walton <calvin.walton@gmail.com>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
