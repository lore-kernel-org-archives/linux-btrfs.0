From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: mount errors
Date: Tue, 22 Nov 2011 14:56:39 +0100
Message-ID: <4ECBAA17.2070404@jan-o-sch.net>
References: <CAPWZyXa84avAjPfsv0FS8L67+uWSk0LKj7pUvLT3JM+bE4wwag@mail.gmail.com>	<ad43919226351cd8f695a0dfc44adc81@www.jots.org>	<CAPWZyXZPVXVxGo3XwTc0j6o3exk7+HnNtsaAoa0JsyrAML_CVQ@mail.gmail.com>	<CAE5mzvhbfo=LsAv8OZNjX9o=jaP0-cE4f8cTYn4EGWhxtgtsEQ@mail.gmail.com>	<CAPWZyXbfQFFxY1UMqpBYn3OnLR=tG9joEc5Mg91Gj348=8mhwg@mail.gmail.com>	<CAE5mzvixWgCDiZUEHvcRz2hXHuZyedp5H3mtwPRki2T_xutEAw@mail.gmail.com> <CAPWZyXa1Psi7cJE-Z=RK=gnaCSs7TR9Qd2fU8aPgJNjJ5h3DoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>, Ken D'Ambrosio <ken@jots.org>,
	linux-btrfs@vger.kernel.org
To: =?UTF-8?B?UmVuw6kgVmFuZ3NnYWFyZA==?= <rene.vangsgaard@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPWZyXa1Psi7cJE-Z=RK=gnaCSs7TR9Qd2fU8aPgJNjJ5h3DoA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 22.11.2011 14:26, Ren=C3=A9 Vangsgaard wrote:
> I got the build working by changing -lpthread to -pthread in the gcc =
call:
>=20
> gcc -pthread -g -O0 -o btrfs btrfs.o btrfs_cmds.o scrub.o ctree.o
> disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o
> dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o
> extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel.=
o
>  -luuid
>=20
> Using -lpthread gave a build error. I will now reboot and have a look=
=2E..

We've already queued a fix for that, it's just not pushed out yet.
-Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
