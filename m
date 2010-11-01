From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 2/3] btrfs: implement 'async-snapshot' command
Date: Mon, 1 Nov 2010 09:29:22 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1011010921130.29194@cobra.newdream.net>
References: <1288461366-26914-1-git-send-email-sage@newdream.net>
 <1288461366-26914-2-git-send-email-sage@newdream.net> <201010302035.05962.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010302035.05962.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 30 Oct 2010, Goffredo Baroncelli wrote:
> On Saturday, 30 October, 2010, Sage Weil wrote:
> > This is identical to 'snapshot', but uses the new async snapshot creation
> > ioctl, and prints out the transid the new snapshot will be committed
> > with.
> 
> Only for curiosity, how long may take snapshot a tree ? It should be only a 
> copy and update of few pages on the disk (the head of the trees), so the time 
> should be O(1)...

In theory, yes, but there is still a fair bit of disk io that goes on 
while preparing the commit in the current code.  Also, I found that even 
when the transaction does unblock, most operations end up waiting for the 
btree inode pages anyway, so there is definitely room for improvement.  
Still, this avoids waiting for the new superblocks to commit, and gets the 
interface in place to take advantage of future improvements in this area.

sage
