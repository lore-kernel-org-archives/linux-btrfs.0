From: John Wyzer <john.wyzer@gmx.de>
Subject: Re: abysmal performance
Date: Sat, 30 Apr 2011 22:40:04 +0200
Message-ID: <1304195921-sup-9266@localhost>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of Sat Apr 30 19:33:16 +0200 2011:
> Also, please note that 'btrfs filesystem defragment -v /' will
> defragment the directory structure, but not the files.
[...]
> To defragment your entire volume, you'll need a command like:
> 
> # for file in $(find <PATH/TO/BTRFS/VOL/> -type f); do btrfs
> filesystem defragment ${file}; done

Thanks, I'm doing something like that at the moment (sorted the whole system
according to atimes and mtimes and started defragmenting in order of recent
access...)

However at this speed this will never end.

I'm willing to let it run some more nights however to see whether there will be
an effect in the end.

By the way: does it make a difference to run defrag on one file at a time or on
more?
At the moment I'm doing 100 files/directories  per btrfs call...

> If you just want to see your fragmentation you can use the 'filefrag'
> program from e2fsprogs:
> 
> # for file in $(find <PATH/TO/BTRFS/VOL/> -type f); do filefrag
> ${file}; done | sort -n -k 2 | less


Hmm.
Tried it and it gives me about 500000 lines of

FIBMAP: Invalid argument 

and then:

large_file: 1 extent found

Is that the way it is supposed to work?
Just asking because this was part of a vmware disk image. Both the virtual
machine and the rest of the host system are almost unusable once the VM ist
started (even more unusable than without vmware :-D )
