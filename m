From: =?UTF-8?Q?Ren=C3=A9_Vangsgaard?= <rene.vangsgaard@gmail.com>
Subject: Re: mount errors
Date: Tue, 22 Nov 2011 14:24:54 +0000
Message-ID: <CAPWZyXZkdnaXJhEWW81LuaEHtMDEQgMBfOKGZCu8y_cMF1JQAA@mail.gmail.com>
References: <CAPWZyXa84avAjPfsv0FS8L67+uWSk0LKj7pUvLT3JM+bE4wwag@mail.gmail.com>
	<ad43919226351cd8f695a0dfc44adc81@www.jots.org>
	<CAPWZyXZPVXVxGo3XwTc0j6o3exk7+HnNtsaAoa0JsyrAML_CVQ@mail.gmail.com>
	<CAE5mzvhbfo=LsAv8OZNjX9o=jaP0-cE4f8cTYn4EGWhxtgtsEQ@mail.gmail.com>
	<CAPWZyXbfQFFxY1UMqpBYn3OnLR=tG9joEc5Mg91Gj348=8mhwg@mail.gmail.com>
	<CAE5mzvixWgCDiZUEHvcRz2hXHuZyedp5H3mtwPRki2T_xutEAw@mail.gmail.com>
	<CAPWZyXa1Psi7cJE-Z=RK=gnaCSs7TR9Qd2fU8aPgJNjJ5h3DoA@mail.gmail.com>
	<4ECBAA17.2070404@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>, "Ken D'Ambrosio" <ken@jots.org>,
	linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ECBAA17.2070404@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

I did a reboot, and now I am trying to recover from a disk with no
partition table. Currently gpart has been running for 30 mins - stupid
me for not printing the partition table.

I did nothing more than executing "make" and "make install" in ./btrs-p=
rogs/.

On 22 November 2011 13:56, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote=
:
> On 22.11.2011 14:26, Ren=C3=A9 Vangsgaard wrote:
>> I got the build working by changing -lpthread to -pthread in the gcc=
 call:
>>
>> gcc -pthread -g -O0 -o btrfs btrfs.o btrfs_cmds.o scrub.o ctree.o
>> disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o
>> dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o
>> extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel=
=2Eo
>> =C2=A0-luuid
>>
>> Using -lpthread gave a build error. I will now reboot and have a loo=
k...
>
> We've already queued a fix for that, it's just not pushed out yet.
> -Jan
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
