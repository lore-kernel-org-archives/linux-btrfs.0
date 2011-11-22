From: =?UTF-8?Q?Ren=C3=A9_Vangsgaard?= <rene.vangsgaard@gmail.com>
Subject: Re: mount errors
Date: Tue, 22 Nov 2011 14:26:36 +0100
Message-ID: <CAPWZyXa1Psi7cJE-Z=RK=gnaCSs7TR9Qd2fU8aPgJNjJ5h3DoA@mail.gmail.com>
References: <CAPWZyXa84avAjPfsv0FS8L67+uWSk0LKj7pUvLT3JM+bE4wwag@mail.gmail.com>
	<ad43919226351cd8f695a0dfc44adc81@www.jots.org>
	<CAPWZyXZPVXVxGo3XwTc0j6o3exk7+HnNtsaAoa0JsyrAML_CVQ@mail.gmail.com>
	<CAE5mzvhbfo=LsAv8OZNjX9o=jaP0-cE4f8cTYn4EGWhxtgtsEQ@mail.gmail.com>
	<CAPWZyXbfQFFxY1UMqpBYn3OnLR=tG9joEc5Mg91Gj348=8mhwg@mail.gmail.com>
	<CAE5mzvixWgCDiZUEHvcRz2hXHuZyedp5H3mtwPRki2T_xutEAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ken D'Ambrosio" <ken@jots.org>, linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvixWgCDiZUEHvcRz2hXHuZyedp5H3mtwPRki2T_xutEAw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I got the build working by changing -lpthread to -pthread in the gcc ca=
ll:

gcc -pthread -g -O0 -o btrfs btrfs.o btrfs_cmds.o scrub.o ctree.o
disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o
dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o
extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o btrfslabel.o
 -luuid

Using -lpthread gave a build error. I will now reboot and have a look..=
=2E

On 22 November 2011 14:06, cwillu <cwillu@cwillu.com> wrote:
> On Tue, Nov 22, 2011 at 7:01 AM, Ren=C3=A9 Vangsgaard
> <rene.vangsgaard@gmail.com> wrote:
>> I have decided to update progs from git. The instructions on the wik=
i
>> do not really help me out (for example I cannot checkout branch
>> "for-chris"). Can anyone tell me what branch (probably integration) =
to
>> use on kernel 3.0.0? Or just point me to a site with working
>> instructions.
>
> Sorry, the wiki is readonly and out-of-date (fallout from the kernel.=
org woes).
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git i=
s
> receiving updates again, and should be what you want.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
