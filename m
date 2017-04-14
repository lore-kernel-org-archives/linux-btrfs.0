Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:37821 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753309AbdDNDrk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 23:47:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cysCp-00073h-JH
        for linux-btrfs@vger.kernel.org; Fri, 14 Apr 2017 05:47:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Encountered kernel bug#72811. Advice on recovery?
Date: Fri, 14 Apr 2017 03:47:18 +0000 (UTC)
Message-ID: <pan$29c2d$faf1fff7$a4518780$dbb0b61@cox.net>
References: <CAFKQ2Bs9-=serb7F-PHDVNQ-X2AXcWPG5jBs9xKXTKkTQ59O7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ank Ular posted on Thu, 13 Apr 2017 14:49:41 -0400 as excerpted:

> I've encountered kernel bug#72811 "If a raid5 array gets into degraded
> mode, gets modified, and the missing drive re-added, the filesystem
> loses state".

> The array normally consists of 22 devices with data and meta in raid6.
> Physically, the devices are split 16 devices in a NORCO DS-24 cage and
> the remaining devices are in the server itself. All the devices are SATA
> III.

> I don't have issues with the above tools not being ready for for raid56.
> Despite the mass quantities, none of the data involved it irretrievable,
> irreplaceable or of earth shattering importance on any level. This is a
> purely personal setup.

> As such, I'm not bothered by the 'not ready for prime time status' of
> raid56. This bug however, is really really nasty bad. Once a drive is
> out of sync, if should never be automatically re-added back.

> I mention all this because I KNOW someone is going to go off on how I
> should have back ups of everything and how I should not run raid56 and
> how I should run mirrored instead etc. Been there. Done that. I have the
> same canned lecture for people running data centers for businesses.
> 
> I am not a business. This is my personal hobby. The risk does not bother
> me. I don't mind running this setup because I think real life runtimes
> can contribute to the general betterment of btrfs for everyone. I'm not
> in any particular hurry. My income is completely independent from this.

> The potential problem is controlling what happens once I mount the
> degraded array in read/write mode to delete copied data and perform
> device reduction. I have no clue how to or even if this can be done
> safely.
> 
> The alternative is to continue to run this array in read only degraded
> mode until I can accumulate sufficient funds for a second chassis and
> approximately 20 more drives.This probably won't be until Jan 2018.
> 
> Is such a recovery strategy even possible? While I would expect a
> strategy involving 'btrfs restore' to be possible for raid0, raid1,
> raid10 configure arrays, I don't know that such a strategy will work for
> raid56.
> 
> As I see it, the key here to to be able to safely delete copied files
> and to safely reduce the number of devices in the array.

OK, I'm one of the ones that's going to "go off" on you, but FWIW, I 
expect pretty much everyone else would pretty much agree.  At least you 
do have backups. =:^)

I don't think you appreciate just how bad raid56 is ATM.  There are just 
too many REALLY serious bugs like the one you mention with it, and it's 
actively NEGATIVELY recommended here as a result.  It's bad enough with 
even current kernels, and the problems are well known enough to the devs, 
that there's really not a whole lot to test ATM...

Well, unless you're REALLY into building kernels with a whole slew of pre-
merge patches and reporting back the results to the dev working on it, as 
there /are/ a significant number of raid56 patches floating around in a 
pre-merge state here on the list.  Some of them may be in btrfs-next 
already, but I don't believe all of them are.

The problem with that is, despite how willing you may be, you obviously 
aren't running them now.  So you obviously didn't know the current 
really /really/ bad state.  If you're /willing/ to run them and have the 
skills to do that sort of patching, etc, including possibly ones that 
won't fix problems, only help further trace them down, then either 
followup with the dev working on it (which I've not tracked specifically 
so I can't tell you who) if he posts a reply, or go looking on the list 
for raid56 patches and get ahold of the dev posting them.

You'll need to get the opinion of the dev as to whether with the patches 
it's worth running yet or not.  I'm not sure if he's thru patching the 
worst of the known issues, or if there's more to go.

One of the big problems is that in the current state, the repair tools, 
scrub, etc, can actively make the problem MUCH worse.  They're simply 
broken.  Normal raid56 runtime has been working for quite awhile, so it's 
no surprise that has worked for you.  And under specific circumstances, 
pulling a drive and replacing it can work too.  But the problem is, those 
circumstances are precisely the type that people test, but not the type 
that tends to actually happen in the real world.

So effectively, raid56 mode is little more dependable than raid0 mode.  
While you /may/ be able to recover, it's uncertain enough that it's 
better to just treat the array as a raid0, and consider that you may well 
lose everything on it with pretty much any problem at all.  As such, it's 
simply irresponsible to recommend that anyone use it /as/ raid56, which 
is why it's actively NEGATIVELY recommended ATM.  Meanwhile, people that 
want raid0s... tend to configure raid0s, not raid5s or raid6s.

FWIW, I /think/ at least /some/ of the patches have been reviewed and 
cleared for, hopefully, 4.12.  For sure they're not going to make 4.11.  
And I'm not sure all of them will make 4.12, and even if they do, while 
they're certainly a beginning, I'm honestly not sure if they fix the 
known problems well enough yet to slack off on the negativity a bit or 
not.


Meanwhile...  what to do with the current array?

If you are up to patching, get those patches applied and work with the 
dev to see what you can do.

If you want to risk it and aren't up for the level of pre-release 
patching I've described above, yeah, running it read-only until early 
next year should basically maintain state (assuming no hardware actually 
fails, that's the risk part), and with a bit of luck getting those 
patches merged, raid56 may actually be stabilizing a bit by then.  One 
can hope. =:^)

Meanwhile, the good thing about btrfs restore is that it's read-only for 
the filesystem you're trying to recover files from.  If there's enough 
damage that the read-only mount won't let you access all the files and 
you want to try restore, while I don't know its raid56 status, unlike 
scrub and some of the other tools, it's not going to hurt things further.

Of course that's going to require quite some space to do all files, space 
you apparently don't have ATM.  What you /may/ find useful, however, is 
using the array read-only for what it gives you, if it's most of them, 
and restoring a few damaged files using btrfs restore.  The regex filters 
should allow you to do that, tho it may take a bit of fiddling to get the 
format correct.  (AFAIK they're a bit more complex than ordinary regex.)

Of course you also have the just blow it all away and restore from 
backups option, because you /do/ have backups. =:^)  But based on your 
post I'm guessing that's too easy for you, something I can understand as 
I've been there myself, wanting to do it the hard way to learn.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

