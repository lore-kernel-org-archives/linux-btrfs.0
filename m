From: Christian Brunner <chb@muc.de>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Wed, 26 Oct 2011 02:16:19 +0200
Message-ID: <CAO47_-9vgo=pVQ1aq_cAArYJWAmTapWnxxugiGWsBJW3rNjBbA@mail.gmail.com>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
	<CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
	<Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
	<20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
	<CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
	<20111025122320.GA3703@dhcp231-156.rdu.redhat.com>
	<CAO47_--rkkKw7AJVRHdhwVXEq736ijhVWKYhRDQdgUxix3P-0w@mail.gmail.com>
	<20111025150512.GC3703@dhcp231-156.rdu.redhat.com>
	<20111025201545.GA4082@shiny.Mikenopa.local>
	<20111025202248.GE3703@dhcp231-156.rdu.redhat.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20111025202248.GE3703@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/25 Josef Bacik <josef@redhat.com>:
> On Tue, Oct 25, 2011 at 04:15:45PM -0400, Chris Mason wrote:
>> On Tue, Oct 25, 2011 at 11:05:12AM -0400, Josef Bacik wrote:
>> > On Tue, Oct 25, 2011 at 04:25:02PM +0200, Christian Brunner wrote:
>> > >
>> > > Attached is a perf-report. I have included the whole report, so =
that
>> > > you can see the difference between the good and the bad
>> > > btrfs-endio-wri.
>> > >
>> >
>> > We also shouldn't be running run_ordered_operations, man this is s=
crewed up,
>> > thanks so much for this, I should be able to nail this down pretty=
 easily.
>> > Thanks,
>>
>> Looks like we're getting there from reserve_metadata_bytes when we j=
oin
>> the transaction?
>>
>
> We don't do reservations in the endio stuff, we assume you've reserve=
d all the
> space you need in delalloc, plus we would have seen reserve_metadata_=
bytes in
> the trace. =A0Though it does look like perf is lying to us in at leas=
t one case
> sicne btrfs_alloc_logged_file_extent is only called from log replay a=
nd not
> during normal runtime, so it definitely shouldn't be showing up. =A0T=
hanks,

Strange! - I'll check if symbols got messed up in the report tomorrow.

Christian
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
