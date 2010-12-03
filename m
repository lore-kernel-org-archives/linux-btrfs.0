From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: What to do about subvolumes?
Date: Thu, 02 Dec 2010 21:43:08 -0500
Message-ID: <4CF8593C.3080100@cfl.rr.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <4CF76BB3.3020705@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF76BB3.3020705@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/02/2010 04:49 AM, Arne Jansen wrote:
> What about the alternative and allocating inode numbers globally? The only
> problem would be with snapshots as they share the inum with the source, but
> one could just remap inode numbers in snapshots by sparing some bits at the
> top of this 64 bit field.

I was wondering this as well.  Why give each subvol its own inode number 
space?  To avoid breaking assumptions of various programs, if they each 
have their own inode space, they must each have a unique st_dev.  How 
are inode numbers currently allocated, and why wouldn't it be simple to 
just have a single pool of inode numbers for all subvols?  It seems 
obvious to me that snapshots start out inheriting the inode numbers of 
the original subvol, but must be given a new st_dev.
