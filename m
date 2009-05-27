From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Compression of large files
Date: Wed, 27 May 2009 10:41:27 -0400
Message-ID: <20090527144127.GA11706@think>
References: <4A1D49C1.8070903@dpf.gov.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Atila Romero <atila.alr@dpf.gov.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A1D49C1.8070903@dpf.gov.br>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 27, 2009 at 11:10:09AM -0300, Atila Romero wrote:
> During a file write, if the compression doesn't proves to be economical
> to a portion of the file, the whole file is marked as nocompress, and
> subsequent writes don't use compression at all. This can be seen as a 
> feature, as it saves CPU in files like videos. But if the file is a dd
> image of a disk, or other types of large files, this behavior is
> undesirable, since different portions of the file will have different
> compression ratios.
> I only became aware of this after searching the source code, after
> spending some hours trying to find out why the compression wasn't
> working. This can be a really unexpected behavior for a end user who is
> looking for compression.
> The specific part of the code is at inode.c:
> 477 <#l477>
>                 /* flag the file so we don't compress in the future */
> 478 <#l478>                 btrfs_set_flag(inode, NOCOMPRESS);
> 
> How about commenting line 478?

The plan is to add a flag for the file to make it always compress even
when parts of the file do not compress well.

-chris

