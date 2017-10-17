Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55196 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754306AbdJQXUS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 19:20:18 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e4b9X-0006gq-4T
        for linux-btrfs@vger.kernel.org; Wed, 18 Oct 2017 01:20:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.13: "error in btrfs_run_delayed_refs:3009: errno=-28 No space
 left" with 1.3TB unallocated / 737G free?
Date: Tue, 17 Oct 2017 23:19:54 +0000 (UTC)
Message-ID: <pan$7012a$2aa3b3f4$9c2bb50d$e909647e@cox.net>
References: <5de6f85d-ddff-8448-ebc3-54df455c4961@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Vladimir Panteleev posted on Tue, 17 Oct 2017 17:19:45 +0000 as excerpted:

> I'm experiencing some issues with a btrfs filesystem - mounting and
> other operations taking forever, a balance that takes hours to start and
> never completes (due to the error in the subject line), and I've also
> seen the NULL pointer dereference in free_reloc_roots which Naohiro Aota
> fixed in 4.13.5 (I was on 4.13.4 at the time).

You may be running into the huge-over-allocation bug in recent kernels.  
There's a fix that should be in 4.14 that I'd have thought would be 
backported to stable kernels by now, but perhaps not.

So your options are:

* try the balance on 4.14-rc5+, where the known bug should be fixed
* wait for 4.14 release and try the balance there
* wait for the backport to stable
* revert to an earlier kernel, say the latest 4.9-LTS series kernel, and 
try it there (tho I'm not sure if the bug had appeared yet on 4.9 or not, 
if it had, then it's as unlikely to be fixed there as in 4.13 current)

If you still see the bug on 4.14-rc5+, then you're likely running into 
some other bug that has similar effects, as to the best of my knowledge 
as a btrfs user following the list, it's fixed there.

Reverting to the long-in-the-tooth-for-btrfs 4.4 LTS series should be 
before that bug appeared for sure, and in theory, being an LTS, it should 
have critical bug fixes since then, but I really hate to recommend it as 
a lot really has happened in btrfs since then.  Here, I'm actually 
running 4.14-rc5 (and ran 14 series from rc3 or so), tho I tend to far 
smaller partitioned btrfs and haven't run into that particular problem, 
but I'd obviously prefer 4.14-rc5 to the long-in-the-tooth-even-if-LTS 
4.4.  YMMV.

And of course your last option is to wait for a developer or regular more 
closely following that particular bug and the patch fixing it to tell you 
whether it's in 4.13.6 or not, and thus whether you're still affected by 
it, or that it must be something else with similar symptoms.  But lacking 
definitive word from them... well I'd obviously try 4.14-rc5+, since I'm 
already running it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

