Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36294 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbbK0LHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 06:07:15 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <565834B3.4020602@gmx.de>
References: <565834B3.4020602@gmx.de>
Date: Fri, 27 Nov 2015 11:07:14 +0000
Message-ID: <CAL3q7H4F4ohPo=LK_dhT+wom7KmP7PwSqm8GzkvknPpBqbR85Q@mail.gmail.com>
Subject: Re: PAX: size overflow detected in function try_merge_map fs/btrfs/extent_map.c:238
From: Filipe Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2015 at 10:47 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> Happened today few times in a row at a stable 64 bit Gentoo hardened system:
>
>
>
> Nov 27 10:23:09 t44 kernel: [41619.519921] PAX: size overflow detected in function try_merge_map fs/btrfs/extent_map.c:238 cicus.107_102 max, count: 13, decl: block_len; num: 0; context: extent_map;
> Nov 27 10:23:09 t44 kernel: [41619.519929] CPU: 2 PID: 3361 Comm: host_jskwgen Tainted: G        W       4.2.6-hardened-r6 #3
> Nov 27 10:23:09 t44 kernel: [41619.519932] Hardware name: LENOVO 20AQCTO1WW/20AQCTO1WW, BIOS GJET83WW (2.33 ) 03/09/2015
> Nov 27 10:23:09 t44 kernel: [41619.519934]  ffffffff81831343 0000000000000000 ffffffff8183132d ffffc9000298b6e8
> Nov 27 10:23:09 t44 kernel: [41619.519939]  ffffffff815ee0ea ffff88033e30eec8 ffffffff81831343 ffffc9000298b718
> Nov 27 10:23:09 t44 kernel: [41619.519943]  ffffffff811ade1b ffff8802fb611480 ffff88032b717510 ffff88032b74fae0
> Nov 27 10:23:09 t44 kernel: [41619.519946] Call Trace:
> Nov 27 10:23:09 t44 kernel: [41619.519955]  [<ffffffff815ee0ea>] dump_stack+0x45/0x5d
> Nov 27 10:23:09 t44 kernel: [41619.519959]  [<ffffffff811ade1b>] report_size_overflow+0x3b/0x50
> Nov 27 10:23:09 t44 kernel: [41619.519963]  [<ffffffff8128c701>] try_merge_map+0x1f1/0x310
> Nov 27 10:23:09 t44 kernel: [41619.519966]  [<ffffffff8128ca82>] add_extent_mapping+0x132/0x1c0
> Nov 27 10:23:09 t44 kernel: [41619.519968]  [<ffffffff81273ea9>] btrfs_get_extent+0x659/0xdd0
> Nov 27 10:23:09 t44 kernel: [41619.519972]  [<ffffffff81197b72>] ? kmem_cache_alloc+0x32/0x140
> Nov 27 10:23:09 t44 kernel: [41619.519975]  [<ffffffff81297292>] __do_readpage+0x6f2/0xc30
> Nov 27 10:23:09 t44 kernel: [41619.519977]  [<ffffffff8129353e>] ? __set_extent_bit+0x14e/0x580
> Nov 27 10:23:09 t44 kernel: [41619.519979]  [<ffffffff81273850>] ? btrfs_real_readdir+0x6f0/0x6f0
> Nov 27 10:23:09 t44 kernel: [41619.519983]  [<ffffffff815f4869>] ? _raw_spin_unlock_irq+0x19/0x30
> Nov 27 10:23:09 t44 kernel: [41619.519985]  [<ffffffff81290e92>] ? btrfs_lookup_ordered_extent+0xa2/0xe0
> Nov 27 10:23:09 t44 kernel: [41619.519987]  [<ffffffff812979a6>] __extent_read_full_page+0x1d6/0x210
> Nov 27 10:23:09 t44 kernel: [41619.519989]  [<ffffffff81273850>] ? btrfs_real_readdir+0x6f0/0x6f0
> Nov 27 10:23:09 t44 kernel: [41619.519991]  [<ffffffff81273850>] ? btrfs_real_readdir+0x6f0/0x6f0
> Nov 27 10:23:09 t44 kernel: [41619.519993]  [<ffffffff812990bf>] extent_read_full_page+0x4f/0x80
> Nov 27 10:23:09 t44 kernel: [41619.519997]  [<ffffffff81155cf9>] ? lru_cache_add+0x19/0x30
> Nov 27 10:23:09 t44 kernel: [41619.519999]  [<ffffffff81270ac0>] ? inode_tree_add+0x150/0x150
> Nov 27 10:23:09 t44 kernel: [41619.520000]  [<ffffffff81270af4>] btrfs_readpage+0x34/0x50
> Nov 27 10:23:09 t44 kernel: [41619.520002]  [<ffffffff81270ac0>] ? inode_tree_add+0x150/0x150
> Nov 27 10:23:09 t44 kernel: [41619.520004]  [<ffffffff81147919>] do_read_cache_page+0x99/0x1b0
> Nov 27 10:23:09 t44 kernel: [41619.520006]  [<ffffffff81270ac0>] ? inode_tree_add+0x150/0x150
> Nov 27 10:23:09 t44 kernel: [41619.520008]  [<ffffffff81270ac0>] ? inode_tree_add+0x150/0x150
> Nov 27 10:23:09 t44 kernel: [41619.520009]  [<ffffffff81147a68>] read_cache_page+0x38/0x50
> Nov 27 10:23:09 t44 kernel: [41619.520012]  [<ffffffff811b4d4a>] page_getlink.isra.48.constprop.51+0x3a/0xa0
> Nov 27 10:23:09 t44 kernel: [41619.520014]  [<ffffffff811b4ddb>] page_follow_link_light+0x2b/0x50
> Nov 27 10:23:09 t44 kernel: [41619.520016]  [<ffffffff811b557f>] trailing_symlink+0x27f/0x2b0
> Nov 27 10:23:09 t44 kernel: [41619.520019]  [<ffffffff811b85db>] path_openat+0x16b/0x1700
> Nov 27 10:23:09 t44 kernel: [41619.520021]  [<ffffffff811bae21>] do_filp_open+0x81/0xf0
> Nov 27 10:23:09 t44 kernel: [41619.520024]  [<ffffffff811a4cc3>] do_sys_open+0x133/0x280
> Nov 27 10:23:09 t44 kernel: [41619.520026]  [<ffffffff811a4e41>] SyS_open+0x31/0x50
> Nov 27 10:23:09 t44 kernel: [41619.520028]  [<ffffffff815f5119>] entry_SYSCALL_64_fastpath+0x12/0x83

