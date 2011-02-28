From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Mon, 28 Feb 2011 11:10:57 -0500
Message-ID: <20110228161056.GA2769@localhost.localdomain>
References: <1298857223-sup-5612@think> <201102281114.00018.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	Maria =?iso-8859-1?Q?Wikstr=F6m?= <maria@ponstudios.se>,
	"Zhong, Xin" <xin.zhong@intel.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201102281114.00018.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 28, 2011 at 11:13:59AM +0100, Johannes Hirte wrote:
> On Monday 28 February 2011 02:46:05 Chris Mason wrote:
> > Excerpts from Mitch Harder's message of 2011-02-25 13:43:37 -0500:
> > > Some clarification on my previous message...
> > > 
> > > After looking at my ftrace log more closely, I can see where Btrfs is
> > > trying to release the allocated pages.  However, the calculation for
> > > the number of dirty_pages is equal to 1 when "copied == 0".
> > > 
> > > So I'm seeing at least two problems:
> > > (1)  It keeps looping when "copied == 0".
> > > (2)  One dirty page is not being released on every loop even though
> > > "copied == 0" (at least this problem keeps it from being an infinite
> > > loop by eventually exhausting reserveable space on the disk).
> > 
> > Hi everyone,
> > 
> > There are actually tow bugs here.  First the one that Mitch hit, and a
> > second one that still results in bad file_write results with my
> > debugging hunks (the first two hunks below) in place.
> > 
> > My patch fixes Mitch's bug by checking for copied == 0 after
> > btrfs_copy_from_user and going the correct delalloc accounting.  This
> > one looks solved, but you'll notice the patch is bigger.
> > 
> > First, I add some random failures to btrfs_copy_from_user() by failing
> > everyone once and a while.  This was much more reliable than trying to
> > use memory pressure than making copy_from_user fail.
> > 
> > If copy_from_user fails and we partially update a page, we end up with a
> > page that may go away due to memory pressure.  But, btrfs_file_write
> > assumes that only the first and last page may have good data that needs
> > to be read off the disk.
> > 
> > This patch ditches that code and puts it into prepare_pages instead.
> > But I'm still having some errors during long stress.sh runs.  Ideas are
> > more than welcome, hopefully some other timezones will kick in ideas
> > while I sleep.
> 
> At least it doesn't fix the emerge-problem for me. The behavior is now the same 
> as with 2.6.38-rc3. It needs a 'emerge --oneshot dev-libs/libgcrypt' with no 
> further interaction to get the emerge-process hang with a svn-process 
> consuming 100% CPU. I can cancel the emerge-process with ctrl-c but the 
> spawned svn-process stays and it needs a reboot to get rid of it. 

Can you cat /proc/$pid/wchan a few times so we can get an idea of where it's
looping?  Thanks,

Josef
