Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35137 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755375AbcH1QTF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 12:19:05 -0400
Received: by mail-wm0-f45.google.com with SMTP id f65so50024472wmi.0
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 09:18:54 -0700 (PDT)
References: <pan$852e9$bd44e66c$65d119d9$c6922137@cox.net>
Subject: Re: btrfstune settings
To: linux-btrfs@vger.kernel.org
Cc: Oliver Freyermuth <o.freyermuth@googlemail.com>
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <df5ff0e5-f07b-72ca-f49f-e9cf2e2c6e39@googlemail.com>
Date: Sun, 28 Aug 2016 18:18:52 +0200
MIME-Version: 1.0
In-Reply-To: <pan$852e9$bd44e66c$65d119d9$c6922137@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(sorry if my Message-ID header is missing, I am not subscribed to the mailing list, 
so I reply using mail-archive)

> Try btrfs-show-super <device>.  The incompat_flags section enumerates the 
> flags that are on (at least with a reasonably new btrfs-progs).

Thanks a lot for this hint - I totally missed that, since I only looked 
at manpages and features of the "all-in-one" btrfs tool up to now. 
Also thanks for the hint to /sys/fs/btrfs, this is even more readable! 

And thanks a lot for your detailed answer(s) in general! 

> In general it should be safe to activate flags via btrfstune, but since 
> they'll generally apply only to newly written data, any benefits on a 
> mature filesystem will be limited.  For that reason as well as to get the 
> benefit of 16K nodesize which you can't except at creation, I recommend 
> backing up and recreating the filesystem from a fresh mkfs.btrfs.

That would certainly be the best option, however, 
I have two issues with that: 
- Any replay of a backup will do a lot of writes on the SSD, 
  reducing lifetime. 
- I did not yet figure out a working way to get a "complete" backup for a btrfs. 
  btrfs send is too slow for me, and rsync does an incomplete backup, 
  since all FS-special attrs (like the NOCOW attr from 'chattr +C')
  are not copied, even when xattr copy is on. 

My last backup replay was from an rsync backup (these I do regularly) 
and afterwards I did a manual fixing of these special attrs, which is some bit of extra work. 
Also, the machine is offline during backup replay, 
while I could still use it during a simple rebalance. 

The good news is my old FS already has 16K leafsize, it's only missing skinny metadata
(and no-holes, apparently that's not default in mkfs.btrfs yet?). 

This reduces the scope of my question a bit - is it sufficient and worthwhile to "btrfstune -x" 
and then "btrfs balance start -musage=0 /" to convert all metadata, and thus gain some space? 

Or are the gains not worth it and I should just wait until the next time I need to replay a backup for other reasons? 

Cheers and thanks for your reply, 
	Oliver
