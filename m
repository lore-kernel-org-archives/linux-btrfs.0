From: =?UTF-8?Q?Ren=C3=A9_Vangsgaard?= <rene.vangsgaard@gmail.com>
Subject: Re: mount errors
Date: Fri, 25 Nov 2011 00:04:09 +0100
Message-ID: <CAPWZyXZ9bwupQKhP+kdvYbuas5xvpYcAtm2mQLtpLrTDeVDCRw@mail.gmail.com>
References: <CAPWZyXa84avAjPfsv0FS8L67+uWSk0LKj7pUvLT3JM+bE4wwag@mail.gmail.com>
	<ad43919226351cd8f695a0dfc44adc81@www.jots.org>
	<CAPWZyXZPVXVxGo3XwTc0j6o3exk7+HnNtsaAoa0JsyrAML_CVQ@mail.gmail.com>
	<CAE5mzvhbfo=LsAv8OZNjX9o=jaP0-cE4f8cTYn4EGWhxtgtsEQ@mail.gmail.com>
	<CAPWZyXbfQFFxY1UMqpBYn3OnLR=tG9joEc5Mg91Gj348=8mhwg@mail.gmail.com>
	<CAE5mzvixWgCDiZUEHvcRz2hXHuZyedp5H3mtwPRki2T_xutEAw@mail.gmail.com>
	<CAPWZyXa1Psi7cJE-Z=RK=gnaCSs7TR9Qd2fU8aPgJNjJ5h3DoA@mail.gmail.com>
	<4ECBAA17.2070404@jan-o-sch.net>
	<CAPWZyXZkdnaXJhEWW81LuaEHtMDEQgMBfOKGZCu8y_cMF1JQAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>, "Ken D'Ambrosio" <ken@jots.org>,
	linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPWZyXZkdnaXJhEWW81LuaEHtMDEQgMBfOKGZCu8y_cMF1JQAA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

After reboot my partition table was gone, and neither gpart og
testdisk could recover it. Sad.

Even though the missing partition table right after upgrading
btrfs-tools is a coincidence, I will wait a while before giving btrfs
another chance.

Best of luck with creating a fsck for this promising file system.

-Ren=C3=A9

On 22 November 2011 15:24, Ren=C3=A9 Vangsgaard <rene.vangsgaard@gmail.=
com> wrote:
> I did a reboot, and now I am trying to recover from a disk with no
> partition table. Currently gpart has been running for 30 mins - stupi=
d
> me for not printing the partition table.
>
> I did nothing more than executing "make" and "make install" in ./btrs=
-progs/.
>
> On 22 November 2011 13:56, Jan Schmidt <list.btrfs@jan-o-sch.net> wro=
te:
>> On 22.11.2011 14:26, Ren=C3=A9 Vangsgaard wrote:
>>> I got the build working by changing -lpthread to -pthread in the gc=
c call:
>>>
>>> gcc -pthread -g -O0 -o btrfs btrfs.o btrfs_cmds.o scrub.o ctree.o
>>> disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o
>>> dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o
>>> extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabe=
l.o
>>> =C2=A0-luuid
>>>
>>> Using -lpthread gave a build error. I will now reboot and have a lo=
ok...
>>
>> We've already queued a fix for that, it's just not pushed out yet.
>> -Jan
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
