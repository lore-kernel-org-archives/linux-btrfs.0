From: Josef Bacik <josef@redhat.com>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Tue, 25 Oct 2011 11:00:45 -0400
Message-ID: <20111025150045.GB3703@dhcp231-156.rdu.redhat.com>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net> <CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com> <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net> <20111024195147.GB31264@dhcp231-156.rdu.redhat.com> <CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com> <20111025122320.GA3703@dhcp231-156.rdu.redhat.com> <CAO47_--rkkKw7AJVRHdhwVXEq736ijhVWKYhRDQdgUxix3P-0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, Sage Weil <sage@newdream.net>,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Christian Brunner <chb@muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_--rkkKw7AJVRHdhwVXEq736ijhVWKYhRDQdgUxix3P-0w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2011 at 04:25:02PM +0200, Christian Brunner wrote:
> 2011/10/25 Josef Bacik <josef@redhat.com>:
> > On Tue, Oct 25, 2011 at 01:56:48PM +0200, Christian Brunner wrote:
> >> 2011/10/24 Josef Bacik <josef@redhat.com>:
> >> > On Mon, Oct 24, 2011 at 10:06:49AM -0700, Sage Weil wrote:
> >> >> [adding linux-btrfs to cc]
> >> >>
> >> >> Josef, Chris, any ideas on the below issues?
> >> >>
> >> >> On Mon, 24 Oct 2011, Christian Brunner wrote:
> >> >> >
> >> >> > - When I run ceph with btrfs snaps disabled, the situation is=
 getting
> >> >> > slightly better. I can run an OSD for about 3 days without pr=
oblems,
> >> >> > but then again the load increases. This time, I can see that =
the
> >> >> > ceph-osd (blkdev_issue_flush) and btrfs-endio-wri are doing m=
ore work
> >> >> > than usual.
> >> >>
> >> >> FYI in this scenario you're exposed to the same journal replay =
issues that
> >> >> ext4 and XFS are. =A0The btrfs workload that ceph is generating=
 will also
> >> >> not be all that special, though, so this problem shouldn't be u=
nique to
> >> >> ceph.
> >> >>
> >> >
> >> > Can you get sysrq+w when this happens? =A0I'd like to see what b=
trfs-endio-write
> >> > is up to.
> >>
> >> Capturing this seems to be not easy. I have a few traces (see
> >> attachment), but with sysrq+w I do not get a stacktrace of
> >> btrfs-endio-write. What I have is a "latencytop -c" output which i=
s
> >> interesting:
> >>
> >> In our Ceph-OSD server we have 4 disks with 4 btrfs filesystems. C=
eph
> >> tries to balance the load over all OSDs, so all filesystems should=
 get
> >> an nearly equal load. At the moment one filesystem seems to have a
> >> problem. When running with iostat I see the following
> >>
> >> Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =
=A0 rsec/s =A0 wsec/s
> >> avgrq-sz avgqu-sz =A0 await =A0svctm =A0%util
> >> sdd =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0 =
=A04.33 =A0 =A0 0.00 =A0 =A053.33
> >> 12.31 =A0 =A0 0.08 =A0 19.38 =A012.23 =A0 5.30
> >> sdc =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 1.00 =A0 =A00.00 =A02=
28.33 =A0 =A0 0.00 =A01957.33
> >> 8.57 =A0 =A074.33 =A0380.76 =A0 2.74 =A062.57
> >> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0 =
=A01.33 =A0 =A0 0.00 =A0 =A016.00
> >> 12.00 =A0 =A0 0.03 =A0 25.00 19.75 2.63
> >> sda =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0 =
=A00.67 =A0 =A0 0.00 =A0 =A0 8.00
> >> 12.00 =A0 =A0 0.01 =A0 19.50 =A012.50 =A0 0.83
> >>
> >> The PID of the ceph-osd taht is running on sdc is 2053 and when I =
look
> >> with top I see this process and a btrfs-endio-writer (PID 5447):
> >>
> >> =A0 PID USER =A0 =A0 =A0PR =A0NI =A0VIRT =A0RES =A0SHR S %CPU %MEM=
 =A0 =A0TIME+ =A0COMMAND
> >> =A02053 root =A0 =A0 =A020 =A0 0 =A0537m 146m 2364 S 33.2 0.6 43:3=
1.24 ceph-osd
> >> =A05447 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S 22.=
6 0.0 19:32.18 btrfs-endio-wri
> >>
> >> In the latencytop output you can see that those processes have a m=
uch
> >> higher latency, than the other ceph-osd and btrfs-endio-writers.
> >>
> >
> > I'm seeing a lot of this
> >
> > =A0 =A0 =A0 =A0[schedule] =A0 =A0 =A01654.6 msec =A0 =A0 =A0 =A0 96=
=2E4 %
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0schedule blkdev_issue_flush blkdev_f=
sync vfs_fsync_range
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0generic_write_sync blkdev_aio_write =
do_sync_readv_writev
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do_readv_writev vfs_writev sys_write=
v system_call_fastpath
> >
> > where ceph-osd's latency is mostly coming from this fsync of a bloc=
k device
> > directly, and not so much being tied up by btrfs directly. =A0With =
22% CPU being
> > taken up by btrfs-endio-wri we must be doing something wrong. =A0Ca=
n you run perf
> > record -ag when this is going on and then perf report so we can see=
 what
> > btrfs-endio-wri is doing with the cpu. =A0You can drill down in per=
f report to get
> > only what btrfs-endio-wri is doing, so that would be best. =A0As fa=
r as the rest
> > of the latencytop goes, it doesn't seem like btrfs-endio-wri is doi=
ng anything
> > horribly wrong or introducing a lot of latency. =A0Most of it seems=
 to be when
> > running the dleayed refs and having to read in blocks. =A0I've been=
 suspecting for
> > a while that the delayed ref stuff ends up doing way more work than=
 it needs to
> > be per task, and it's possible that btrfs-endio-wri is simply getti=
ng screwed by
> > other people doing work.
> >
> > At this point it seems like the biggest problem with latency in cep=
h-osd is not
> > related to btrfs, the latency seems to all be from the fact that ce=
ph-osd is
> > fsyncing a block dev for whatever reason. =A0As for btrfs-endio-wri=
 it seems like
> > its blowing a lot of CPU time, so perf record -ag is probably going=
 to be your
> > best bet when it's using lots of cpu so we can figure out what it's=
 spinning on.
>=20
> Attached is a perf-report. I have included the whole report, so that
> you can see the difference between the good and the bad
> btrfs-endio-wri.
>

Oh shit we're inserting xattrs in endio, thats not good.  I'll look mor=
e into
this when I get back home but this is definitely a problem, we're doing=
 a lot
more work in endio than we should.  Thanks,

Josef=20
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
