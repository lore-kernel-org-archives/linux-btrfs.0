Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53008 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbcDKCaT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Apr 2016 22:30:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1apRcC-0005oI-RF
	for linux-btrfs@vger.kernel.org; Mon, 11 Apr 2016 04:30:12 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 04:30:12 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Apr 2016 04:30:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfstune -u makes filesystem unmountable
Date: Mon, 11 Apr 2016 02:30:06 +0000 (UTC)
Message-ID: <pan$70df8$76e0ce5f$a5e09485$b958241f@cox.net>
References: <CAK1feJAqOgucajbGQmZMzrdaw=BmXV9ht=Rt16Kk+X3A7Xs_oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Richard C posted on Sun, 10 Apr 2016 15:47:44 +0100 as excerpted:

> Hi,
> 
> I'm writing a backup script that images a btrfs using btrfs-image, then
> restores to a file on a loop device. Since I had trouble mounting the
> original and copied btrfs filesystems with the same UUID on the same
> machine, I decided to try btrfstune -fu. However, this appears to
> corrupt the copied filesystem altogether making fsck and mount fail.
> Details below.

Of course as Hugo mentions, btrfs-image (which is primarily a debugging 
tool simply images the metadata, not the data.  So it can't be used for 
backups, as you're doing it.

The closest thing to that would be creating a new btrfs, then using btrfs 
send on snapshots taken on the old filesystem, sent to btrfs receive on 
the new filesystem, creating a copy of the sent snapshot on the new 
filesystem.  (Unfortunately, for those using multiple subvolumes, that 
means multiple send/receives, as the recursive-send feature isn't yet 
implemented and thus doesn't work.)

> Is this a bug?
> 
> $ uname -a
> Linux adventure 3.16.0-67-generic #87~14.04.1-Ubuntu SMP Fri
> Mar 11 00:26:02 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> $ btrfs --version
> btrfs-progs v4.4

Of course you know that a 3.16 kernel isn't well supported on this list, 
right?  Btrfs is still stabilizing, and as such, that's simply too old to 
properly support on-list.

On-list kernel recommendations fall into two tracks, mainline LTS, and 
mainline current.  On the current kernel track, we recommend keeping to 
the latest couple kernel releases, which are supported with current 
kernel track stable releases.  With 4.5 the latest, that means 4.4 or 4.5 
series.

On the LTS (long-term-support) track, until recently it was again the 
latest two kernel series, but of the mainstream kernel LTS series.  4.4 
is the latest LTS series and 4.1 was the previous one.  However, as btrfs 
has continued to stabilize and mature, the previous one to that, 3.18, 
ended up reasonably stable and problem free, so while we still recommend 
the lastest two LTS series, we know some people will prefer to stick with 
3.18 awhile longer, and given that it actually has been pretty good, it's 
still reasonably acceptable as well... as long as you're not trying to do 
btrfs raid56, anyway, as it's still new enough following the current 
kernel track is recommended.

With 3.18 the oldest reasonably well supported LTS series, and 3.16 being 
previous to that, it's well out of the recommended support range.  And 
3.16 wasn't even an LTS kernel series; the one before 3.18 was 3.14, 
which was a VERY long time ago in btrfs development terms and is thus out 
of the recommended range even tho it is an LTS kernel.

Of course some distros choose to support btrfs only older kernels and we 
recognize that.  However, we focus on mainline on this list, and aren't 
in a position to track what patches may or may not have been backported 
to base-kernels that old, which means we really can't support them very 
well.  If you're relying on a distro's btrfs support on that old a 
kernel, that's really where you should be looking for support, not here, 
as we're simply not equipped to provide it.  That doesn't mean we won't 
do our best, but it does mean that the best support we're likely going to 
be able to provide in response to any reported problem is likely to be 
recommending that you upgrade to a newer kernel and see if the problem 
still exists, reporting the output, etc, there, if it does.

OTOH, you're doing great on the btrfs-tools userspace, where you're using 
4.4. =:^)  The rule of thumb there is to make sure you're using a 
userspace version at least comparable to your kernel version, which if 
you're following kernel recommendations, will ensure that you don't get 
/too/ far behind with userspace as well, since the version numbers are 
synced and a userspace release of a particular series tends to come a 
week or so after the corresponding kernel series .0 release.  So 4.4 is 
great there.  If your kernel was only as current as your userspace, you'd 
be great. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

