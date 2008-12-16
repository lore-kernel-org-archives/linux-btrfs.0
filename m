From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: Compressed Filesystem
Date: Tue, 16 Dec 2008 11:25:00 -0500
Message-ID: <20081216162500.GA9685@tux64-01>
References: <543762723@web.de> <20081216152004.GA7002@tux64-01> <1229441170.27573.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lee Trager <lt73@cs.drexel.edu>, devzero@web.de,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1229441170.27573.19.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

I agree that adding more options will add more complexity but it seems
the same amount of work in kernel space will have to be done. If we
support mutiple compression schemes somewhere the compression scheme
used will have to be stored so we know what to use in the future. If we
store it on the super block the user will have to choose when they
format at which point they may not see the need to use compression. Or
they may choose one compression scheme and later want to change to
something else. It doesn't make sence to have to reformat your drive
just to change compression scheme. This leaves us with storing what the
compression scheme is on each inode.  We currently store if compression
is used on a per inode basis so storing the type wouldn't be a huge
leap.

Lee
On Tue, Dec 16, 2008 at 10:26:10AM -0500, Chris Mason wrote:
> On Tue, 2008-12-16 at 10:20 -0500, Lee Trager wrote:
> > While I agree that the command you send should be possible it wasn't
> > exactly what I was thinking. Currently I am working on a way for the
> > user to individually set which files/directories they want compressed or
> > not. What I was saying is that assuming you are in a mounted btrfs
> > directory you could do something like
> > 
> > chattr -R +c zlib dir1	Compress dir1 and all its contents with zlib
> > chattr -R +c bzip dir2	Compress dir2 and all its contents with bzip
> > chattr +c lzo file1	Compress fil1 with lzo
> > chattr -c file2		Uncompress file2
> > chattr +c none dir3	Uncompress dir3 but leave contents as is
> > 
> > If the user did something like 
> > mount -o compress,cscheme=zlib /dev/xyz /mntpoint
> > and then
> > chattr +c /mntpoint/dir
> > /mntpoint/dir would default to zlib as would anything else written to
> > the disk.
> > 
> 
> This is one of those places where more options isn't always better.
> Every option adds complexity to the filesystem and the testing matrix.  
> 
> I'd much rather have just one compression scheme per FS.  If people need
> a specific compression scheme for a specific file, they can just
> compress it in userland.
> 
> -chris
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
