From: Josef Bacik <josef@redhat.com>
Subject: Re: disk space caching generation missmatch
Date: Fri, 3 Dec 2010 13:14:49 -0500
Message-ID: <20101203181449.GB3173@localhost.localdomain>
References: <201012011746.14458.johannes.hirte@fem.tu-ilmenau.de> <201012012240.29525.johannes.hirte@fem.tu-ilmenau.de> <20101202203410.GC8805@dhcp231-156.rdu.redhat.com> <201012030107.54983.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012030107.54983.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 03, 2010 at 01:07:53AM +0100, Johannes Hirte wrote:
> On Thursday 02 December 2010 21:34:10 Josef Bacik wrote:
> > On Wed, Dec 01, 2010 at 10:40:29PM +0100, Johannes Hirte wrote:
> > > On Wednesday 01 December 2010 22:22:45 Johannes Hirte wrote:
> > > > On Wednesday 01 December 2010 21:03:13 Josef Bacik wrote:
> > > > > On Wed, Dec 01, 2010 at 08:56:14PM +0100, Johannes Hirte wrote:
> > > > > > On Wednesday 01 December 2010 18:40:18 Josef Bacik wrote:
> > > > > > > On Wed, Dec 01, 2010 at 05:46:14PM +0100, Johannes Hirte wrote:
> > > > > > > > After enabling disk space caching I've observed several log entries like this:
> > > > > > > > 
> > > > > > > > btrfs: free space inode generation (0) did not match free space cache generation (169594) for block group 15464398848
> > > > > > > > 
> > > > > > > > I'm not sure, but it seems this happens on every reboot. Is this something to
> > > > > > > > worry about?
> > > > > > > > 
> > > > > > > 
> > > > > > > So that usually means 1 of a couple of things
> > > > > > > 
> > > > > > > 1) You didn't have space for us to save the free space cache
> > > > > > > 2) When trying to write out the cache we hit one of those cases where we would
> > > > > > > deadlock so we couldn't write the cache out
> > > > > > > 
> > > > > > > It's nothing to worry about, it's doing what it is supposed to.  However I'd
> > > > > > > like to know why we're not able to write out the cache.  Are you running close
> > > > > > > to full?  Thanks,
> > > > > > > 
> > > > > > > Josef
> > > > > > >
> > > > > > 
> > > > > > I think there should be enough free space:
> > > > > > 
> > > > > 
> > 
> > Ok it doesn't look like theres an actual problem, we're just being sub-optimal.
> > Take out the other patch and apply this one, boot into that kernel and then
> > reboot and then give me the dmesg. 
> 
> Here it comes:
> 

Perfect, thats much better.  Thanks for bringing this up.

Josef
