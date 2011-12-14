From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: don't panic if orphan item already exists
Date: Wed, 14 Dec 2011 10:27:07 -0500
Message-ID: <20111214152638.GB1925@localhost.localdomain>
References: <1323798951-4329-1-git-send-email-josef@redhat.com>
 <4EE7A172.2010105@cfl.rr.com>
 <20111213190942.GA3602@localhost.localdomain>
 <4EE804EB.5070209@cn.fujitsu.com>
 <4EE8707D.7080504@cn.fujitsu.com>
 <20111214145843.GA1925@localhost.localdomain>
 <4EE8BD45.7090809@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, Miao Xie <miaox@cn.fujitsu.com>,
	WuBo <wu.bo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE8BD45.7090809@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 14, 2011 at 10:14:13AM -0500, Phillip Susi wrote:
> On 12/14/2011 9:58 AM, Josef Bacik wrote:
> >There is no "underlying bug", there is a shitty situation, the shitty situation
> 
> Maybe my assumptions are wrong somewhere then.  You add the orphan
> item to make sure that the truncate will be finalized even if the
> system crashes before the transaction commits right?  So if
> truncate() fails with -ENOSPC, then you shouldn't be trying to
> finalize the truncate on the next mount, should you ( because the
> call did not succeed )?
> 

Except consider the case that the program was written intelligently and checks
for errors on truncate.  So he writes 100G, truncates to 50M, and the truncate
fails and he closes the file and exits.  Then somewhere down the road the inode
is evicted from cache and we reboot the box.  Next time the box comes up it only
looks like a 50M file, except we're still taking up 100G of disk space, and we
have no idea there's space there and it's still taken up in the allocator so it
will just look like we've lost ~100G of space.  This is why it's left there, so
everything can be cleaned up.

Course now that I've had the chance to think and calm down a little bit there
may be another option.  We could probably keep track of how much we've deleted
in btrfs_truncate_inode_items, and then if we fail to complete the truncate we
just set the i_size to whatever it is when we stopped truncating, update the
inode and remove the orphan item.  I'll look into this and see how tricky it is
to do.  Thanks,

Josef
