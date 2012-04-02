From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs io errors on 3.4rc1
Date: Mon, 2 Apr 2012 18:28:02 -0400
Message-ID: <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
References: <20120402180214.GA1830@redhat.com>
 <20120402194814.GA10965@shiny.msi.event>
 <20120402211622.GA2487@redhat.com>
 <20120402212608.GA14958@shiny.msi.event>
 <20120402214051.GB2487@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120402214051.GB2487@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2012 at 05:40:51PM -0400, Dave Jones wrote:
> On Mon, Apr 02, 2012 at 05:26:08PM -0400, Chris Mason wrote:
>  > On Mon, Apr 02, 2012 at 05:16:22PM -0400, Dave Jones wrote:
>  > > On Mon, Apr 02, 2012 at 03:48:14PM -0400, Chris Mason wrote:
>  > >  > On Mon, Apr 02, 2012 at 02:02:14PM -0400, Dave Jones wrote:
>  > >  > > Updated to rc1 this morning, and my machines with btrfs are all freaking out..
>  > >  > > 
>  > >  > > I got this from my cron email ..
>  > >  > > 
>  > >  > > /etc/cron.daily/prelink: line 41: /var/lib/prelink/full: Input/output error
>  > >  > > cp: cannot create regular file `/var/lib/prelink/quick': Input/output error
>  > >  > > /etc/cron.daily/prelink: line 45: /var/log/prelink/prelink.log: Input/output error
>  > >  > 
>  > >  > That's not good.  Can you please try my for-linus branch against 3.3?
>  > >  > That will rules out all the shiny new btrfs code.
>  > >  > 
>  > >  > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>  > >  > 
>  > >  > -chris
>  > > 
>  > > Broken.
>  > > 
>  > > (17:14:52:davej@dhcp-189-232:~)$ fsx foo
>  > > truncating to largest ever: 0x13e76
>  > > truncating to largest ever: 0x2e52c
>  > > ftruncate1: 2e52c
>  > > dotruncate: ftruncate: Input/output error
>  > > Segmentation fault (core dumped)
>  > 
>  > Huh.  x86-32 or x86-64?  I know you said there were no interesting
>  > messages, but could you please send the messages you did get?
> 
> x86-64.
> 
> dmesg below.  (ignore the rpc oops, reported elsewhere, it's unrelated)

Well, there really are no btrfs messages in there at all.  Do you have
free space for a clean copy of the btrfs partition?  Trying to figure
out if you have a stale corruption (on two boxes seems really unlikely).
I definitely can't reproduce it here.

-chris
