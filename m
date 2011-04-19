From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: =?UTF-8?Q?fs=2Fbtrfs=2Finode=2Ec=3A6039=3A_warning=3A_=E2=80=98bio=E2=80=99_is_used_un?=
	=?UTF-8?Q?initialized_in_this_function?=
Date: Tue, 19 Apr 2011 13:00:30 +0200
Message-ID: <BANLkTi=zNkSkD7L8f0pkZ2+j5pGcGhCYJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

fs/btrfs/inode.c: In function =E2=80=98btrfs_submit_direct_hook=E2=80=99=
:
fs/btrfs/inode.c:6039: warning: =E2=80=98bio=E2=80=99 is used uninitial=
ized in this function

`BIO_BUG_ON(!atomic_read(&bio->bi_cnt))' in bio_put() later will blow u=
p nicely
when passed a random pointer on the stack.

Introduced by commit 02f57c7aedef1a537f4b16db7061cdd8efa3bb4e
("Btrfs: don't split dio bios if we don't have to").

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
