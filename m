From: Andy Lutomirski <luto@mit.edu>
Subject: Re: snapshot/subvol deletion
Date: Wed, 26 Aug 2009 23:47:25 -0400
Message-ID: <4A9601CD.8040005@mit.edu>
References: <4A93F749.3010708@oracle.com> <20090825150351.GB16561@think> <20090825155317.GA6155@localhost.localdomain> <20090825160414.GC16561@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090825160414.GC16561@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> 
> ;) The problem is the directory entry for the snapshot, but its a little
> more complex. Lets say subvolA has a directory entry for snapshotZ, and
> then someone wanders in and snapshots subvolA, creating snapshotA'.
> 
> This means that both subvolA and snashotA' have a directory entry for
> snapshotZ.  If we delete snapshotZ we have to deal with both directory
> entries.

I would've expected that, if we delete snapshotZ by IOCTL / rmdir / 
whatever from within snapshotA', then it still exists until it's also 
deleted from (the original) subvolA.  But maybe I just don't get it.

Is there some end-user-oriented documentation on what the semantics of 
snapshots and subvolumes are supposed to be?  I couldn't find it with a 
bit of Googling and wiki reading.

--Andy
