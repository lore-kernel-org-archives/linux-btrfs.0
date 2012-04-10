From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Tue, 10 Apr 2012 12:04:00 -0400
Message-ID: <1334073840.2758.5.camel@ayu>
References: <1333986823.2928.6.camel@ayu> <1333991404.2817.6.camel@ayu>
	 <20120409205429.GB6958@localhost.localdomain> <1334006446.2678.0.camel@ayu>
	 <20120410151645.GC2296@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120410151645.GC2296@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2012-04-10 at 11:16 -0400, Josef Bacik wrote:
> On Mon, Apr 09, 2012 at 05:20:46PM -0400, Calvin Walton wrote:
> > On Mon, 2012-04-09 at 16:54 -0400, Josef Bacik wrote:
> > > On Mon, Apr 09, 2012 at 01:10:04PM -0400, Calvin Walton wrote:
> > > > On Mon, 2012-04-09 at 11:53 -0400, Calvin Walton wrote:
> > > > > Hi,
> > > > > 
> > > > > I have a system that's using a dracut-generated initramfs to mount a
> > > > > btrfs root. After upgrading to kernel 3.4.0-rc2 to test it out, I've
> > > > > noticed that the process of mounting the root filesystem takes much
> > > > > longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 seconds slower!
> 
> Ok drop that previous patch and give this one a whirl, it helped on my laptop.
> This is only  half of the problem AFAICS, but it's the easier half to fix, in
> the meantime I need to lock down why we're not writing out cache for a bunch of
> block groups, but thats trickier since the messages I need are spit out while
> I'm shutting down, so I need to get creative.  Let me know if/how much this
> helps.  Thanks,

This one brings the mount time right down on my laptop, it's back to
around 0.5 seconds, same as 3.3.x.

Tested-by: Calvin Walton <calvin.walton@kepstin.ca>

I'll keep following this email thread; let me know if you have any other
patches that you want me to try out.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

