From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: don't panic if orphan item already exists
Date: Wed, 14 Dec 2011 10:46:25 -0500
Message-ID: <20111214154624.GA10536@localhost.localdomain>
References: <1323798951-4329-1-git-send-email-josef@redhat.com>
 <4EE7A172.2010105@cfl.rr.com>
 <20111213190942.GA3602@localhost.localdomain>
 <4EE804EB.5070209@cn.fujitsu.com>
 <4EE8707D.7080504@cn.fujitsu.com>
 <20111214145843.GA1925@localhost.localdomain>
 <4EE8BD45.7090809@cfl.rr.com>
 <20111214152638.GB1925@localhost.localdomain>
 <4EE8C391.9090501@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, Miao Xie <miaox@cn.fujitsu.com>,
	WuBo <wu.bo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE8C391.9090501@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 14, 2011 at 10:41:05AM -0500, Phillip Susi wrote:
> On 12/14/2011 10:27 AM, Josef Bacik wrote:
> >Except consider the case that the program was written intelligently and checks
> >for errors on truncate.  So he writes 100G, truncates to 50M, and the truncate
> >fails and he closes the file and exits.  Then somewhere down the road the inode
> >is evicted from cache and we reboot the box.  Next time the box comes up it only
> >looks like a 50M file, except we're still taking up 100G of disk space, and we
> >have no idea there's space there and it's still taken up in the allocator so it
> >will just look like we've lost ~100G of space.  This is why it's left there, so
> >everything can be cleaned up.
> 
> I'm a little confused here.  Is there a commit somewhere in there?
> How can the 100g allocation be committed, but not the i_size of the
> inode? Shouldn't either both or neither be committed?  If both are
> committed, and then the truncate fails, then I would expect the
> system to come back up after a crash with the file still at 100g.
> That is, as long as the orphan item is not left in place after the
> failed truncate.
> 

100g allocation succeeds

unmount

mount
truncate to 50m
i_size is set to 50m
truncate fails
orphan item left

unmount

mount

file looks like its only 50m but still has 100g of extents taking up space
orphan cleanup happens and the inode is truncated and the extra space is cleaned
up

Josef
