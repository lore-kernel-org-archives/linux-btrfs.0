From: Josef Bacik <josef@redhat.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2193
	btrfs_orphan_commit_root+0xb0/0xc0 [btrfs]()
Date: Thu, 15 Sep 2011 15:50:29 -0400
Message-ID: <20110915195029.GD25179@dhcp231-156.rdu.redhat.com>
References: <4E6BDAEB.7020206@tuxadero.com> <4E6EABAF.9010903@cn.fujitsu.com> <Pine.LNX.4.64.1109151137420.17623@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, martin@tuxadero.com,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	josef@redhat.com
To: Sage Weil <sage@newdream.net>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1109151137420.17623@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2011 at 11:44:09AM -0700, Sage Weil wrote:
> On Tue, 13 Sep 2011, Liu Bo wrote:
> > On 09/11/2011 05:47 AM, Martin Mailand wrote:
> > > Hi
> > > I am hitting this Warning reproducible, the workload is a ceph osd,
> > > kernel ist 3.1.0-rc5.
> > > 
> > 
> > Have posted a patch for this:
> > 
> > http://marc.info/?l=linux-btrfs&m=131547325515336&w=2
> 
> We're still seeing this with -rc6, which includes 98c9942 and 65450aa.
> 
> I haven't looked at the reservation code in much detail.  Is there 
> anything I can do to help track this down?
> 

This should be taken care of with all my enospc changes.  You can pull them down
from my btrfs-work tree as soon as kernel.org comes back from the dead :).
Thanks,

Josef
