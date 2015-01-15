Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbbAOKsW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 05:48:22 -0500
Date: Thu, 15 Jan 2015 11:48:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Samuel <chris@csamuel.org>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>, chandanrmail@gmail.com
Subject: Re: btrfs_inode_item's otime?
Message-ID: <20150115104820.GZ3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150105172152.GB19126@gardel-login>
 <3797928.30urVis5AR@quad>
 <20150106184100.GF24104@twin.jikos.cz>
 <2188846.ArnMyWRJKN@quad>
 <20150109161142.GC3685@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150109161142.GC3685@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2015 at 05:11:42PM +0100, David Sterba wrote:
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -5835,6 +5835,11 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
> >                              sizeof(*inode_item));
> >         fill_inode_item(trans, path->nodes[0], inode_item, inode);
> >  
> > +       /*
> > +        * Set the creation time on the inode.
> > +        */
> > +       btrfs_set_stack_timespec_sec( &inode.otime, cur_time.tv_sec );
> 
> Drop the spaces after/before parens and also set usec the same way.
> There's no such thing as 'current_time', only CURRENT_TIME but that
> cannot be used directly as a structure.
> 
> Given that the mtime is set a few lines above, copy the tv_sec and
> tv_usec from there.

chandan pointed out on IRC the other day that he'd sent a patch for that
already

http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg17508.html

Though the patch cannot be applied as-is, it's more complete (I've
missed a few places where the otime has to be set).

Chandan, please drop the btrfs_inode_otime helper and resend. Thanks.
