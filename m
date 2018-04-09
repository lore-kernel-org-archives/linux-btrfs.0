Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53181 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751688AbeDIPIJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 11:08:09 -0400
Date: Mon, 9 Apr 2018 17:05:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Use more loose open ctree flags for
 dump-tree and restore
Message-ID: <20180409150538.GW8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180406063919.11771-1-wqu@suse.com>
 <20180409141235.GP8557@twin.jikos.cz>
 <a75a16c3-eb04-5c64-a861-e370aa144606@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a75a16c3-eb04-5c64-a861-e370aa144606@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2018 at 10:29:34PM +0800, Qu Wenruo wrote:
> >> --- a/cmds-inspect-dump-tree.c
> >> +++ b/cmds-inspect-dump-tree.c
> >> @@ -303,7 +303,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
> >>  	int uuid_tree_only = 0;
> >>  	int roots_only = 0;
> >>  	int root_backups = 0;
> >> -	unsigned open_ctree_flags = OPEN_CTREE_FS_PARTIAL;
> >> +	/* Speed up open_ctree() and continue if extent tree is corrupted */
> >> +	unsigned open_ctree_flags = OPEN_CTREE_PARTIAL |
> >> +				    OPEN_CTREE_NO_BLOCK_GROUPS;
> > 
> > We could consider that separatelly, whether to allow dumping a partially
> > created filesystem, ie. OPEN_CTREE_FS_PARTIAL added by a new option.
> 
> For dump-tree, there is really no limitation here.
> As long as chunk tree is OK, we should be OK to do "-b" dump.
> 
> For "-t" or all tree (default) dump, with chunk tree opened only, we
> could try our best to print any good trees.
> So I don't get the point to read all other trees.

Yeah, eg. a bad filesystem magic number does not stop dump-tree, so no
change is needed.
