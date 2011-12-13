From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: don't panic if orphan item already exists
Date: Tue, 13 Dec 2011 14:09:42 -0500
Message-ID: <20111213190942.GA3602@localhost.localdomain>
References: <1323798951-4329-1-git-send-email-josef@redhat.com>
 <4EE7A172.2010105@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE7A172.2010105@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 13, 2011 at 02:03:14PM -0500, Phillip Susi wrote:
> On 12/13/2011 12:55 PM, Josef Bacik wrote:
> >I've been hitting this BUG_ON() in btrfs_orphan_add when running xfstest 269 in
> >a loop.  This is because we will add an orphan item, do the truncate, the
> >truncate will fail for whatever reason (*cough*ENOSPC*cough*) and then we're
> >left with an orphan item still in the fs.  Then we come back later to do another
> >truncate and it blows up because we already have an orphan item.  This is ok so
> >just fix the BUG_ON() to only BUG() if ret is not EEXIST.  Thanks,
> 
> Wouldn't it be better to fix the underlying bug, and remove the
> orphan item when the truncate fails?
> 

No because we still need the thing to be cleaned up.  If the truncate fails we
need to leave the orphan item there so the next time the fs is mounted the inode
is cleaned up, that's not a bug.  Thanks,

Josef
