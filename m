Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:35818 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932356AbdCaTiu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 15:38:50 -0400
Received: by mail-wr0-f169.google.com with SMTP id k6so108314080wre.2
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 12:38:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <22750.37100.788020.938846@tree.ty.sabi.co.uk>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk> <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327194847.5c0c5545@natsu> <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
 <22746.30348.324000.636753@tree.ty.sabi.co.uk> <43e29da2-1d1b-1680-f262-1c95575645d8@gmail.com>
 <22749.10893.729399.275210@tree.ty.sabi.co.uk> <d2f4af84-739e-d43c-0978-8bbe74e8a277@gmail.com>
 <22750.37100.788020.938846@tree.ty.sabi.co.uk>
From: GWB <gwb@2realms.com>
Date: Fri, 31 Mar 2017 14:38:07 -0500
Message-ID: <CAP8EXU2cdtVP7+Qgy6mTJ1oqCmpW4JpaoUxAsf0RZ27WprvZ3g@mail.gmail.com>
Subject: Re: Shrinking a device - performance?
To: Peter Grandi <pg@btrfs.list.sabi.co.uk>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well, now I am curious.  Until we hear back from Christiane on the
progress of the never ending file system shrinkage, I suppose it can't
hurt to ask what the signifigance of the xargs size limits of btrfs
might be.  Or, again, if Christiane is already happily on his way to
an xfs server running over lvm, skip, ignore, delete.

Here is the output of xargs --size-limits on my laptop:

<<
$ xargs --show-limits
Your environment variables take up 4830 bytes
POSIX upper limit on argument length (this system): 2090274
POSIX smallest allowable upper limit on argument length (all systems): 4096
Maximum length of command we could actually use: 2085444
Size of command buffer we are actually using: 131072

Execution of xargs will continue now...
>>

That is for a laptop system.  So what does it mean that btrfs has a
higher xargs size limit than other file systems?  Could I
theoretically use 40% of the total allowed argument length of the
system for btrfs arguments alone?  Would that make balance, shrinkage,
etc., faster?  Does the higher capacity for argument length mean btrfs
is overly complex and therefore more prone to breakage?  Or does the
lower capacity for argument length for hfsplus demonstrate it is the
superior file system for avoiding breakage?

Or does it means that hfsplus is very old (and reflects older xargs
limits), and that btrfs is newer code?  I am relatively new to btrfs,
and would like to find out.  I am also attracted to the idea that it
is better to leave some operations to the system itself, and not code
them into the file system.  For example, I think deduplication "off
line" or "out of band" is an advantage for btrfs over zfs.  But that's
only for what I do.  For other uses deduplication "in line", while
writing the file, is preferred, and that is what zfs does (preferably
with lots of memory, at least one ssd to run zil, caches, etc.).

I use btrfs now because Ubuntu has it as a default in the kernel, and
I assume that when (not "if") I have to use a system rescue disk (USB
or CD) it will have some capacity to repair btrfs.  Along the way,
btrfs has been quite good as a general purpose file system on root; it
makes and sends snapshots, and so far only needs an occasional scrub
and balance.  My earlier experience with btrfs on a 2TB drive was more
complicated, but I expected that for a file system with a lot of
potential but less maturity.

Personally, I would go back to fossil and venti on Plan 9 for an
archival data server (using WORM drives), and VAX/VMS cluster for an
HA server.  But of course that no longer makes sense except for a very
few usage cases.  Time has moved on, prices have dropped drastically,
and hardware can do a lot more per penny than it used to.

Gordon

