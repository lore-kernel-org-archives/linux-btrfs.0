Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35957 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752560AbcH1Ioq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 04:44:46 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bdvRp-0001QI-Gz
        for linux-btrfs@vger.kernel.org; Sun, 28 Aug 2016 10:28:09 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfstune settings
Date: Sun, 28 Aug 2016 08:27:59 +0000 (UTC)
Message-ID: <pan$852e9$bd44e66c$65d119d9$c6922137@cox.net>
References: <fac36170-075c-db45-5aff-afa55bcd9e34@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oliver Freyermuth posted on Sun, 28 Aug 2016 05:42:39 +0200 as excerpted:

> Dear btrfs experts,
> 
> I hope this is the correct place to ask, the wiki and manpages did not
> help me on these questions.
> 
> BTRFS has gained extended inode refs, skinny metadata and no-holes quite
> a while ago and these are now the defaults for new mkfs.btrfs. btrfstune
> can activate those features.
> 
> However, I miss two things:
> - How do I see on an existing FS which of these features are on?
>   btrfstune (it seems) can only "set", but not "get" the feature flags.

Try btrfs-show-super <device>.  The incompat_flags section enumerates the 
flags that are on (at least with a reasonably new btrfs-progs).

> - Is it worthwhile / recommended / safe to activate those on existing
> FS?
>   Are there any steps (e.g. balancing metadata with -musage=0, I'd
>   guess) needed to make them become active afterwards?

If they're intended to be changed on an existing filesystem, btrfstune 
should allow it, otherwise it doesn't.  Node/leaf-size used to default to 
sectorsize (4K on x86/amd64), for instance, while now defaulting to 16K, 
but can't be changed on an existing filesystem, only at mkfs time, so 
that's the only place with the option.

In general it should be safe to activate flags via btrfstune, but since 
they'll generally apply only to newly written data, any benefits on a 
mature filesystem will be limited.  For that reason as well as to get the 
benefit of 16K nodesize which you can't except at creation, I recommend 
backing up and recreating the filesystem from a fresh mkfs.btrfs.

Since btrfs is considered still stabilizing, having a backup is very 
strongly recommended in any case unless the value of the data simply 
isn't worth the hassle, and once you have a backup tested, available and 
ready to use should it be necessary, blowing the existing filesystem away 
and starting with a fresh filesystem created with the options you want 
isn't much more difficult and may well be faster than a full balance 
anyway. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

