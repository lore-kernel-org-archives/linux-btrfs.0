Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33200 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdGBNuc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jul 2017 09:50:32 -0400
Received: by mail-qt0-f196.google.com with SMTP id c20so20620859qte.0
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Jul 2017 06:50:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170626103727.8945-2-lufq.fnst@cn.fujitsu.com>
References: <20170626103727.8945-1-lufq.fnst@cn.fujitsu.com> <20170626103727.8945-2-lufq.fnst@cn.fujitsu.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Sun, 2 Jul 2017 15:50:31 +0200
Message-ID: <CAPmG0jaR89wz3GcBNxKN9-BF=QogiZo8uPi0VK2iVD8cN4Smpg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] btrfs-progs: lowmem check: Fix false alert about
 referencer count mismatch
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, marc@merlins.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 12:37 PM, Lu Fengqi <lufq.fnst@cn.fujitsu.com> wrote:
> The normal back reference counting doesn't care about the extent referred
> by the extent data in the shared leaf. The check_extent_data_backref
> function need to skip the leaf that owner mismatch with the root_id.
>
> Reported-by: Marc MERLIN <marc@merlins.org>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  cmds-check.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/cmds-check.c b/cmds-check.c
> index 70d2b7f2..f42968cd 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -10692,7 +10692,8 @@ static int check_extent_data_backref(struct btrfs_fs_info *fs_info,
>                 leaf = path.nodes[0];
>                 slot = path.slots[0];
>
> -               if (slot >= btrfs_header_nritems(leaf))
> +               if (slot >= btrfs_header_nritems(leaf) ||
> +                   btrfs_header_owner(leaf) != root_id)
>                         goto next;
>                 btrfs_item_key_to_cpu(leaf, &key, slot);
>                 if (key.objectid != objectid || key.type != BTRFS_EXTENT_DATA_KEY)
> --
> 2.13.1

With this patch applied to v4.11, I ran:
# btrfs check -p --mode lowmem /dev/mapper/smr

no 'referencer count mismatch' anymore, but likely due to other hidden
corruption, the check took more time than I had planned, so after 5
days, I cancelled it.

As a summary, both kernel and lowmem check mention the same issue as
it looks like; for the lowmem check it is this, (repeating):
[...]
parent transid verify failed on 6350669414400 wanted 24678 found 24184
parent transid verify failed on 6350645837824 wanted 24678 found 23277
Ignoring transid failure
leaf parent key incorrect 6350645837824
ERROR: extent[6349151535104 16384] backref lost (owner: 2, level: 0)
ERROR: check leaf failed root 2 bytenr 6349151535104 level 0, force
continue check
parent transid verify failed on 6350645837824 wanted 24678 found 23277
Ignoring transid failure
leaf parent key incorrect 6350645837824
ERROR: extent[6349150486528 16384] backref lost (owner: 2, level: 0)
ERROR: check leaf failed root 2 bytenr 6349150486528 level 0, force
continue check
^C

My plan is now to image the whole 8TB fs to extra/new storage hardware
with dd and then see if I can get the copy fixed. But it might take a
year before I do so (it is not critical w.r.t. data-loss, it's cold
storage, multi-year btrfs features test).
