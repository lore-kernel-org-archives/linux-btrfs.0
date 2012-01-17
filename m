From: Kyle Gates <kylegates@hotmail.com>
Subject: btrfs-progs compile warnings on x86
Date: Tue, 17 Jan 2012 13:17:39 -0600
Message-ID: <COL113-W26B06C5519CFEB29075D36B0800@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


When compiling btrfs-progs (2011-12-01) from git://git.kernel.org/pub/s=
cm/linux/kernel/git/mason/btrfs-progs.git on 3.2.1-030201-generic #2012=
01121644 SMP Thu Jan 12 21:53:24 UTC 2012 i686 athlon i386 GNU/Linux
I get the following warnings:

ls btrfs_cmds.c
btrfs_cmds.c
gcc -Wp,-MMD,./.btrfs_cmds.o.d,-MT,btrfs_cmds.o -Wall -D_FILE_OFFSET_BI=
TS=3D64 -D_FORTIFY_SOURCE=3D2 -g -O0 -c btrfs_cmds.c
btrfs_cmds.c: In function =E2__ino_to_path_fd=E2:
btrfs_cmds.c:1138:15: warning: cast from pointer to integer of differen=
t size [-Wpointer-to-int-cast]
btrfs_cmds.c: In function =E2do_logical_to_ino=E2:
btrfs_cmds.c:1242:15: warning: cast from pointer to integer of differen=
t size [-Wpointer-to-int-cast]

Thanks,
Kyle
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
