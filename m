Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43995 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754406AbcIIWK3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 18:10:29 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1biU02-0002Yd-4J
        for linux-btrfs@vger.kernel.org; Sat, 10 Sep 2016 00:10:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs kernel oops on mount
Date: Fri, 9 Sep 2016 22:09:55 +0000 (UTC)
Message-ID: <pan$c5981$cb24a4d7$13ac64bf$80da2007@cox.net>
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
        <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
        <a6bbb384-f51a-34f8-0789-27a9945a20f6@moparisthebest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

moparisthebest posted on Fri, 09 Sep 2016 15:23:13 -0400 as excerpted:

> On 09/09/2016 02:47 PM, Austin S. Hemmelgarn wrote:
>> On 2016-09-09 12:12, moparisthebest wrote:
>>> Hi,
>>>
>>> I'm hoping to get some help with mounting my btrfs array which quit
>>> working yesterday.  My array was in the middle of a balance, about 50%
>>> remaining, when it hit an error and remounted itself read-only [1].
>>> btrfs fi show output [2], btrfs df output [3].
>>>
>>> I unmounted the array, and when I tried to mount it again, it locked
>>> up the whole system so even alt+sysrq would not work.  I rebooted,
>>> tried to mount again, same lockup.  This was all kernel 4.5.7.
>>>
>>> I rebooted to kernel 4.4.0, tried to mount, crashed again, this time a
>>> message appeared on the screen and I took a picture [4].
>>>
>>> I rebooted into an arch live system with kernel 4.7.2, tried to mount
>>> again, got some dmesg output before it crashed [5] and took a picture
>>> when it crashed [6], says in part 'BUG: unable to handle kernel NULL
>>> pointer dereference at 00000000000001f0'.
>>>
>>> Is there anything I can do to get this in a working state again or
>>> perhaps even recover some data?
>>>
>>> Thanks much for any help
>>>
>>> [1]: https://www.moparisthebest.com/btrfs/initial_crash.txt [2]:
>>> https://www.moparisthebest.com/btrfs/btrfsfishow.txt [3]:
>>> https://www.moparisthebest.com/btrfs/btrfsdf.txt [4]:
>>> https://www.moparisthebest.com/btrfsoops.jpg [5]:
>>> https://www.moparisthebest.com/btrfs/dmsgprecrash.txt [6]:
>>> https://www.moparisthebest.com/btrfsnulldereference.jpg
>> 
>> The output from btrfs fi show and fi df both indicate that the
>> filesystem is essentially completely full.  You've gotten to the point
>> where your using the global metadata reserve, and I think things are
>> getting stuck trying (and failing) to reclaim the space that's used
>> there.

>> Given that the FS is pretty much wedged, I think your best bet for
>> fixing this is probably going to be to use btrfs restore to get the
>> data onto a new (larger) set of disks.  If you do take this approach, a
>> metadata dump might be useful, if somebody could find enough room to
>> extract it.

> If I read btrfs fi show right, it's got minimum ~600gb free on each one
> of the 8 drives, shouldn't that be more than enough for most things?  (I
> guess unless I have single files over 600gb that need COW'd, I don't
> though)

Austin did pick up on something I (and apparently Chris) missed, the non-
zero used global reserve, but as best I can tell he's wrongly attributing 
it to fully used devices, when as you (and Chris) point out that's not 
the case.

What he picked up on is this.  Under normal conditions, global reserve 
"used" should always be zero, as sans bugs, btrfs has to be in pretty 
dire lack of space condition before it'll start using the reserve.  Under 
most conditions, btrfs will simply ENOSPC an operation before it starts 
using reserve, so the fact that it's used indicates that btrfs *BELIEVES* 
that it is in dire straits, space-wise, and has no place to go *but* 
reserves.

But as you point out, all eight devices seem to have a half-TiB plus 
available, unallocated and free to allocate as necessary.  Given that 
btrfs raid1 only does pair-mirroring, and that chunks should be at 
absolute largest, 10 GiB, there's *plenty* of space to allocate as needed.


