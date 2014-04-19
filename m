Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51666 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbaDSX3n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 19:29:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WbehV-0004lB-23
	for linux-btrfs@vger.kernel.org; Sun, 20 Apr 2014 01:29:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 01:29:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 01:29:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Balance interrupted twice, not mountable fs
Date: Sat, 19 Apr 2014 23:29:25 +0000 (UTC)
Message-ID: <pan$b8c4e$f96906f0$ac0968d6$6ffcafe7@cox.net>
References: <CAOTaaruU9MWeSmeYkhmhutjL5LE5aj9SDyb4G9XuqgLD647z0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dario Santamaria posted on Sat, 19 Apr 2014 13:26:42 +0200 as excerpted:

> Hi there,
> after 2 power down during "btrfs balance" (I'm a very lucky man), now my
> fs is not mountable.
> It's an SSD with btrfs as the main root partition. Have Debian testing,
> kernel 3.13.10 with btrfs-progs from git (cloned yesterday).
> I know data is there, but I can't use it.

> Btrfs v3.14.1 matrix64:~/tmpgit/btrfs-progs# mount -v -t btrfs /dev/sdb1
> ~/pendrive/
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>        missing codepage or helper program, or other error In some cases
>        useful info is found in syslog - try dmesg | tail  or so

That's the generic mount error, not even btrfs specific.  No info there 
except that it couldn't mount.  As it says, check dmesg, which follows...

> matrix64:~/tmpgit/btrfs-progs# dmesg|tail -50 [...]
> [ 3424.805108] btrfs: device label debianssd devid 1 transid 2032022
> /dev/sdb1
> [ 3565.122729] btrfs: device label debianssd devid 1 transid 2032022
> /dev/sdb1
> [ 3565.124126] btrfs: disk space caching is enabled
> [ 3565.127616] parent transid verify failed on 126732546048 wanted
> 2032022 found 2032019
> [ 3565.128113] parent transid verify failed on 126732546048 wanted
> 2032022 found 2032019
> [ 3565.128116] btrfs: failed to read tree root on sdb1
> [ 3565.134066] btrfs: open_ctree failed
> matrix64:~/tmpgit/btrfs-progs#

The verify failed reports are saying those blocks fail checksum.  It 
appears they're the root blocks for one of the trees, thus failing 
checksum there fails that tree open and thus the mount.  However, that 
too is reasonably generic for btrfs.  Tho you do have the block numbers, 
which could possibly help with debugging, etc.

> I tried all the option to mount: "recovery", "recovery,ro",
> "recovery,noatime,clear_cache", "recovery,noatime,nospace_cache" with no
> luck.

With a bit of luck the bad tree would have just been the space-cache and 
resetting it would have helped.  Given the frequent re-write of the space-
cache data that's often all it takes.  Unfortunately, not in your case.

The recovery mount option tries previous tree roots, and often, 
particularly in combination with ro so the filesystem doesn't error out 
trying to repair other damage, it can help.  But it looks like your 
filesystem is beyond its automated attempts as well.  Tho there's still 
something left to try.  See below.

> Then I tried a "./btrfs rescue chunk-recover -vy /dev/sdb1" but it
> failed with:
> 
> [...]
> Orphan Device Extents:
[...]
> Couldn't setup extent tree open with broken chunk
> error Fail to recover the chunk tree.
> 
> Full log here: http://www.freezonestudio.com/btrfs-recover.txt

I don't know enough about rescue chunk-recover to say anything 
intelligent about it, so I'll leave it as-is.

> Finally the btrfs check exit with Segmentation Fault...
> 
> matrix64:~/tmpgit/btrfs-progs# ./btrfs check --repair /dev/sdb1
[...]
> Critical roots corrupted, unable to fsck the FS
> Errore di segmentazione
> matrix64:~/tmpgit/btrfs-progs#

You left btrfs check --repair until last, good. =:^)  While it can help 
with some errors, it doesn't know how to handle others yet and can thus 
sometimes make the problem worse.  So the on-list recommendation is to 
leave it until last, either right before you give up hope and do a mkfs 
over the remains so the risk is zero anyway, or on the recommendation of 
a dev after they've examined the situation and know it won't make things 
worse.  Unfortunately, that's not well documented, and people often run 
it first.

> Any test? Any hint? Any suggestion?

Looks like you've tried /almost/ everything except letting the devs take 
a look, which is why you've posted here.  But there's one thing left to 
try, the restore tool, btrfs restore.  Quoting its wiki page:

>> The btrfs restore utility is a non-destructive method for attempting
>> to recover data from an unmountable filesystem. It makes no attempt to
>> repair the filesystem, which means that you cannot cause further
>> damage by running it.

Unless the devs pull something out of a hat, it looks like your 
filesystem is beyond recovery, but assuming you have some free space on 
another filesystem to put it, there's still a chance of getting at least 
some data off of it.  Hopefully you had backups, as recommended for btrfs 
since it's not entirely stable yet, and can recover from them at least 
older copies of whatever you can't get off of the filesystem using this 
tool.

The wiki has far more practical advice about using btrfs restore, and 
find-root to give it as good a root as possible to work with if necessary 
(as it likely will be in your case), than I have, so I'll just point you 
at it.

https://btrfs.wiki.kernel.org/index.php/Restore

Note that as of btrfs-progs 3.14 there's another potentially quite useful 
btrfs restore option, -D/--dry-run.  This isn't listed on either the wiki 
or the btrfs manpage yet, but it is listed if you run btrfs restore 
help.  The idea of this option is that it can give you at least some idea 
of how much can actually be restored and thus how much space you'll need 
for it.


Meanwhile, if you've not yet discovered the wiki, it's well worth taking 
a look around at other pages.  Here's the general landing page, suitable 
for bookmarking or simply memorizing:

https://btrfs.wiki.kernel.org

Or for bookmarking, here's the guides and usage information link.  The 
pages reachable from here are where you'll spend most of your time as a 
user.

https://btrfs.wiki.kernel.org/index.php/Main_Page#Guides_and_usage_information

(The restore page linked above can be reached via guides/usage, problem 
faq, #5 my filesystem won't mount and none of the above helped, is there 
any hope for my data, which links the restore page.)





-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

