Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34268 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752279AbeB1SuN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 13:50:13 -0500
Received: by mail-wr0-f193.google.com with SMTP id m5so3533431wrg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 10:50:13 -0800 (PST)
Message-ID: <1519843790.4682.4.camel@gmail.com>
Subject: Re: [Bug report] BTRFS partition re-mounted as read-only after few
 minutes of use
From: peteryuchuang@gmail.com
To: fdmanana@gmail.com, dsterba@suse.cz,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Wed, 28 Feb 2018 19:49:50 +0100
In-Reply-To: <CAL3q7H4HLn1X1GNZPWXdmzWmbZB25Fhyi8_+MXUA8fkw2xvhxQ@mail.gmail.com>
References: <1519836220.1693.23.camel@gmail.com>
         <20180228175013.GG27791@twin.jikos.cz>
         <CAL3q7H4HLn1X1GNZPWXdmzWmbZB25Fhyi8_+MXUA8fkw2xvhxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2018-02-28 at 18:36 +0000, Filipe Manana wrote:
> On Wed, Feb 28, 2018 at 5:50 PM, David Sterba <dsterba@suse.cz>
> wrote:
> > On Wed, Feb 28, 2018 at 05:43:40PM +0100, peteryuchuang@gmail.com
> > wrote:
> > > On my laptop, which has just been switched to BTRFS, the root
> > > partition
> > > (a BTRFS partition inside an encrypted LVM. The drive is an NVMe)
> > > is
> > > re-mounted as read-only few minutes after boot.
> > > 
> > > Trace:
> > 
> > By any chance, are there other messages from btrfs above the line?
> > > 
> > > [  199.974591] ------------[ cut here ]------------
> > > [  199.974593] BTRFS: Transaction aborted (error -95)
> > 
> > -95 is EOPNOTSUPP, ie operation not supported
> > 
> > > [  199.974647] WARNING: CPU: 0 PID: 324 at fs/btrfs/inode.c:3042
> > > btrfs_finish_ordered_io+0x7ab/0x850 [btrfs]
> > 
> > btrfs_finish_ordered_io::
> > 
> >  3038         btrfs_ordered_update_i_size(inode, 0,
> > ordered_extent);
> >  3039         ret = btrfs_update_inode_fallback(trans, root,
> > inode);
> >  3040         if (ret) {
> >  3041                 btrfs_abort_transaction(trans, ret);
> >  3042                 goto out;
> >  3043         }
> 
> I don't know what's exactly in Arch's kernel, but looking at the
> 4.15.5 stable tag from kernel.org:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g
> it/tree/fs/btrfs/inode.c?h=v4.15.5#n3042
> 
> The -EOPNOTSUPP error can come from btrfs_drop_extents() through the
> call to insert_reserved_file_extent().
> We've had several reports of this kind of error in this location in
> the past and they happened to be on filesystems converted from extN
> to
> btrfs.
> I don't know however if this filesystem was from such a conversion
> nor
> if those old bugs in the conversion tool were fixed.
> 
> 

Indeed it was converted from ext4. I may try to rebuild the system from
scratch when I have more time, but I'm afraid I have to revert back to
ext4 for now.

> > 
> > the return code is unexpected here. And seeing 'operation not
> > supported'
> > after a inode size change looks strange but EOPNOTSUPP could be
> > returned
> > from some places.
> > 
> > The transaction is aborted from a thread that finalizes some
> > processing
> > so we don't have enough information here to see how it started. I
> > suspect there's a file that gets modified short after boot and hits
> > the
> > problem. I don't think the EOPNOTSUPP is returned from the lower
> > layers
> > (lvm encryption or nvme), so at this point seems like a btrfs bug.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
