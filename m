Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2L0NYk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 08:24:40 -0500
Date: Thu, 27 Dec 2012 14:24:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Slava Barinov <rayslava@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: BUG at fs/btrfs/locking.c:265
Message-ID: <20121227132437.GS14116@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CADef55rak5VxVePgXtBz8fVpnqaWh2gRAfnGgZQT2QATJ4AS+Q@mail.gmail.com>
 <20121227080728.GB20325@liubo.au.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121227080728.GB20325@liubo.au.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 27, 2012 at 04:07:31PM +0800, Liu Bo wrote:
> On Thu, Dec 27, 2012 at 08:27:11AM +0400, Slava Barinov wrote:
> >   And there's nothing in dmesg that could help user to understand what
> > happened. I've lost about ten minutes trying to understand what does
> > it want from me.
>Could you please show me what line does 'walk_down_proc+0x2b0/0x2e0 [btrfs]'
> refer to?

It's

6578         if (path->locks[level] && level > 0) {
6579                 btrfs_tree_unlock_rw(eb, path->locks[level]);
^^^^
6580                 path->locks[level] = 0;
6581         }
6582         return 0;

which calls btrfs_tree_unlock() and hits the

241 void btrfs_tree_unlock(struct extent_buffer *eb)
242 {
243         int blockers = atomic_read(&eb->blocking_writers);
244
245         BUG_ON(blockers > 1);
246
247         btrfs_assert_tree_locked(eb);

->

263 void btrfs_assert_tree_locked(struct extent_buffer *eb)
264 {
265         BUG_ON(!atomic_read(&eb->write_locks));
266 }


david
