Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48754 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S968372AbdIZOoP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 10:44:15 -0400
Date: Tue, 26 Sep 2017 16:42:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] btrfs: Add sanity check for EXTENT_DATA when
 reading out leaf
Message-ID: <20170926144241.GU31640@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
 <20170823075759.13982-4-quwenruo.btrfs@gmx.com>
 <20170925154503.GL31640@twin.jikos.cz>
 <d90b5bd1-8b8f-4403-6d46-a817d935d63d@gmx.com>
 <4e71f431-8869-b430-4179-23a5a442951f@gmx.com>
 <20170926121336.GS31640@twin.jikos.cz>
 <92ac816e-222a-a3b5-79b7-07f7d351a1d8@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <92ac816e-222a-a3b5-79b7-07f7d351a1d8@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 26, 2017 at 08:49:55PM +0800, Qu Wenruo wrote:
> > Yeah something like that. And also make it a function, unless we're
> > going to use some macro magic (I'm not sure about that yet).
> > 
> > Schematically:
> > 
> > btrfs_report_corruption(fs_info, EXTENT_ITEM, "file item type is unknown: %d", fi->type);
> > 
> > implemented as:
> > 
> > btrfs_err(fs_info,
> > 	"corruption detected for item %d: "
> > 	"file item type is unknown: %d",
> > 	EXTENT_ITEM
> > 	fi->type);
> > 
> > Here comes the magic: as btrfs_err will print the arguments on one line
> > and adds the \n, we have to merge the string and the argument list into
> > one.
> > 
> > But if adding a separate helper similar to btrfs_err would be more
> > suitable, then ok.
> > 
> I'll try to implement it, but I'm a little afraid that it may turn out 
> to little common routine for the error report and we may need to 
> manually craft the output for each member.
> 
> But I'll keep this point in mind when updating the patchset.

Ok, let's see how far we can make it. Please send only updates on top of
this patches for now, I've merged them to misc-next (ie. "for 4.15").

> BTW, what about moving these checkers and error reporting mechanism to 
> its own C file?
> The code will definitely get larger and larger, I think moving them to 
> one separate file at the very beginning will save us more time.

Good point, please proceed.
