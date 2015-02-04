Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35618 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbBDMS2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 07:18:28 -0500
Received: by mail-lb0-f179.google.com with SMTP id z11so231709lbi.10
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Feb 2015 04:18:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1423051853-25336-1-git-send-email-forrestl@synology.com>
References: <1423051853-25336-1-git-send-email-forrestl@synology.com>
Date: Wed, 4 Feb 2015 20:18:26 +0800
Message-ID: <CAJSVwFPsf5DUTsFCNrrfCyruTNV8-oz65KRCrZoi+uZBdWNy2g@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix find_free_dev_extent() malfunction in case
 device tree has hole
From: Forrest Liu <forrestl@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Forrest Liu <forrestl@synology.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The problem can be reproduce by following steps on 3.19-rc7 , and the
patch was tested on 3.19-rc7

mntpath=/btrfs
loopdev=/dev/loop0
filepath=/volume2/100g_image

umount $mntpath
losetup -d $loopdev
truncate --size 100g $filepath
losetup $loopdev $filepath
mkfs.btrfs -f $loopdev
mount $loopdev $mntpath

for i in `seq 1 1 100`; do
        fallocate -l 1g $mntpath/$i
done
sync
for i in `seq 1 1 95`; do
        rm $mntpath/$i
done
sync

# wait cleaner thread remove unused block group
sleep 300

fallocate -l 1g $mntpath/aaa

# failed to allocate new chunk
fallocate -l 1g $mntpath/bbb
fallocate -l 1g $mntpath/ccc
fallocate -l 1g $mntpath/ddd
fallocate -l 1g $mntpath/eee

Thanks,
-Forrest

2015-02-04 20:10 GMT+08:00 Forrest Liu <forrestl@synology.com>:
> If device tree has hole, find_free_dev_extent() cannot find available
> address properly.
>
> The example below, has one BIG hole in device tree, and can only
> allocate just one chunk in a transaction.
>
>     item 9 key (1 DEV_EXTENT 273841913856) itemoff 15811 itemsize 48
>         dev extent chunk_tree 3
>         chunk objectid 256 chunk offset 272759783424 length 1073741824
>     item 10 key (1 DEV_EXTENT 1071632089088) itemoff 15763 itemsize 48
>         dev extent chunk_tree 3
>         chunk objectid 256 chunk offset 1070549958656 length 1073741824
>     item 11 key (1 DEV_EXTENT 1072705830912) itemoff 15715 itemsize 48
>             dev extent chunk_tree 3
>             chunk objectid 256 chunk offset 1071623700480 length
>
> Signed-off-by: Forrest Liu <forrestl@synology.com>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> changelog:
> v2: fix typo key_offset
>     replace WARN_ON with WARN_ON_ONCE
>
>  fs/btrfs/volumes.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 50c5a87..da07eca 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1060,6 +1060,7 @@ static int contains_pending_extent(struct btrfs_trans_handle *trans,
>         struct extent_map *em;
>         struct list_head *search_list = &trans->transaction->pending_chunks;
>         int ret = 0;
> +       u64 physical_start = *start;
>
>  again:
>         list_for_each_entry(em, search_list, list) {
> @@ -1070,9 +1071,9 @@ again:
>                 for (i = 0; i < map->num_stripes; i++) {
>                         if (map->stripes[i].dev != device)
>                                 continue;
> -                       if (map->stripes[i].physical >= *start + len ||
> +                       if (map->stripes[i].physical >= physical_start + len ||
>                             map->stripes[i].physical + em->orig_block_len <=
> -                           *start)
> +                           physical_start)
>                                 continue;
>                         *start = map->stripes[i].physical +
>                                 em->orig_block_len;
> @@ -1195,8 +1196,14 @@ again:
>                          */
>                         if (contains_pending_extent(trans, device,
>                                                     &search_start,
> -                                                   hole_size))
> -                               hole_size = 0;
> +                                                   hole_size)) {
> +                               if (key.offset >= search_start)
> +                                       hole_size = key.offset - search_start;
> +                               else {
> +                                       WARN_ON_ONCE(1);
> +                                       hole_size = 0;
> +                               }
> +                       }
>
>                         if (hole_size > max_hole_size) {
>                                 max_hole_start = search_start;
> --
> 1.9.1
>
