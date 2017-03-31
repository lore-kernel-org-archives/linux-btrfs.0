Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:53503 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933153AbdCaRZO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 13:25:14 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:60062)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cu0IQ-003iI1-Kk
        for linux-btrfs@vger.kernel.org; Fri, 31 Mar 2017 18:25:10 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cu0IH-0000Np-BU
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 18:25:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <22750.37100.788020.938846@tree.ty.sabi.co.uk>
Date: Fri, 31 Mar 2017 18:25:00 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Shrinking a device - performance?
In-Reply-To: <d2f4af84-739e-d43c-0978-8bbe74e8a277@gmail.com>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <43e29da2-1d1b-1680-f262-1c95575645d8@gmail.com>
        <22749.10893.729399.275210@tree.ty.sabi.co.uk>
        <d2f4af84-739e-d43c-0978-8bbe74e8a277@gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> My guess is that very complex risky slow operations like
>>> that are provided by "clever" filesystem developers for
>>> "marketing" purposes, to win box-ticking competitions.

>>> That applies to those system developers who do know better;
>>> I suspect that even some filesystem developers are
>>> "optimistic" as to what they can actually achieve.

>>> There are cases where there really is no other sane
>>> option. Not everyone has the kind of budget needed for
>>> proper HA setups,

>> Thnaks for letting me know, that must have never occurred to
>> me, just as it must have never occurred to me that some
>> people expect extremely advanced features that imply
>> big-budget high-IOPS high-reliability storage to be fast and
>> reliable on small-budget storage too :-)

> You're missing my point (or intentionally ignoring it).

In "Thanks for letting me know" I am not missing your point, I
am simply pointing out that I do know that people try to run
high-budget workloads on low-budget storage.

The argument as to whether "very complex risky slow operations"
should be provided in the filesystem itself is a very different
one, and I did not develop it fully. But is quite "optimistic"
to simply state "there really is no other sane option", even
when for people that don't have "proper HA setups".

Let'a start by assuming for the time being. that "very complex
risky slow operations" are indeed feasible on very reliable high
speed storage layers. Then the questions become:

* Is it really true that "there is no other sane option" to
  running "very complex risky slow operations" even on storage
  that is not "big-budget high-IOPS high-reliability"?

* Is is really true that it is a good idea to run "very complex
  risky slow operations" even on ¨big-budget high-IOPS
  high-reliability storage"?

> Those types of operations are implemented because there are
> use cases that actually need them, not because some developer
> thought it would be cool. [ ... ]

And this is the really crucial bit, I'll disregard without
agreeing too much (but in part I do) with the rest of the
response, as those are less important matters, and this is going
to be londer than a twitter message.

First, I agree that "there are use cases that actually need
them", and I need to explain what I am agreeing to: I believe
that computer systems, "system" in a wide sense, have what I
call "inewvitable functionality", that is functionality that is
not optional, but must be provided *somewhere*: for example
print spooling is "inevitable functionality" as long as there
are multuple users, and spell checking is another example.

The only choice as to "inevitable functionality" is *where* to
provide it. For example spooling can be done among two users by
queuing jobs manually with one saying "I am going to print now",
and the other user waits until the print is finished, or by
using a spool program that queues jobs on the source system, or
by using a spool program that queues jobs on the target
printer. Spell checking can be done on the fly in the document
processor, batch with a tool, or manually by the document
author. All these are valid implementations of "inevitable
functionality", just with very different performance envelope,
where the "system" includes the users as "peripherals" or
"plugins" :-) in the manual implementations.

There is no dispute from me that multiple devices,
adding/removing block devices, data compression, structural
repair, balancing, growing/shrinking, defragmentation, quota
groups, integrity checking, deduplication, ...a are all in the
general case "inevitably functionality", and every non-trivial
storage system *must* implement them.

The big question is *where*: for example when I started using
UNIX the 'fsck' tool was several years away, and when the system
crashed I did like everybody filetree integrity checking and
structure recovery myself (with the help of 'ncheck' and
'icheck' and 'adb'), that is 'fsck' was implemented in my head.

