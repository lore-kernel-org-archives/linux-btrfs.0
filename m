From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs caused kernel oops warning
Date: Wed, 22 Sep 2010 08:13:11 -0400
Message-ID: <20100922121311.GD2309@think>
References: <1284691538.30133.9.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	"Chen, Tim C" <tim.c.chen@intel.com>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1284691538.30133.9.camel@sli10-conroe.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 17, 2010 at 10:45:38AM +0800, Shaohua Li wrote:
> Chris,
> we are seeing kernel warning from time to time when doing btrfs test.
> That issue is hard to trigger, but it sometimes pop up. we saw this in
> both fio and ffsb test in several kernel version. Below is an example.
> do you have idea about it? we are glad to test patches/do debug if you
> can share some ideas.

Interesting.  We're backing up behind the ordered operations mutex, but
I don't see the stack trace from the process currently holding it.
Could you please do a sysrq-w and record the results?  We need to see
who we are stuck on.

My guess is we're stuck waiting for IO, but the traces will say for
sure.

-chris
