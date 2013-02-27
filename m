Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759866Ab3B0NDq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 08:03:46 -0500
Date: Wed, 27 Feb 2013 14:03:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Shilong Wang <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/17] btrfs-progs: fix mem leak in resolve_root
Message-ID: <20130227130344.GC27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
 <1361832890-40921-15-git-send-email-sandeen@redhat.com>
 <CAP9B-QkUP7ZftFkWw-_W-K2YKT8KdymabTf2mEK8Z_mgiKaJnA@mail.gmail.com>
 <512C3BD9.6000008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512C3BD9.6000008@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 25, 2013 at 10:36:41PM -0600, Eric Sandeen wrote:
> On 2/25/13 6:36 PM, Shilong Wang wrote:
> >> --- a/btrfs-list.c
> >> +++ b/btrfs-list.c
> >> @@ -568,8 +568,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
> >>                 * ref_tree = 0 indicates the subvolumes
> >>                 * has been deleted.
> >>                 */
> >> -               if (!found->ref_tree)
> >> +               if (!found->ref_tree) {
> >> +                       free(full_path);
> >>                         return -ENOENT;
> >> +               }
> >>                 int add_len = strlen(found->path);
> >>
> >>                 /* room for / and for null */
> >> @@ -612,8 +614,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
> >>                 * subvolume was deleted.
> >>                 */
> >>                 found = root_tree_search(rl, next);
> >> -               if (!found)
> >> +               if (!found) {
> >> +                       free(full_path);
> >>                         return -ENOENT;
> >> +               }
> >>         }
> >>
> >>         ri->full_path = full_path;
> >> --
> >> 1.7.1
> > 
> > I think the patch is wrong;
> > Here we return ENOENT, it means a subvolume/snapshot deletion happens.
> > We just filter them in the filter_root, But the free work is done by
> > the function all_subvolume_free..
> > so your modification will cause a double free..
> 
> Thanks for the review.  I'll admit that when looking at too many of
> these static checker reports, sometimes things look obvious when
> they are actually subtle, and I've certainly made mistakes before. :)
> 
> However, full_path location doesn't seem to be available outside the
> scope of this function unless we exit normally and do:
> 
>         ri->full_path = full_path;
> 
>         return 0;
> }
> 
> If we exit early at the -ENOENT points, it seems that full_path
> is leaked; there are no other references to it.

I agree with you, the freed value is local.

david
