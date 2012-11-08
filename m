Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33838 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab2KHVfT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Nov 2012 16:35:19 -0500
MIME-Version: 1.0
In-Reply-To: <1352410044-10547-1-git-send-email-ablock84@googlemail.com>
References: <1352410044-10547-1-git-send-email-ablock84@googlemail.com>
Date: Thu, 8 Nov 2012 22:35:19 +0100
Message-ID: <CAB9VWqAJZCr5HiHwpisiuKNq0Rarba9YL9SfxudssR9YcQ75sA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: merge inode_list in __merge_refs
From: Alexander Block <ablock84@googlemail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 8, 2012 at 10:27 PM, Alexander Block
<ablock84@googlemail.com> wrote:
> When __merge_refs merges two refs, it is also needed to merge the
> inode_list of both refs. Otherwise we have missed backrefs and memory
> leaks. This happens for example if two inodes share an extent and
> both lie in the same leaf and thus also have the same parent.
>
> Signed-off-by: Alexander Block <ablock84@googlemail.com>
> Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/backref.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 208d8aa..aea6d2d 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -461,6 +461,7 @@ static int __merge_refs(struct list_head *head, int mode)
>                      pos2 = n2, n2 = pos2->next) {
>                         struct __prelim_ref *ref2;
>                         struct __prelim_ref *xchg;
> +                       struct extent_inode_elem *eie;
>
>                         ref2 = list_entry(pos2, struct __prelim_ref, list);
>
> @@ -472,12 +473,20 @@ static int __merge_refs(struct list_head *head, int mode)
>                                         ref1 = ref2;
>                                         ref2 = xchg;
>                                 }
> -                               ref1->count += ref2->count;
>                         } else {
>                                 if (ref1->parent != ref2->parent)
>                                         continue;
> -                               ref1->count += ref2->count;
>                         }
> +
> +                       eie = ref1->inode_list;
> +                       while (eie && eie->next)
> +                               eie = eie->next;
> +                       if (eie)
> +                               eie->next = ref2->inode_list;
> +                       else
> +                               ref1->inode_list = ref2->inode_list;
> +                       ref1->count += ref2->count;
> +
>                         list_del(&ref2->list);
>                         kfree(ref2);
>                 }
> --
> 1.7.10.4
>

Used wrong CC for stable list. Corrected now.
