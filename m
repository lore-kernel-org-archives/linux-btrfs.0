From: Josef Bacik <josef@redhat.com>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Tue, 25 Oct 2011 08:23:20 -0400
Message-ID: <20111025122320.GA3703@dhcp231-156.rdu.redhat.com>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net> <CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com> <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net> <20111024195147.GB31264@dhcp231-156.rdu.redhat.com> <CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, Sage Weil <sage@newdream.net>,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Christian Brunner <chb@muc.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2011 at 01:56:48PM +0200, Christian Brunner wrote:
> 2011/10/24 Josef Bacik <josef@redhat.com>:
> > On Mon, Oct 24, 2011 at 10:06:49AM -0700, Sage Weil wrote:
> >> [adding linux-btrfs to cc]
> >>
> >> Josef, Chris, any ideas on the below issues?
> >>
> >> On Mon, 24 Oct 2011, Christian Brunner wrote:
> >> >
> >> > - When I run ceph with btrfs snaps disabled, the situation is ge=
tting
> >> > slightly better. I can run an OSD for about 3 days without probl=
ems,
> >> > but then again the load increases. This time, I can see that the
> >> > ceph-osd (blkdev_issue_flush) and btrfs-endio-wri are doing more=
 work
> >> > than usual.
> >>
> >> FYI in this scenario you're exposed to the same journal replay iss=
ues that
> >> ext4 and XFS are. =A0The btrfs workload that ceph is generating wi=
ll also
> >> not be all that special, though, so this problem shouldn't be uniq=
ue to
> >> ceph.
> >>
> >
> > Can you get sysrq+w when this happens? =A0I'd like to see what btrf=
s-endio-write
> > is up to.
>=20
> Capturing this seems to be not easy. I have a few traces (see
> attachment), but with sysrq+w I do not get a stacktrace of
> btrfs-endio-write. What I have is a "latencytop -c" output which is
> interesting:
>=20
> In our Ceph-OSD server we have 4 disks with 4 btrfs filesystems. Ceph
> tries to balance the load over all OSDs, so all filesystems should ge=
t
> an nearly equal load. At the moment one filesystem seems to have a
> problem. When running with iostat I see the following
>=20
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdd               0.00     0.00    0.00    4.33     0.00    53.33
> 12.31     0.08   19.38  12.23   5.30
> sdc               0.00     1.00    0.00  228.33     0.00  1957.33
> 8.57    74.33  380.76   2.74  62.57
> sdb               0.00     0.00    0.00    1.33     0.00    16.00
> 12.00     0.03   25.00  19.75   2.63
> sda               0.00     0.00    0.00    0.67     0.00     8.00
> 12.00     0.01   19.50  12.50   0.83
>=20
> The PID of the ceph-osd taht is running on sdc is 2053 and when I loo=
k
> with top I see this process and a btrfs-endio-writer (PID 5447):
>=20
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  2053 root      20   0  537m 146m 2364 S 33.2  0.6  43:31.24 ceph-osd
>  5447 root      20   0     0    0    0 S 22.6  0.0  19:32.18 btrfs-en=
dio-wri
>=20
> In the latencytop output you can see that those processes have a much
> higher latency, than the other ceph-osd and btrfs-endio-writers.
>=20

I'm seeing a lot of this

        [schedule]      1654.6 msec         96.4 %
                schedule blkdev_issue_flush blkdev_fsync vfs_fsync_rang=
e
                generic_write_sync blkdev_aio_write do_sync_readv_write=
v
                do_readv_writev vfs_writev sys_writev system_call_fastp=
ath

where ceph-osd's latency is mostly coming from this fsync of a block de=
vice
directly, and not so much being tied up by btrfs directly.  With 22% CP=
U being
taken up by btrfs-endio-wri we must be doing something wrong.  Can you =
run perf
record -ag when this is going on and then perf report so we can see wha=
t
btrfs-endio-wri is doing with the cpu.  You can drill down in perf repo=
rt to get
only what btrfs-endio-wri is doing, so that would be best.  As far as t=
he rest
of the latencytop goes, it doesn't seem like btrfs-endio-wri is doing a=
nything
horribly wrong or introducing a lot of latency.  Most of it seems to be=
 when
running the dleayed refs and having to read in blocks.  I've been suspe=
cting for
a while that the delayed ref stuff ends up doing way more work than it =
needs to
be per task, and it's possible that btrfs-endio-wri is simply getting s=
crewed by
other people doing work.

At this point it seems like the biggest problem with latency in ceph-os=
d is not
related to btrfs, the latency seems to all be from the fact that ceph-o=
sd is
fsyncing a block dev for whatever reason.  As for btrfs-endio-wri it se=
ems like
its blowing a lot of CPU time, so perf record -ag is probably going to =
be your
best bet when it's using lots of cpu so we can figure out what it's spi=
nning on.
Thanks,

Josef

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
