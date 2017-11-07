Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43105 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932356AbdKGUPC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 15:15:02 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6941EABF4
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Nov 2017 20:15:01 +0000 (UTC)
Date: Tue, 7 Nov 2017 21:13:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/10] Cleanup unnecessary get_extent parameters
Message-ID: <20171107201302.GC27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1509996091.git.dsterba@suse.com>
 <831c9c09-c974-eb38-0e26-fa9a6e8309ee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <831c9c09-c974-eb38-0e26-fa9a6e8309ee@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 11:26:54PM +0200, Nikolay Borisov wrote:
> 
> 
> On  6.11.2017 21:30, David Sterba wrote:
> > There are several functions that take a generic get_extent parameter, but not
> > all of them use it to distinguish between btree_get_exnent (for metadata) and
> > btrfs_get_extent (for data). This is namely extent_read_full_page and
> > __do_readpage.
> 
> I wonder whether we can do some similar collpasing withe some of the
> hooks we have i.e. readpage_end_io_hook (resp.
> btrfs_readpage_end_io_hook and btree_readpage_end_io_hook). All those
> callbacks don't necessarily help readability...

Some of the callbacks passed as parameters can be possibly pushed down
the callstack, the only difference is btree_inode vs file extents.
Instead of the uppper caller switch, the right function can be called
based on the inode number (btree_inode has 1).

Josef has some ideas/patches to get rid of the btree_inode completely so
cleaning up the callback might not be worth. There's still some
potential to reduce the arguments to the various callbacks, I have
patches for that. This is a relatively easy and safe so I would still
send them, as the btree_inode removal will be probably intrusive and the
ETA for such changes is unpredictable.
