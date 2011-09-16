From: Henti Smith <henti@geekware.co.za>
Subject: Re: Raid0 and drive failure.
Date: Fri, 16 Sep 2011 17:24:38 +0200
Message-ID: <CAC_HdUrqiiajN9CfnnSUuTrtmYeDrkS+mp4AkMk75n+C5YLBkw@mail.gmail.com>
References: <CAC_HdUrrEzUYp3K=ZAG9sQK=6totXmoy5FswGg=huTuxb6vtnw@mail.gmail.com>
	<CAAeznTp1eX8m--Mw-RFNY8VmU8O08kRNQeOmHAZo=cGNxvV7Tg@mail.gmail.com>
	<CAC_HdUrh+LhBfHTMKE8VTkuwEgJbcX2mBP3pJFYivk228-VctA@mail.gmail.com>
	<20110916151044.GF11031@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Henti Smith <henti@geekware.co.za>,
	Leonidas Spyropoulos <artafinde@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110916151044.GF11031@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

>> This is the more pertinent question, which it seem btrfs can't do cu=
rrently.
>
> =A0 btrfs stripes its RAID-0 data across all available disks, so you'=
d
> lose approximately 1/3 of the data for each file. In some cases, you
> might get lucky and have a small file that resides entirely on the tw=
o
> undamaged disks. In that case, it *might* be possible to recover your
> data, but I think in general the amount of effort involved to get tha=
t
> degree of recovery is probably far outweighted by the use of your
> backups to restore all of the missing data...

That how I understood raid0 as well, so I do understand that, thank you=
=2E

Henti
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
