Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:64103 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3KKK0F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Nov 2013 05:26:05 -0500
Message-ID: <5280B0BE.90605@giantdisaster.de>
Date: Mon, 11 Nov 2013 11:26:06 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Emil Karlson <jekarlson@gmail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs-progs static compile failure due to multiple uuid-tree.o
 in linking paratemeters
References: <CAELSAVbQXyNbSpTkKjSUMzh-BYqPA-g0-AieFaG_rmpMe5vRng@mail.gmail.com>
In-Reply-To: <CAELSAVbQXyNbSpTkKjSUMzh-BYqPA-g0-AieFaG_rmpMe5vRng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 9 Nov 2013 11:22:01 +0200, Emil Karlson wrote:
> Greetings
> 
> Btrfs-progs static compile fails due to multiple uuid-tree.o in
> linking paratemeters:
> 
> build error:
> gcc -g -O1 -ffunction-sections -fdata-sections -o btrfs.static
> btrfs.static.o help.static.o  cmds-subvolume.static.o
> cmds-filesystem.static.o  cmds-device.static.o  cmds-scrub.static.o
> cmds-inspect.static.o  cmds-balance.static.o  cmds-send.static.o
> cmds-receive.static.o  cmds-quota.static.o  cmds-qgroup.static.o
> cmds-replace.static.o  cmds-check.static.o  cmds-restore.static.o
> cmds-rescue.static.o  chunk-recover.static.o  super-recover.static.o \
> ctree.static.o  disk-io.static.o  radix-tree.static.o
> extent-tree.static.o  print-tree.static.o  root-tree.static.o
> dir-item.static.o  file-item.static.o  inode-item.static.o
> inode-map.static.o  extent-cache.static.o  extent_io.static.o
> volumes.static.o  utils.static.o  repair.static.o  qgroup.static.o
> raid6.static.o  free-space-cache.static.o  uuid-tree.static.o
> list_sort.static.o  send-stream.static.o  send-utils.static.o
> rbtree.static.o  btrfs-list.static.o  crc32c.static.o
> uuid-tree.static.o -static -Wl,--gc-sections -luuid -lblkid -lm -lz
> -llzo2 -L. -lpthread
> uuid-tree.static.o: In function `btrfs_lookup_uuid_subvol_item':
> /home/jkarlson/.local/repo/btrfs-progs/uuid-tree.c:94: multiple
> definition of `btrfs_lookup_uuid_subvol_item'
> uuid-tree.static.o:/home/jkarlson/.local/repo/btrfs-progs/uuid-tree.c:94:
> first defined here
> uuid-tree.static.o: In function `btrfs_lookup_uuid_received_subvol_item':
> /home/jkarlson/.local/repo/btrfs-progs/uuid-tree.c:101: multiple
> definition of `btrfs_lookup_uuid_received_subvol_item'
> uuid-tree.static.o:/home/jkarlson/.local/repo/btrfs-progs/uuid-tree.c:101:
> first defined here
> collect2: error: ld returned 1 exit status
> make: *** [btrfs.static] Error 1
> 
> 
> I have no idea what I am doing but removing uuid-tree.o from objects
> seems to help to compile btrfs-progs both as statically and
> dynamically linked binaries:

Yes, your fix is correct.

Are you going to send this fix as a git patch (git commit -s Makefile;
git format-patch -1; git send-email --to=linux-btrfs@vger.kernel.org
*.patch)?


> diff --git a/Makefile b/Makefile
> index 4e33648..4604b1f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -9,7 +9,7 @@ CFLAGS = -g -O1
>  objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
>           root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
>           extent-cache.o extent_io.o volumes.o utils.o repair.o \
> -         qgroup.o raid6.o free-space-cache.o uuid-tree.o list_sort.o
> +         qgroup.o raid6.o free-space-cache.o list_sort.o
>  cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>                cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
>                cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \

