Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:46944 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751537Ab3EQPon (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 11:44:43 -0400
Date: Fri, 17 May 2013 10:44:36 -0500
From: Ben Myers <bpm@sgi.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: xattr performance
Message-ID: <20130517154436.GW29359@sgi.com>
References: <alpine.DEB.2.10.1305170444590.13746@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.10.1305170444590.13746@trent.utfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Christian,

On Fri, May 17, 2013 at 05:02:21AM -0700, Christian Kujau wrote:
> a while ago I was setting & reading extended attributes to ~25000 files 
> in a directory structure on an XFS filesystem. The files were usually a 
> few MB in size, but some where up to 2GB in size.
> 
> Anyway, I *felt* that setting or reading these xattrs was going very
> slowly. While the storage may be not the fastest, stat()'ing these
> files was fine, but getfattr/setfattr took very long.
> 
> I got curious and while it turned out that the slowness was related to the 
> wrapper script I used to read/set those values, I created a little test 
> suite to 1) create a few thousand files and 2) do xattr operations on 
> them and see if xattr performance was filesystem specific:
> 
>    http://nerdbynature.de/bits/xattr/
> 
> Not very sophisticated, true. But it was interesting to see that 
> ext3/ext4/xfs behaved kinda well for all these tests; btrfs/jfs/reiserfs
> sometimes took way longer than the others.

Very interesting results!  One wrinkle that you might want to consider with XFS
is the overall size of the attributes versus the size of the inode.  You can
choose inode sizes between 256 bytes and 2k in powers of two, and we always
allocate them in chunks of 64.  The 'literal' area is the space after the inode
core and before the next one... it's best described here:
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/On-disk_Inode.html

The short version:

inode core (96 bytes) + literal area == inode size

The data and attribute forks share the literal area.  If the attributes get too
big to fit inside the literal area with the data fork they will go out of line
and be stored elsewhere in the filesystem.  The performance characteristics of
inline vs out-of-line attributes are significantly different.  That might be
what you experienced when you felt that setting/reading xattrs was taking a
long time. 

Anyway... If you're a heavy user of EAs you might benefit from using larger
inodes.  Just something to consider.  Cool tests!  ;)

Regards,
	Ben
