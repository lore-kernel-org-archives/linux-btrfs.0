From: cwillu <cwillu@cwillu.com>
Subject: Re: very poor read / write performance compared to other FS's?
Date: Wed, 11 May 2011 16:41:10 -0600
Message-ID: <BANLkTinBsvfa1ZbOVMoP=Mm_h-_it8Ps-Q@mail.gmail.com>
References: <BANLkTinRa9TdVOAaMt9_gcR2xDhbDWVJcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Marek Fstump <marekfstump@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinRa9TdVOAaMt9_gcR2xDhbDWVJcA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2011 at 4:33 PM, Marek Fstump <marekfstump@gmail.com> w=
rote:
> Hi
>
> I am very interested in using BTRFS for my solution but in basic test=
s
> it seems to be very poor on read and write performance. =C2=A0I am
> surprised by this so suspect that maybe I am doing something
> incorrectly or that there are updates I should be using, but I am not
> sure how I update BTRFS on SLES11
>
> Summary:
> RESULTS on link below
> SLES11 SP1
> Compared Sequential read/write performance against XFS and OCFS2
> Backend storage =E2=80=93 FusionIO SLC SSD =3D circa 750MBsec
>
> Tests =C2=A0set as follows:
> Filesystem contains 30 x 4GB files (made of random data)
> Read tests will read from 1 to 30 files concurrently
> Write tests will write 1 to 30 concurrent NEW files (simple 000=E2=80=
=99s)
> dd -direct flag used on writes
>
> All defaults used for mounting etc.
>
> Results shown in attachment.
>
> BTRFS looks an excellent FS and perfect for my application and I am
> hoping that there are some factors that I am missing
> and would appreciate any advice / help
>
> Graph is here (Thank you =E2=80=98cwillu=E2=80=99)
>
> http://cwillu.com/files/btrfs/read-write_perf.pdf

A couple questions:

Which kernel version?
How big is the partition the testing is done on?
How does btrfs compare if you drop the -direct flag, and instead sync
+ drop_caches before, and time until sync completes after dd (for all
of them, not just btrfs)?

There are a couple btrfs mount options that will improve performance
in this particular case, but this benchmark may not reflect your
actual needs.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
