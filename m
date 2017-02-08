Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:37247 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751714AbdBHMvO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 07:51:14 -0500
Received: by mail-it0-f47.google.com with SMTP id r185so102179423ita.0
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 04:50:28 -0800 (PST)
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
To: Hans Deragon <hans@deragon.biz>, linux-btrfs@vger.kernel.org
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
 <6e26ee22-3d67-d2aa-22b7-c03f9ffc18f2@deragon.biz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6e4b9b4f-d4df-5679-5645-a52dbc15b424@gmail.com>
Date: Wed, 8 Feb 2017 07:50:22 -0500
MIME-Version: 1.0
In-Reply-To: <6e26ee22-3d67-d2aa-22b7-c03f9ffc18f2@deragon.biz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 22:21, Hans Deragon wrote:
> Greetings,
>
> On 2017-02-02 10:06, Austin S. Hemmelgarn wrote:
>> On 2017-02-02 09:25, Adam Borowski wrote:
>>> On Thu, Feb 02, 2017 at 07:49:50AM -0500, Austin S. Hemmelgarn wrote:
>>>> This is a severe bug that makes a not all that uncommon (albeit bad) use
>>>> case fail completely.  The fix had no dependencies itself and
>>>
>>> I don't see what's bad in mounting a RAID degraded.  Yeah, it provides no
>>> redundancy but that's no worse than using a single disk from the start.
>>> And most people not doing storage/server farm don't have a stack of spare
>>> disks at hand, so getting a replacement might take a while.
>> Running degraded is bad. Period.  If you don't have a disk on hand to
>> replace the failed one (and if you care about redundancy, you should
>> have at least one spare on hand), you should be converting to a single
>> disk, not continuing to run in degraded mode until you get a new disk.
>> The moment you start talking about running degraded long enough that you
>> will be _booting_ the system with the array degraded, you need to be
>> converting to a single disk.  This is of course impractical for
>> something like a hardware array or an LVM volume, but it's _trivial_
>> with BTRFS, and protects you from all kinds of bad situations that can't
>> happen with a single disk but can completely destroy the filesystem if
>> it's a degraded array.  Running a single disk is not exactly the same as
>> running a degraded array, it's actually marginally safer (even if you
>> aren't using dup profile for metadata) because there are fewer moving
>> parts to go wrong.  It's also exponentially more efficient.
>>>
>>> Being able to continue to run when a disk fails is the whole point of
>>> RAID
>>> -- despite what some folks think, RAIDs are not for backups but for
>>> uptime.
>>> And if your uptime goes to hell because the moment a disk fails you
>>> need to
>>> drop everything and replace the disk immediately, why would you use RAID?
>> Because just replacing a disk and rebuilding the array is almost always
>> much cheaper in terms of time than rebuilding the system from a backup.
>> IOW, even if you have to drop everything and replace the disk
>> immediately, it's still less time consuming than restoring from a
>> backup.  It also has the advantage that you don't lose any data.
>
> We disagree on letting people run degraded, which I support, you not.  I
> respect your opinion.  However, I have to ask who decides these rules?
> Obviously, not me since I am a simple btrfs home user.
This is a pretty typical stance among seasoned system administrators. 
It's worth pointing out that I'm not saying you shouldn't run with a 
single disk for an extended period of time, I'm saying you should 
_convert_ to single disk profiles until you can get a replacement, and 
then convert back to raid profiles once you have the replacement.  It is 
exponentially safer in BTRFS to run single data single metadata than 
half raid1 data half raid1 metadata.  This is one of the big reasons 
that I've avoided MD over the years, it's functionally impossible to do 
this with MD arrays.
>
> Since Oracle is funding btrfs development, is that Oracle's official
> stand on how to handle a failed disk?  Who decides of btrfs's roadmap?
> I have no clue who is who on this mailing list and who influences the
> features of btrfs.
>
> Oracle is obviously using raid systems internally.  How do the operators
> of these raid systems feel about this "not let the system run in
> degraded mode"?
They replace the disks immediately, so it's irrelevant to them.  Oracle 
isn't the sole source of funding (I'm actually not even sure they are 
anymore CLM works for Facebook now last I knew), but you have to 
understand that it has been developed primarily as an _enterprise_ 
filesystem.  This means that certain perfectly reasonable assumptions 
are made about the conditions under which it will be used.
>
> As a home user, I do not want to have a disk always available.  This is
> paying a disk very expensively when the raid system can run easily for
> two years without disk failure.  I want to buy the new disk (asap, of
> course) once one died.  At that moment, the cost of a drive would have
> fallen drastically.  Yes, I can live with running my home system (which
> has backups) for a day or two, in degraded rw mode until I purchase and
> can install a new disk.  Chances are low that both disks will quit at
> around the same time.
You're missing my point.  I have zero issue with running with one disk 
when the other fails.  I have issue with not telling the FS that it 
won't have another disk for a while.  IOW, in that situation, I would run:
btrfs balance start -dconvert=single -mconvert=dup /whatever
To convert to profiles _designed_ for a single device and then convert 
back to raid1 when I got another disk.  The issue you've stumbled across 
is only partial motivation for this, the bigger motivation is that 
running half a 2 disk array is more risky than running a single disk by 
itself.
>
> Simply because I cannot run in degraded mode and cannot add a disk to my
> current degraded raid1, despite having my replacement disk in my hands,
> I must resort to switch to mdadm or zfs.
Both MDADM and ZFS still have the issue that it is more dangerous to run 
half a 2 disk RAID1 array than a single disk.  That doesn't change just 
because the software handles things a bit differently.
>
> Having a policy that limits user's options for the sake that they are
> too stupid to understand the implications is wrong.  Its ok for
> applications, but not at the operating system; there should be a way to
> force this.  A
> --yes-i-know-what-i-am-doing-now-please-mount-rw-degraded-so-i-can-install-the-new-disk
> parameter must be implemented.  Currently, it is like disallowing root
> to run mkfs over an existing filesystem because people could erase data
> by mistake.  Let people do what they want and let them live with the
> consequences.
A patch exists to fix the particular issue you encountered.  Trust me, I 
wish it had been merged like it should have been too, then we could just 
tell people in this situation to upgrade their kernel instead of telling 
them to rebuild it with a patch.
>
> hdparm has a --yes-i-know-what-i-am-doing flag.  btrfs needs one.
>
> Whoever decides about btrfs features to add, please consider this one.
