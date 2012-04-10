From: Josef Bacik <josef@redhat.com>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Tue, 10 Apr 2012 09:08:54 -0400
Message-ID: <20120410130854.GA2296@localhost.localdomain>
References: <1333986823.2928.6.camel@ayu>
 <1333991404.2817.6.camel@ayu>
 <20120409205429.GB6958@localhost.localdomain>
 <1334006446.2678.0.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334006446.2678.0.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2012 at 05:20:46PM -0400, Calvin Walton wrote:
> On Mon, 2012-04-09 at 16:54 -0400, Josef Bacik wrote:
> > On Mon, Apr 09, 2012 at 01:10:04PM -0400, Calvin Walton wrote:
> > > On Mon, 2012-04-09 at 11:53 -0400, Calvin Walton wrote:
> > > > Hi,
> > > > 
> > > > I have a system that's using a dracut-generated initramfs to mount a
> > > > btrfs root. After upgrading to kernel 3.4.0-rc2 to test it out, I've
> > > > noticed that the process of mounting the root filesystem takes much
> > > > longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 seconds slower!
> 
> > > And the bisect results are in:
> > > 285ff5af6ce358e73f53b55c9efadd4335f4c2ff is the first bad commit
> > > commit 285ff5af6ce358e73f53b55c9efadd4335f4c2ff
> > > Author: Josef Bacik <josef@redhat.com>
> > > Date:   Fri Jan 13 15:27:45 2012 -0500
> > > 
> > >     Btrfs: remove the ideal caching code> 
> > 
> > Ok can you give this a whirl?  You are going to have to boot/reboot a few times
> > to let the cache get re-generated again to make sure it's taken effect, but
> > hopefully this will help out.  Thanks,
> 
> Unfortunately, it doesn't seem to help. Even after 3 or 4 reboots with
> this patch applied I'm still seeing the same delay.
> 

Alright my laptop is on btrfs, I'll build my tree and see if I can see the same
thing and then narrow down whats going on.  If not you will be seeing many more
patches from me ;).  Thanks,

Josef
