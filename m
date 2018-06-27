Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57063 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752817AbeF0NVT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 09:21:19 -0400
Date: Wed, 27 Jun 2018 15:21:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Noah Massey <noah.massey@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: Add graceful handling of V0 extents
Message-ID: <20180627132116.GE2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180625152156.GF27958@twin.jikos.cz>
 <1530021456-20749-1-git-send-email-nborisov@suse.com>
 <20180626141659.GJ27958@twin.jikos.cz>
 <CADfjVrgZAgXFLDV7KJ4tYby9EAEOOdBOxo5EHQRW4dsNGQMeZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADfjVrgZAgXFLDV7KJ4tYby9EAEOOdBOxo5EHQRW4dsNGQMeZQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2018 at 09:12:06AM -0400, Noah Massey wrote:
> On Tue, Jun 26, 2018 at 12:02 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Tue, Jun 26, 2018 at 04:57:36PM +0300, Nikolay Borisov wrote:
> > > Following the removal of the v0 handling code let's be courteous and
> > > print an error message when such extents are handled. In the cases
> > > where we have a transaction just abort it, otherwise just call
> > > btrfs_handle_fs_error. Both cases result in the FS being re-mounted RO.
> > >
> > > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> >
> > > -             ASSERT(key.type != BTRFS_EXTENT_REF_V0_KEY);
> > > -             if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
> > > +             if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
> > > +                     err = -EINVAL;
> > > +                     btrfs_print_v0_err(rc->extent_root->fs_info);
> > > +                     btrfs_handle_fs_error(rc->extent_root->fs_info, err,
> > > +                                           NULL);
> > > +                     goto out;
> > > +             } else if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
> >
> > The v0 check should be made last as it's not expected to happen. I'm
> > commiting with this diff
> >
> > --- a/fs/btrfs/relocation.c
> > +++ b/fs/btrfs/relocation.c
> > @@ -787,13 +787,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
> >                         goto next;
> >                 }
> >
> > -               if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
> > -                       err = -EINVAL;
> > -                       btrfs_print_v0_err(rc->extent_root->fs_info);
> > -                       btrfs_handle_fs_error(rc->extent_root->fs_info, err,
> > -                                             NULL);
> > -                       goto out;
> > -               } else if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
> > +               if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
> >                         if (key.objectid == key.offset) {
> >                                 /*
> >                                  * only root blocks of reloc trees use
> > @@ -838,6 +832,12 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
> >                         goto next;
> >                 } else if (key.type != BTRFS_TREE_BLOCK_REF_KEY) {
> >                         goto next;
> 
> The V0 check needs to be before this one

Right, due to !=. Thanks for catching it.

> > +               } else if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
> > +                       err = -EINVAL;
> > +                       btrfs_print_v0_err(rc->extent_root->fs_info);
> > +                       btrfs_handle_fs_error(rc->extent_root->fs_info, err,
> > +                                             NULL);
> > +                       goto out;
> >                 }
> >
> >                 /* key.type == BTRFS_TREE_BLOCK_REF_KEY */
