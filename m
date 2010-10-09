From: David Nicol <davidnicol@gmail.com>
Subject: Re: revisiting "Hard link across subvolumes"
Date: Sat, 9 Oct 2010 14:26:47 -0500
Message-ID: <AANLkTinmZPV=D8y_L0Tyj2XF-ysn8+xcLXOb3DRrbWm7@mail.gmail.com>
References: <AANLkTim28O+6b86Cuoxgt5sht6KK2Xq=iwMNp46X1ceL@mail.gmail.com> <201010091544.19468.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010091544.19468.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

when i have some time to work on this I will figure out a way to pull
inodes from a larger pool or include the subvolume id at creation time
in them or something so that the collisions go away. Surely it must be
possible to prefix or suffix the inode number with a few bits that are
per-subvolume unique.

On Sat, Oct 9, 2010 at 8:44 AM, Goffredo Baroncelli <kreijack@libero.it=
> wrote:
>
> In case of a snapshot make sense to preserve the inode number.



--=20
l'=C3=A9galit=C3=A9 des droits pour les ambidextres
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