Try the following (also pasted at
https://friendpaste.com/5O6o1cqWqJZDIKrH1YqG7y):

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6a98bdd..26b4c13 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -235,7 +235,8 @@ static void try_merge_map(struct extent_map_tree
*tree, struct extent_map *em)
                        em->start = merge->start;
                        em->orig_start = merge->orig_start;
                        em->len += merge->len;
-                       em->block_len += merge->block_len;
+                       if (em->block_start != EXTENT_MAP_HOLE)
+                               em->block_len += merge->block_len;
                        em->block_start = merge->block_start;
                        em->mod_len = (em->mod_len + em->mod_start) -
merge->mod_start;
                        em->mod_start = merge->mod_start;
@@ -252,7 +253,8 @@ static void try_merge_map(struct extent_map_tree
*tree, struct extent_map *em)
                merge = rb_entry(rb, struct extent_map, rb_node);
        if (rb && mergable_maps(em, merge)) {
                em->len += merge->len;
-               em->block_len += merge->block_len;
+               if (em->block_start != EXTENT_MAP_HOLE)
+                       em->block_len += merge->block_len;
                rb_erase(&merge->rb_node, &tree->map);
                RB_CLEAR_NODE(&merge->rb_node);
                em->mod_len = (merge->mod_start + merge->mod_len) -
em->mod_start;

>
>
> Furthermore  neither login into the KDE screen saver nor login at the console could be made, sys-rq keys didn't worked  - power off was my friend.
>
>
>
> --
> Toralf, pgp: C4EACDDE 0076E94E
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
