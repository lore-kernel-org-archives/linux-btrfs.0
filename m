From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: Selective Compression/Encryption
Date: Tue, 9 Dec 2008 13:14:06 -0500
Message-ID: <20081209181406.GB6551@tux64-03>
References: <20081209145952.GA30494@tux64-03> <1228840516.27601.10.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228840516.27601.10.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Would you suggest using the existing chattr/lsattr commands from
e2fsprogs for userspace control and just add support at the kernel
level?

Miguel suggested this be done at the volume level. Do you have any
thoughts on that?

Thanks,

Lee

On Tue, Dec 09, 2008 at 11:35:16AM -0500, Chris Mason wrote:
> On Tue, 2008-12-09 at 09:59 -0500, Lee Trager wrote:
> > Currently compression and I assume if encryption is implemented it is
> > turned on or off during mount. There are however many times when a user may
> > want to select which files/directories they want to compress or encrypt.
> > This will also be helpful when implementing btrfs support in grub for
> > example. We can say the disk can be compressed/encrypted except for /boot so 
> > compression/encryption doesn't have to be implemented in grub.
> > 
> > I was thinking of adding this functionality to the userspace application
> > btrfstune. The way I was thinking of doing this is when btrfstune +c is
> > applied to a directory or file the directory(and all its contents) or
> > file will always be compressed reguardless of how the filesystem is
> > mounted. The opposite would happen when btrfstune -c is used.
> > 
> 
> This was my plan, but btrfstune probably isn't the best program to do it
> (the ext2 tune program is mostly aimed at the super block level things).
> 
> I think it would be better to make a setattr style program to call the
> ioctls.  There is already a per file compression flag, and the code
> should already be checking it.
> 
> -chris
> 
