From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Problems Implementing Snappy Patches
Date: Wed, 15 Feb 2012 23:03:30 +0000 (UTC)
Message-ID: <pan.2012.02.15.23.03.29@cox.net>
References: <CAKcLGm_AgoHWa1TGwxz6PfSkKvxmDXi_3ykHR10WgTFVW9Gt4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Mitch Harder posted on Wed, 15 Feb 2012 16:46:00 -0600 as excerpted:

> I've been trying to test the snappy compression patches, but I'm getting
> corruptions when trying to use snappy as built on my system.
> 
> I'm checking out the Linux 3.2.6 kernel, merging that with the latest
> 'for-linus' branch on Chris Mason's kernel.org repo, and then
> integrating the snappy and lz4 patches from David Sterba's git
> repository (dev/compression-squad branch).

Given that we're past the 3.3 kernel merge window, wouldn't Chris's "for-
linus" branch be based on the patches that went into 3.3, now?  IOW, 
you're basing on 3.2.x but AFAIK you should be basing on 3.3, now, so 
you're missing the 3.3 patches which CM's for-linus tree branch should be 
assuming, at this point.

Unless you know otherwise of course.  I run the mainline tree here, and 
don't actually run anything btrfs yet, as once I started investigating I 
realized that it's missing features (like multi-mirror not just dual-
mirror) that I need, and isn't yet as stable as I had hoped, either.  So 
I don't know that much about the specifics of CM's tree, but in the 
general case, a for-linus branch would be based on 3.3 now, since it's 
well past the merge window.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

