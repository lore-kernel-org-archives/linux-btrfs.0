Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40705 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755654AbcH1RgK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 13:36:10 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1be406-0000DW-1A
        for linux-btrfs@vger.kernel.org; Sun, 28 Aug 2016 19:36:06 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfstune settings
Date: Sun, 28 Aug 2016 19:35:59 +0200
Message-ID: <20160828193559.09534344@jupiter.sol.kaishome.de>
References: <pan$852e9$bd44e66c$65d119d9$c6922137@cox.net>
        <df5ff0e5-f07b-72ca-f49f-e9cf2e2c6e39@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 28 Aug 2016 18:18:52 +0200
schrieb Oliver Freyermuth <o.freyermuth@googlemail.com>:

> (sorry if my Message-ID header is missing, I am not subscribed to the
> mailing list, so I reply using mail-archive)
> 
> > Try btrfs-show-super <device>.  The incompat_flags section
> > enumerates the flags that are on (at least with a reasonably new
> > btrfs-progs).  
> 
> Thanks a lot for this hint - I totally missed that, since I only
> looked at manpages and features of the "all-in-one" btrfs tool up to
> now. Also thanks for the hint to /sys/fs/btrfs, this is even more
> readable! 
> 
> And thanks a lot for your detailed answer(s) in general! 
> 
> > In general it should be safe to activate flags via btrfstune, but
> > since they'll generally apply only to newly written data, any
> > benefits on a mature filesystem will be limited.  For that reason
> > as well as to get the benefit of 16K nodesize which you can't
> > except at creation, I recommend backing up and recreating the
> > filesystem from a fresh mkfs.btrfs.  
> 
> That would certainly be the best option, however, 
> I have two issues with that: 
> - Any replay of a backup will do a lot of writes on the SSD, 
>   reducing lifetime. 
> - I did not yet figure out a working way to get a "complete" backup
> for a btrfs. btrfs send is too slow for me, and rsync does an
> incomplete backup, since all FS-special attrs (like the NOCOW attr
> from 'chattr +C') are not copied, even when xattr copy is on. 

Try borgbackup, I'm using it very successfully. It is very fast,
supports very impressive deduplication and compression, retention
policies, and remote backups - and it is available as a single binary
version so you can more easily use it for disaster recovery. One
downside: while it seems to restore nocow attributes, it seems to do it
in a silly way (it first creates the file, then sets the attributes,
which of course won't work for nocow). I have not checked that
extensively, only had to restore once yet.

> My last backup replay was from an rsync backup (these I do regularly) 
> and afterwards I did a manual fixing of these special attrs, which is
> some bit of extra work. Also, the machine is offline during backup
> replay, while I could still use it during a simple rebalance. 

It's hard to circumvent this. I had once the idea to rsync backups to a
btrfs device, then during recovery use it as a seeding device. I never
tried it but it could work. Your system could be almost immediately back
online this way but you'll have to do some special extra steps to get
the seeding device back into a state which you can use again for your
backups.

> The good news is my old FS already has 16K leafsize, it's only
> missing skinny metadata (and no-holes, apparently that's not default
> in mkfs.btrfs yet?). 

AFAIR no-holes and skinny-metadata can be enabled on existing
filesystems...

> This reduces the scope of my question a bit - is it sufficient and
> worthwhile to "btrfstune -x" and then "btrfs balance start
> -musage=0 /" to convert all metadata, and thus gain some space? 

Not sure... Especially about no-holes. You could also try to
"defragment" meta data using

$ find /mnt/btrfs-pool -type d -print0 | xargs -0 btrfs fi defrag

> Or are the gains not worth it and I should just wait until the next
> time I need to replay a backup for other reasons? 

It's probably not worth the hassle... Wait until you are forced to
recreate the filesystem or you are having enough spare time to do it.
However, some settings can be changed for existing filesystems and I
would simply ignore the fact existing meta data needs to be converted.

-- 
Regards,
Kai

Replies to list-only preferred.

