Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36580 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab2IXQru (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 12:47:50 -0400
Date: Mon, 24 Sep 2012 18:47:42 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ilya Dryomov <idryomov@gmail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] Btrfs: cleanup duplicated division functions
Message-ID: <20120924164742.GN14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5051BAB8.7080200@cn.fujitsu.com>
 <505A8632.10101@cn.fujitsu.com>
 <505C2E62.2000400@cn.fujitsu.com>
 <20120923114924.GA1975@zambezi.lan>
 <505FBFCE.3010503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505FBFCE.3010503@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 10:05:02AM +0800, Miao Xie wrote:
> Generally, we should check the value when it is input. If not, we might
> run our program with the wrong value, and it is possible to cause unknown
> problems. So I think the above chunk is necessary.

The difference is that giving an invalid value will exit early (your
version), while Ilya's version will clamp the 'usage' to the allowed
range during processing. From usability POV, I'd prefer to let the
command fail early with a verbose error eg. that the range is invalid.

> > (diff is on top of the patch in question)
> > 
> > This is the most straightforward transformation I can think of.  It
> > doesn't result in an unnecessary BUG_ON, keeps churn to a minimum and
> 
> agree with you.
> 
> > doesn't change the "style" of the balance ioctl.  (If I were to check
> > every filter argument that way, btrfs_balance_ioctl() would be very long
> > and complicated.)
> 
> I think the check in btrfs_balance_ioctl() is necessary, the reason is above.

btrfs_balance_ioctl does not seem as the right place, it does the
processing related to the state of balance (resume/cancel etc). Look at
btrfs_balance() itself, it does lot more sanity checks of the
parameters. We can put the extra checks into helpers (and not only this
one) if clarity and readability of the function becomes a concern.


david
