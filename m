From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Usage in embedded projects
Date: Thu, 12 Apr 2012 03:19:45 +0000 (UTC)
Message-ID: <pan.2012.04.12.03.19.45@cox.net>
References: <CA+ULb+vGT8PYDHzuJnvqpommtH6=tpu2153KQPyLsRqw1t=0TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Roman Shaposhnik posted on Wed, 11 Apr 2012 18:08:47 -0700 as excerpted:

> after attending Chris' presentation at Linux Foundation Summit I got
> really excited about the potential for using btrfs in some of the
> embedded projects that I do. With that in mind, here's a couple of
> question (feel free to vector me off to an FAQ ;-)):
>   * does anybody on this list have any experience with btrfs in the
> embedded space?
>      OpenWRT/OpenEmbedded or anything else? Most of my projects are MIPS
>      (some are ARM).
>   * what's the kernel/userland versions that I should start with?
>   * is there any reason for a restriction to the size of the device
>   (>=256 MB)?
>     256MB is a lot for an embedded application.

I claim no embedded knowledge and actually am waiting for a particular 
feature that's not in mainline yet so I'm not actually running btrfs here 
yet, but you asked for a FAQ and didn't mention the existing ones or the 
wikis in general, so...

There's actually two wikis ATM, the static and quite dated (from pre-
kernel.org-breakin) but official looking kernel.org URL wiki, and a 
"temporary" one created in the wake of the breakin that's looking like it 
might ultimately be permanent.  Here's the links for both...

outdated: https://btrfs.wiki.kernel.org/

current: http://btrfs.ipv5.de/index.php?title=Main_Page

Some quick points:

AFAIK, the 256 MB minimum is gone with 3.2 or so.  You *WILL* want the 
equally recent mixed-mode (data/metadata mixed together), however, for 
something that small, but it's now the default under a gig anyway.  (I 
know this one since that was one of the issues I asked about while 
planning my own eventual upgrade... I currently have a 128 MB /boot 
partition.)

FWIW, btrfs' default is single-mode data, dup-mode metadata.  You can 
read more about it on the wiki, but for smaller filesystems, you may not 
have room for the duped metadata.  And if you're not duping metadata 
anyway, you may wish to consider whether you want checksumming at all, 
thus reducing metadata size further.  It /may/ also affect speed on 
embedded platforms, tho it's not so much a factor for non-embedded.  But 
that of course kills one of the big selling points of btrfs, its 
automatic checksumming and error detection/correction.  There's other 
similar mount option and etc tradeoff choices to make, too, so pay 
attention to those bits on the wiki.


Kernel and btrfs-tools versions?  btrfs is still under very heavy 
development, with bugs actively being reported, tracked down and fixed 
here on this list.  As such, the general rule is to run the newest 
versions possible and to actively follow this list for current 
developments.  That normally means following the latest linus-mainline 
kernel release, if not the rcs, if not the btrfs-next branch pre-
integration with mainline.  If you're running more than a version behind, 
that's normally considered OLD and of little testing value (if you've 
kept up, that's all btrfs is considered ready for now, testing, official 
oracle, etc, support not withstanding), as a lot of bugs have been fixed 
since then, while others may well have just been exposed and need testing 
to trigger and then reported.

If you've noted, I said "normally".  There's apparently an active 
regression in 3.3, and while 3.4 may correct it, there's another active 
regression there, tho they've traced it and should have a fix in by 3.4-
rc4 or so.  Of course the last few weeks of list archives have the 
details, thus the emphasis on keeping up with current status on the list, 
but at the moment there's an exception to the general "absolute 
latest" (unless you want to try the btrfs-next tree), and you might want 
to stick with the latest stable 3.2.x for a couple weeks.

If from that you get the picture that btrfs isn't ready for anything 
besides testing data, you've been paying attention! =:^)  Of course 
backups are always recommended, even with stable filesystems, but btrfs 
goes way beyond that.  With a stable filesystem, your backup is just 
that, a backup to your "real" data.  With current btrfs, the best 
approach is to consider anything on btrfs testing-only throw-away 
temporary data.  You really SHOULD be considering the data on another non-
btrfs volume your primary data, with it backed up as you would any data 
you value, and the copy you're testing btrfs with exactly what I said 
above, testing-only, no big deal if btrfs eats it, because testing for 
and reporting that sort of thing are ideally exactly why you're running 
btrfs at this point anyway.

If that hasn't scared you way yet, welcome to btrfs testing, have a read 
of the wiki and a couple weeks of btrfs list archives to get oriented, 
and looking forward to seeing your reports of any issues you find with 
embedded use specifically, but in general as well. =:^)

Alternatively, you may wish to do what I'm doing ATM, continue following 
the list to keep updated, but hold off on actual testing for the moment.  
(In my case, the feature I'm waiting for is N-way mirroring, at least 
three-way.  The current so-called raid1 mode is in reality only two-way-
mirroring, not N-way, with either 3-way or N-way (I'm not actually clear 
which) roadmapped for 3.5 or 3.6 at this point.  Another thing I was 
waiting for was an actual error-correcting btrfsck, which is only now 
coming available, so it's coming, but I have 1-2 kernel cycles to wait 
for my critical feature, which is fine with me, since btrfs is starting 
to mature now and should be much improved in that time, thus less risk 
and hassle for me. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

