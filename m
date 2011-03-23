From: Chester <somethingsome2000@gmail.com>
Subject: Re: efficiency of btrfs cow
Date: Wed, 23 Mar 2011 15:53:17 +0000
Message-ID: <AANLkTikF3e2X=UK2pJmNgaTAJqR0DXymKfzr=drhC5S=@mail.gmail.com>
References: <il0a8d$4ev$1@dough.gmane.org> <1299427596.15017.8.camel@ayu> <4D89EA17.20506@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D89EA17.20506@interlinx.bc.ca>
List-ID: <linux-btrfs.vger.kernel.org>

I'm not a developer, but I think it goes something like this:
btrfs doesn't write the filesystem on the entire device/partition at
format time, rather, it dynamically increases the size of the
filesystem as data is used. That's why formating a disk in btrfs can
be so fast.

On Wed, Mar 23, 2011 at 12:39 PM, Brian J. Murrell
<brian@interlinx.bc.ca> wrote:
>
> On 11-03-06 11:06 AM, Calvin Walton wrote:
> >
> > To see exactly what's going on, you should use the "btrfs filesyste=
m df"
> > command to see how space is being allocated for data and metadata
> > separately:
>
> OK. =A0So with an empty filesystem, before my first copy (i.e. the ba=
se on
> which the next copy will CoW from) df reports:
>
> Filesystem =A0 =A0 =A0 =A0 =A0 1K-blocks =A0 =A0 =A0Used Available Us=
e% Mounted on
> /dev/mapper/btrfs--test-btrfs--test
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 922746880 =A0 =A0 =A0 =A056 9=
22746824 =A0 1% /mnt/btrfs-test
>
> and btrfs fi df reports:
>
> Data: total=3D8.00MB, used=3D0.00
> Metadata: total=3D1.01GB, used=3D24.00KB
> System: total=3D12.00MB, used=3D4.00KB
>
> after the first copy df and btrfs fi df report:
>
> Filesystem =A0 =A0 =A0 =A0 =A0 1K-blocks =A0 =A0 =A0Used Available Us=
e% Mounted on
> /dev/mapper/btrfs--test-btrfs--test
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 922746880 121402328 801344552=
 =A014% /mnt/btrfs-test
>
> root@linux:/mnt/btrfs-test# cat .snapshots/monthly.22/metadata/btrfs_=
df-stop
> Data: total=3D110.01GB, used=3D109.26GB
> Metadata: total=3D5.01GB, used=3D3.26GB
> System: total=3D12.00MB, used=3D24.00KB
>
> So it's clear that total usage (as reported by df) was 121,402,328KB =
but
> Metadata has two values:
>
> Metadata: total=3D5.01GB, used=3D3.26GB
>
> What's the difference between total and used? =A0And for that matter,
> what's the difference between the total and used for Data
> (total=3D110.01GB, used=3D109.26GB)?
>
> Even if I take the largest values (i.e. the total values) for Data an=
d
> Metadata (each converted to KB first) and add them up they are:
> 120,607,211.52 which is not quite the 121,402,328 that df reports.
> There is a 795,116.48KB discrepancy.
>
> In any case, which value from a btrfs df fi should I be subtracting f=
rom
> df's accounting to get a real accounting of the amount of data used?
>
> Cheers,
> b.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
