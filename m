From: Josef Bacik <josef@redhat.com>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Mon, 9 Apr 2012 13:14:18 -0400
Message-ID: <20120409171418.GA6958@localhost.localdomain>
References: <1333986823.2928.6.camel@ayu>
 <1333991404.2817.6.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333991404.2817.6.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2012 at 01:10:04PM -0400, Calvin Walton wrote:
> On Mon, 2012-04-09 at 11:53 -0400, Calvin Walton wrote:
> > Hi,
> > 
> > I have a system that's using a dracut-generated initramfs to mount a
> > btrfs root. After upgrading to kernel 3.4.0-rc2 to test it out, I've
> > noticed that the process of mounting the root filesystem takes much
> > longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 seconds slower!
> > 
> > Does anyone have any ideas? I'm going to try bisecting the issue to see
> > if I can narrow down the cause. I've included excerpts from dmesg of the
> > bad and good kernels here, and attached the complete dmesg from the bad
> > kernel, in case it has anything interesting that I've trimmed out here.
> 
> And the bisect results are in:
> 285ff5af6ce358e73f53b55c9efadd4335f4c2ff is the first bad commit
> commit 285ff5af6ce358e73f53b55c9efadd4335f4c2ff
> Author: Josef Bacik <josef@redhat.com>
> Date:   Fri Jan 13 15:27:45 2012 -0500
> 
>     Btrfs: remove the ideal caching code
>    
>     This is a relic from before we had the disk space cache and it was to make
>     bootup times when you had btrfs as root not be so damned slow.  Now that we have
>     the disk space cache this isn't a problem anymore and really having this code
>     casues uneeded fragmentation and complexity, so just remove it.  Thanks,
>     
>     Signed-off-by: Josef Bacik <josef@redhat.com>
> 
> The commit doesn't revert cleanly on top of 3.4.0-rc2, so I haven't
> tested that; but it looks like that caching code is in fact still useful
> to make "btrfs as root not be so damned slow."

Hrm well you should have disk space cache which is 10x faster, if it's falling
back to the old slow way we should probably figure out why that is happening.
Let me run some tests and see how often I'm getting no disk cache written out.
Thanks,

Josef
