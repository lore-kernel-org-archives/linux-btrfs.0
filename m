From: Christian Brunner <chb@muc.de>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Thu, 27 Oct 2011 22:39:03 +0200
Message-ID: <CAO47_-_bBd5W55P87DQKpjE7CnbjgXXUMR37SgkQQqNwNZxpog@mail.gmail.com>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
	<CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
	<Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
	<20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
	<CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
	<20111027195209.GD2329@localhost.localdomain>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20111027195209.GD2329@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/27 Josef Bacik <josef@redhat.com>:
> On Tue, Oct 25, 2011 at 01:56:48PM +0200, Christian Brunner wrote:
>> 2011/10/24 Josef Bacik <josef@redhat.com>:
>> > On Mon, Oct 24, 2011 at 10:06:49AM -0700, Sage Weil wrote:
>> >> [adding linux-btrfs to cc]
>> >>
>> >> Josef, Chris, any ideas on the below issues?
>> >>
>> >> On Mon, 24 Oct 2011, Christian Brunner wrote:
>> >> >
>> >> > - When I run ceph with btrfs snaps disabled, the situation is g=
etting
>> >> > slightly better. I can run an OSD for about 3 days without prob=
lems,
>> >> > but then again the load increases. This time, I can see that th=
e
>> >> > ceph-osd (blkdev_issue_flush) and btrfs-endio-wri are doing mor=
e work
>> >> > than usual.
>> >>
>> >> FYI in this scenario you're exposed to the same journal replay is=
sues that
>> >> ext4 and XFS are. =A0The btrfs workload that ceph is generating w=
ill also
>> >> not be all that special, though, so this problem shouldn't be uni=
que to
>> >> ceph.
>> >>
>> >
>> > Can you get sysrq+w when this happens? =A0I'd like to see what btr=
fs-endio-write
>> > is up to.
>>
>> Capturing this seems to be not easy. I have a few traces (see
>> attachment), but with sysrq+w I do not get a stacktrace of
>> btrfs-endio-write. What I have is a "latencytop -c" output which is
>> interesting:
>>
>> In our Ceph-OSD server we have 4 disks with 4 btrfs filesystems. Cep=
h
>> tries to balance the load over all OSDs, so all filesystems should g=
et
>> an nearly equal load. At the moment one filesystem seems to have a
>> problem. When running with iostat I see the following
>>
>> Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0=
 rsec/s =A0 wsec/s
>> avgrq-sz avgqu-sz =A0 await =A0svctm =A0%util
>> sdd =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0 =A0=
4.33 =A0 =A0 0.00 =A0 =A053.33
>> 12.31 =A0 =A0 0.08 =A0 19.38 =A012.23 =A0 5.30
>> sdc =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 1.00 =A0 =A00.00 =A0228=
=2E33 =A0 =A0 0.00 =A01957.33
>> 8.57 =A0 =A074.33 =A0380.76 =A0 2.74 =A062.57
>> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0 =A0=
1.33 =A0 =A0 0.00 =A0 =A016.00
>> 12.00 =A0 =A0 0.03 =A0 25.00 19.75 2.63
>> sda =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.00 =A0 =A0 0.00 =A0 =A00.00 =A0 =A0=
0.67 =A0 =A0 0.00 =A0 =A0 8.00
>> 12.00 =A0 =A0 0.01 =A0 19.50 =A012.50 =A0 0.83
>>
>> The PID of the ceph-osd taht is running on sdc is 2053 and when I lo=
ok
>> with top I see this process and a btrfs-endio-writer (PID 5447):
>>
>> =A0 PID USER =A0 =A0 =A0PR =A0NI =A0VIRT =A0RES =A0SHR S %CPU %MEM =A0=
 =A0TIME+ =A0COMMAND
>> =A02053 root =A0 =A0 =A020 =A0 0 =A0537m 146m 2364 S 33.2 0.6 43:31.=
24 ceph-osd
>> =A05447 root =A0 =A0 =A020 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =A00 S 22.6 =
0.0 19:32.18 btrfs-endio-wri
>>
>> In the latencytop output you can see that those processes have a muc=
h
>> higher latency, than the other ceph-osd and btrfs-endio-writers.
>>
>> Regards,
>> Christian
>
> Ok just a shot in the dark, but could you give this a whirl and see i=
f it helps
> you? =A0Thanks

Thanks for the patch! I'll install it tomorrow and I think that I can
report back on Monday. It always takes a few days until the load goes
up.

Regards,
Christian
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