Which can only mean that you've hit one of those elusive ENOSPC bugs 
where there's plenty of space left to allocate, but btrfs simply refuses 
to allocate it, instead triggering ENOSPC errors left and right, and of 
particular interest here, btrfs believes the ENOSPC problems to be severe 
enough that it has even run substantially into global reserves, *DESPITE* 
there *actually* being *plenty* of space!

Now I'm not a dev (just a btrfs user and list regular) and the traces, 
etc, don't tend to add much usable information for me, so I can't judge 
whether your particular case is affected by the following or not, but as 
it so happens, there's active patches going into 4.8 dealing with some of 
these previously unsolved ENOSPC when there's *plenty* of space bugs.

So there's a fair chance the patches in either current 4.8-git or still 
in-process at this very moment will fix at least the evident false ENOSPC 
despite loads of space actually being available, which based on the fact 
that used reserve is /not/ zero was very likely the original trigger for 
the auto-remount-ro.  However, it's also possible that there are other 
issues now as well, that the current patches may /not/ fix, even if they 
fix all the ENOSPC issues, which itself I can't guarantee.  But it's 
worth a shot.

The other known problem with a known (mount-option) fix that you're 
almost certainly running into ATM is the unfinished balance, since the 
balance will try to resume once you mount the btrfs writable, and at 
least without the ENSPC patchs mentioned above, that balance is 
immediately running into the same ENSPC problem that triggered the 
remount-ro in the first place.

So try adding skip_balance to your mount options, and see if that lets 
you mount without the crash.  If it does, you can then manually run btrfs 
balance cancel to cancel the ongoing balance, allowing you to mount 
normally (without skip_balance) again.  However, you might want to try 
the ENOSPC patches first, before canceling the balance, since the cancel 
by definition will lose your place in the balance, and presumably you 
were doing a balance for some reason and would thus have to restart it.


So what I'd try, in order:

0) Btrfs is still considered stabilizing, not yet fully stable and 
mature, so the usual sysadmin's rule of backups, that you either have 
them or by virtue of skipping them, you're defining your data as of less 
value to you than the hassle and resources a backup would otherwise 
require, regardless of any claims to the contrary, applies even more 
strongly than it does to a normally stable and mature filesystem.

So if you don't have backups (or they're outdated) and you are now 
reconsidering your definition of that data as not worth the hassle of 
backups, your first priority is getting those backups, even before repair 
of the filesystem.

If that is your case, I'd try mounting read-only and taking the backup 
from there if you can, or using btrfs restore if you can't mount read-
only.

Then of course be aware of what a failure to have backups actually means 
in terms of how you are defining the value of your data (or the value of 
the delta between the current data and the data at the time of the last 
backup, if you have them but they aren't absolutely current), and act 
accordingly.  If that means btrfs is no longer an appropriate choice for 
you due to the stronger backups rule application, that's what it means.

1) A quick mount with skip_balance using your existing kernel, just to 
see if it lets you mount without an immediate crash.  If it does, we know 
it was the resuming balance that was the problem.  But don't cancel the 
balance just yet so you don't lose your place in it.

Of course if the option works, this is a nice place to take/update 
backups too. =:^)

2) A mount with the very latest 4.8-rc or git kernel, possibly with 
further enospc patches applied (I'm not sure if they've all reached 
mainline yet).  If you're really lucky, these enospc patches will let you 
continue the existing in-process balance from where you left off, thus 
avoiding the cancel.

If you're less lucky but still in good shape, they'll fix the root 
problem but the balance already got the btrfs so wedged that you'll still 
have to mount with skip_balance, then cancel the balance, losing your 
place, and then presumably restart a new one.

3) Given the currently active enospc work, find the threads discussing 
those patches and either confirm that they fixed your enospc problem, or 
catch up on the status of the current patches and what sorts of debugging 
and testing the devs are having reporters do, and either confirm a 
remaining issue on those threads or get prepared to do a new bug, if the 
issue appears to yet another enospc bug, that isn't addressed by those 
patches.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

