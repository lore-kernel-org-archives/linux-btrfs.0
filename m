Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:34450 "EHLO
	homiemail-a52.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753541Ab3GBPm7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jul 2013 11:42:59 -0400
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unclean shutdown and space cache rebuild
Date: Tue, 02 Jul 2013 21:19:07 +0530
Message-ID: <14300696.s96c8th5lD@bheem>
In-Reply-To: <pan$57f3a$a89b75ab$e2d2d0f4$5964d331@cox.net>
References: <11441914.sRzrmH57Vq@bheem> <1792894.GCCHX1XfTr@bheem> <pan$57f3a$a89b75ab$e2d2d0f4$5964d331@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, July 02, 2013 01:00:29 PM Duncan wrote:
> Just to be clear, your system, your call.  I'd never /dream/ of
> interfering with that due to the implications for my own system (which is
> certainly highly customized even matched against a peer-group of other
> gentoo installs =:^).  That said...
> 
> I'm guessing what you experiences with the autodefrag mount option was
> because you were not in stable-state yet.  The original btrfs filesystem
> setup and fill was very likely without the flag on[2], so there's quite a
> lot of existing fragmentation what would have to be worked thru before
> the filesystem gets defragged and you reach stable-state, at which I'd
> expect the autodefrag mount option to have little overhead.

Yes, I suspect as much. One of the data parition I have is over an year old 
and never defragged, /home about 3 months old.

and I can see the defragmentation working when run by hand. The initial run on 
/var(only directories, to defrag metadata) was 6 min. Now that I am running it 
daily by hand, entire /var(including files, that includes 1.8G pacman cache, 
few tiny postgresql databases and /var/tmp where kde generates tons of IO) 
takes about 6-7 min.

Despite of my experience with autodefrag, I want to use it because thats the 
best solution(kinda like autovacuum in postgresql) that keeps things clean, 
all the time.

> 
> Tho if what you're saying is correct[1] then it may be that the
> background defrag thread isn't (io-)niced as I would have expected it to
> be.
> 
> But I'd still expect there to be some better performance steady state
> after a few mounts gets the basic filesystem defragged.  Tho if the
> fileystem is heavily fragmented[2], in practice it may well be easier to
> backup the filesystem content, do a clean mkfs and mount with autodefrag
> and restore from backup, thus ensuring autodefrag is on while filling the
> filesystem in the first place, than to wait for autodefrag to reach a
> stable system state in normal operation over many mounts.

well, I think I will bite the bullet and defrag entire / overnight and repeat 
the autodefrag mount option. That should work too.

Thanks

-- 
Regards
 Shridhar
