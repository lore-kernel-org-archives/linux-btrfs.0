From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: Problem with latest for-linus branch
Date: Mon, 30 May 2011 13:59:30 +0200
Message-ID: <BANLkTimDsRC6yNJ0R5kbBdtTyBAmcf0FfA@mail.gmail.com>
References: <BANLkTikmYx+K9crXYFeBmsJm+qUq9_W+gQ@mail.gmail.com>
	<1306620858-sup-7865@shiny>
	<BANLkTi=FPw7RwkPW0zpD05YRtt19NrZ-5A@mail.gmail.com>
	<1306751696-sup-7618@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306751696-sup-7618@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011/5/30 Chris Mason <chris.mason@oracle.com>:
> These are perfect, thank you. =C2=A0We're failing to write out the in=
ode
> cache. =C2=A0Since you're on a 32 bit machine, I'm guessing that we f=
ailed to
> kmap something properly.

Thanks a lot for detailed info.
I recompiled, and get this:
gelma@dell:~$ gdb /lib/modules/3.0.0-rc1/kernel/fs/btrfs/*
GNU gdb (Ubuntu/Linaro 7.2-1ubuntu11) 7.2
Copyright (C) 2010 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl=
=2Ehtml>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copyi=
ng"
and "show warranty" for details.
This GDB was configured as "i686-linux-gnu".
=46or bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /lib/modules/3.0.0-rc1/kernel/fs/btrfs/btrfs.ko...=
done.
(gdb) list *__btrfs_write_out_cache+0x43a
0x5fada is in __btrfs_write_out_cache (fs/btrfs/free-space-cache.c:676)=
=2E
671				struct btrfs_free_space *e;
672=09
673				e =3D rb_entry(node, struct btrfs_free_space, offset_index);
674				entries++;
675=09
676				entry->offset =3D cpu_to_le64(e->offset);
677				entry->bytes =3D cpu_to_le64(e->bytes);
678				if (e->bitmap) {
679					entry->type =3D BTRFS_FREE_SPACE_BITMAP;
680					list_add_tail(&e->list, &bitmap_list);
(gdb)

Thanks a lot for your quick answer,
Andrea
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
