Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49523 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbeEBXKA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 May 2018 19:10:00 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fE0qg-0006aj-AA
        for linux-btrfs@vger.kernel.org; Thu, 03 May 2018 01:07:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID56 - 6 parity raid
Date: Wed, 2 May 2018 23:07:39 +0000 (UTC)
Message-ID: <pan$9b20d$2f2c31e6$ba0834da$d20ddbad@cox.net>
References: <CAJH6TXhuyR0Kn9Uq2xZ6qvJhAmeeUOF7uvyyYT9ns10uuM_5eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gandalf Corvotempesta posted on Wed, 02 May 2018 19:25:41 +0000 as
excerpted:

> On 05/02/2018 03:47 AM, Duncan wrote:
>> Meanwhile, have you looked at zfs? Perhaps they have something like
>> that?
> 
> Yes, i've looked at ZFS and I'm using it on some servers but I don't
> like it too much for multiple reasons, in example:
> 
> 1) is not officially in kernel, we have to build a module every time
> with DKMS

FWIW zfz is excluded from my choice domain as well, due to the well known 
license issues.  Regardless of strict legal implications, because Oracle 
has copyrights they could easily solve that problem and the fact that 
they haven't strongly suggests they have no interest in doing so.  That 
in turn means they have no interest in people like me running zfs, which 
means I have no interest in it either.

But because it does remain effectively the nearest to btrfs features and 
potential features "working now" solution out there, for those who simply 
_must_ have it and/or find it a more acceptable solution than cobbling 
together a multi-layer solution out of a standard filesystem on top of 
device-mapper or whatever, it's what I and others point to when people 
wonder about missing or unstable btrfs features.

> I'm new to BTRFS (if fact, i'm not using it) and I've seen in the status
> page that "it's almost ready".
> The only real missing part is a stable, secure and properly working
> RAID56,
> so i'm thinking why most effort aren't directed to fix RAID56 ?

Well, they are.  But finding and fixing corner-case bugs takes time and 
early-adopter deployments, and btrfs doesn't have the engineering 
resources to simply assign to the problem that Sun had with zfs.

Despite that, as I stated, current btrfs raid56 is, to the best of my/
list knowledge, the current code is now reasonably ready, tho it'll take 
another year or two without serious bug reports to actually test that, 
but it simply has the well known write hole that applies to all parity-
raid unless they've taken specific measures such as partial-stripe-write 
logging (slow), writing a full stripe even if it's partially empty 
(wastes space and needs periodic maintenance to reclaim it), or variable-
stripe-widths (needs periodic maintenance and more complex than always 
writing full stripes even if they're partially empty) (both of the latter 
avoiding the problem by avoiding in-place read-modify-write cycle 
entirely).

So to a large degree what's left is simply time for testing to 
demonstrate stability on the one hand, and a well known problem with 
parity-raid in general on the other.  There's the small detail that said 
well-known write hole has additional implementation-detail implications 
on btrfs, but at it's root it's the same problem all parity-raid has, and 
people choosing parity-raid as a solution are already choosing to either 
live with it or ameliorate it in some other way (tho some parity-raid 
solutions have that amelioration built-in).

> There are some environments where a RAID1/10 is too expensive and a
> RAID6 is mandatory,
> but with the current state of RAID56, BTRFS can't be used for valuable
> data

Not entirely true.  Btrfs, even btrfs raid56 mode, _can_ be used for 
"valuable" data, it simply requires astute /practical/ definitions of 
"valuable", as opposed to simple claims that don't actually stand up in 
practice.

Here's what I mean:  The sysadmin's first rule of backups defines 
"valuable data" by the number of backups it's worth making of that data.  
If there's no backups, then by definition the data is worth less than the 
time/hassle/resources necessary to have that backup, because it's not a 
question of if, but rather when, something's going to go wrong with the 
working copy and it won't be available any longer.

Additional layers of backup and whether one keeps geographically 
separated off-site backups as well are simply extensions of the first-
level-backup case/rule.  The more valuable the data, the more backups 
it's worth having of it, and the more effort is justified in ensuring 
that single or even multiple disasters aren't going to leave no working 
backup.

With this view, it's perfectly fine to use btrfs raid56 mode for 
"valuable" data, because that data is backed up and that backup can be 
used as a fallback if necessary.  True, the "working copy" might not be 
as reliable as it is in some cases, but statistically, that simply brings 
the 50% chance of failure rate (or whatever other percentage chance you 
choose) closer, to say once a year, or once a month, rather than perhaps 
once or twice a decade.  Working copy failure is GOING to happen in any 
case, it's just a matter of playing the chance game as to when, and using 
a not yet fully demonstrated reliable filesystem mode simply brings ups 
the chances a bit.

But if the data really *is* defined as "valuable", not simply /claimed/ 
to be valuable, then by that same definition, it *will* have a backup.

In the worst case, when some component (here the filesystem) of the 
storage platform is purely testing and expected to fail in near real-
time, the otherwise working-copy is often not even considered the working 
copy any longer, but rather, the testing copy, garbage value, because 
it's /expected/ to be destroyed by the test and therefore can't be 
considered the working copy.  In that case, what would be the first-line 
backup is actually the working copy, and if the testing copy (that would 
otherwise be the working copy) actually happens to survive the test, it's 
often deliberately destroyed anyway, with a mkfs (for the filesystem 
layer, device replace if it's the hardware layer, etc) destroying the 
data and setting up for the next test or actual working deployment.

And by that view, even if btrfs raid56 mode is defined as entirely 
unreliable, it can still be used for "valuable" data, because by 
definition, "valuable" data will be backed up, and should the working 
copy fail for any reason (remembering that even in the best cases, it 
*WILL* fail, the only question is when, not if), no problem, because the 
data *was* defined as valuable enough to have a backup, which can simply 
be restored, or fallen back to, if the first-line backup is deployable as 
a fallback and there's further backups to allow that without demoting the 
value to trivial because the working copy is now the /only/ copy.

> Also, i've seen that to fix write hole, a dedicated disk is needed ? Is
> this true ?
> I cant' create a 6 disks RAID6 with only 6 disks and no write-hole like
> with ZFS ?

A dedicated disk is not /necessary/, tho depending on the chosen 
mitigation strategy, it might be /useful/faster/.

For partial-stripe-write-logging, a comparatively fast device, say an ssd 
on an otherwise still legacy spinning-rust raid array, will help 
alleviate the speed issue.  But again, parity-raid isn't normally a go-to 
solution where performance is paramount in any case, so just using 
another ordinary spinning-rust device may work, if the performance level 
is acceptable.

For either always-full-stripe writes (writing zeros if the write would 
otherwise be too small) or variable-stripe widths (smaller stripes if 
necessary, down to a single data strip plus parity), the tradeoff is 
different and a dedicated logging device isn't used.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

