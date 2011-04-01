From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Do not use free space caching!
Date: Fri, 01 Apr 2011 13:56:51 -0400
Message-ID: <1301680612.1934.3.camel@ayu>
References: <4D939E76.1060801@redhat.com> <1301605604.12638.5.camel@ayu>
	 <20110331225956.GC7484@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110331225956.GC7484@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2011-03-31 at 18:59 -0400, Josef Bacik wrote:
> On Thu, Mar 31, 2011 at 05:06:42PM -0400, Calvin Walton wrote:
> > On Wed, 2011-03-30 at 17:19 -0400, Josef Bacik wrote:
> > > Hello,
> > > 
> > > Just found a big bug in the free space caching stuff that will result in 
> > > early ENOSPC.  I'm working on fixing this bug, but it won't be until 
> > > tomorrow that I'll have it completely working, so for now make sure to 
> > > mount -o clear_cache so that it just clears the cache and doesn't use it.
> 
> Yeah it affects any kernel that has the free space cache feature, which I think
> started in .37.  Course you have to have specifically enabled it, so it's not a
> huge problem.  I've submitted a patch, but since it's currently an optional
> feature I don't think it needs to go to stable.  Thanks,

If you don't think the full fix is appropriate for the stable kernel,
what about sending a simple patch to stable that just disables the free
space caching support?

That should be enough to stop any adventurous users (of the kind who
don't read mailing lists) from trying the free space caching support,
and possibly hitting this bug.

-- 
Calvin Walton <calvin.walton@kepstin.ca>


