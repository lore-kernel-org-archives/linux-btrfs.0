From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sun, 26 Feb 2012 09:41:06 +0000 (UTC)
Message-ID: <pan.2012.02.26.09.41.05@cox.net>
References: <pan.2012.02.26.08.52.06@cox.net> <C3b00H6y1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Helmut Hullen posted on Sun, 26 Feb 2012 10:10:00 +0100 as excerpted:

> Just take a look at Fedora.
> The maintainers had planned to use btrfs as standard filesystem for
> Fedora 16 (but haven't done so), they had planned to use btrfs for
> Fedora 17, but perhaps hesitate, see
> 
>   https://fedorahosted.org/fesco/ticket/704
> 
> There are some other distributions which also seem to (perhaps) follow
> the "bleading edge".
> 
> And therefore end users believe that using btrfs is safe.
> (I've learned my lesson ...)
> 
> Just for the record: using btrfs (when it runs stable) may reduce many
> other problems on my system. I'm still hoping.

FWIW, until a few weeks ago I had the idea based on the general Linux 
community press that btrfs was safe and basically ready, as well.  
Luckily I research such things as filesystems a bit closer than general 
community press, before I jump, tho.  I ended up at the kernel wiki, and 
read a couple weeks worth of this list before starting to respond to 
posters, mostly quoting the wiki, and posting my own thread, asking some 
questions the wiki didn't deal with.

It turns out that the raid1 features I was most interested in, at this 
point, aren't true raid1 (that is, N-way mirror, with N corresponding to 
the number of disks/SSDs), but rather, two-way-mirror only.  Either 3-way 
or N-way mirror (it was covered as 3-way, but I'm not sure if that's 3+ 
because 2-way is covered already, or 3-way only, limiting it to 2-3-way) 
is on the roadmap to be introduced after (and building on) raid5/6, which 
is on the roadmap for kernel 3.4/3.5, so that'd put 3-way-raid1 at 
3.5/3.6, probably.  So I've not even bothered trying it yet (I've 
installed btrfs-progs and have the kernel option enabled, but haven't 
actually setup any btrfs filesystems) pending that feature introduction.  
But now that I'm here on-list, I'm sticking around to track progress, and 
to help with replies, mostly quoting wiki stuff, the manpages, etc, where 
I can.

So I'm (im)patiently waiting, but it's not too bad, because already in 
the few weeks I've been on-list, I've already seen a decent number of 
fixes including the ones for small-filesystems, so I'm watching the 
filesystem gain stability and eliminate bugs "live", and I know that by 
the time multi-way raid1 is available, the filesystem will only be more 
stable and less buggy than it is now, and that's a good thing! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

