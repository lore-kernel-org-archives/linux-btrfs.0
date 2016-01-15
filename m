Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbcAORvD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 12:51:03 -0500
Date: Fri, 15 Jan 2016 18:51:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH v5 0/2][PULL REQUEST] Unify 'norecovery' bahavior with
 other filesystems
Message-ID: <20160115175059.GH4227@suse.cz>
Reply-To: dsterba@suse.cz
References: <1452564313-22007-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160114160031.GB4227@twin.jikos.cz>
 <56985046.1030306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56985046.1030306@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 15, 2016 at 09:49:58AM +0800, Qu Wenruo wrote:
> David Sterba wrote on 2016/01/14 17:00 +0100:
> > On Tue, Jan 12, 2016 at 10:05:11AM +0800, Qu Wenruo wrote:
> >> 'Norecovery' mount option is almost a standard for all other
> >> filesystems, including f2fs, ext4, gfs2, nilfs2, and xfs.
> >> And since current 'recovery' mount option for btrfs is too generic, it's
> >> better to change btrfs 'recovery' to 'usebackuproot' and then we can
> >> safely add 'norecovery' and 'nologreplay' mount option for btrfs.
> >>
> >> The patch itself is not huge and already tested by others since v2.
> >> Only mount option name is changing during all these version changes.
> >
> > So we have some kind of consensus about the options, but I think you
> > need to split the patches further.
> 
> It's never a bad idea to split patches :)

My comment was motivated by the patch that introduced nologreplay and
norecovery in one go, although the functionality is logically separate
from the user's POV.

> > * the new option 'nologreplay'
> > * keep 'usebackuproot' as a new alias for 'recovery' (with the
> >    deprecation warning)
> > * new 'norecovery' that switches on 'nologreplay' and 'nousebackuproot'
> >    (ie. the desired "no writes")
> >
> > There is a case in remount, when we start with 'ro,nologreplay' then
> > remount with just 'ro', the log should be replayed. The other
> > combinations should be easy. I haven't looked at the patch if it's
> > implemented that way though.
> >
> >
> For that case, even remount with -o remount,ro the nologreplay mount 
> option won't be erased.
> That's why we added a lot of "noXXXX" mount option, or we can't disable 
> some feature by remount.

Yeah, I've realized that later that we need the 'logreplay' option to
achieve the readonly transition to the replayed state.

> And since I didn't add such "logreplay" mount option intentionally, so 
> there is no way to replay log unless umount the fs and mount it without 
> "nologreplay" again.
> 
> I'll update the patchset soon and hopes it can catch the rc1 merge window.

Yeah, I'd like to see it 4.5 as well, the topic has been discussed
enough and the implementation is simple.
