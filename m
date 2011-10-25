From: Chris Mason <chris.mason@oracle.com>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Tue, 25 Oct 2011 16:15:45 -0400
Message-ID: <20111025201545.GA4082@shiny.Mikenopa.local>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
 <CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
 <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
 <20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
 <CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
 <20111025122320.GA3703@dhcp231-156.rdu.redhat.com>
 <CAO47_--rkkKw7AJVRHdhwVXEq736ijhVWKYhRDQdgUxix3P-0w@mail.gmail.com>
 <20111025150512.GC3703@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Brunner <chb@muc.de>, Sage Weil <sage@newdream.net>,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20111025150512.GC3703@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2011 at 11:05:12AM -0400, Josef Bacik wrote:
> On Tue, Oct 25, 2011 at 04:25:02PM +0200, Christian Brunner wrote:
> > 
> > Attached is a perf-report. I have included the whole report, so that
> > you can see the difference between the good and the bad
> > btrfs-endio-wri.
> >
> 
> We also shouldn't be running run_ordered_operations, man this is screwed up,
> thanks so much for this, I should be able to nail this down pretty easily.
> Thanks,

Looks like we're getting there from reserve_metadata_bytes when we join
the transaction?

-chris
