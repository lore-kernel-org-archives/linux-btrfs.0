From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] big fat transaction ioctl
Date: Wed, 11 Nov 2009 09:54:35 -0500
Message-ID: <20091111145435.GB5566@think>
References: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, hch@lst.de
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0911101143120.31818@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 10, 2009 at 12:12:14PM -0800, Sage Weil wrote:
> Hi all,
> 
> This is an alternative approach to atomic user transactions for btrfs.  
> The old start/end ioctls suffer from some basic limitations, namely
> 
>  - We can't properly reserve space ahead of time to avoid ENOSPC part 
> way through the transaction, and
>  - The process may die (seg fault, SIGKILL) part way through the 
> transaction.  Currently when that happens the partial transaction will 
> commit.

I like this much more than providing a journal start/stop to userland.
If we can get Christoph to ack the exports we can work on the interface
in general.

-chris
