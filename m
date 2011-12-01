From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Blocked for more than 120 seconds
Date: Thu, 1 Dec 2011 13:41:58 -0500
Message-ID: <20111201184158.GB10535@shiny>
References: <4ED34359.6010305@robotech.de>
 <1322472549.1962.2.camel@Nokia-N900>
 <4ED5FAEF.8070400@robotech.de>
 <20111130141006.GY24338@shiny>
 <4ED738E5.3080200@robotech.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tobias <tracer@robotech.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED738E5.3080200@robotech.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 01, 2011 at 09:20:53AM +0100, Tobias wrote:
> Hi Chris
> 
> Am 30.11.2011 15:10, schrieb Chris Mason:
> >We see a bunch of procs stuck waiting to start a transaction, but we
> >don't see why they are waiting.  Could you please capture a sysrq-t
> >during this?  That will show us all the waiters everywhere.  We're
> >really looking for the one proc stuck in btrfs_commit_transaction, he's
> >the key to the stalls.
> >
> 
> This is my first time working with sysrq... i hope i did it right...
> Here is the logoutput (quite much)

So, the transaction close is in btrfs_evict_inode, which sounds like a
deadlock recently fixed by this commit:

http://git.kernel.org/?p=linux/kernel/git/mason/linux-btrfs.git;a=commit;h=aa38a711a893accf5b5192f3d705a120deaa81e0

If you pull the for-linus branch from today, hopefully the problem will
be gone.

-chris
