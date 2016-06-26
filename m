Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36696 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbcFZCay (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 22:30:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bGzqV-0007NJ-Il
	for linux-btrfs@vger.kernel.org; Sun, 26 Jun 2016 04:30:52 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 04:30:51 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 04:30:51 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Trying to rescue my data :(
Date: Sun, 26 Jun 2016 02:30:45 +0000 (UTC)
Message-ID: <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net>
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
	<4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
	<CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
	<dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
	<d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
	<47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au>
	<f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>
	<c87e2f76-6cd6-46a4-21ca-dc5f66898d59@crc.id.au>
	<CAJCQCtRrF-KZOo3HOzNWHwhWcDxFem-tcpGh5ScXoQM2Brosag@mail.gmail.com>
	<b578050f-1425-134b-9655-7ad36dd4b7ab@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steven Haigh posted on Sun, 26 Jun 2016 02:39:23 +1000 as excerpted:

> In every case, it was a flurry of csum error messages, then instant
> death.

This is very possibly a known bug in btrfs, that occurs even in raid1 
where a later scrub repairs all csum errors.  While in theory btrfs raid1 
should simply pull from the mirrored copy if its first try fails checksum 
(assuming the second one passes, of course), and it seems to do this just 
fine if there's only an occasional csum error, if it gets too many at 
once, it *does* unfortunately crash, despite the second copy being 
available and being just fine as later demonstrated by the scrub fixing 
the bad copy from the good one.

I'm used to dealing with that here any time I have a bad shutdown (and 
I'm running live-git kde, which currently has a bug that triggers a 
system crash if I let it idle and shut off the monitors, so I've been 
getting crash shutdowns and having to deal with this unfortunately often, 
recently).  Fortunately I keep my root, with all system executables, etc, 
mounted read-only by default, so it's not affected and I can /almost/ 
boot normally after such a crash.  The problem is /var/log and /home 
(which has some parts of /var that need to be writable symlinked into /
home/var, so / can stay read-only).  Something in the normal after-crash 
boot triggers enough csum errors there that I often crash again.

So I have to boot to emergency mode and manually mount the filesystems in 
question, so nothing's trying to access them until I run the scrub and 
fix the csum errors.  Scrub itself doesn't trigger the crash, thankfully, 
and once it has repaired all the csum errors due to partial writes on one 
mirror that either were never made or were properly completed on the 
other mirror, I can exit emergency mode and complete the normal boot (to 
the multi-user default target).  As there's no more csum errors then 
because scrub fixed them all, the boot doesn't crash due to too many such 
errors, and I'm back in business.


Tho I believe at least the csum bug that affects me may only trigger if 
compression is (or perhaps has been in the past) enabled.  Since I run 
compress=lzo everywhere, that would certainly affect me.  It would also 
explain why the bug has remained around for quite some time as well, 
since presumably the devs don't run with compression on enough for this 
to have become a personal itch they needed to scratch, thus its remaining 
untraced and unfixed.

So if you weren't using the compress option, your bug is probably 
different, but either way, the whole thing about too many csum errors at 
once triggering a system crash sure does sound familiar, here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

