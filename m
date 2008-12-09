From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Selective Compression/Encryption
Date: Tue, 09 Dec 2008 11:35:16 -0500
Message-ID: <1228840516.27601.10.camel@think.oraclecorp.com>
References: <20081209145952.GA30494@tux64-03>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081209145952.GA30494@tux64-03>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-12-09 at 09:59 -0500, Lee Trager wrote:
> Currently compression and I assume if encryption is implemented it is
> turned on or off during mount. There are however many times when a user may
> want to select which files/directories they want to compress or encrypt.
> This will also be helpful when implementing btrfs support in grub for
> example. We can say the disk can be compressed/encrypted except for /boot so 
> compression/encryption doesn't have to be implemented in grub.
> 
> I was thinking of adding this functionality to the userspace application
> btrfstune. The way I was thinking of doing this is when btrfstune +c is
> applied to a directory or file the directory(and all its contents) or
> file will always be compressed reguardless of how the filesystem is
> mounted. The opposite would happen when btrfstune -c is used.
> 

This was my plan, but btrfstune probably isn't the best program to do it
(the ext2 tune program is mostly aimed at the super block level things).

I think it would be better to make a setattr style program to call the
ioctls.  There is already a per file compression flag, and the code
should already be checking it.

-chris


