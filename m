From: James <torpesco@gmail.com>
Subject: Re: Single drive volume + second drive -> RAID1?
Date: Mon, 23 Jan 2012 00:52:11 -0800
Message-ID: <CAEPoJ-34AmiaRpSCk4Whby4gDM6PSKYRyLHmG1my5_WFODaNrQ@mail.gmail.com>
References: <CAEPoJ-1PXu9Pt9E1EEudJ5NN-RunT4POJtjzo=BVRiOn_F97ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAEPoJ-1PXu9Pt9E1EEudJ5NN-RunT4POJtjzo=BVRiOn_F97ng@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2012 at 12:36 AM, James <torpesco@gmail.com> wrote:
> I bought one drive to replace the failing one. I'd like to end up wit=
h
> RAID1. Back in July I set up a server for my brother and (unless I'm
> forgetting a different path we ended up taking), I thought what I did
> was:
> =A01. mkfs.btrfs on a single drive but tell it to use RAID1
> =A02. copy data on
> =A03. once the second drive for the RAID1 was available, add it to th=
e
> volume and rebalance (or something)

I must be mixing memories. Maybe that's what I did to end up with the
volume that turned out to be RAID0 for the data. On a whim, even
thought btrfs filesystem df /path showed no indications of RAID after
adding the second drive, I issued a balance command. I ran 'df' right
away and now see the results I don't want -- RAID0 data, RAID1
metadata. Ctrl-C doesn't seem to be aborting the balance.

Especially with the currently inflated HDD prices compared to a few
months ago, I can't afford to go out and buy an extra drive just to
facilitate turning two drives into a mirror. Is there another way?

Thanks,
James.

>
> Since I had to get all the data off the volume with the failing drive=
,
> I tried doing the above. All my data is on the new drive, but when I
> add the other good drive to the volume, I just see it as a volume
> containing two drives, not as RAID1.
>
> Is there any way for me to get my current single disk volume into a
> RAID1 volume by adding the other drive? I didn't save the reference,
> but I thought I read something last night about being able to create =
a
> "RAID1" volume with a single disk as having been a bug.
>
> Thanks,
> James.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
