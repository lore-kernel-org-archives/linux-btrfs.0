Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbcFFIPs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 04:15:48 -0400
Date: Mon, 6 Jun 2016 10:15:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: clear uptodate flags of pages in sys_array eb
Message-ID: <20160606081506.GR29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1465000902-3205-1-git-send-email-bo.li.liu@oracle.com>
 <20160604011617.GA8214@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160604011617.GA8214@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 03, 2016 at 06:16:18PM -0700, Liu Bo wrote:
> On Fri, Jun 03, 2016 at 05:41:42PM -0700, Liu Bo wrote:
> > We set uptodate flag to pages in the temporary sys_array eb,
> > but do not clear the flag after free eb.  As the special
> > btree inode may still hold a reference on those pages, the
> > uptodate flag can remain alive in them.
> > 
> > If btrfs_super_chunk_root has been intentionally changed to the
> > offset of this sys_array eb, reading chunk_root will read content
> > of sys_array and it will pass our beautiful checks in
> 
> s/pass/skip/
> 
> My mistake, sorry.

Updated in the patch.
