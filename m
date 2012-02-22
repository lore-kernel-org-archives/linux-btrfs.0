From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is there any data recovery tool?
Date: Wed, 22 Feb 2012 12:58:50 +0000 (UTC)
Message-ID: <pan.2012.02.22.12.58.49@cox.net>
References: <CAMtaSwTAeKrvQ2ev7-genxt49ivOAGLYDbKDpO6q1vYExMzj3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

qasdfgtyuiop posted on Tue, 21 Feb 2012 20:11:06 +0800 as excerpted:

> I'm using GNU/linux with btrfs root. My filesystem is created with
> command "mkfs.btrfs /dev/sda" .  Today I'm trying to install Microsoft
> Windows 7 on /dev/sdb , a 16GB esata ssd.  After the installation, I
> found that Windows create a "hidden" NTFS partition called "System
> Reserved" on the first 100MB of my /dev/sda and that my btrfs filesystem
> was lost!  I have searched google for help but I got no useful
> information.  Is there any data recovery tools?

The btrfs kernel option says:

Btrfs filesystem (EXPERIMENTAL) Unstable disk format

Its description says in part:

Btrfs is highly experimental, and THE DISK FORMAT IS NOT YET FINALIZED.
You should say N here unless you are interested in testing Btrfs with non-
critical data. [...] If unsure, say N.

The front page and getting started pages of the wiki (see URL below)
also heavily emphasize the development aspect and backups, and the source
code section has this to say:

Warning, Btrfs evolves very quickly do not test it unless:

    You have good backups and you have tested the restore capability
    You have a backup installation that you can switch to when
	something breaks
    You are willing to report any issues you find
    You can apply patches and compile the latest btrfs code against your
	kernel (quite easy with git and dkms, see below)
    You acknowledge that btrfs may eat your data
    Backups! Backups! Backups! 


Given all that, any data you store on btrfs is by definition not particularly
important, either because you have it backed up in a more stable format
elsewhere (which might be the net, or local), or because the data really
/isn't/ particularly important to you in the first place, or you'd have
made and tested backups (naturally, always test recovery from your backups,
as an untested backup is worse than none, since it's likely to give you
a false sense of security) before putting it on the after all still
experimental and under heavy development btrfs in the first place.

Thus, you shouldn't need to worry about a data recovery tool, since
you can either simply restore from backups (which since you tested
recovery, you're already familiar with the recovery procedures),
or the data was simply garbage you were using for testing and didn't
care about losing anyway.


Never-the-less, yes, there's a recovery tool, naturally experimental
just like the filesystem itself at this point, but there is one.  Testing
and suggestions for improvements, especially with patches, will be
welcomed.

It seems you need to read up on the wiki, which covers this among other
things.  There's an older version on btrfs.wiki.kernel.org, but that's
not updated ATM due to restrictions in place since the kernel.org
breakin some months ago.  The "temporary" (but six months and counting,
I believe) replacement is at btrfs.ipv5.de:

http://btrfs.ipv5.de/index.php?title=Main_Page

The restore and find-root commands from btrfs-progs are specifically
covered on this page:

http://btrfs.ipv5.de/index.php?title=Restore

If you wish to try a newer copy of btrfs-progs (after all, it's all
still in development, and bugs are fixed all the time), you'll also want
to read:

http://btrfs.ipv5.de/index.php?title=Getting_started#Compiling_Btrfs_from_sources


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

