From: Sage Weil <sage@newdream.net>
Subject: Re: [Btrfs-devel] cloning file data
Date: Fri, 2 May 2008 14:38:31 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0805021433310.23143@cobra.newdream.net>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
 <200805021650.25497.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200805021650.25497.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2 May 2008, Chris Mason wrote:
> Sage's work has been pushed into the stable and unstable trees, along with a 

Thanks!

For the transaction ioctls...  would it make more sense to specify a 
string of ops to apply atomically in a vector instead of exposing the raw 
transaction start/end to userspace?  Would that avoid the deadlock and 
memory issues?

sage
