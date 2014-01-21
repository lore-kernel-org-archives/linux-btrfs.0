Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:35663 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbaAURRe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 12:17:34 -0500
Message-ID: <52DEABC9.2040205@jrs-s.net>
Date: Tue, 21 Jan 2014 12:18:01 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Scrubbing with BTRFS Raid 5
References: <95DB9BB3-D706-4023-940A-D100D93D560A@gmail.com> <pan$226f4$e1329373$53c2dcca$438e95e@cox.net>
In-Reply-To: <pan$226f4$e1329373$53c2dcca$438e95e@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Would it be reasonably accurate to say "btrfs' RAID5 implementation is 
likely working well enough and safe enough if you are backing up 
regularly and are willing and able to restore from backup if necessary 
if a device failure goes horribly wrong", then?

This is a reasonably serious question. My typical scenario runs along 
the lines of two identical machines with regular filesystem replication 
between them; in the event of something going horribly horribly wrong 
with the production machine, I just spin up services on the replicated 
machine - making it "production" - and then deal with the broken one at 
relative leisure.

If the worst thing wrong with RAID5/6 in current btrfs is "might not 
deal as well as you'd like with a really nasty example of single-drive 
failure", that would likely be livable for me.

On 01/21/2014 12:08 PM, Duncan wrote:
 > What you're missing is that device death and replacement rarely happens
 > as neatly as your test (clean unmounts and all, no middle-of-process
 > power-loss, etc).  You tested best-case, not real-life or worst-case.
 >
 > Try that again, setting up the raid5, setting up a big write to it,
 > disconnect one device in the middle of that write (I'm not sure if just
 > dropping the loop works or if the kernel gracefully shuts down the loop
 > device), then unplugging the system without unmounting... and /then/ see
 > what sense btrfs can make of the resulting mess.  In theory, with an
 > atomic write btree filesystem such as btrfs, even that should work fine,
 > minus perhaps the last few seconds of file-write activity, but the
 > filesystem should remain consistent on degraded remount and device add,
 > device remove, and rebalance, even if another power-pull happens in the
 > middle of /that/.
 >
 > But given btrfs' raid5 incompleteness, I don't expect that will work.
 >

