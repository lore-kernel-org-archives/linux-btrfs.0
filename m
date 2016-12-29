Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55653 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753708AbcL2Wb5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 17:31:57 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cMjEj-0007Va-EE
        for linux-btrfs@vger.kernel.org; Thu, 29 Dec 2016 23:31:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mounting failed any file on my filesystem
Date: Thu, 29 Dec 2016 22:31:29 +0000 (UTC)
Message-ID: <pan$623d2$cd2f67c9$e174a628$49552d7a@cox.net>
References: <1707774.BW2KGqTm4d@dibsi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Koester posted on Thu, 29 Dec 2016 20:05:35 +0100 as excerpted:

> Hi,
> 
> i have problem with filesystem if my system crashed i have made been
> hard reset of the system after my Filesystem was crashed. I have already
> tried to repair without success you can see it on log file. It's seem
> one corrupted block brings complete filesystem to crashing.
> 
> Have anybody idea what happened with my filesystem ?
> 
> dmesg if open file:
> [29450.404327] WARNING: CPU: 5 PID: 16161 at
> /build/linux-lIgGMF/linux-4.8.11/ fs/btrfs/extent-tree.c:6945
> __btrfs_free_extent.isra.71+0x8e2/0xd60 [btrfs]

First a disclaimer.  I'm a btrfs user and list regular, not a dev.  As 
such I don't really read call traces much beyond checking the kernel 
version, and don't do code.  It's likely that you will get a more 
authoritative reply from someone who does, and it should take precedence, 
but in the mean time, I can try to deal with the preliminaries.

Kernel 4.8.11, good.  But you run btrfs check below, and we don't have 
the version of your btrfs-progs userspace.  Please report that too.

> btrfs output:
> root@dibsi:/home/jan# btrfs check /dev/disk/by-uuid/
> 73d4dc77-6ff3-412f-9b0a-0d11458faf32

Note that btrfs check is read-only by default.  It will report what it 
thinks are errors, but won't attempt to fix them unless you add various 
options (such as --repair) to tell it to do so.  This is by design and is 
very important, as attempting to repair problems that it doesn't properly 
understand could make the problems worse instead of better.  So even tho 
the above command will only report what it sees as problems, not attempt 
to fix them, you did the right thing by running check without --repair 
first, and posting the results here for an expert to look at and tell you 
whether to try --repair, or what else to try instead.

> Checking filesystem on
> /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32
> UUID: 73d4dc77-6ff3-412f-9b0a-0d11458faf32
> checking extents
> parent transid verify failed on 2280458502144 wanted 861168
> found 860380
> parent transid verify failed on 2280458502144 wanted 861168
> found 860380
> checksum verify failed on 2280458502144 found FC3DF84D
> wanted 2164EB93
> checksum verify failed on 2280458502144 found FC3DF84D
> wanted 2164EB93
> bytenr mismatch, want=2280458502144, have=15938383240448
[...]

Some other information that we normally ask for includes the output from 
a few other btrfs commands.

It's unclear from your report if the filesystem will mount at all.  The 
subject says mount failed, but then it mentions any file on the 
filesystem, which seems to imply that you could mount, but that any file 
you attempted to actually access after mounting crashes the system with 
the trace you posted, so I'm not sure if you can actually mount the 
filesystem at all.

If you can't mount the filesystem, at least try to post the output from...

btrfs filesystem show

If you can mount the filesystem, then the much more detailed...

btrfs filesystem usage

... if your btrfs-progs is new enough, or...

btrfs filesystem df

... if btrfs-progs is too old to have the usage command.

Also, if it's not clear from the output of the commands above (usage by 
itself, or show plus df, should answer most of the below, but show alone 
only provides some of the information), tell us a bit more about the 
filesystem in question:

Single device (like traditional filesystems) or multiple device?  If 
multiple device, what raid levels if you know them, or did you just go 
with the defaults.  If single device, again, defaults, or did you specify 
single or dup, particularly for metadata.

Also, how big was the filesystem and how close to full?  And was it on 
ssd, spinning rust, or on top of something virtual (like a VM image 
existing as a file on the host, or lvm, or mdraid, etc)?


