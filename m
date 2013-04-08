Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36473 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935482Ab3DHN5B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2013 09:57:01 -0400
Date: Mon, 8 Apr 2013 21:56:44 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allow file data clone within a file
Message-ID: <20130408135643.GA27988@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1365344298-23917-1-git-send-email-bo.li.liu@oracle.com>
 <20130408124918.GB18193@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130408124918.GB18193@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 08, 2013 at 02:49:18PM +0200, David Sterba wrote:
> On Sun, Apr 07, 2013 at 10:18:18PM +0800, Liu Bo wrote:
> > We did not allow file data clone within the same file because of
> > deadlock issues.
> >
> > However, we now use nested lock to avoid deadlock between the
> > parent directory and the child file.
> > 
> > So it's safe to do file clone at different offset within the
> > same file.
> 
> There's a todo comment inside the function saying that cloning within
> the same file is possible but with an exception of overlapping ranges.
> How does your patch prevent that? With current code + your patch it's
> possible to call 
> 
> 2583         /* truncate page cache pages from target inode range */
> 2584         truncate_inode_pages_range(&inode->i_data, destoff,
> 2585                                    PAGE_CACHE_ALIGN(destoff + len) - 1);
> 
> where [destoff, destoff+len) intersects with the source [off, off+len)
> thus destroying the data to be cloned.
> 
> david

Yeah, that's right, I missed this, what about another sanity check for
overlapping ranges, of course in the case of the same file?

thanks,
liubo
