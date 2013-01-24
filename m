Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:40203 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3AXRNe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 12:13:34 -0500
Message-ID: <51016BBB.8060307@jan-o-sch.net>
Date: Thu, 24 Jan 2013 18:13:31 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Chen Yang <chenyang.fnst@cn.fujitsu.com>,
        Alexander Block <ablock84@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs/send: sparse and pre-allocated file support for,
 btrfs-send mechanism
References: <50FF58BC.7090604@cn.fujitsu.com> <50FFC3C6.7040305@cn.fujitsu.com> <CAOcd+r0cNNaVFJdTVW_2f6u90u-km02mDtwk3H4Vt-YEcHNzzQ@mail.gmail.com> <51009455.7040005@cn.fujitsu.com> <CAOcd+r0hMRic8=fXNmUSbifAXwnQER8wCkj=mHSBGpQ7fM=LDA@mail.gmail.com>
In-Reply-To: <CAOcd+r0hMRic8=fXNmUSbifAXwnQER8wCkj=mHSBGpQ7fM=LDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On Thu, January 24, 2013 at 09:53 (+0100), Alex Lyakas wrote:
> Looking, for example, here:
> http://man7.org/linux/man-pages/man2/fallocate.2.html
> 
> "Allocating disk space
> The default operation (i.e., mode is zero) of fallocate() allocates
> and initializes to zero the disk space within the range specified by
> offset and len."
> 
> "Deallocating file space
> Specifying the FALLOC_FL_PUNCH_HOLE flag (available since Linux
> 2.6.38) in mode deallocates space (i.e., creates a hole) in the byte
> range starting at offset and continuing for len bytes.  Within the
> specified range, partial file system blocks are zeroed, and whole file
> system blocks are removed from the file."
> 
> These are clearly two different modes of operation, and I don't think
> you or me can decide otherwise, at this point.
> 
> However, I may be not knowledgeable enough to confirm this.
> Jan/Alexander, can you perhaps comment on this?

We don't transfer the metadata itself and that's for good reason. The data
should look alike from a user's point of view where possible. In places where we
have no good solution, we make compromises (inode numbers come to mind).

So, as a general rule: If possible with reasonable effort, I like to keep as
much of the structure as possible. Therefore, I'd rather not see a sparse
detector in any receiver out there; if it's sparse, send it as sparse, and if
it's on disk, send it as zeros on disk.

Handling of preallocated space with this rule is, well, arguable. For me, such
space is more on disk than it's not. Applications preallocating space might do
so for a good reason, and I would not treat those blocks as if they were holes
for send and receive.

-Jan
