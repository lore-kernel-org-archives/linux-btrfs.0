Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42748 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbcGTWbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jul 2016 18:31:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bQ016-00059M-Dj
	for linux-btrfs@vger.kernel.org; Thu, 21 Jul 2016 00:31:00 +0200
Received: from ip1f11faa0.dynamic.kabel-deutschland.de ([31.17.250.160])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 00:31:00 +0200
Received: from hurikhan77 by ip1f11faa0.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 00:31:00 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Data recovery from a linear multi-disk btrfs file system
Date: Thu, 21 Jul 2016 00:30:52 +0200
Message-ID: <20160721003052.146a1caf@jupiter.sol.kaishome.de>
References: <A06BAA26-44FF-4947-B552-26ED228B5BF6@gmx.net>
	<179e2713-cd97-213c-3476-82f0b48c6442@gmail.com>
	<1378A988-195F-4E68-B6DE-30CEDFAC8474@gmx.net>
	<20160721001941.0352d42f@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 21 Jul 2016 00:19:41 +0200
schrieb Kai Krakow <hurikhan77@gmail.com>:

> Am Fri, 15 Jul 2016 20:45:32 +0200
> schrieb Matt <langelino@gmx.net>:
> 
> > > On 15 Jul 2016, at 14:10, Austin S. Hemmelgarn
> > > <ahferroin7@gmail.com> wrote:
> > > 
> > > On 2016-07-15 05:51, Matt wrote:    
>  [...]  
> > > The tool you want is `btrfs restore`.  You'll need somewhere to
> > > put the files from this too of course.  That said, given that you
> > > had data in raid0 mode, you're not likely to get much other than
> > > very small files back out of this, and given other factors,
> > > you're not likely to get what you would consider reasonable
> > > performance out of this either.    
> > 
> > Thanks so much for pointing me towards btrfs-restore. I surely will
> > give it a try.  Note that the FS is not a RAID0 but  linear (“JPOD")
> > configuration. This is why  it somehow did not occur to me to try
> > btrfs-restore.  The good news about in this configuration  the files
> > are *not* distributed across disks. We can  read most of the files
> > just fine.  The failed disk was actually smaller than the others
> > five so that we should be able to recover more than 5/6 of the data,
> > shouldn’t we?  My trouble is that the IO errors due to the missing
> > disk  cripple the transfer speed of both rsync and dd_rescue.
> >   
> > > Your best bet to get a working filesystem again would be to just
> > > recreate it from scratch, there's not much else that can be done
> > > when you've got a raid0 profile and have lost a disk.    
> > 
> > This is what I plan to do if there if btrfs-restore turns out to be
> > too slow and nobody on this list has any better idea.  It will,
> > however, require  transferring  >15TB across the Atlantic (this is
> > were the “backup” reside).  This can be tedious which is why I would
> > love to avoid it.  
> 
> Depending on the importance of the data it may be cheaper to transfer
> the data physically on harddisks...
> 
> However, if your backup potentially includes a lot of duplicate
> blocks, you may have a better experience using borgbackup to transfer
> the data
> - it's a free, deduplicating and compressing backup tool. If your data
> isn't already compressed and doesn't contain a lot of images, you may
> end up with 8TB or less data to transfer. I'm using borg to compress a
> 300GB server down to 50-60GB backup (and this already includes 4 weeks
> worth of retention). My home machine compresses down to 1.2TB from
> 1.8TB data with around 1 week of retention - tho I'm having a lot of
> non-duplicated binary data (images, videos, games).
> 
> When backing up across a long or slow network link, you may want to
> work with a local cache of the backup - and you may want to work with
> deduplication. My strategy is to use borgbackup to create backups
> locally, then rsync the result to the remote location.

BTW: You should start transferring the backup to your local location in
parallel to recovering your local storage. Another option would be to
recover what's possible, take a borgbackup of it, then use borg to
backup the remote location into the same repository - thanks to its
deduplication it would only transfer blocks not known locally. You then
have an option to recover data easily from both copies in the
repository. This, however, will only work properly if your remote
backup has been built using rsync (so it has the same file structure
and is not some archive format) or is extracted temporarily at the
remote location. Extra tip: borg will recover from partial
transfers, you could still parallelize both options. ;-) You just
cannot access a single backup repository concurrently.

-- 
Regards,
Kai

Replies to list-only preferred.


