Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50186 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbcG1FOK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 01:14:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bSde4-0004WK-HR
	for linux-btrfs@vger.kernel.org; Thu, 28 Jul 2016 07:14:08 +0200
Received: from ip-64-134-228-15.public.wayport.net ([64.134.228.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 07:14:08 +0200
Received: from 1i5t5.duncan by ip-64-134-228-15.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 07:14:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi defrag does not defrag files >256kB?
Date: Thu, 28 Jul 2016 05:14:03 +0000 (UTC)
Message-ID: <pan$aef9a$f7db9e1f$4c68e09$be53f063@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <CAD=QJKjoSR8R_hDnr4sgWizMugp+jvmHQwT-SMDdNJH=G9HEkw@mail.gmail.com>

Nicholas D Steeves posted on Wed, 27 Jul 2016 13:19:01 -0400 as excerpted:

> Is there any reason why defrag without -t cannot detect and default to
> the data chunk size, or why it does not default to 1 GiB?

I don't know the answer, but have wondered that myself.  256 KiB seems a 
rather small default, to me.  I'd expect something in the MiB range, at 
least, maybe the same 2 MiB that modern partitioners tend to use for 
alignment, for the same reason, that tends to be a reasonable whole 
multiple of most erase-block sizes, and if the partition is aligned, 
should prevent unnecessary read-modify-write cycles on ssd, and help with 
tiled zones on SMR drives as well.

As to the question in the subject line, AFAIK btrfs fi defrag works on 
extents, not filesize per-se, so using the default 256 KiB target, yes 
it'll defrag files larger than that, but only for extents that are 
smaller than that.  If all the extents are 256 KiB plus, defrag won't do 
anything with it without a larger target option or unless the compress 
option is also used, in which case it rewrites everything it is pointed 
at, in ordered to recompress it.

Talking about compression, it's worth mentioning that filefrag doesn't 
understand btrfs compression either, and will count each 128 KiB 
(uncompressed size) compression block as a separate extent.  To get the 
true picture using filefrag, you need to use verbose and either eyeball 
the results manually or feed them into a script that processes the 
numbers and combines "extents" if they are reported as immediately 
consecutive on the filesystem.

As such, filefrag, given the regular opportunistic compression, turns out 
to be a good method of determining whether a file (of over 128 KiB in 
size) is actually compressed or not, since if it is filefrag will report 
multiple 128 KiB extents, while if it's not, extent size should be much 
less regular, likely with larger extents unless the file is often 
modified and rewritten in-place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

