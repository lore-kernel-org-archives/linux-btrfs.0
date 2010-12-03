From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: What to do about subvolumes?
Date: Fri, 3 Dec 2010 15:56:31 -0500
Message-ID: <20101203205631.GB25980@fieldses.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <4CF76BB3.3020705@gmx.net>
 <1291306150-sup-7861@think>
 <4CF7D40D.508@electric-spoon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Arne Jansen <sensille@gmx.net>, Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch <hch@lst.de>,
	ssorce <ssorce@redhat.com>
To: David Pottage <david@electric-spoon.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4CF7D40D.508@electric-spoon.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 02, 2010 at 05:14:53PM +0000, David Pottage wrote:
> A couple of years ago I was suffering from the problem of different
> files having the same inode number on Netapp servers. On a Netapp
> device if you snapshot a volume then the files in the snapshot have
> the same inode number as the original, even if the original changes.
> (Netapp snapshots are read only).
> 
> This means that if you attempt to see what has changed since your
> last snapshot using a command line such as:
> 
> diff src/file.c .snapshots/hourly.12/src.file.c
> 
> Then the diff tool will tell you that the files are the same even if
> they are different, because it is assuming that files with the same
> inode number will have identical contents.

diff should also recognize when they're on different filesystem, so this
should also be fixable if subvolumes are treated as different filesystem
(in the sense that they have different vfsmounts and fsid's).

--b.

> 
> Therefore I think it is a bad idea if potentially different files on
> btrfs can have the same inode number. It will break all sorts of
> tools.
> 
> Instead of maintaining a big complicated reference count of used
> inode numbers, could btrfs use bit masks to create a the userland
> visible inode number from the subvolume id and the real internal
> inode number. Something like:
> 
> userland_inode = ( volume_id << 48 ) & internal_inode;
> 
> Please forgive me if this is impossible, or if that C snippet is
> syntactically incorrect. I am not a filesystem or kernel developer,
> and I have not coded in C for many years.
> 
> -- 
> David Pottage
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
