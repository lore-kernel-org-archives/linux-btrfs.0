From: Christian Brunner <chb@muc.de>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Tue, 25 Oct 2011 17:13:53 +0200
Message-ID: <CAO47_-_VREsjCED1xMTyf7bGx4bYs4D0d1qCQ_tU6DXJ-xDWVw@mail.gmail.com>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
	<CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
	<Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
	<20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
	<CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
	<20111025122320.GA3703@dhcp231-156.rdu.redhat.com>
	<CAO47_--rkkKw7AJVRHdhwVXEq736ijhVWKYhRDQdgUxix3P-0w@mail.gmail.com>
	<20111025150512.GC3703@dhcp231-156.rdu.redhat.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111025150512.GC3703@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/25 Josef Bacik <josef@redhat.com>:
> On Tue, Oct 25, 2011 at 04:25:02PM +0200, Christian Brunner wrote:
>> 2011/10/25 Josef Bacik <josef@redhat.com>:
>> > On Tue, Oct 25, 2011 at 01:56:48PM +0200, Christian Brunner wrote:
[...]
>> >>
>> >> In our Ceph-OSD server we have 4 disks with 4 btrfs filesystems. =
Ceph
>> >> tries to balance the load over all OSDs, so all filesystems shoul=
d get
>> >> an nearly equal load. At the moment one filesystem seems to have =
a
>> >> problem. When running with iostat I see the following
>> >>
>> >> Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s=
 =A0 rsec/s =A0 wsec/s
>> >> avgrq-sz avgqu-sz =A0 await =A0svctm =A0%util
>> >> sdd =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0=
 =A04.33 =A0 =A0 0.00 =A0 =A053.33
>> >> 12.31 =A0 =A0 0.08 =A0 19.38 =A012.23 =A0 5.30
>> >> sdc =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 1.00 =A0 =A00.00 =A0=
228.33 =A0 =A0 0.00 =A01957.33
>> >> 8.57 =A0 =A074.33 =A0380.76 =A0 2.74 =A062.57
>> >> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0=
 =A01.33 =A0 =A0 0.00 =A0 =A016.00
>> >> 12.00 =A0 =A0 0.03 =A0 25.00 19.75 2.63
>> >> sda =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0=
 =A00.67 =A0 =A0 0.00 =A0 =A0 8.00
>> >> 12.00 =A0 =A0 0.01 =A0 19.50 =A012.50 =A0 0.83
>> >>
>> >> The PID of the ceph-osd taht is running on sdc is 2053 and when I=
 look
>> >> with top I see this process and a btrfs-endio-writer (PID 5447):
>> >>
>> >> =A0 PID USER =A0 =A0 =A0PR =A0NI =A0VIRT =A0RES =A0SHR S %CPU %ME=
M =A0 =A0TIME+ =A0COMMAND
>> >> =A02053 root =A0 =A0 =A020 =A0 0 =A0537m 146m 2364 S 33.2 0.6 43:=
31.24 ceph-osd
>> >> =A05447 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S 22=
=2E6 0.0 19:32.18 btrfs-endio-wri
>> >>
>> >> In the latencytop output you can see that those processes have a =
much
>> >> higher latency, than the other ceph-osd and btrfs-endio-writers.
>> >>
>> >
>> > I'm seeing a lot of this
>> >
>> > =A0 =A0 =A0 =A0[schedule] =A0 =A0 =A01654.6 msec =A0 =A0 =A0 =A0 9=
6.4 %
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0schedule blkdev_issue_flush blkdev_=
fsync vfs_fsync_range
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0generic_write_sync blkdev_aio_write=
 do_sync_readv_writev
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do_readv_writev vfs_writev sys_writ=
ev system_call_fastpath
>> >
>> > where ceph-osd's latency is mostly coming from this fsync of a blo=
ck device
>> > directly, and not so much being tied up by btrfs directly. =A0With=
 22% CPU being
>> > taken up by btrfs-endio-wri we must be doing something wrong. =A0C=
an you run perf
>> > record -ag when this is going on and then perf report so we can se=
e what
>> > btrfs-endio-wri is doing with the cpu. =A0You can drill down in pe=
rf report to get
>> > only what btrfs-endio-wri is doing, so that would be best. =A0As f=
ar as the rest
>> > of the latencytop goes, it doesn't seem like btrfs-endio-wri is do=
ing anything
>> > horribly wrong or introducing a lot of latency. =A0Most of it seem=
s to be when
>> > running the dleayed refs and having to read in blocks. =A0I've bee=
n suspecting for
>> > a while that the delayed ref stuff ends up doing way more work tha=
n it needs to
>> > be per task, and it's possible that btrfs-endio-wri is simply gett=
ing screwed by
>> > other people doing work.
>> >
>> > At this point it seems like the biggest problem with latency in ce=
ph-osd is not
>> > related to btrfs, the latency seems to all be from the fact that c=
eph-osd is
>> > fsyncing a block dev for whatever reason. =A0As for btrfs-endio-wr=
i it seems like
>> > its blowing a lot of CPU time, so perf record -ag is probably goin=
g to be your
>> > best bet when it's using lots of cpu so we can figure out what it'=
s spinning on.
>>
>> Attached is a perf-report. I have included the whole report, so that
>> you can see the difference between the good and the bad
>> btrfs-endio-wri.
>>
>
> We also shouldn't be running run_ordered_operations, man this is scre=
wed up,
> thanks so much for this, I should be able to nail this down pretty ea=
sily.

Please note that this is with "btrfs snaps disabled" in the ceph conf.
When I enable snaps our problems get worse (the btrfs-cleaner thing),
but I would be glad if this one thing gets solved. I can run debugging
with snaps enabled, if you want, but I would suggest, that we do this
afterwards.

Thanks,
Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
