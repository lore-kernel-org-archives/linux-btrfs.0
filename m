From: Chris Mason <chris.mason@oracle.com>
Subject: Re: ls & flush-btrfs-1 sit at 100% sys
Date: Fri, 19 Nov 2010 09:32:46 -0500
Message-ID: <1290177036-sup-2385@think>
References: <AANLkTim-esHsiRYTYxAA2WtpOj=XHvZDc6y2+5b0TB0x@mail.gmail.com> <m3r5ejyzz4.fsf@pullcord.laptop.org> <AANLkTinKm-6H60V2EivQuKF079yS0W-nS=r5dgw_ZcGm@mail.gmail.com> <AANLkTimRtgFy2LwJqsSszOFYSxk9T+qfJ9=snFFGzysf@mail.gmail.com> <AANLkTinfcAZrO+UzioG=DtN7KA=aWBB2-BtfZgggqpEm@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
	Chris Ball <cjb@laptop.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Brian Sullivan <bexamous@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTinfcAZrO+UzioG=DtN7KA=aWBB2-BtfZgggqpEm@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Brian Sullivan's message of 2010-11-18 13:30:51 -0500:
> Yep actually, with noatime,nodiratime ls is fine.  I didn't try ro but
> I assume that'll work too.  So with noatime,nodiratime I can go around
> in tree and ls works.  If I try to touch a new file, touch doesn't
> return.  If I then ls in that same folder ls doesn't return either.
> So yeah seems like soon as something has to write.
> 
> Also after I run touch, it doesn't return, I look at top, nothing is
> spinning, everything is at 0% usage.  After a minute or so then touch
> and flush-btrfs-1 jump to 50%sys each and sit there.

So, based on this trace we're banging on the delalloc flushing to free
up room.

I just wanted to confirm, you're seeing this with 2.6.37-rc?  I thought
I had fixed up this delalloc hammering.

-chris
