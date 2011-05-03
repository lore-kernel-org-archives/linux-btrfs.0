From: Chris Mason <chris.mason@oracle.com>
Subject: Re: abysmal performance
Date: Tue, 03 May 2011 08:52:30 -0400
Message-ID: <1304427015-sup-4772@think>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com> <20110430235539.6205.qmail@stuge.se> <ipolll$2h0$1@dough.gmane.org> <1304420831-sup-4737@think> <4DBFE75C.2000104@birkenwald.de> <1304422493-sup-6212@think> <4DBFEA48.3000406@birkenwald.de>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bernhard Schmidt <berni@birkenwald.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DBFEA48.3000406@birkenwald.de>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Bernhard Schmidt's message of 2011-05-03 07:43:04 -0400:
> Hi,
> 
> > Using compression is not a problem, but in order to reduce the maximum
> > amount of ram we need to uncompress an extent, we enforce a max size on
> > the extent.  So you'll tend to have more extents, but they should be
> > close together on disk.
> > 
> > Could you please do a filefrag -v on the file?  Lets see how bad it
> > really is.
> 
> 
> root@schleppi:~# filefrag -v
> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
> Filesystem type is: 9123683e
> File size of /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1 is
> 9361528 (2286 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       0  4542111              32
>    1      32  4542134  4542142     32
>    2      64  4573263  4542165     32

Ok, looks like we could be doing a little better job when compression is
on to build out a bigger extent.  This shouldn't be causing trouble on
an ssd at all but on your rotating disk it'll be slightly slower.

Still most of these extents are somewhat close together, this is roughly
what mount -o ssd (which is enabled automatically when we detect a
non-rotating drive) would try for.

The problematic files are going to have thousands of extents, this file
should be fine.

-chris
