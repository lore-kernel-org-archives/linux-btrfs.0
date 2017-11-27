Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753197AbdK0QTh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 11:19:37 -0500
Date: Mon, 27 Nov 2017 17:17:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Hans van Kranenburg <hans@knorrie.org>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: dump_tree: remove superfluous _TREE
Message-ID: <20171127161739.GB3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171124202608.11152-1-hans@knorrie.org>
 <7166920a-17c1-cd00-23d8-cef0a1693ba5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <7166920a-17c1-cd00-23d8-cef0a1693ba5@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 25, 2017 at 09:03:26AM +0800, Qu Wenruo wrote:
> On 2017年11月25日 04:26, Hans van Kranenburg wrote:
> > -# btrfs inspect-internal dump-tree -t fs /dev/block/device
> > ERROR: unrecognized tree id: fs
> > 
> > Without this fix I can't dump-tree fs, but I can dump-tree fs_tree and
> > also fs_tree_tree, which is a bit silly.
> > ---
> >  cmds-inspect-dump-tree.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
> > index 4e72c08a..df44bb63 100644
> > --- a/cmds-inspect-dump-tree.c
> > +++ b/cmds-inspect-dump-tree.c
> > @@ -143,7 +143,7 @@ static u64 treeid_from_string(const char *str, const char **end)
> >  		{ "CHUNK", BTRFS_CHUNK_TREE_OBJECTID },
> >  		{ "DEVICE", BTRFS_DEV_TREE_OBJECTID },
> >  		{ "DEV", BTRFS_DEV_TREE_OBJECTID },
> > -		{ "FS_TREE", BTRFS_FS_TREE_OBJECTID },
> > +		{ "FS", BTRFS_FS_TREE_OBJECTID },
> 
> Considering no other name has the _tree suffix, this looks good to me.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.
