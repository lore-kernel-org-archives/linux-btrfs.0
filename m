From: Josef Bacik <josef@redhat.com>
Subject: Re: ls & flush-btrfs-1 sit at 100% sys
Date: Fri, 19 Nov 2010 09:46:25 -0500
Message-ID: <20101119144625.GB2579@localhost.localdomain>
References: <AANLkTim-esHsiRYTYxAA2WtpOj=XHvZDc6y2+5b0TB0x@mail.gmail.com> <m3r5ejyzz4.fsf@pullcord.laptop.org> <AANLkTinKm-6H60V2EivQuKF079yS0W-nS=r5dgw_ZcGm@mail.gmail.com> <AANLkTimRtgFy2LwJqsSszOFYSxk9T+qfJ9=snFFGzysf@mail.gmail.com> <AANLkTinfcAZrO+UzioG=DtN7KA=aWBB2-BtfZgggqpEm@mail.gmail.com> <1290177036-sup-2385@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Brian Sullivan <bexamous@gmail.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Chris Ball <cjb@laptop.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290177036-sup-2385@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 19, 2010 at 09:32:46AM -0500, Chris Mason wrote:
> Excerpts from Brian Sullivan's message of 2010-11-18 13:30:51 -0500:
> > Yep actually, with noatime,nodiratime ls is fine.  I didn't try ro but
> > I assume that'll work too.  So with noatime,nodiratime I can go around
> > in tree and ls works.  If I try to touch a new file, touch doesn't
> > return.  If I then ls in that same folder ls doesn't return either.
> > So yeah seems like soon as something has to write.
> > 
> > Also after I run touch, it doesn't return, I look at top, nothing is
> > spinning, everything is at 0% usage.  After a minute or so then touch
> > and flush-btrfs-1 jump to 50%sys each and sit there.
> 
> So, based on this trace we're banging on the delalloc flushing to free
> up room.
> 
> I just wanted to confirm, you're seeing this with 2.6.37-rc?  I thought
> I had fixed up this delalloc hammering.
> 

Also can you run with this patch

http://www.spinics.net/lists/linux-btrfs/msg06890.html

its a crap bug which will make us look like we're out of space when we arent and
we'll flush alot more.  Thanks,

Josef
