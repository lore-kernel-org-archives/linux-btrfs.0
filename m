From: Chris Mason <chris.mason@oracle.com>
Subject: Re: UI issues around RAID1
Date: Thu, 19 Nov 2009 09:56:27 -0500
Message-ID: <20091119145627.GK3110@think>
References: <adapr7ib96f.fsf@roland-alpha.cisco.com>
 <20091116202043.GA9779@localhost.localdomain>
 <4B01C8AF.5040308@hp.com>
 <adamy2jaf43.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jim owens <jowens@hp.com>, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <adamy2jaf43.fsf@roland-alpha.cisco.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 18, 2009 at 09:59:24AM -0800, Roland Dreier wrote:
> 
>  > > Yeah df is just a fun ball of wax in many respects.  We don't take into account
>  > > RAID and we don't subtrace space thats strictly for metadata, so there are
>  > > several things that need to be fixed for df.  Thanks,
> 
>  > But as we have said many times... if we have different
>  > raid types active on different files, any attempt to make
>  > df report "raid adjusted numbers" instead of the current raw
>  > total storage numbers is going to sometimes give wrong answers.
>  > 
>  > So I think it is dangerous to try.  The current output
>  > may be ugly, but it is always consistent and explainable.
> 
> It does seem like a big problem, especially as we add in other RAID
> levels etc.  However on the flip side, the accounting of the "used"
> space does seem off and maybe fixable?
> 
> In other words if I create a btrfs filesystem out of two 1GB devices
> with RAID1 for data and metadata, then df shows a total size of 2GB for
> the filesystem.  But if I then create a .5 GB file on that filesystem,
> the used space is shown as .5 GB only -- ie the accounting of total size
> is at the device/block level, but the accounting of used space is at the
> logical/filesystem level.  Which leads to very confusing df output.
> 
> I wonder if it's possible to come up with a way to make things
> consistent at least, or figure out a way to define more useful
> information about space left on the filesystem.

That part we can at least do.  Since we know the amount of space used in
each block group and the raid level of each block group, we can figure
it out.  It won't be cheap overall but it is at least possible.

-chris

