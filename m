From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH] Btrfs-progs: Relocate -lpthread in makefile
Date: Mon, 14 Nov 2011 16:57:08 +0100
Message-ID: <4EC13A54.6050606@jan-o-sch.net>
References: <1321285648-16237-1-git-send-email-arnd@arndnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	Sergei Trofimovich <slyfox@gentoo.org>
To: Arnd Hannemann <arnd@arndnet.de>, David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1321285648-16237-1-git-send-email-arnd@arndnet.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 14.11.2011 16:47, Arnd Hannemann wrote:
> This patch fixes the following compile error when compiled with
> gcc version 4.6.1 (Ubuntu/Linaro 4.6.1-9ubuntu3):
> 
> gcc -lpthread -g -O0 -o btrfs btrfs.o btrfs_cmds.o scrub.o \
> 		ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel.o  -luuid
> scrub.o: In function `scrub_start':
> /home/arnd/Projekte/kernel/btrfs-progs/scrub.c:1342: undefined reference to `pthread_create'
> /home/arnd/Projekte/kernel/btrfs-progs/scrub.c:1360: undefined reference to `pthread_create'
> /home/arnd/Projekte/kernel/btrfs-progs/scrub.c:1374: undefined reference to `pthread_join'
> /home/arnd/Projekte/kernel/btrfs-progs/scrub.c:1430: undefined reference to `pthread_cancel'
> /home/arnd/Projekte/kernel/btrfs-progs/scrub.c:1432: undefined reference to `pthread_join'
> collect2: ld returned 1 exit status
> make: *** [btrfs] Error 1
> 
> The gcc man page says: "[...] the placement of the -l option is significant." so lets include -lpthread together with the usual $(LIBS)
>
> Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

Sergei also sent this patch a week ago. I agree with you. David, do you
want to investigate the -pthread option?

-Jan
