Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46326 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2L1Jv6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 04:51:58 -0500
Date: Fri, 28 Dec 2012 17:49:07 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Slava Barinov <rayslava@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: BUG at fs/btrfs/locking.c:265
Message-ID: <20121228094906.GA7283@liubo>
Reply-To: bo.li.liu@oracle.com
References: <CADef55rak5VxVePgXtBz8fVpnqaWh2gRAfnGgZQT2QATJ4AS+Q@mail.gmail.com>
 <20121227080728.GB20325@liubo.au.oracle.com>
 <20121227132437.GS14116@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121227132437.GS14116@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Slava, David,

I've sent a patch to fix the bug(Cced you), could you please check if it
works? :)

thanks,
liubo


On Thu, Dec 27, 2012 at 02:24:37PM +0100, David Sterba wrote:
> On Thu, Dec 27, 2012 at 04:07:31PM +0800, Liu Bo wrote:
> > On Thu, Dec 27, 2012 at 08:27:11AM +0400, Slava Barinov wrote:
> > >   And there's nothing in dmesg that could help user to understand what
> > > happened. I've lost about ten minutes trying to understand what does
> > > it want from me.
> >Could you please show me what line does 'walk_down_proc+0x2b0/0x2e0 [btrfs]'
> > refer to?
> 
> It's
> 
> 6578         if (path->locks[level] && level > 0) {
> 6579                 btrfs_tree_unlock_rw(eb, path->locks[level]);
> ^^^^
> 6580                 path->locks[level] = 0;
> 6581         }
> 6582         return 0;
> 
> which calls btrfs_tree_unlock() and hits the
> 
> 241 void btrfs_tree_unlock(struct extent_buffer *eb)
> 242 {
> 243         int blockers = atomic_read(&eb->blocking_writers);
> 244
> 245         BUG_ON(blockers > 1);
> 246
> 247         btrfs_assert_tree_locked(eb);
> 
> ->
> 
> 263 void btrfs_assert_tree_locked(struct extent_buffer *eb)
> 264 {
> 265         BUG_ON(!atomic_read(&eb->write_locks));
> 266 }
> 
> 
> david
