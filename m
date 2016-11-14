Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47617 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932174AbcKNQk0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 11:40:26 -0500
Date: Mon, 14 Nov 2016 17:40:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 3/6] btrfs-progs: add OPEN_CTREE_INVALIDATE_FST flag
Message-ID: <20161114164021.GP12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1479064970.git.osandov@fb.com>
 <b22be9b08513c06ad7a091ea502aaa31ee03ca34.1479064970.git.osandov@fb.com>
 <0daf0321-5d0f-5820-2f11-05e69cfe471f@cn.fujitsu.com>
 <20161114162256.GA22223@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161114162256.GA22223@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 14, 2016 at 08:22:56AM -0800, Omar Sandoval wrote:
> > > --- a/disk-io.c
> > > +++ b/disk-io.c
> > > @@ -904,7 +904,7 @@ free_all:
> > >  	return NULL;
> > >  }
> > > 
> > > -int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable)
> > > +int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, unsigned flags)
> > 
> > IIRC kernel checkpatch will warn on single "unsigned", as it's recommended
> > to use "unsigned int".
> 
> I was going for consistency with the rest of disk-io.c, but I can fix
> it.

Not needed IMHO, we don't use unsinged int/unsigned consistently.
