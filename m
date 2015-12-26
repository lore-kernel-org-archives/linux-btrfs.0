Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0131.smtp25.com ([75.126.84.131]:41786 "EHLO
	mail0131.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbbLZHo7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 02:44:59 -0500
From: covici@ccs.covici.com
To: Duncan <1i5t5.duncan@cox.net>
cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs problems on new file system
In-reply-to: <pan$5b392$be4c0a13$5e032f42$d915874d@cox.net>
References: <16107.1451037790@ccs.covici.com> <CAPmG0jbOu6BmKfbaoJ6pzprWzbch3tf7=zbBS8AcDz4MQVEJZA@mail.gmail.com> <18552.1451078098@ccs.covici.com> <pan$5b392$be4c0a13$5e032f42$d915874d@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 26 Dec 2015 02:44:56 -0500
Message-ID: <5624.1451115896@ccs.covici.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> wrote:

> covici posted on Fri, 25 Dec 2015 16:14:58 -0500 as excerpted:
> 
> > Henk Slager <eye1tm@gmail.com> wrote:
> > 
> >> On Fri, Dec 25, 2015 at 11:03 AM,  <covici@ccs.covici.com> wrote:
> >> > Hi.  I created a file system using 4.3.1 version of btrfsprogs and
> >> > have been using it for some three days.  I have gotten the following
> >> > errors in the log this morning:
> 
> >> > Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> >> > transid verify failed on 51776421888 wanted 4983 found 4981
> 
> [Several of these within a second, same block and transids, wanted 4983, 
> found 4981.]
> 
> >> > The file system was then made read only.  I unmounted, did a check
> >> > without repair which said it was fine, and remounted successfully in
> >> > read/write mode, but am I in trouble?  This was on a solid state
> >> > drive using lvm.
> >> What kernel version are you using?
> >> I think you might have some hardware error or glitch somewhere,
> >> otherwise I don't know why you have such errors. These kind of errors
> >> remind me of SATA/cable failures over quite a period of time (multipe
> >> days). Or something with lvm or trim of SSD.
> >> Any unusual with the SSD if you run  smartctl?
> >> A btrfs check will indeed likely result in an OK for this case.
> >> What about running read-only scrub?
> >> Maybe running  memtest86+  can rule-out the worst case.
> > 
> > I am running 4.1.12-gentoo and btrfs progs 4.3.1.  Same thing happened
> > on another filesystem, so I switched them over to ext4 and no troubles
> > since.  As far as I know the ssd drives are fine, I have been using them
> > for months.  Maybe btrfs needs some more work.  I did do scrubs on the
> > filesystems after I went offline and remounted them, and they were
> > successful, and I got no errors from the lower layers at all.  Maybe
> > I'll try this in a year or so.
> 
> Well, as I seem to say every few posts, btrfs is "still stabilizing, not 
> fully stable and mature", so it's a given that more work is needed, tho 
> it's demonstrated to be "stable enough" for many in daily use, as long as 
> they're generally aware of stability status and are following the admin's 
> rule of backups[1] with the increased risk-factor of running "still 
> stabilizing" filesystems in mind.
> 
> The very close generation/transid numbers, only two commits apart, for 
> the exact same block, within the same second, indicate a quite recent 
> block-write update failure, possibly only a minute or two old.  You could 
> tell how recent by comparing the generation/transid in the superblock 
> (using btrfs-show-super) at as close to the same time as possible, seeing 
> how far ahead it is.
> 
> I'd check smartctl -A for the device(s), then run scrub and check it 
> again, to see if the raw number for ID5, Reallocated_Sector_Ct (or 
> similar for your device) changed.  (I have some experience with this.[2])
> 
> If the raw reallocated sector count goes up, it's obviously the device.  
> If it doesn't but scrub fixes an error, then it's likely elsewhere in the 
> hardware (cabling, power, memory or storage bus errors, sata/scsi 
> controller...).  If scrub detects but can't fix the error the lack of fix 
> is probably due to single mode, with the original error due possibly to a 
> bad shutdown/umount or a btrfs bug.  If scrub says it's fine, then 
> whatever it was was temporary could be due to all sorts of things, from a 
> cosmic ray induced memory error, to btrfs bug, to...
> 
> In any case, if scrub fixes or doesn't detect an error, I'd not worry 
> about it too much, as it doesn't seem to be affecting operation, you 
> didn't get a lockup or backtrace, etc.  In fact, I'd take that as 
> indication of btrfs normal problem detection and self-healing, likely due 
> to being able to pull a valid copy from elsewhere due to raidN or dup 
> redundancy or parity.
> 
> Tho there's no shame in simply deciding btrfs is still too "stabilizing, 
> not fully stable and mature" for you, either.  I know I'd still hesitate 
> to use it in a full production environment, unless I had both good/tested 
> backups and failover in place.  "Good enough for daily use, provided 
> there's backups if you don't consider the data throwaway", is just that; 
> it's not really yet good enough for "I just need it to work, reliably, 
> because it's big money and people's jobs if it doesn't."
> 
> ---
> [1] Admin's rule of backups:  For any given level of backup, you either 
> have it, or by your actions are defining the data to be of less value 
> than the hassle and resources taken to do the backup, multiplied by the 
> risk factor of actually needing that backup.  As a consequence, after the 
> fact protests to the contrary are simply lies, as actions spoke louder 
> than words and they defined the time and hassle saved as more valuable, 
> so the valuable was saved in any case and in this case the user should be 
> happy they saved the more valuable hassle and resources even if the data 
> got lost.
> 
> And of course with btrfs still stabilizing, that risk factor remains 
> somewhat elevated, meaning more levels of backups need to be kept, for 
> relatively lower value data.
> 
> But AFAIK, you've stated elsewhere that you have backups, so this is more 
> for completeness and for other readers than for you, thus its footnoting, 
> here.

...
...

The show stopper for me was that the file system was put into read only
mode and even though scrub was fine, which would not run in read only
mode, I had to unmount the fs, and  run the check, which maybe I didn't
really need to do and remount, which for me is not practical to do.  So,
even though I had no actual data loss, I had to say it was not worth it
for the time being.

-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
