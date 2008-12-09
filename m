From: "Joshua J. Berry" <des@condordes.net>
Subject: Re: Selective Compression/Encryption
Date: Tue, 9 Dec 2008 11:26:03 -0800
Message-ID: <200812091126.04044.des@condordes.net>
References: <20081209145952.GA30494@tux64-03> <1228840516.27601.10.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Cc: Lee Trager <lt73@cs.drexel.edu>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228840516.27601.10.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 09 December 2008 08:35:16 Chris Mason wrote:
> On Tue, 2008-12-09 at 09:59 -0500, Lee Trager wrote:
> > Currently compression and I assume if encryption is implemented it is
> > turned on or off during mount. There are however many times when a user
> > may want to select which files/directories they want to compress or
> > encrypt. This will also be helpful when implementing btrfs support in
> > grub for example. We can say the disk can be compressed/encrypted except
> > for /boot so compression/encryption doesn't have to be implemented in
> > grub.
> >
> > I was thinking of adding this functionality to the userspace application
> > btrfstune. The way I was thinking of doing this is when btrfstune +c is
> > applied to a directory or file the directory(and all its contents) or
> > file will always be compressed reguardless of how the filesystem is
> > mounted. The opposite would happen when btrfstune -c is used.
>
> This was my plan, but btrfstune probably isn't the best program to do it
> (the ext2 tune program is mostly aimed at the super block level things).
>
> I think it would be better to make a setattr style program to call the
> ioctls.  There is already a per file compression flag, and the code
> should already be checking it.

Is there some reason this can't be done with the existing extended attribute 
facilities?

It seems like xattrs would be preferable to some btrfs-specific tunable, as 
programs like rsync or backup tools would be able to preserve (and restore) 
these bits with no extra work required.

-- Josh


-- 
Joshua J. Berry

"I haven't lost my mind -- it's backed up on tape somewhere."
    -- /usr/games/fortune

