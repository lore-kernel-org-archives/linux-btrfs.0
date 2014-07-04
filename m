Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37109 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaGDELH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 00:11:07 -0400
Date: Thu, 3 Jul 2014 21:11:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: Liu Bo <bo.li.liu@oracle.com>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.15.1: kernel BUG at fs/btrfs/locking.c:269
Message-ID: <20140704041102.GS11539@merlins.org>
References: <20140702204152.GI20961@merlins.org> <20140703081318.GB20612@localhost.localdomain> <53B5125F.4070707@cn.fujitsu.com> <20140703134421.GS26932@merlins.org> <53B62481.3030606@cn.fujitsu.com> <20140702204152.GI20961@merlins.org> <20140703081318.GB20612@localhost.localdomain> <53B5125F.4070707@cn.fujitsu.com> <20140703134421.GS26932@merlins.org> <20140704030721.GE20612@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53B62481.3030606@cn.fujitsu.com> <20140704030721.GE20612@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 11:07:22AM +0800, Liu Bo wrote:
> > > >>[160562.925463] parent transid verify failed on 2776298520576 wanted 41015 found 18120
> > 
> > What should I be doing about this?
> > Does it mean that I do have some kind of corruption/damage on my
> > filesystem?
> > 
> If there is another copy for the block(RAID1, DUP, RAID5/6), it'd try to read
> the copy and repair the crc with the good one, it's all we can do about it.

Right. It's not quite my question though.
I mean I don't know what device it's on, never mind what file is affected.
If I know which file is corrupted, I can simply delete it and restore from
backup, no biggie.
Right now I don't even know which one of my 3 btrfs filesystems (over 10TB)
has this problem. That makes the message kind of problematic: "you have a
problem, but not I'm not giving you any fighting chance of finding out
where" :)
 
> > Also, is it possible to have all these messages state which devid they
> > occurred on? I don't even know which device I should be worrying about
> > right now, and although I'm running scrub now, my understanding is that
> > scrub doesn't actually look at FS structures and is likely to miss this
> > anyway.
> 
> Yes we can but it'd need a bit more effort, for now, all device msg we've seen
> in panic info comes from sb->s_id which points to @fs_info->latest_device.

Food for though, as is the message is unfortunately close to useless, except
to an FS developer with a system that has only one btrfs filesystem.

On Fri, Jul 04, 2014 at 11:50:25AM +0800, Wang Shilong wrote:
> I am afraid, scrub maybe could not fix such kind of errors, all scrub
> doing is to verify whether checksums match and if possible use good
> mirrors to rewrite bad one.

I wouldn't be bothered if scrub can't fix it, but it would be good if it
could tell me.
 
> Such errors seem imply contention itself is corrupted, we may have passed
> checksum check after ending io, but we fail generation check afterwards.
 
So should I really replace scrub with
find / -type f -print0 | xargs grep . >/dev/null ?

Basically we need something that will scan the filesystem and ensure that
all files are reachable correctly without causing filesystem problems, and
if one is bad, output the name of the bad file(s).
Scrub only does a half job of that it seems.

> To get physical device name, we still need mirror num to know which device
> we are locating.

Ok, so it's missing for now and therefore the code can't easily report it,
I understand.

Well, I explained the problem, ext4 and others of course tell me which devid
an error is on, hopefully btrfs will able to do so in the near future.

Back to the original problem, would you agree that 
find / -type f -print0 | xargs grep . >/dev/nul?
may do a better job scanning the entire FS for problems than scrub would?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
