Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33469 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdBBPGy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 10:06:54 -0500
Received: by mail-it0-f68.google.com with SMTP id e137so6054247itc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Feb 2017 07:06:53 -0800 (PST)
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
To: Adam Borowski <kilobyte@angband.pl>
References: <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
 <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
 <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
 <07bba687-64c3-6713-6f6a-c8da183cbd3d@gmail.com>
 <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
 <a5262907-06f2-2c6f-d23a-2703b10429b7@deragon.biz>
 <pan$be2e$8a233bb0$f63eb0cb$d3413db@cox.net>
 <20170201115530.l2ce5afcqld2kzi4@angband.pl>
 <pan$27de1$6045e2b1$7cc1684e$e9aac1ad@cox.net>
 <7cb699fd-44a7-d8eb-e492-c448f67b0eac@gmail.com>
 <20170202142521.nfiy73ye6bi5smjv@angband.pl>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c1c37876-68ce-8674-782e-1268631f9c2c@gmail.com>
Date: Thu, 2 Feb 2017 10:06:46 -0500
MIME-Version: 1.0
In-Reply-To: <20170202142521.nfiy73ye6bi5smjv@angband.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-02 09:25, Adam Borowski wrote:
> On Thu, Feb 02, 2017 at 07:49:50AM -0500, Austin S. Hemmelgarn wrote:
>> This is a severe bug that makes a not all that uncommon (albeit bad) use
>> case fail completely.  The fix had no dependencies itself and
>
> I don't see what's bad in mounting a RAID degraded.  Yeah, it provides no
> redundancy but that's no worse than using a single disk from the start.
> And most people not doing storage/server farm don't have a stack of spare
> disks at hand, so getting a replacement might take a while.
Running degraded is bad. Period.  If you don't have a disk on hand to 
replace the failed one (and if you care about redundancy, you should 
have at least one spare on hand), you should be converting to a single 
disk, not continuing to run in degraded mode until you get a new disk. 
The moment you start talking about running degraded long enough that you 
will be _booting_ the system with the array degraded, you need to be 
converting to a single disk.  This is of course impractical for 
something like a hardware array or an LVM volume, but it's _trivial_ 
with BTRFS, and protects you from all kinds of bad situations that can't 
happen with a single disk but can completely destroy the filesystem if 
it's a degraded array.  Running a single disk is not exactly the same as 
running a degraded array, it's actually marginally safer (even if you 
aren't using dup profile for metadata) because there are fewer moving 
parts to go wrong.  It's also exponentially more efficient.
>
> Being able to continue to run when a disk fails is the whole point of RAID
> -- despite what some folks think, RAIDs are not for backups but for uptime.
> And if your uptime goes to hell because the moment a disk fails you need to
> drop everything and replace the disk immediately, why would you use RAID?
Because just replacing a disk and rebuilding the array is almost always 
much cheaper in terms of time than rebuilding the system from a backup. 
IOW, even if you have to drop everything and replace the disk 
immediately, it's still less time consuming than restoring from a 
backup.  It also has the advantage that you don't lose any data.
>
>>> I /thought/ the immediate benefit was obvious enough that it
>>> would be mainline-merged by now, not hoovered-up into some long-term
>>> project with no real hint as to /when/ it might be merged.  Oh, well...
>> I think (although I'm not sure about it) that this:
>> http://www.spinics.net/lists/linux-btrfs/msg47283.html
>> is the first posting of the patch series.
>
> Is there a more recent version somewhere?  Mechanically rebasing+resolving
> conflicts doesn't work, I'd need to do a more involved refresh, which would
> be a waste of time if it's already done by someone with an actual clue about
> this code.
There may be, but I haven't looked very far.  Qu would probably be the 
person to ask.
