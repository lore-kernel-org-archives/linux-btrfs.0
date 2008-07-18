From: "tgelter" <tgelter@gurulabs.com>
Subject: Re: Problems building btrfs
Date: Fri, 18 Jul 2008 12:51:03 -0600
Message-ID: <f70cef3dd5bd52cbf48509a8d3ab1ad9@gurulabs.com>
References: <3da3b5b40807160139w4b8e3474te113980d0086ba9c@mail.gmail.com>
            <3da3b5b40807160206h1e07033fu3fba59fd5edd7aa1@mail.gmail.com>
            <20080716120540.GH30311@unused.rdu.redhat.com>
            <3da3b5b40807160622l1f7fe447q3c40219cdae3b18@mail.gmail.com>
            <f058a9c30807170725v10f08ccft85e7427637791077@mail.gmail.com>
            <3da3b5b40807180930i7808cfc4w3432442ea7e4587f@mail.gmail.com>
            <4880C69B.7050301@gurulabs.com>
            <1216405254.6932.41.camel@think.oraclecorp.com>
Reply-To: <tgelter@gurulabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: <email.ahmedkamal@googlemail.com>, <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216405254.6932.41.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12:20 pm 07/18/08 Chris Mason <chris.mason@oracle.com> wrote:
> On Fri, 2008-07-18 at 10:36 -0600, Tim Gelter wrote:
>
> >  Hello all,
> >  I've been silently following the development of btrfs for a while
> >  now. After checking out and building the kernel module, I am
> >  unable to insmod it. It complains that it's not of a valid type.
> >  Any ideas? -Tim
> >
>
> Hello,
>
> Could you please cut n' paste the error messages, as well as anything
> from the kernel dmesg.
>
> -chris

[tgelter@guapFed kernel]$ uname -r
2.6.25.10-86.fc9.x86_64
[tgelter@guapFed kernel]$ make
make -C /lib/modules/`uname -r`/build M=`pwd` modules
make[1]: Entering directory `/usr/src/kernels/2.6.25.10-86.fc9.x86_64'
  Building modules, stage 2.
  MODPOST 1 modules
make[1]: Leaving directory `/usr/src/kernels/2.6.25.10-86.fc9.x86_64'
[tgelter@guapFed kernel]$ su -
Password or swipe finger: 
[root@guapFed ~]# cd /home/tgelter/btrfs/kernel/
[root@guapFed kernel]# modprobe libcrc32c
[root@guapFed kernel]# lsmod | grep libcrc32c
libcrc32c              11008  0 
[root@guapFed kernel]# insmod btrfs.ko
insmod: error inserting 'btrfs.ko': -1 Invalid module format
[root@guapFed kernel]# 

[root@guapFed kernel]# dmesg
---snip---
btrfs: version magic '2.6.25.10-86.fc9.x86_64stripped SMP mod_unload '
should be '2.6.25.10-86.fc9.x86_64 SMP mod_unload '
---snip---


Looks like I've got some residue of a custom kernel compile I was trying
before cached somewhere. I haven't the foggiest idea how to get things
straightened out...looks like I'll be hitting up freenode's #fedora for
help.

