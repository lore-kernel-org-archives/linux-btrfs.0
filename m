Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44984 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753689AbeEOSVh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 14:21:37 -0400
Date: Tue, 15 May 2018 20:18:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, wqu@suse.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
Message-ID: <20180515181856.GY6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180514070210.27047-1-wqu@suse.com>
 <20180514165205.GP6649@twin.jikos.cz>
 <CAGqmi75S-ceHKpG0fsocFnQfgBbbP7W=FrNHgwjcXJMn3SDWsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi75S-ceHKpG0fsocFnQfgBbbP7W=FrNHgwjcXJMn3SDWsQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 11:46:09PM +0300, Timofey Titovets wrote:
> > > @@ -396,6 +396,14 @@ static inline int inode_need_compress(struct inode
> *inode, u64 start, u64 end)
> > >  {
> > >       struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> > >
> > > +     /*
> > > +      * Btrfs doesn't support compression without csum or CoW.
> > > +      * This should have the highest priority.
> > > +      */
> > > +     if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW ||
> > > +         BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
> > > +             return 0;
> 
> > This is also the wrong place to fix that, NODATASUM or NODATACOW inode
> > should never make it to compress_file_range (that calls
> > inode_need_compress).
> 
> 
> David, i've talk about that some time ago:
> https://www.spinics.net/lists/linux-btrfs/msg73137.html
> 
> NoCow files can be *easy* compressed.

I missed your previous mail, the issue with compression and nocow/nosum
is there. Seems like some of the combinations are not properly handled
when it's mount option vs defrag.
