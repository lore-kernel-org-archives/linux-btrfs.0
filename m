From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Mon, 09 Apr 2012 17:20:46 -0400
Message-ID: <1334006446.2678.0.camel@ayu>
References: <1333986823.2928.6.camel@ayu> <1333991404.2817.6.camel@ayu>
	 <20120409205429.GB6958@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120409205429.GB6958@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2012-04-09 at 16:54 -0400, Josef Bacik wrote:
> On Mon, Apr 09, 2012 at 01:10:04PM -0400, Calvin Walton wrote:
> > On Mon, 2012-04-09 at 11:53 -0400, Calvin Walton wrote:
> > > Hi,
> > > 
> > > I have a system that's using a dracut-generated initramfs to mount a
> > > btrfs root. After upgrading to kernel 3.4.0-rc2 to test it out, I've
> > > noticed that the process of mounting the root filesystem takes much
> > > longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 seconds slower!

> > And the bisect results are in:
> > 285ff5af6ce358e73f53b55c9efadd4335f4c2ff is the first bad commit
> > commit 285ff5af6ce358e73f53b55c9efadd4335f4c2ff
> > Author: Josef Bacik <josef@redhat.com>
> > Date:   Fri Jan 13 15:27:45 2012 -0500
> > 
> >     Btrfs: remove the ideal caching code> 
> 
> Ok can you give this a whirl?  You are going to have to boot/reboot a few times
> to let the cache get re-generated again to make sure it's taken effect, but
> hopefully this will help out.  Thanks,

Unfortunately, it doesn't seem to help. Even after 3 or 4 reboots with
this patch applied I'm still seeing the same delay.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

