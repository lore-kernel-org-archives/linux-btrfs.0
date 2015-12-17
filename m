Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2on0107.outbound.protection.outlook.com ([65.55.169.107]:7782
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932870AbbLQVpB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Dec 2015 16:45:01 -0500
From: "Langhorst, Brad" <Langhorst@neb.com>
To: Duncan <1i5t5.duncan@cox.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: need to recover large file
Date: Thu, 17 Dec 2015 21:44:58 +0000
Message-ID: <CBDB8C37-DDFF-4662-8E48-C4247FEF03C6@neb.com>
References: <E3AE2CD5-D3F1-48CF-9C5E-092DDF41AF3A@neb.com>
 <pan$8fd1f$d0a2d4bd$a145e3d0$e1171740@cox.net>
In-Reply-To: <pan$8fd1f$d0a2d4bd$a145e3d0$e1171740@cox.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have updated the btrfs tools.
The error with find roots was fixed.

I think iâ€™m making some progressâ€¦

sudo ./btrfs restore -v -o -t 25606820544512  --path-regex ^/\(\|deer\(\|/masurca\(\|/quorum_mer_db.jf\)\)\)$ /dev/sdd1 ~/recover/
parent transid verify failed on 25606820544512 wanted 21614 found 21591
parent transid verify failed on 25606820544512 wanted 21614 found 21591
parent transid verify failed on 25606820544512 wanted 21614 found 21591
parent transid verify failed on 25606820544512 wanted 21614 found 21591
Ignoring transid failure
parent transid verify failed on 25606820560896 wanted 21591 found 21611
parent transid verify failed on 25606820560896 wanted 21591 found 21611
parent transid verify failed on 25606820560896 wanted 21591 found 21611
parent transid verify failed on 25606820560896 wanted 21591 found 21611
Ignoring transid failure
leaf parent key incorrect 25606820560896
Couldn't setup extent tree
parent transid verify failed on 25606820560896 wanted 21591 found 21611
Ignoring transid failure
leaf parent key incorrect 25606820560896
Couldn't setup device tree
Could not open root, trying backup super
warning, device 6 is missing
warning, device 7 is missing
bytenr mismatch, want=25606758596608, have=0
Couldn't read chunk root
Could not open root, trying backup super
warning, device 6 is missing
warning, device 7 is missing
bytenr mismatch, want=25606758596608, have=0
Couldn't read chunk root
Could not open root, trying backup super

A bunch of data came back, but not the whole fileâ€¦
The device 6 missing sounds like btrfs restore canâ€™t find the other disks. (this is a 6 disk group - raid 0 - see below for details)

Should I be using a UUID here somehow (didnâ€™t see anything in the docsâ€¦ but maybe)?

Thanks for any advice!

Brad

â€”
Brad Langhorst, Ph.D.
Development Scientist
New England Biolabs




> On Dec 16, 2015, at 6:01 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> Langhorst, Brad posted on Wed, 16 Dec 2015 03:13:48 +0000 as excerpted:
> 
>> Hi:
>> 
>> I just screwed upÃ¢â‚¬Å  spent the last 3 weeks generting a 400G file
>> (genome assembly) .
>> Went to back it up and swapped the arguments to tar (tar Jcf my_precious
>> my_precious.tar.xz)
>> what was once 400G is now 108 bytes of xz header - argh.
>> 
>> This is on a 6-volume btrfs filesystem.
>> 
>> I immediately unmounted the fs (had to cd /  first).
>> 
>> After a bit of searching I found Chris MasonÃ¢â‚¬â„¢s post about using
>> btrfs-debug-tree -R
> 
> [Snip most of the result as I'm not familiar with this utility.  But it 
> ends with...]
> 
>> Btrfs v3.12
> 
> [...]
> 
>> I also read that one can use btrfs-find-root to get a list of files to
>> recover and just ran btrfs-find-root on one of the underlying disks but
>> I get an error "Super think's the tree root is at 25606900367360,
>> chunk root 25606758596608
>> Went past the fs size, exiting
> 
> WTF?  I thought that bug was patched a long time ago.  How old a btrfs-
> progs are you using, anyway?
> 
> *OH!* *3.12*
> 
> Why are you still using 3.12?  That's nigh back in the dark ages as far 
> as btrfs is concerned.  AFAIK, btrfs was either still labeled 
> experimental back then, or 3.12 was the first version where experimental 
> was stripped, so it's a very long time ago indeed, particularly for a 
> filesystem that while no longer experimental, is still under heavy 
> development, with bugs being fixed in every release, with the patches not 
> always reaching old stable tho since 3.12 for the kernel anyway they do 
> try, so if you're running old releases, you're code that's known to be 
> buggy and known to have fixes for those bugs in newer releases.
> 
> The general list recommendation for the kernel, unless you have a known 
> reason (like an already reported but still unfixed bug in newer), is run 
> the latest or next to latest release series of either current, which 
> would ATM be 4.3 or 4.2, as 4.4 isn't out yet, tho it's getting close, or 
> or LTS, which would be 4.1 or 3.18, tho 4.4 will be also and it's getting 
> close so you should be already preparing to upgrade to at least 4.1 if 
> you're on the LTS series.
> 
> The coverage of the penultimate series gives you some time to upgrade to 
> the latest, since the penultimate series is covered too.
> 
> For runtime, the kernel code is generally used (userspace mostly just 
> makes calls to the kernel and lets it do the work), so kernel code is 
> most important.  However, once you're trying to recover things, 
> basically, when you're working with the unmounted filesystem, userspace 
> code is used, so having something reasonably current there becomes 
> important.
> 
> As a rule of thumb, then, running a btrfs-progs userspace of at least the 
> same release series as the kernel you're running is recommended (tho 
> newer is fine), since the kernel and userspace were developed at about 
> the same time and with the same problems in mind, and if you're keeping 
> up with the kernel series recommendation, that means you're userspace 
> isn't getting /too/ old.  But even then, once you're trying to do a btrfs 
> recovery with those tools, a recommendation to try latest current can be 
> considered normal, since it'll be able to detect and usually fix the 
> latest problems.
> 
> So a 3.18 series kernel and at least a 3.18 series userspace, would be 
> recommended, and indeed, for a filesystem like btrfs that is still 
> stabilizing and not yet fully stable and mature, is quite reasonable 
> indeed.  While some people have reason to use particularly old and 
> demonstrated stable versions, and enterprise distros generally cater to 
> this need with support for upto a decade, using a still new and maturing 
> btrfs is incompatible with a need for old and demonstrated stable, so in 
> that case, from the viewpoint of this list at least, if you're looking 
> for that old and stable, you really should be using a different 
> filesystem, as btrfs simply isn't that old and stable, yet.
> 
> Meanwhile, while that's the view of upstream btrfs and thus this upstream 
> list, some distros never-the-less choose to support old btrfs, backporting 
> patches, etc, as they consider necessary.  However, that's their support 
> then, and their business.  If you're trusting them for that support, 
> really, you should be contacting them for it, as this list really isn't 
> in the best position to supply that sort of support.  Yes, they may be 
> using an old in number kernel and perhaps userspace, with newer patches 
> backported to it, but it's the distro that makes those choices and knows 
> what patches it's backporting, and thus is in the best position to 
> support it.  Not that we on the list won't try, but we're simply not in a 
> good position to provide that support that far back as we've long since 
> moved on, neither do we track what distros have backported and what they 
> haven't, etc.
> 
> 
> So, basically, you have four choices:
> 
> 1) Follow list recommendations and upgrade to something that isn't out of 
> the dark ages in terms of btrfs history.
> 
> 2) Follow the presumed recommendations of your distro, and get support 
> there, since they're best positioned to support you with those old 
> versions.
> 
> 3) Decide to take your chances at the best support we can offer given 
> your old versions, knowing it's not to the level we could offer if you 
> upgraded to something semi-current, and it might mean losing data to bugs 
> that are long since fixed in current versions.
> 
> 4) Decide that btrfs is too fast moving for your use-case as you need a 
> truly stable filesystem and tools, and switch to something more 
> appropriate to your use-case.
> 
> 
> Seriously.  I remember discussion of that bug and believe it's fixed in 
> anything even close to current userspace.  Meanwhile, the latest btrfs 
> restore works quite a bit better as well.  I know as I've used restore a 
> couple times myself, and the new version really does work a LOT better. 
> =:^)  So I really would suggest upgrading, as I think it very well might 
> eliminate the problems you're seeing and let you find and restore from a 
> good root, hopefully getting that file back.
> 
> -- 
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
