From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs io errors on 3.4rc1
Date: Mon, 2 Apr 2012 18:39:19 -0400
Message-ID: <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
References: <20120402180214.GA1830@redhat.com>
 <20120402194814.GA10965@shiny.msi.event>
 <20120402211622.GA2487@redhat.com>
 <20120402212608.GA14958@shiny.msi.event>
 <20120402214051.GB2487@redhat.com>
 <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
 <20120402223350.GA16907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120402223350.GA16907@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2012 at 06:33:50PM -0400, Dave Jones wrote:
> On Mon, Apr 02, 2012 at 06:28:02PM -0400, Chris Mason wrote:
>  
>  > > x86-64.
>  > > 
>  > > dmesg below.  (ignore the rpc oops, reported elsewhere, it's unrelated)
>  > 
>  > Well, there really are no btrfs messages in there at all.  Do you have
>  > free space for a clean copy of the btrfs partition?  Trying to figure
>  > out if you have a stale corruption (on two boxes seems really unlikely).
>  > I definitely can't reproduce it here.
> 
> Don't really have any free space for it (It's the / partition on both)
> 
> Is there a wip btrfs.fsck yet ? One of the machines is just a scratch testbox,
> so I'm happy to run it even if it'll potentially make things worse.

The current btrfsck repair mode will fix problems in the extent
allocation tree, but that probably isn't what you're seeing.  I'd just
run it read only and see if it finds any problems.

(You'll need the FS completely unmounted though).

-chris
