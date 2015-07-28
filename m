Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26465 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706AbbG1J6f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 05:58:35 -0400
Date: Tue, 28 Jul 2015 17:58:28 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix warning in backref walking
Message-ID: <20150728095828.GD1338@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1437984953-453-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H6+_Xs=34Qvy+uKT1peJV=ff9TtqcE2bACvLRqYyCwK0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6+_Xs=34Qvy+uKT1peJV=ff9TtqcE2bACvLRqYyCwK0g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 27, 2015 at 10:03:44AM +0100, Filipe David Manana wrote:
> On Mon, Jul 27, 2015 at 9:15 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > When we do backref walking, we search firstly in queued delayed refs
> > and then the on-disk backrefs, but we parse differently for shared
> > references, for delayed refs we also add 'ref->root' while for on-disk
> > backrefs we don't, this can prevent us from merging refs indexed
> > by the same bytenr and cause find_parent_nodes() to throw a warning at
> > 'WARN_ON(ref->count < 0)', for example, when we have a shared data extent
> > with 'ref_cnt=1' and a delayed shared data with a BTRFS_DROP_DELAYED_REF,
> > that happens.
> >
> > For shared references, no matter if it's delayed or on-disk, ref->root is
> > not at all used, instead it's ref->parent that really matters, so this has
> > delayed refs handled as the same way as on-disk refs.
> >
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/backref.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > index 802fabb..2485b868 100644
> > --- a/fs/btrfs/backref.c
> > +++ b/fs/btrfs/backref.c
> > @@ -632,7 +632,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
> >                         struct btrfs_delayed_tree_ref *ref;
> >
> >                         ref = btrfs_delayed_node_to_tree_ref(node);
> > -                       ret = __add_prelim_ref(prefs, ref->root, NULL,
> > +                       ret = __add_prelim_ref(prefs, 0, NULL,
> >                                                ref->level + 1, ref->parent,
> >                                                node->bytenr,
> >                                                node->ref_mod * sgn, GFP_ATOMIC);
> > @@ -665,10 +665,9 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
> >
> >                         ref = btrfs_delayed_node_to_data_ref(node);
> >
> > -                       key.objectid = ref->objectid;
> 
> Why remove only this line and not the following 2 as well if key isn't
> used anymore?

Urr, this looks like a typo, thanks for pointing it out.

> 
> >                         key.type = BTRFS_EXTENT_DATA_KEY;
> >                         key.offset = ref->offset;
> > -                       ret = __add_prelim_ref(prefs, ref->root, &key, 0,
> > +                       ret = __add_prelim_ref(prefs, 0, NULL, 0,
> >                                                ref->parent, node->bytenr,
> >                                                node->ref_mod * sgn, GFP_ATOMIC);
> >                         break;
> 
> Do you have any reproducer to turn into an fstest? Would be nice,
> since this is a rather critical part of the code.

I do have a reproducer, but it cannot be integrated in fstests since it's
snapshot-aware defrag that helps me find this warning but right now it's
hard-code turned off.

Thanks,

-liubo

> 
> thanks
> 
> > --
> > 2.1.0
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
