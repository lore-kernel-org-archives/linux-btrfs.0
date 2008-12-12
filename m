From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Selective Compression/Encryption
Date: Fri, 12 Dec 2008 09:19:23 -0500
Message-ID: <1229091563.11620.1.camel@think.oraclecorp.com>
References: <20081209145952.GA30494@tux64-03>
	 <1228840516.27601.10.camel@think.oraclecorp.com>
	 <200812091126.04044.des@condordes.net> <493ED385.7000608@hp.com>
	 <20081211220304.GA9082@tux64-02>
Mime-Version: 1.0
Content-Type: text/plain
Cc: jim owens <jowens@hp.com>, "Joshua J. Berry" <des@condordes.net>,
	linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081211220304.GA9082@tux64-02>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-12-11 at 17:03 -0500, Lee Trager wrote:
> On Tue, Dec 09, 2008 at 03:22:29PM -0500, jim owens wrote:
> > Joshua J. Berry wrote:
> >> On Tuesday 09 December 2008 08:35:16 Chris Mason wrote:
> >>> On Tue, 2008-12-09 at 09:59 -0500, Lee Trager wrote:
> >>>> Currently compression and I assume if encryption is implemented it is
> >>>> turned on or off during mount. There are however many times when a user
> >>>> may want to select which files/directories they want to compress or
> >>>> encrypt. This will also be helpful when implementing btrfs support in
> >>>> grub for example. We can say the disk can be compressed/encrypted except
> >>>> for /boot so compression/encryption doesn't have to be implemented in
> >>>> grub.
> >>>>
> >>>> I was thinking of adding this functionality to the userspace application
> >>>> btrfstune. The way I was thinking of doing this is when btrfstune +c is
> >>>> applied to a directory or file the directory(and all its contents) or
> >>>> file will always be compressed reguardless of how the filesystem is
> >>>> mounted. The opposite would happen when btrfstune -c is used.
> >>> This was my plan, but btrfstune probably isn't the best program to do it
> >>> (the ext2 tune program is mostly aimed at the super block level things).
> >>>
> >>> I think it would be better to make a setattr style program to call the
> >>> ioctls.  There is already a per file compression flag, and the code
> >>> should already be checking it.
> >>
> >> Is there some reason this can't be done with the existing extended 
> >> attribute facilities?
> >>
> >> It seems like xattrs would be preferable to some btrfs-specific 
> >> tunable, as programs like rsync or backup tools would be able to 
> >> preserve (and restore) these bits with no extra work required.
> >
> > I had the same thought... that many btrfs per-file tunables would
> > be better implemented in xattrs (I've read christoph's earlier
> > objections and hope to get around those issues).
> I agree that implementing it in the xattr would be best but what
> userspace tools should be used to control it? lsattr/chattr or our own?
> lsattr/chattr does seem to do what we want for compression but it really
> has nothing for encryption. Should we also support attribute(a), no
> modification(i), etc support in xattrs?

Just to clarify, I'm fine with xattrs as a user interface to set the
per-inode flags.  The flag for this should be stored in the inode
though, and not as a btrfs xattr.  There is already a flag field in the
inode for this use (see NODATASUM and NODATACOW)

-chris


