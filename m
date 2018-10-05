Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39CFC65BA7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 09:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 838B620875
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 09:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 838B620875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbeJEQRr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 12:17:47 -0400
Received: from [195.159.176.226] ([195.159.176.226]:40322 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbeJEQRq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 12:17:46 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1g8MEs-0007YD-73
        for linux-btrfs@vger.kernel.org; Fri, 05 Oct 2018 11:17:38 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: What to do with damaged root fllesystem (opensuse leap 42.2)
Date:   Fri, 5 Oct 2018 09:17:32 +0000 (UTC)
Message-ID: <pan$7d1b$960e48ab$8c11d075$52585620@cox.net>
References: <d2d4ca86-1b51-d14f-150f-cf6b10aa44d8@swiss-wireless.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; 22c743dad)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Beat Meier posted on Wed, 03 Oct 2018 16:20:14 -0300 as excerpted:

> Hello
> 
> I'm using btrfs on opensuse leap 42.2.
> 
> This days I had a power loss and system does not mount anymore root
> filesystem with subvolumes.
> 
> My original problem in dmesg was skinny extents and space cache
> generation (...) does not match inode (...) errors.

Those are not a big deal and should be dealt with automatically, at least 
on a reasonably current kernel, so there either were other problems or 
you were using an old kernel (not being on opensuse I haven't a clue from 
the leap number what the kernel is, but at least the 4.12 kernel below is 
both a bit old and not a mainstream LTS kernel, as those were 4.14 and 
4.9).

> After investiagting a little bit I did the following commands, which
> already told me was an error...
> 
> btrfsck /dev/sdc18
> 
> several times

OK, plain btrfsck (aka btrfs check) is normally read-only, reporting 
problems but not attempting to fix them, unless --repair or one of the 
other options (--init-csum-tree, etc) was used, and that's not 
recommended until after checking with the list as it only knows how to 
fix some things and can cause further damage for others.

Assuming you didn't try repair mode at this point, why would you run it 
several times, as that does nothing but report the same problems several 
times?  And if you did try repair mode, who told you to do so and why?

> After that
> 
> btrfs rescue zero-log

Again, that's a fix for specific problems and should only be run after 
checking with the list.

> And at least
> 
> btrfs check --repair

As above, this should only be run after checking with the list, and with 
the knowledge that if it doesn't fix the problem, it might actually make 
it worse, so best to try to scrap what you can off the filesystem using a 
read-only mount if possible, or btrfs restore, /before/ trying it.

> All this was done on recues system or live system of opensuse

> Not they told me that I should do
> 
> "btrfs restore"
> 
> with guidance of the list
> 
> So please can you guide me what to do do recover filesystem....

What btrfs restore does is try to recover files off the unmountable 
filesystem, putting what it recovers elsewhere.   This is actually a good 
idea and should have been done earlier, since it doesn't further damage 
the existing filesystem, and gives you a chance at getting at the files 
before trying riskier operations like btrfs check --repair.

Of course, as the admin's first rule of backups states, the true value of 
data isn't defined by arbitrary claims, but rather, by the number of 
backups you consider it worth having of that data, just in case.  Thus, 
only data of such trivial value that it's not worth the time/trouble/
resources to back it up won't have any backups at all.

Which means that the only thing you should need btrfs restore for is a 
chance at recovering the data that has changed since your last backup, 
that was of trivial enough value it wasn't yet worth doing another backup 
yet, or that backup would have been done.

So it shouldn't be a big deal if btrfs restore doesn't work, and/or if 
you lose everything on the filesystem, since if it was of more than 
trivial value, you can simply restore from the backup that you made, 
because that's the /definition/ of data value.  Otherwise, you were 
simply defining the data as of throw-away value, not worth the trouble to 
backup, so losing it isn't a big deal.

Which takes the pressure off trying to restore or otherwise recover, 
since in any case, you always saved what was of most value to you, either 
the data because you had it backed up, or the time/trouble/resources you 
would have otherwise put into that backup, if saving that time/trouble/
resources was more valuable to you than the data you otherwise would have 
backed up.

> I have now removed disk from original system and tried to mount on leap
> 15 and of course won't work :-(
> 
> Information of my leap 15 system which has not damaged root fs of my
> leap 42.2
> 
> btrfs --version btrfs-progs v4.15
> 
> uname -a
> 
> Linux laptop 4.12.14-lp150.12.16-default #1 SMP Tue Aug 14 17:51:27 UTC
> 2018 (28574e6) x86_64 x86_64 x86_64 GNU/Linux

FWIW, when the filesystem is still mountable, it's the kernel version 
that's critical, and commands such as btrfs balance and btrfs scrub 
actually call kernel functionality to do what they do, so for them a 
current kernel will normally work best.

But once the btrfs won't mount and you're using commands like btrfs 
check, btrfs rescue, btrfs restore, etc, on the unmountable filesystem, 
it's the btrfs-progs version that's critical, and you'll normally want 
the very latest version, since that has the latest fixes and the greatest 
chance at fixing things or for restore, scraping files off the damaged 
filesystem.

So before doing the btrfs restore, you should find a current btrfs-progs, 
4.17.1 ATM, to do it with, as that should give you the best results.  Try 
Fedora Rawhide or Arch (or the Gentoo I run), as they tend to have more 
current versions.

Then you need some place to put the scraped files, a writable filesystem 
with enough space to put what you're trying to restore.

Once you have some place to put the scraped files, with luck, it's a 
simple case of running...

btrfs restore <options> <device> <path>

... where ...

<device> is the damaged filesystem

<path> is the path on the writable filesystem where you want to dump the 
restored files

and <options> can include various options as found in the btrfs-restore 
manpage, like -m/--metadata if you want to try to restore owner/times/
perms for the files, -s/--symlinks if you want to try to restore them, 
-x/--xattr if you want to try to restore them, etc.

You may want to do a dry-run with -D/--dry-run first, to get some idea of 
whether it's looking like it can restore many of the files or not, and 
thus, of the sort of free space you may need on the writable filesystem 
to store the files it can restore.


If a simple btrfs restore doesn't seem to get anything, there is an 
advanced mode as well, with a link to the wiki page covering it in the 
btrfs-restore manpage, but it does get quite technical, and results may 
vary.  You will likely need help with that if you decide to try it, but 
as they say, that's a bridge we can cross when/if we get to it, no need 
to deal with it just yet.

Meanwhile, again, don't worry too much about whether you can recover 
anything here or not, because in any case you already have what was most 
important to you, either backups you can restore from if you considered 
the data worth having them, or the time and trouble you would have put 
into those backups, if you considered saving that more important than 
making the backups.  So losing the data on the filesystem, whether from 
filesystem error as seems to be the case here, due to admin fat-fingering 
(the infamous rm -rf .* or alike), or due to physical device loss if the 
disks/ssds themselves went bad, can never be a big deal, because the 
maximum value of the data in question is always strictly limited to that 
of the point at which having a backup is more important than the time/
trouble/resources you save(d) by not having one.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