Meanwhile, if you can mount, the first thing I'd try is btrfs scrub 
(unless you were running btrfs raid56 mode, which makes things far more 
complex as it's not stable yet and isn't recommended except for testing 
with data you can afford to lose).  Often, a scrub can fix much of the 
damage of a crash if you were running raid1 mode (multi-device metadata 
default), raid10, or dup (single device metadata default, except on ssd), 
as those have a second checksummed copy that will often be correct that 
scrub can use to fix the bad copy, but it will detect but be unable to 
fix damage in single mode (default for data) or raid0 mode, as those 
don't have a second copy available to fix the first.

Because the default for single device btrfs is dup metadata, single data, 
in that case the scrub should fix most or all of metadata, allowing you 
to access small file (roughly anything under a couple KiB) and larger 
files that weren't themselves damaged, but you may still have damage in 
some files of any significant size.

But scrub can only run if you can mount the filesystem.  If you can't, 
then you have to try other things in ordered to get it mountable, first.  
Many of these other things tend to be much more complex and risky, so if 
you can mount at all, try scrub first, and see how much it helps.  Here 
I'm dual-device raid1 for nearly all my btrfs, and (assuming I can mount 
the affected filesystem, which I usually can) I now run scrub first thing 
after a crash, as a preventative measure even without knowing if the 
filesystem was damaged or not.

If the filesystem won't mount, then the recommendation is /likely/ to be 
trying the usebackuproot mount option (which replaced the older recovery 
mount option, but you're using a new enough kernel for usebackuproot), 
which will try some older tree roots if the newest one is damaged.  You 
may have to use that option with readonly, which of course will prevent 
running scrub or the like while mounted, but may help you get access to 
the data at least to freshen up your backups.  However, usebackuproot 
will by definition sacrifice the last seconds of writes before the crash, 
and while I'd probably try this option on my own system without asking, 
I'm not comfortable recommending it to others, so I'd suggest waiting for 
one of the higher experts to confirm, before trying it yourself.

Beyond usebackuproot, you get into more risky attempts to repair that may 
instead do further damage if they don't work.  This is where btrfs check 
--repair lives, along with some other check options, btrfs rescue, etc.  
Unless specifically told otherwise by an expert after they look at the 
filesystem info, these are risky enough that if at all possible, you want 
to freshen your backups before you try them.

That's where btrfs restore comes in, as it lets you try to attempt 
restoring files from an unmountable filesystem, while not actually 
writing to that filesystem, thus not risking doing further damage, in the 
process.  Of course that means you have to have some place to put the 
files it's going to restore.  In simple mode you just run btrfs restore 
with commandline parameters telling it what device to try to restore from 
and where to put the restored files (and some options telling it whether 
to try restoring metadata like file ownership, permissions, dates, etc), 
and it just works.

However, should btrfs restore's simple mode fail, there's more complex 
advanced modes to try, still without risking further damage to the 
filesystem in question, but that gets complex enough it needs its own 
post... if you come to that.  There's a page on the wiki with some 
instructions, but they may not be current and it's a complex enough 
operation that most people need help beyond what's on the wiki (and in 
the btrfs-restore manpage), anyway.  But here's the link so you can take 
a look at what the general operation looks like:

https://btrfs.wiki.kernel.org/index.php/Restore

Meanwhile, it's a bit late now, but in general, btrfs is considered still 
in heavy development, stabilizing but not yet fully stable and mature.  
As such, while any sysadmin worth the label will tell you that you are 
defining any data you don't have backups for as not worth the time, 
trouble and resources to do those backups, basically defining it as throw-
away data because it's /not/ worth backing up or by definition you'd 
/have/ those backups, even for normal stable and mature filesystems, with 
btrfs still stabilizing, backups are even /more/ strongly recommended, as 
is keeping them current within the window of data you're willing to lose 
if you lose the primary copy, and keeping those backups practically 
usable (not over a slow net link that'll take over a week to download in 
ordered to restore, for instance, one real case that was posted).  If 
you're doing that then losing a filesystem isn't going to be a big stress 
and you can afford to skip the real complex and risky stuff (unless 
you're simply doing it to learn how) and just restore from backup, as it 
will be simpler.  If not, then you should really reexamine whether btrfs 
is the right filesystem choice for you, because it /isn't/ yet fully 
stable and mature, and chances are you'd be better off with a more stable 
and mature filesystem where not having updated at-hand backups is less of 
a risk (altho as I said any sysadmin worth the name will tell you not 
having backups is literally defining the data as throw-away value, 
because in the real world, "things happen", and there's too many of those 
things possible in the real world to behave otherwise).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