On Fri, Mar 31, 2017 at 12:25 PM, Peter Grandi <pg@btrfs.list.sabi.co.uk> wrote:
>>>> My guess is that very complex risky slow operations like
>>>> that are provided by "clever" filesystem developers for
>>>> "marketing" purposes, to win box-ticking competitions.
>
>>>> That applies to those system developers who do know better;
>>>> I suspect that even some filesystem developers are
>>>> "optimistic" as to what they can actually achieve.
>
>>>> There are cases where there really is no other sane
>>>> option. Not everyone has the kind of budget needed for
>>>> proper HA setups,
>
>>> Thnaks for letting me know, that must have never occurred to
>>> me, just as it must have never occurred to me that some
>>> people expect extremely advanced features that imply
>>> big-budget high-IOPS high-reliability storage to be fast and
>>> reliable on small-budget storage too :-)
>
>> You're missing my point (or intentionally ignoring it).
>
> In "Thanks for letting me know" I am not missing your point, I
> am simply pointing out that I do know that people try to run
> high-budget workloads on low-budget storage.
>
> The argument as to whether "very complex risky slow operations"
> should be provided in the filesystem itself is a very different
> one, and I did not develop it fully. But is quite "optimistic"
> to simply state "there really is no other sane option", even
> when for people that don't have "proper HA setups".
>
> Let'a start by assuming for the time being. that "very complex
> risky slow operations" are indeed feasible on very reliable high
> speed storage layers. Then the questions become:
>
> * Is it really true that "there is no other sane option" to
>   running "very complex risky slow operations" even on storage
>   that is not "big-budget high-IOPS high-reliability"?
>
> * Is is really true that it is a good idea to run "very complex
>   risky slow operations" even on ¨big-budget high-IOPS
>   high-reliability storage"?
>
>> Those types of operations are implemented because there are
>> use cases that actually need them, not because some developer
>> thought it would be cool. [ ... ]
>
> And this is the really crucial bit, I'll disregard without
> agreeing too much (but in part I do) with the rest of the
> response, as those are less important matters, and this is going
> to be londer than a twitter message.
>
> First, I agree that "there are use cases that actually need
> them", and I need to explain what I am agreeing to: I believe
> that computer systems, "system" in a wide sense, have what I
> call "inewvitable functionality", that is functionality that is
> not optional, but must be provided *somewhere*: for example
> print spooling is "inevitable functionality" as long as there
> are multuple users, and spell checking is another example.
>
> The only choice as to "inevitable functionality" is *where* to
> provide it. For example spooling can be done among two users by
> queuing jobs manually with one saying "I am going to print now",
> and the other user waits until the print is finished, or by
> using a spool program that queues jobs on the source system, or
> by using a spool program that queues jobs on the target
> printer. Spell checking can be done on the fly in the document
> processor, batch with a tool, or manually by the document
> author. All these are valid implementations of "inevitable
> functionality", just with very different performance envelope,
> where the "system" includes the users as "peripherals" or
> "plugins" :-) in the manual implementations.
>
> There is no dispute from me that multiple devices,
> adding/removing block devices, data compression, structural
> repair, balancing, growing/shrinking, defragmentation, quota
> groups, integrity checking, deduplication, ...a are all in the
> general case "inevitably functionality", and every non-trivial
> storage system *must* implement them.
>
> The big question is *where*: for example when I started using
> UNIX the 'fsck' tool was several years away, and when the system
> crashed I did like everybody filetree integrity checking and
> structure recovery myself (with the help of 'ncheck' and
> 'icheck' and 'adb'), that is 'fsck' was implemented in my head.
>
> In the general case there are three places where such
> "inevitable functionality" can be implemented:
>
> * In the filesystem module in the kernel, for example Btrfs
>   scrubbing.
> * In a tool that uses hook provided by the filesystem module in
>   the kernel, for example Btrfs deduplication, 'send'/'receive'.
> * In a tool, for example 'btrfsck'.
> * In the system administrator.
>
> Consider the "very complex risky slow" operation of
> defragmentation; the system administrator can implement it by
> dumping and reloading the volume, or a tool ban implement it by
> running on the unmounted filesystem, or a tool and the kernel
> can implement it by using kernel module hooks, or it can be
> provided entirely in the kernel module.
>
> My argument is that providing "very complex risky slow"
> maintenance operations as filesystem primitives looks awesomely
> convenient, a good way to "win box-ticking competitions" for
> "marketing" purposes, but is rather bad idea for several
> reasons, of varying strengths:
>
> * Most system administrators apparently don't understand the
>   most basic concepts of storage, or try to not understand them,
>   and in particular don't understand that some in-place
>   maintenance operations are "very complex risky slow" and
>   should be avoided. Manual alternatives to shrinking like
>   dumping and reloading should be encouraged.
>
> * In an ideal world "very complex risky slow operations" could
>   be done either "automagically" or manually, and wise system
>   administrators would choose appropriately, but the risk of the
>   wrong choice by less wise system administrators can reflect
>   badly on the filesystem reputation and that of their
>   designers, as in "after 10 years it still is like this" :-).
>
> * In particular for whatever reasons many system administrators
>   seems to be very "optimistic" as to cost/benefit planning,
>   maybe because they want to be considered geniuses who can
>   deliver large high performance high reliability storage for
>   cheap, and systematically under-resource IOPS because they are
>   very expensive, yet large quantities of these are consumed by
>   most maintenance "very complex risky slow operations",
>   especially those involving in-place manipulation, and then
>   ingenuously or disingenuously complain when 'balance' takes 3
>   months, because after all it is a single command, and that
>   single command hides a "very complex risky slow" operation.
>
> * In an ideal world implementing "very complex risky slow
>   operations" in kernel modules (or even in tools) is entirely
>   cost free, as kernel developers never make mistakes as to
>   state machines or race conditions or lessedr bug despite the
>   enormouse complexity of the code paths needed to support many
>   possible options, but kernel code is particularly fragile,
>   kernel developers seem to be human after all, when they are
>   are not quite careless, and making it hard to stabilize kernel
>   code can reflect badly on the filesystem reputation and that
>   of their designers, as in "after 10 years it still is like
>   this" :-).
>
> Therefore in my judgement a filesystem design should only
> provide the barest and most direct functionality, unless the
> designers really overrate themselves, or rate highly their skill
> at marketing long lists of features as "magic dust". Im my
> judgement higher level functionality can be left to the
> ingenuity of system administrators, both because crude methods
> like dump and reload actually work pretty well and quickly, even
> if they are most costly in terms of resources used, and because
> they give a more direct feel to system administrators of the
> real costs of doing certain maintenance operations.
>
> Put another way, as to this:
>
>> Those types of operations are implemented because there are
>> use cases that actually need them,
>
> Implementing "very complex risky slow operations" like in-place
> shrinking *in the kernel module* as a "just do it" primitive is
> certainly possible and looks great in a box-ticking competition
> but has large hidden costs as to complexity and opacity, and
> simpler cruder more manual out of kernel implementations are
> usually less complex, less risky, less slow, even if more
> expensive in terms of budget. In the end the question for either
> filesystem designers or system administrators is "Do you feel
> lucky?" :-).
>
> The following crudely tells part of the story, for example that
> some filesystem designers know better :-)
>
>   $  D='btrfs f2fs gfs2 hfsplus jfs nilfs2 reiserfs udf xfs'
>   $  find $D -name '*.ko' | xargs size | sed 's/^  *//;s/ .*\t//g'
>   text    filename
>   832719  btrfs/btrfs.ko
>   237952  f2fs/f2fs.ko
>   251805  gfs2/gfs2.ko
>   72731   hfsplus/hfsplus.ko
>   171623  jfs/jfs.ko
>   173540  nilfs2/nilfs2.ko
>   214655  reiserfs/reiserfs.ko
>   81628   udf/udf.ko
>   658637  xfs/xfs.ko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
