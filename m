From: Josef Bacik <josef@redhat.com>
Subject: Re: Do not use free space caching!
Date: Thu, 31 Mar 2011 18:59:57 -0400
Message-ID: <20110331225956.GC7484@dhcp231-156.rdu.redhat.com>
References: <4D939E76.1060801@redhat.com> <1301605604.12638.5.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301605604.12638.5.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2011 at 05:06:42PM -0400, Calvin Walton wrote:
> On Wed, 2011-03-30 at 17:19 -0400, Josef Bacik wrote:
> > Hello,
> > 
> > Just found a big bug in the free space caching stuff that will result in 
> > early ENOSPC.  I'm working on fixing this bug, but it won't be until 
> > tomorrow that I'll have it completely working, so for now make sure to 
> > mount -o clear_cache so that it just clears the cache and doesn't use it.
> > 
> > NOTE: It doesn't cause problems other than early ENOSPC, you won't get 
> > corruption or anything like that, tho you could possibly panic.
> > 
> > Sorry for the inconvenience.  Thanks,
> 
> Any chance you could provide a little more information about which
> kernels are affected? Is it any kernel with free space cache support (is
> 2.6.38.x included?) - and if so, do you plan on submitting the fix to
> the stable kernel series?
>

Yeah it affects any kernel that has the free space cache feature, which I think
started in .37.  Course you have to have specifically enabled it, so it's not a
huge problem.  I've submitted a patch, but since it's currently an optional
feature I don't think it needs to go to stable.  Thanks,

Josef 
