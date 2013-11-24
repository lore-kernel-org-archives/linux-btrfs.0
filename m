Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:39981 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3KXFTL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 00:19:11 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: stan@hardwarefreak.com
Subject: Re: Triple parity and beyond
Date: Sun, 24 Nov 2013 16:19:08 +1100
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <20131123181208.5103bee4@notabene.brown> <52917AA8.1040300@hardwarefreak.com>
In-Reply-To: <52917AA8.1040300@hardwarefreak.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201311241619.08668.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 24 Nov 2013, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> I have always surmised that the culprit is rotational latency, because
> we're not able to get a real sector-by-sector streaming read from each
> drive.  If even only one disk in the array has to wait for the platter
> to come round again, the entire stripe read is slowed down by an
> additional few milliseconds.  For example, in an 8 drive array let's say
> each stripe read is slowed 5ms by only one of the 7 drives due to
> rotational latency, maybe acoustical management, or some other firmware
> hiccup in the drive.  This slows down the entire stripe read because we
> can't do parity reconstruction until all chunks are in.  An 8x 2TB array
> with 512KB chunk has 4 million stripes of 4MB each.  Reading 4M stripes,
> that extra 5ms per stripe read costs us
> 
> (4,000,000 * 0.005)/3600 = 5.56 hours

If that is the problem then the solution would be to just enable read-ahead.  
Don't we already have that in both the OS and the disk hardware?  The hard-
drive read-ahead buffer should at least cover the case where a seek completes 
but the desired sector isn't under the heads.

RAM size is steadily increasing, it seems that the smallest that you can get 
nowadays is 1G in a phone and for a server the smallest is probably 4G.

On the smallest system that might have an 8 disk array you should be able to 
use 512M for buffers which allows a read-ahead of 128 chunks.

> Now consider that arrays typically have a few years on them before the
> first drive failure.  During our rebuild it's likely that some drives
> will take a few rotations to return a sector that's marginal.

Are you suggesting that it would be a common case that people just write data 
to an array and never read it or do an array scrub?  I hope that it will 
become standard practice to have a cron job scrubbing all filesystems.

> So  this
> might slow down a stripe read by dozens of milliseconds, maybe a full
> second.  If this happens to multiple drives many times throughout the
> rebuild it will add even more elapsed time, possibly additional hours.

Have you observed such 1 second reads in practice?

One thing I've considered doing is placing a cheap disk on a speaker cone to 
test vibration induced performance problems.  Then I can use a PC to control 
the level of vibration in a reasonably repeatable manner.  I'd like to see 
what the limits are for retries.

Some years ago a company I worked for had some vibration problems which 
dropped the contiguous read speed from about 100MB/s to about 40MB/s on some 
parts of the disk (other parts gave full performance).  That was a serious and 
unusual problem and it only abouty halved the overall speed.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
