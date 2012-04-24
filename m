From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: Ceph on btrfs 3.4rc
Date: Tue, 24 Apr 2012 13:41:15 -0400
Message-ID: <20120424174115.GA9012@hmsreliant.think-freely.org>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
 <20120424152141.GB3326@localhost.localdomain>
 <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
 <20120424173343.GB6164@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sage Weil <sage@newdream.net>,
	Christian Brunner <christian@brunner-muc.de>,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20120424173343.GB6164@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2012 at 01:33:44PM -0400, Josef Bacik wrote:
> On Tue, Apr 24, 2012 at 09:26:15AM -0700, Sage Weil wrote:
> > On Tue, 24 Apr 2012, Josef Bacik wrote:
> > > On Fri, Apr 20, 2012 at 05:09:34PM +0200, Christian Brunner wrote:
> > > > After running ceph on XFS for some time, I decided to try btrfs again.
> > > > Performance with the current "for-linux-min" branch and big metadata
> > > > is much better. The only problem (?) I'm still seeing is a warning
> > > > that seems to occur from time to time:
> > 
> > Actually, before you do that... we have a new tool, 
> > test_filestore_workloadgen, that generates a ceph-osd-like workload on the 
> > local file system.  It's a subset of what a full OSD might do, but if 
> > we're lucky it will be sufficient to reproduce this issue.  Something like
> > 
> >  test_filestore_workloadgen --osd-data /foo --osd-journal /bar
> > 
> > will hopefully do the trick.
> > 
> > Christian, maybe you can see if that is able to trigger this warning?  
> > You'll need to pull it from the current master branch; it wasn't in the 
> > last release.
> > 
> 
> Keep up the good work Sage, at this rate I'll never have to setup ceph for
> myself :),
> 
You can setup another OSD on daedalus if you're looking for something to do
Josef :)
Neil

> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
