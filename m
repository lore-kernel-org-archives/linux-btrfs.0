Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54593 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbcDFVCW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Apr 2016 17:02:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anuag-0001IQ-Ts
	for linux-btrfs@vger.kernel.org; Wed, 06 Apr 2016 23:02:19 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 23:02:18 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 23:02:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
Date: Wed, 6 Apr 2016 21:02:07 +0000 (UTC)
Message-ID: <pan$20f45$63875276$ec725eab$c0dca8d1@cox.net>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ank Ular posted on Wed, 06 Apr 2016 11:34:39 -0400 as excerpted:

> I am currently unable to mount nor recover data from my btrfs storage
> pool.
> 
> To the best of my knowledge, the situation did not arise from hard disk
> failure. I believe the sequence of events is:
> 
> One or possibly more of my external devices had the USB 3.0
> communications link fail. I recall seeing the message which is generated
> when a USB based storage device is newly connected.
> 
> I was near the end of a 'btrfs balance' run which included adding
> devices and converting the pool from RAID5 to RAID6. There were
> approximately 1000 chunks {out of 22K+ chunks} left to go.
> I was also participating in several torrents {this means my btrfs pool
> was active}
> 
> From the ouput of 'dmesg', the section:
> [   20.998071] BTRFS: device label FSgyroA
> devid 9 transid 625039 /dev/sdm
> [   20.999984] BTRFS: device label FSgyroA
> devid 10 transid 625039 /dev/sdn
> [   21.004127] BTRFS: device label FSgyroA
> devid 11 transid 625039 /dev/sds
> [   21.011808] BTRFS: device label FSgyroA
> devid 12 transid 625039 /dev/sdu
> 
> bothers me because the transid value of these four devices doesn't match
> the other 16 devices in the pool {should be 625065}. In theory,
> I believe these should all have the same transid value. These four
> devices are all on a single USB 3.0 port and this is the link I believe
> went down and came back up. This is an external, four drive bay case
> with 4 6T drives in it.

Unfortunately it's somewhat common to have problems with USB attached 
devices.  On a single-device btrfs it's not so much of a problem because 
it all dies at the same time and should be conventionally rolled back to 
the previous transaction commit, with fsyncs beyond that replayed by the 
log.  A pair-device raid1 mode should be easily recovered as well, as 
while the two may be out of sync, there's only the two copies and one 
will consistently be ahead, so the btrfs should mount and a scrub can 
easily be used to update the device that's behind.  Any other raid than 
raid0 should work similarly when only a single device is behind.

But with multiple devices behind, like your four, things get far more 
complex.

Of course the first thing to note is that with btrfs still considered 
stabilizing, but not fully stable and mature, the sysadmin's rule of 
backups, in simple form that anything without at least one backup is 
defined by that lack of backup as not worth the trouble, applies even 
stronger than it would in the mature filesystem case.  Similarly, btrfs' 
parity-raid is fairly new and not yet at the stability of other btrfs 
raid types (raid1 and raid10, plus of course raid0 which implies you 
don't care about recovery after failure anyway), strengthening the 
application of the backups rule even further.

So you definitely (triple-power!) either had backups you can restore 
from, or were defining that data as not worth the hassle.  That means 
worst-case, you can either restore from your backups, or you considered 
the time and resources saved in not doing them more valuable than the 
data you were risking.  Since either way you saved what was most 
important to you, you can be happy. =:^)

But even if you had backups, there's then a tradeoff between the hassle 
of updating them and the risk of having to revert to them, and like me, 
while you do have backups they may not be particularly current as the 
limited risk didn't really justify updating the backups at a higher 
frequency, so some effort to get more current versions is justified.  
(I've actually been in that situation a couple times with some of my 
btrfs.  Fortunately, in both cases I was able to btrfs restore and thus 
/was/ able to recover basically current versions of everything that 
mattered on the filesystem.)

Anyway, that does sound like where you're at, you have backups but 
they're several weeks old and you'd prefer to recover newer versions if 
possible.  That I can definitely understand as I've been there. =:^)


With four devices behind by (fortunately only) 26 transactions, and 
luckily all at the same transaction/generation number, you're likely 
beyond what the recovery mount option can deal with (I believe upto three 
transactions, tho it might be a few more in newer kernels), and obviously 
from your results, beyond what btrfs restore can deal with automatically 
as well.

There is still hope via btrfs restore, but you have to feed it more 
information than it can get on its own, and while it's reasonably likely 
that you can get that information and as a result a successful restore, 
the process of finding the information and manually verifying that it's 
appropriately complete is definitely rather more technical than the 
automated process.  If you're sufficiently technically inclined (not at a 
dev level, but at an admin level, able to understand technical concepts 
and make use of them on the command line, etc), your chances at recovery 
are still rather good.  If you aren't... better be getting out those 
backups.

There's a page on the wiki that describes the general process, but keep 
in mind that the tools continue to evolve and the wiki page may not be 
absolutely current, so what it describes might not be exactly what you 
get, and you may have to do some translation between the current tools 
and what's on the wiki.  (Actually, it looks like it is much more current 
than it used to be, but I'm not sure whether all parts of the page have 
been updated/rewritten or not.)

https://btrfs.wiki.kernel.org/index.php/Restore

You're at the "advanced usage" point as the automated method didn't work.

The general idea is to use the btrfs-find-root command to get a list of 
previous roots, their generation number (aka transaction ID, aka transid), 
and their corresponding byte number (bytenr).  The bytenr is the value 
you feed to btrfs restore, via the -t option.

I'd start with the 625039 generation/transid that is the latest on the 
four "behind" devices, hoping that the other devices still have it intact 
as well.  Find the corresponding bytenr via btrfs-find-root, and feed it 
to btrfs restore via -t.  But not yet in a live run!!

First, use -t and -l together, to get a list of the tree-roots available 
at that bytenr.  You want to pick a bytenr/generation that still has its 
tree roots intact as much as possible.  Down near the bottom of the page 
there's a bit of an explanation of what the object-IDs mean.  The low 
number ones are filesystem-global and are quite critical.  256 up are 
subvolumes and snapshots.  If a few snapshots are missing no big deal, 
tho if something critical is in a subvolume, you'll want either it or a 
snapshot of it available to try to restore from.

Once you have a -t bytenr candidate with ideally all of the objects 
intact, or as many as possible if not all of them, do a dry-run using the 
-D option.  The output here will be the list of files it's trying to 
recover and thus may be (hopefully is, with a reasonably populated 
filesystem) quite long.  But if it looks reasonable, you can use the same 
-t bytenr without the -D/dry-run option to do the actual restore.  Be 
sure to use the various options restoring metadata, symlinks, extended 
attributes, snapshots, etc, if appropriate.

Of course you'll need enough space to restore to as well.  If that's an 
issue, you can use the --path-regex option to restore the most important 
stuff only.  There's an example on the page.


If that's beyond your technical abilities or otherwise doesn't work, you 
may be able to use some of the advanced options of btrfs check and btrfs 
rescue to help, but I've never tried that myself and you'll be better off 
with help from someone else, because unlike restore, which doesn't write 
to the damaged filesystem the files are being restored from and thus 
can't damage it further, these tools and options can destroy any 
reasonable hope of recovery if they aren't used with appropriate 
knowledge and care.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

