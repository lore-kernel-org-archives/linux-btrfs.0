Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34539 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932231AbeCLSML (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 14:12:11 -0400
Date: Mon, 12 Mar 2018 19:09:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH 1/4] btrfs-progs: mode-lowmem: Fix false alert about
 orphan inode
Message-ID: <20180312180947.GB32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180205064714.15659-1-wqu@suse.com>
 <f929f410-7413-9892-4e9c-a11c77f7e21a@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f929f410-7413-9892-4e9c-a11c77f7e21a@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 05, 2018 at 03:00:39PM +0800, Su Yue wrote:
> 
> 
> On 02/05/2018 02:47 PM, Qu Wenruo wrote:
> > Btrfs can delay inode deletion and in that case btrfs will unlink the
> > victim inode from its parent dir, and insert a marker to info btrfs to
> > delete it later.
> > 
> > In that case, such victim inode will have nlinks == 0, but is still
> > completely valid.
> > Original mode won't report such problem, but lowmem mode doesn't check
> > the ORPHAN_ITEM key for such inode, and can report false alert like:
> > ------
> > ERROR: root 257 INODE[28891726] is orphan item
> > ------
> > 
> > Fix such false alert by checking orphan item for inode whose nlink is 0.
> > 
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > ---
> >   check/mode-lowmem.c | 24 ++++++++++++++++++++++--
> >   1 file changed, 22 insertions(+), 2 deletions(-)
> > 
> > diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> > index 62bcf3d2e126..b11a6d77d102 100644
> > --- a/check/mode-lowmem.c
> > +++ b/check/mode-lowmem.c
> > @@ -1861,6 +1861,24 @@ out:
> >   	return ret;
> >   }
> >   
> > +static bool has_orphan_item(struct btrfs_root *root, u64 ino)
> > +{
> > +	struct btrfs_path path;
> > +	struct btrfs_key key;
> > +	int ret;
> > +
> > +	btrfs_init_path(&path);
> > +	key.objectid = BTRFS_ORPHAN_OBJECTID;
> > +	key.type = BTRFS_ORPHAN_ITEM_KEY;
> > +	key.offset = ino;
> > +
> > +	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> > +	btrfs_release_path(&path);
> > +	if (ret == 0)
> > +		return true;
> > +	return false;
> > +}
> > +
> 
> Suggestion:
> Maybe "is_orphan_item" is a better name?

The inode cannot be an orphan item itself, the orphan status is denoted
by the orphan item so the inode does have the item attached. So
has_orphan_item seems appropriate.

> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

Thanks.
