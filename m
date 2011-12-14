From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: don't panic if orphan item already exists
Date: Wed, 14 Dec 2011 11:45:24 -0500
Message-ID: <20111214164524.GE31158@shiny>
References: <1323798951-4329-1-git-send-email-josef@redhat.com>
 <4EE7A172.2010105@cfl.rr.com>
 <20111213190942.GA3602@localhost.localdomain>
 <4EE804EB.5070209@cn.fujitsu.com>
 <4EE8707D.7080504@cn.fujitsu.com>
 <20111214145843.GA1925@localhost.localdomain>
 <4EE8BD45.7090809@cfl.rr.com>
 <20111214153438.GA10175@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@cfl.rr.com>, Miao Xie <miaox@cn.fujitsu.com>,
	WuBo <wu.bo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111214153438.GA10175@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 14, 2011 at 10:34:45AM -0500, Josef Bacik wrote:
> On Wed, Dec 14, 2011 at 10:14:13AM -0500, Phillip Susi wrote:
> > On 12/14/2011 9:58 AM, Josef Bacik wrote:
> > >There is no "underlying bug", there is a shitty situation, the shitty situation
> > 
> > Maybe my assumptions are wrong somewhere then.  You add the orphan
> > item to make sure that the truncate will be finalized even if the
> > system crashes before the transaction commits right?  So if
> > truncate() fails with -ENOSPC, then you shouldn't be trying to
> > finalize the truncate on the next mount, should you ( because the
> > call did not succeed )?
> > 
> 
> Yes because otherwise we'll leak space since the i_size has been updated
> already.  The other option is to make btrfs_truncate_inode_items update i_size
> as we truncate so if it fails we can delete the orphan item and then update the
> inode with the new i_size, that way we don't leave the orphan item on disk and
> we don't leak space.  I'll see how doable this is.  Thanks,

If we fail with enospc though we're very likely to not be able to update
the inode item.  It may work, but the failure case will still be there
where we can't make i_size match the file contents.

-chris
