From: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: BTRFS Duplicated UUID on /home
Date: Mon, 25 Jul 2011 11:35:16 -0700
Message-ID: <CABsxX9KBhy=WzGMxN0ay28jmwkNPZa0ox1yBWoMD8TgVxPQyow@mail.gmail.com>
References: <4A4056E2BAF08843A2EC20D92A2136321572C78FE4@exch01lex.ceradyne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Bryce Myers <bmyers@ceradyne.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A4056E2BAF08843A2EC20D92A2136321572C78FE4@exch01lex.ceradyne.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 25, 2011 at 5:10 AM, Bryce Myers <bmyers@ceradyne.com> wrot=
e:
> I have 4 partitions on my hard drive
> 1 =3D /boot on ext2
> 2 =3D Swap
> 3 =3D / on brtfs
> 4 =3D /home on btrfs
>
> The uuid on partition 3 on my last boot was cloned to partition 4, so=
 when I try to mount either 3 or 4 they both mount the / partition.
>
> We tried 7182011 git, and the current version in the ARCH 1062010, an=
d neither had an option for resetting the UUID that we could find.=A0 B=
oth partitions were btrfsck'd and returned no errors.

Resetting the UUID on btrfs isn't a quick-and-easy thing - you have to
walk the entire tree and change every object. We've got a bad-hack in
meego that uses btrfs-debug-tree and changes the UUID while it runs
the entire tree, but it's ugly as hell.

You shouldn't clone btrfs really, just make a new filesystem.

Auke
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
