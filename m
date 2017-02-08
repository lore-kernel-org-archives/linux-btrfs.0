Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from alt22.smtp-out.videotron.ca ([70.80.0.73]:37993 "EHLO
        alt22.smtp-out.videotron.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751946AbdBHDh0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Feb 2017 22:37:26 -0500
Received: from [192.168.1.226] (wifi.deragon.biz [192.168.1.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.localdomain (Postfix) with ESMTPSA id 7391D180433
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Feb 2017 22:21:40 -0500 (EST)
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
To: linux-btrfs@vger.kernel.org
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
 <ZIyPcL4cW36fIZIyQcB9Hs@videotron.ca>
From: Hans Deragon <hans@deragon.biz>
Message-ID: <6e26ee22-3d67-d2aa-22b7-c03f9ffc18f2@deragon.biz>
Date: Tue, 7 Feb 2017 22:21:40 -0500
MIME-Version: 1.0
In-Reply-To: <ZIyPcL4cW36fIZIyQcB9Hs@videotron.ca>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings,

On 2017-02-02 10:06, Austin S. Hemmelgarn wrote:
> On 2017-02-02 09:25, Adam Borowski wrote:
>> On Thu, Feb 02, 2017 at 07:49:50AM -0500, Austin S. Hemmelgarn wrote:
>>> This is a severe bug that makes a not all that uncommon (albeit bad) use
>>> case fail completely.  The fix had no dependencies itself and
>>
>> I don't see what's bad in mounting a RAID degraded.  Yeah, it provides no
>> redundancy but that's no worse than using a single disk from the start.
>> And most people not doing storage/server farm don't have a stack of spare
>> disks at hand, so getting a replacement might take a while.
> Running degraded is bad. Period.  If you don't have a disk on hand to
> replace the failed one (and if you care about redundancy, you should
> have at least one spare on hand), you should be converting to a single
> disk, not continuing to run in degraded mode until you get a new disk.
> The moment you start talking about running degraded long enough that you
> will be _booting_ the system with the array degraded, you need to be
> converting to a single disk.  This is of course impractical for
> something like a hardware array or an LVM volume, but it's _trivial_
> with BTRFS, and protects you from all kinds of bad situations that can't
> happen with a single disk but can completely destroy the filesystem if
> it's a degraded array.  Running a single disk is not exactly the same as
> running a degraded array, it's actually marginally safer (even if you
> aren't using dup profile for metadata) because there are fewer moving
> parts to go wrong.  It's also exponentially more efficient.
>>
>> Being able to continue to run when a disk fails is the whole point of
>> RAID
>> -- despite what some folks think, RAIDs are not for backups but for
>> uptime.
>> And if your uptime goes to hell because the moment a disk fails you
>> need to
>> drop everything and replace the disk immediately, why would you use RAID?
> Because just replacing a disk and rebuilding the array is almost always
> much cheaper in terms of time than rebuilding the system from a backup.
> IOW, even if you have to drop everything and replace the disk
> immediately, it's still less time consuming than restoring from a
> backup.  It also has the advantage that you don't lose any data.

We disagree on letting people run degraded, which I support, you not.  I
respect your opinion.  However, I have to ask who decides these rules?
Obviously, not me since I am a simple btrfs home user.

Since Oracle is funding btrfs development, is that Oracle's official
stand on how to handle a failed disk?  Who decides of btrfs's roadmap?
I have no clue who is who on this mailing list and who influences the
features of btrfs.

Oracle is obviously using raid systems internally.  How do the operators
of these raid systems feel about this "not let the system run in
degraded mode"?

As a home user, I do not want to have a disk always available.  This is
paying a disk very expensively when the raid system can run easily for
two years without disk failure.  I want to buy the new disk (asap, of
course) once one died.  At that moment, the cost of a drive would have
fallen drastically.  Yes, I can live with running my home system (which
has backups) for a day or two, in degraded rw mode until I purchase and
can install a new disk.  Chances are low that both disks will quit at
around the same time.

Simply because I cannot run in degraded mode and cannot add a disk to my
current degraded raid1, despite having my replacement disk in my hands,
I must resort to switch to mdadm or zfs.

Having a policy that limits user's options for the sake that they are
too stupid to understand the implications is wrong.  Its ok for
applications, but not at the operating system; there should be a way to
force this.  A
--yes-i-know-what-i-am-doing-now-please-mount-rw-degraded-so-i-can-install-the-new-disk
parameter must be implemented.  Currently, it is like disallowing root
to run mkfs over an existing filesystem because people could erase data
by mistake.  Let people do what they want and let them live with the
consequences.

hdparm has a --yes-i-know-what-i-am-doing flag.  btrfs needs one.

Whoever decides about btrfs features to add, please consider this one.

Best regards,
Hans Deragon
