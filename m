Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54222 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbaD1UfH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Apr 2014 16:35:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WesGW-00088V-2V
	for linux-btrfs@vger.kernel.org; Mon, 28 Apr 2014 22:35:04 +0200
Received: from 5ED60B40.cm-7-7a.dynamic.ziggo.nl ([94.214.11.64])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 22:35:04 +0200
Received: from jaap by 5ED60B40.cm-7-7a.dynamic.ziggo.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 22:35:04 +0200
To: linux-btrfs@vger.kernel.org
From: Jaap Pieroen <jaap@pieroen.nl>
Subject: Re: "kernel BUG at =?utf-8?b?L2hvbWUvYXB3L0NPRC9saW51eC9mcy9idHJmcy9leHRlbnRfaW8uYzoyMTE2ISI=?= when deleting device or balancing filesystem.
Date: Mon, 28 Apr 2014 20:30:55 +0000 (UTC)
Message-ID: <loom.20140428T222711-911@post.gmane.org>
References: <C25AA8A9-30B0-4D00-80B5-B681D93D67A3@pieroen.nl> <pan$2abc$efe882ea$fdd493d$5779ebd8@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> 
> Jaap Pieroen posted on Sun, 27 Apr 2014 18:30:19 +0200 as excerpted:
> 
> > ... <snip>
> 
> Never use btrfsck (or btrfs check) with the --repair option, unless 
> you're about ready to give up on the filesystem and do a mkfs, in which 
> case you aren't risking anything anyway, or unless a dev suggests you run 
> it.
> 
> The reason being, btrfs check --repair knows how to fix some types of 
> errors, but among the ones it doesn't know how to fix, it can sometimes 
> make the problem worse.  At some point it should know most problems and 
> at least not make them worse, but until then, it's not a good risk to 
> take unless  you really know what you're doing or it's no risk as the 
> next step is blowing away the filesystem anyway.
> 
> (btrfs check, without --repair, is fine to run, since it's read-only and 
> thus won't make anything worse.  But by the same token, it won't fix 
> anything either, it's simply informational.)

I guess I have been lucky. Unfortunately I was locked out of SSH due to
unmounting my /home folder, so I didn't copy the error message. But if memory
serves me well it only found csum errors which I guess it never corrected.

>  ...
> 
> You're behind on btrfs-tools.  =:^(  The latest version is v3.14.1.

I guess I like to install my packages via apt :). Since the error was a kernel
message I figured it was tool independent. But you are right, I should have
tried the latest tools.

> > $ sudo btrfs fi show
> > Label: btrfs_storage  uuid: 7ca5f38e-308f-43ab-b3ea-31b3bcd11a0d
> > 	Total devices 6 FS bytes used 4.57TiB
> > 	devid    1 size 1.82TiB used 1.32TiB path /dev/sde
> > 	devid    2 size 1.82TiB used 1.32TiB path /dev/sdf
> > 	devid    3 size 1.82TiB used 1.32TiB path /dev/sdg
> > 	devid    4 size 931.51GiB used 88.00GiB path /dev/sdb
> > 	devid    6 size 2.73TiB used 947.03GiB path /dev/sdh
> > 	devid    7 size 2.73TiB used 947.03GiB path /dev/sdi
> > 	
> > Btrfs v3.12
> 
> For further reference, whenever you post btrfs fi show, please post btrfs 
> fi df as well, as the two provide complementary information, and the 
> picture without both of them is incomplete.
> 
> If you'd supplied the btrfs fi df output, we could see what raid level 
> you're running for data/metadata/system, as well as which type of chunks 
> were still left on /dev/sdb.

Yep, I dropped the ball here. I did look in the wiki for a list of output
required when asking for support, but I couldn't find any. I'll make sure I add
it to the wiki for the next person.

Here is the output:

  # btrfs fi df /home/
  Data, RAID5: total=4.57TiB, used=4.57TiB
  System, RAID1: total=32.00MiB, used=352.00KiB
  Metadata, RAID1: total=7.00GiB, used=5.58GiB

Which will tell you I've been adventurous and went for raid5. :)

> 
> ...
> 
> You mentioned that you did try scrub and that it fixed some errors, which 
> would be csum errors.  But did it leave any unfixed because there wasn't 
> a second, valid copy of the invalid data with which to rewrite it?  If it 
> found and fixed all the errors, then you shouldn't be seeing further csum 
> errors like those in the log file, unless more are being created, which 
> would indicate an ongoing problem (perhaps a device going bad).

Well, in hindsight I realize the scrub actually did not fix any errors. It
reported 6 csums errors, and none of those could be fixed. Which shouldn't be a
suprise since currently scrub doesn't fix raid5 errors.

My mistake was that I thought these crc errors should be fixed by a balance
( https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg30714.html), but I
guess that only applies when you are balancing over an missing drive? I was also
under the assumption that a csum error shouldn't prevent relocation of block
groups.

> 
> Of course the kernel bug is presumably locking up your system, not 
> allowing a clean shutdown, in which case you may well have more csum 
> errors due to that.  So after rebooting, be sure to run a scrub before 
> you try to balance or device delete, and hopefully eliminate the problem.

Even when I do a 'proper' REISUB reboot?

> 
> But... since you didn't post the df output, we don't know what the 
> remaining content on the device is, data/metadata/system, nor do we know 
> what mode it is, and it could well be that scrub can't remove it due to 
> invalid csums if there's no second, valid copy, as will definitely be the 
> case if it's single or raid0 mode (with data chunks being single by 
> default, tho metadata and system chunks default to raid1 on a multi-
> device filesystem and dup on a single-device filesystem).
> 
> If there's no valid second copy to rewrite the bad one with, you may 
> simply have to figure out what file and/or snapshot(s) it belongs to and 
> delete them, fixing the bad csums that way.
>

This is what I'll do as a workaround. It's unfortunate that a balance didn't
seem to take care of these checksum errors.

> 
> Of course that's assuming it's the bad csums causing the problem, not 
> something else.

I assume it is so. I deleted the files with the wrong csum and reran the device
delete command. It has managed to progress much further than before and, as i'm
writing, is near completion.

> Meanwhile, while I don't claim to be a dev nor to /really/ read code, I 
> did see some recent patches go by with comments that described bugs that 
> looked to me like they might match the problem you're reporting here, 
> specifically, failure to properly device delete under some conditions.  
> So I'd suggest updating to a current btrfs-progs v3.14.1 and see if that 
> helps.  If not, try a current v3.15-rcX testing kernel, or if you don't 
> want to try that, wait a couple stable kernel releases and see if there's 
> any btrfs patches applied.
> 
> With a bit of luck, between tracking down and eliminating the bad csums, 
> and the newer code that I think fixes at least some of the failure to 
> device delete issues, the problem will be addressed. =:^)
> 

The problems where addressed and I gained a lot of new insights. It makes me
glad that I made decided to give btrfs a try.

The take away is that:
- The 'kernel bug' message is not something alarming, but even a reasonably
  common occurrence. (though undocumented and might I say not user-friendly.
  Maybe even user scaring :o)   )
- Unresolved csum errors will disable btrfs from moving block groups around
  effectively inhibiting balancing / device deleting

How a raid5 user should be able to resolve these csum error(s), apart from
trashing the file(s) or yanking out the device containing the file and
rebalancing, is yet unclear to me. Maybe raid5 is not ready for users who want
to protect themselves agains corruption/bit rot?

Lastely: thanks a lot for this elaborate and insightful response! I realize
you have taken quite some time to give me this good in depth answer and I
appreciate it. A lot. It was very helpful.

-- Jaap

