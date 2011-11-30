From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Blocked for more than 120 seconds
Date: Wed, 30 Nov 2011 09:10:06 -0500
Message-ID: <20111130141006.GY24338@shiny>
References: <4ED34359.6010305@robotech.de>
 <1322472549.1962.2.camel@Nokia-N900>
 <4ED5FAEF.8070400@robotech.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tobias <tracer@robotech.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED5FAEF.8070400@robotech.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 30, 2011 at 10:44:15AM +0100, Tobias wrote:
> Am 28.11.2011 10:29, schrieb Chris Samuel:
> >Hi Tobias,
> >
> >On Mon, 28 Nov 2011, 19:16:25 EST, Tobias<tracer@robotech.de>  wrote:
> >
> >>The problem occurs on the stock ubuntu kernel 2.6.38-8, 3.0.0-12,
> >>3.0.0-13 and on my self-compiled 3.1.2.
> >There's a lot of work gone into btrfs in 3.2,
> >it would be interesting to know (speaking as
> >just another user) whether it still occurs
> >with 3.2-rc3.
> >
> I tried 3.2-rc3 tonight but the messages are still there:

We see a bunch of procs stuck waiting to start a transaction, but we
don't see why they are waiting.  Could you please capture a sysrq-t
during this?  That will show us all the waiters everywhere.  We're
really looking for the one proc stuck in btrfs_commit_transaction, he's
the key to the stalls.

-chris
