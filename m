From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: reiserfs3/ext4/btrfs RAID read performance
Date: Sun, 20 Sep 2009 12:40:48 -0700 (PDT)
Message-ID: <5d60108b-94f3-4bcb-a09c-20f9dd67e576@k26g2000vbp.googlegroups.com>
References: <dms9u-34x-3@gated-at.bofh.it> <dms9u-34x-5@gated-at.bofh.it>
	<dms9u-34x-1@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: wbrana@gmail.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755436AbZITTkq@vger.kernel.org>
In-Reply-To: <dms9u-34x-1@gated-at.bofh.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sep 20, 11:50 am, wbrana@gmail.com wrote:
> On Sun, Sep 20, 2009 at 3:47 AM, Daniel J Blueman
>
> <daniel.blueman@gmail.com> wrote:
> > On Sep 19, 7:20 pm, wbr...@gmail.com wrote:
>
> >> RAID details:
> >>
> >> md8 : active raid10 sda7[0] sdd7[3] sdc7[2] sdb7[1]
> >>       62925824 blocks 256K chunks 2 far-copies [4/4] [UUUU]
> >>
> >> Ext4:
> >> mkfs.ext4 -E stride=64,stripe-width=128 /dev/md8
> >> mount -t ext4 -o noatime,auto_da_alloc,commit=600 /dev/md8 /mnt/md8

Here, stripe-width should be 4* stride, not that it'll make much
difference.

> >> Reiser3:
> >> mount -t reiserfs /dev/md8 /mnt/md8
> >> mount -t reiserfs -o noatime,notail /dev/md8 /dev/md8
> >>
> >> Ext4 results:
> >> intial create total runs 10 avg 172.76 MB/s (user 0.43s sys 0.60s)
> >> create total runs 14 avg 36.49 MB/s (user 0.42s sys 0.59s)
> >> patch total runs 15 avg 15.16 MB/s (user 0.24s sys 0.49s)
> >> compile total runs 14 avg 64.07 MB/s (user 0.10s sys 0.59s)
> >> clean total runs 10 avg 393.43 MB/s (user 0.02s sys 0.06s)
> >> read tree total runs 11 avg 20.47 MB/s (user 0.53s sys 0.74s)
> >> read compiled tree total runs 4 avg 32.94 MB/s (user 0.61s sys 1.17s)
> >> delete tree total runs 10 avg 2.51 seconds (user 0.24s sys 0.42s)
> >> delete compiled tree total runs 4 avg 2.63 seconds (user 0.28s sys 0.50s)
> >> stat tree total runs 11 avg 1.99 seconds (user 0.23s sys 0.18s)
> >> stat compiled tree total runs 7 avg 2.11 seconds (user 0.27s sys 0.21s)
> >>
> >> Reiser3 results:
> >> intial create total runs 10 avg 82.74 MB/s (user 0.45s sys 1.13s)
> >> create total runs 14 avg 28.54 MB/s (user 0.45s sys 1.19s)
> >> patch total runs 15 avg 10.91 MB/s (user 0.24s sys 0.86s)
> >> compile total runs 14 avg 47.49 MB/s (user 0.10s sys 1.27s)
> >> clean total runs 10 avg 270.21 MB/s (user 0.02s sys 0.15s)
> >> read tree total runs 11 avg 26.33 MB/s (user 0.54s sys 0.81s)
> >> read compiled tree total runs 4 avg 41.82 MB/s (user 0.62s sys 1.36s)
> >> delete tree total runs 10 avg 3.38 seconds (user 0.24s sys 0.72s)
> >> delete compiled tree total runs 4 avg 4.14 seconds (user 0.27s sys 0.88s)
> >> stat tree total runs 11 avg 2.09 seconds (user 0.22s sys 0.18s)
> >> stat compiled tree total runs 7 avg 2.27 seconds (user 0.25s sys 0.21s)
> >>
> > It would be interesting to also compare against BTRFS if on 2.6.30 or
> > newer, if you can.
>
> BTRFS 2.6.31
>
> mkfs.btrfs -d raid10 -m raid10 /dev/sda7 /dev/sdb7 /dev/sdc7 /dev/sdd7
> mount -t btrfs -o noatime /dev/sda7 /mnt/md8
>
> intial create total runs 10 avg 158.85 MB/s (user 0.45s sys 0.93s)
> create total runs 14 avg 32.67 MB/s (user 0.44s sys 0.90s)
> patch total runs 15 avg 8.91 MB/s (user 0.22s sys 0.84s)
> compile total runs 14 avg 61.02 MB/s (user 0.09s sys 0.50s)
> clean total runs 10 avg 245.12 MB/s (user 0.02s sys 0.18s)
>
> read tree total runs 11 avg 14.03 MB/s (user 0.48s sys 0.87s)
> read compiled tree total runs 4 avg 29.14 MB/s (user 0.54s sys 1.37s)
>
> delete tree total runs 10 avg 9.77 seconds (user 0.28s sys 1.37s)
> delete compiled tree total runs 4 avg 11.91 seconds (user 0.31s sys 1.60s)
> stat tree total runs 11 avg 4.36 seconds (user 0.25s sys 0.33s)
> stat compiled tree total runs 7 avg 5.29 seconds (user 0.29s sys 0.37s)

Not ext4 specific, but I was finding 64KB chunk-size RAID 10 (layout
f2 if using MD) and increasing readahead of /dev/mdX to drives*256 to
give the best performance on a 4-drive SATA array. Consider using
aligned partitions (ext4 has internal alignment, I don't think BTRFS
does) and at the outside of identical disks if using non-SSDs.

Thanks,
  Daniel
--
Daniel J Blueman
