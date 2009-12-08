From: Josef Bacik <josef@redhat.com>
Subject: Re: committing new snapshots
Date: Tue, 8 Dec 2009 11:05:07 -0500
Message-ID: <20091208160507.GA3374@localhost.localdomain>
References: <Pine.LNX.4.64.0912071411560.31714@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0912071411560.31714@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 07, 2009 at 02:25:50PM -0800, Sage Weil wrote:
> When you create a new snap or subvol, first a new ROOT_ITEM is created 
> while everything commits, and then the referring directory entry is set up 
> (with a correspond ROOT_BACKREF).  
> 
> First, if you say 'btrfsctl -s foo .' and then 'reboot -f -n' before the 
> next regularly scheduled commit, the snap is created, but lost.. there's 
> no reference.  Second, the unreferenced ROOT_ITEM is never cleaned up.
> 
> Are there any existing plans for this?  It would be nice if the reference 
> could be committed as well the first time around.  That probably requires 
> a bit of futzing to determine what the root objectid is going to be 
> beforehand, then adding the link in the namespace, then flushing things 
> out and updating the root item in the right order?
> 

We could probably use the orphan code for this.  Just create an orphan item for
the snapshot and then delete it when the snapshot is fully created that way if
somebody does reboot -fn we cleanup the root item and such.  Thanks,

Josef