In the general case there are three places where such
"inevitable functionality" can be implemented:

* In the filesystem module in the kernel, for example Btrfs
  scrubbing.
* In a tool that uses hook provided by the filesystem module in
  the kernel, for example Btrfs deduplication, 'send'/'receive'.
* In a tool, for example 'btrfsck'.
* In the system administrator.

Consider the "very complex risky slow" operation of
defragmentation; the system administrator can implement it by
dumping and reloading the volume, or a tool ban implement it by
running on the unmounted filesystem, or a tool and the kernel
can implement it by using kernel module hooks, or it can be
provided entirely in the kernel module.

My argument is that providing "very complex risky slow"
maintenance operations as filesystem primitives looks awesomely
convenient, a good way to "win box-ticking competitions" for
"marketing" purposes, but is rather bad idea for several
reasons, of varying strengths:

* Most system administrators apparently don't understand the
  most basic concepts of storage, or try to not understand them,
  and in particular don't understand that some in-place
  maintenance operations are "very complex risky slow" and
  should be avoided. Manual alternatives to shrinking like
  dumping and reloading should be encouraged.

* In an ideal world "very complex risky slow operations" could
  be done either "automagically" or manually, and wise system
  administrators would choose appropriately, but the risk of the
  wrong choice by less wise system administrators can reflect
  badly on the filesystem reputation and that of their
  designers, as in "after 10 years it still is like this" :-).

* In particular for whatever reasons many system administrators
  seems to be very "optimistic" as to cost/benefit planning,
  maybe because they want to be considered geniuses who can
  deliver large high performance high reliability storage for
  cheap, and systematically under-resource IOPS because they are
  very expensive, yet large quantities of these are consumed by
  most maintenance "very complex risky slow operations",
  especially those involving in-place manipulation, and then
  ingenuously or disingenuously complain when 'balance' takes 3
  months, because after all it is a single command, and that
  single command hides a "very complex risky slow" operation.

* In an ideal world implementing "very complex risky slow
  operations" in kernel modules (or even in tools) is entirely
  cost free, as kernel developers never make mistakes as to
  state machines or race conditions or lessedr bug despite the
  enormouse complexity of the code paths needed to support many
  possible options, but kernel code is particularly fragile,
  kernel developers seem to be human after all, when they are
  are not quite careless, and making it hard to stabilize kernel
  code can reflect badly on the filesystem reputation and that
  of their designers, as in "after 10 years it still is like
  this" :-).

Therefore in my judgement a filesystem design should only
provide the barest and most direct functionality, unless the
designers really overrate themselves, or rate highly their skill
at marketing long lists of features as "magic dust". Im my
judgement higher level functionality can be left to the
ingenuity of system administrators, both because crude methods
like dump and reload actually work pretty well and quickly, even
if they are most costly in terms of resources used, and because
they give a more direct feel to system administrators of the
real costs of doing certain maintenance operations.

Put another way, as to this:

> Those types of operations are implemented because there are
> use cases that actually need them,

Implementing "very complex risky slow operations" like in-place
shrinking *in the kernel module* as a "just do it" primitive is
certainly possible and looks great in a box-ticking competition
but has large hidden costs as to complexity and opacity, and
simpler cruder more manual out of kernel implementations are
usually less complex, less risky, less slow, even if more
expensive in terms of budget. In the end the question for either
filesystem designers or system administrators is "Do you feel
lucky?" :-).

The following crudely tells part of the story, for example that
some filesystem designers know better :-)

  $  D='btrfs f2fs gfs2 hfsplus jfs nilfs2 reiserfs udf xfs'
  $  find $D -name '*.ko' | xargs size | sed 's/^  *//;s/ .*\t//g'
  text    filename
  832719  btrfs/btrfs.ko
  237952  f2fs/f2fs.ko
  251805  gfs2/gfs2.ko
  72731   hfsplus/hfsplus.ko
  171623  jfs/jfs.ko
  173540  nilfs2/nilfs2.ko
  214655  reiserfs/reiserfs.ko
  81628   udf/udf.ko
  658637  xfs/xfs.ko
