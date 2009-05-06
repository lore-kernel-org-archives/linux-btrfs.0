From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG] fallocate behavior when crossing end-of-file
Date: Wed, 06 May 2009 11:10:23 -0400
Message-ID: <1241622623.17493.0.camel@localhost.localdomain>
References: <4A018A90.7050109@mccme.ru>  <4A01A5DF.5050406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Raskin Michael <raskin@mccme.ru>, linux-btrfs@vger.kernel.org
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A01A5DF.5050406@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-05-06 at 16:59 +0200, Edward Shishkin wrote:
> Raskin Michael wrote:
> > 		Hello.
> >   
> 
> Hello.
> 
> > 	I found the following bug in BtrFS:
> >
> > 	1. Create and open an empty file
> > 	2. fallocate (fd, 0, 1)
> > 	
> > Desired: something (probably, one block) is allocated/reserved for the
> > file. File length is set to 1 byte.
> >   
>              
> Where is it documented?
> 
> IMHO we should only guarantee that writes
> to [0, 1] won't fail because of lack of disk space.
> Other things (including file size) are up to implementation.
> 

This one looks like a pretty simple bug in the fallocate call.  It is
rounding up the size to a block boundary.

-chris

> > Actual: A block is allocated. File length is set to 1 block (4096
> > bytes). The rest of the file is filled with zeros.
> >
> > 	last_byte = min(extent_map_end(em), alloc_end);
> > 	last_byte = (last_byte + mask) & ~mask;
> > 	if (em->block_start == EXTENT_MAP_HOLE) {
> > 		ret = prealloc_file_range(trans, inode, cur_offset,
> > 				last_byte, locked_end + 1,
> > 				alloc_hint, mode);
> >
> > That part seems strange to me. You make an effort for block size to
> > divide last_byte. But last_byte should be
> > max(i_size_read(inode), offset+len)
> > - without any rounding.
> >
> > Michael Raskin
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >   
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

