From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Compressed Filesystem
Date: Tue, 16 Dec 2008 10:26:10 -0500
Message-ID: <1229441170.27573.19.camel@think.oraclecorp.com>
References: <543762723@web.de>  <20081216152004.GA7002@tux64-01>
Mime-Version: 1.0
Content-Type: text/plain
Cc: devzero@web.de, linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081216152004.GA7002@tux64-01>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-12-16 at 10:20 -0500, Lee Trager wrote:
> While I agree that the command you send should be possible it wasn't
> exactly what I was thinking. Currently I am working on a way for the
> user to individually set which files/directories they want compressed or
> not. What I was saying is that assuming you are in a mounted btrfs
> directory you could do something like
> 
> chattr -R +c zlib dir1	Compress dir1 and all its contents with zlib
> chattr -R +c bzip dir2	Compress dir2 and all its contents with bzip
> chattr +c lzo file1	Compress fil1 with lzo
> chattr -c file2		Uncompress file2
> chattr +c none dir3	Uncompress dir3 but leave contents as is
> 
> If the user did something like 
> mount -o compress,cscheme=zlib /dev/xyz /mntpoint
> and then
> chattr +c /mntpoint/dir
> /mntpoint/dir would default to zlib as would anything else written to
> the disk.
> 

This is one of those places where more options isn't always better.
Every option adds complexity to the filesystem and the testing matrix.  

I'd much rather have just one compression scheme per FS.  If people need
a specific compression scheme for a specific file, they can just
compress it in userland.

-chris


