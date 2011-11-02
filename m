From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: btrfs-progs
Date: Wed, 2 Nov 2011 14:45:18 +0000
Message-ID: <CAAeznTob3MSuFksLRf0=urH0KwyZmdKzyD-=DJ+hXHpdo92yaQ@mail.gmail.com>
References: <20111101163414.b1b46d9c.b3nton@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Andrew Benton <b3nton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101163414.b1b46d9c.b3nton@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Tue, Nov 1, 2011 at 4:34 PM, Andrew Benton <b3nton@gmail.com> wrote:
> Hello,
>
> I've just pulled btrfs-progs from the new git repo
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> However, when I come to make it fails like so:
>
> gcc -Wp,-MMD,./.btrfsctl.o.d,-MT,btrfsctl.o -Wall -D_FILE_OFFSET_BITS=
=3D64 -D_FORTIFY_SOURCE=3D2 -g -Werror -Os -c btrfsctl.c
> gcc -g -Werror -Os -o btrfsctl btrfsctl.o ctree.o disk-io.o radix-tre=
e.o extent-tree.o print-tree.o root-tree.o dir-item.o file-item.o inode=
-item.o inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volume=
s.o utils.o btrfs-list.o btrfslabel.o =A0-luuid
> ls mkfs.c
> mkfs.c
> gcc -Wp,-MMD,./.mkfs.o.d,-MT,mkfs.o -Wall -D_FILE_OFFSET_BITS=3D64 -D=
_FORTIFY_SOURCE=3D2 -g -Werror -Os -c mkfs.c
> mkfs.c:39:24: fatal error: attr/xattr.h: No such file or directory
> compilation terminated.
> make: *** [mkfs.o] Error 1
> andy@eccles:~/btrfs-progs$
>
> Is attr a required dependency of btrfs-progs now?
> If I sed -i 's#attr/#sys/#' mkfs.c then it compiles and installs (I'v=
e
> not tried to use any of the tools yet). Is it wise to do this? I don'=
t
> use any extended attributes, I don't have extended attributes enabled
> in my kernel config, I have no wish to install libattr.
>
> Please CC me as I'm not subscribed,

I just cloned the repo and compiled it without problems on an
up-to-date Archlinux x86-64 system

As far as dependencies the only one needed is: libuuid
Quoting the INSTALL file:
=2E..
The Btrfs utility programs require libuuid to build.  This can be
found in the e2fsprogs sources, and is usually available as libuuid or
e2fsprogs-devel from various distros.
=2E..

As for the xattr.h file I searched my system and I am guessing my
compilation it's using the file located in /usr/include/attr/xattr.h
(because I got multiple ones in different locations)
This seems to be coming from attr package.
pkgfile /usr/include/attr/xattr.h
core/attr

But searching for this file outside that path it seems like the
linux-headers contain it as well.
So it could be a solution to use the one from the headers?

Maybe someone else can light a bit more some corners of my procedure. :=
)

Hope I helped.

Leonidas
>
> Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
