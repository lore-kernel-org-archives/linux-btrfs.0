Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50289 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbbLGIZV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 03:25:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a5r6j-0003Me-6c
	for linux-btrfs@vger.kernel.org; Mon, 07 Dec 2015 09:25:17 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 09:25:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 09:25:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing recursive fault and parent transid verify failed
Date: Mon, 7 Dec 2015 08:25:01 +0000 (UTC)
Message-ID: <pan$42653$68e1a3aa$3a4c1c2c$b0e89f8@cox.net>
References: <20151207015715.GA13954@alistair-xps13>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alistair Grant posted on Mon, 07 Dec 2015 12:57:15 +1100 as excerpted:

> I've ran btrfs scrub and btrfsck on the drives, with the output included
> below.  Based on what I've found on the web, I assume that a
> btrfs-zero-log is required.
> 
> * Is this the recommended path?

[Just replying to a couple more minor points, here.]

Absolutely not.  btrfs-zero-log isn't the tool you need here.

About the btrfs log...

Unlike most journaling filesystems, btrfs is designed to be atomic and 
consistent at commit time (every 30 seconds by default) and doesn't log 
normal filesystem activity at all.  The only thing logged is fsyncs, 
allowing them to deliver on their file-written-to-hardware guarantees, 
without forcing the entire atomic filesystem sync, which would trigger a 
normal atomic commit and thus is a far heavier weight process.  IOW, all 
it does is log and speedup fsyncs.  The filesystem is designed to be 
atomically consistent at commit time, with or without the log, with the 
only thing missing if the log isn't replayed being the last few seconds 
of fsyncs since the last atomic commit.

So the btrfs log is very limited in scope and will in many cases be 
entirely empty, if there were no fsyncs after the last atomic filesystem 
commit, again, every 30 seconds by default, so in human terms at least, 
not a lot of time.

About btrfs log replay...

The kernel, meanwhile, is designed to replay the log automatically at 
mount time.  If the mount is successful, the log has by definition been 
replayed successfully and zeroing it wouldn't have done much of anything 
but possibly lose you a few seconds worth of fsyncs.

Since you are able to run scrub, which requires a writable mount, the 
mount is definitely successful, which means btrfs-zero-log is the wrong 
tool for the job, since it addresses a problem you obviously don't have.

> * Is there a way to find out which files will be affected by the loss of
>   the transactions?

I'm interpreting that question in the context of the transid wanted/found 
listings in your linked logs, since it no longer makes sense in the 
context of btrfs-zero-log, given the information above.

I believe so, but the most direct method requires manual use of btrfs-
debug and similar tools, looking up addresses and tracing down the files 
to which they belong.  Of course that's if the addresses trace to actual 
files at all.  If they trace to metadata instead of data, then it's not 
normally files, but the metadata (including checksums and very small 
files of only a few KiB) about files, instead.  Of course if it's 
metadata the problem's worse, as a single bad metadata block can affect 
multiple actual files.

The more indirect way would be to use btrfs restore with the -t option, 
feeding it the root address associated with the transid found (with that 
association traced via btrfs-find-root), to restore the file from the 
filesystem as it existed at that point, to some other mounted filesystem, 
also using the restore metadata option.  You could then do for instance a 
diff of the listing (or possibly a per-file checksum, say md5sum, of both 
versions) between your current backup (or current mounted filesystem, 
since you can still mount it) and the restored version, which would be 
the files at the time of that transaction-id, and see which ones 
changed.  That of course would be the affected files. =:^]

> I do have a backup of the drive (which I believe is completely up to
> date, the btrfs volume is used for archiving media and documents, and
> single person use of git repositories, i.e. only very light writing and
> reading).

Of course either one of the above is going to be quite some work, and if 
you have a current backup, simply restoring it is likely to be far 
easier, unless of course you're interested in practicing your recovery 
technique or the like, certainly not a valueless endeavor, if you have 
the time and patience for it.

The *GOOD* thing is that you *DO* have a current backup.  Far *FAR* too 
many people we see posting here, are unfortunately finding out the hard 
way, that their actions, or more precisely, lack thereof, in failing to 
do backups, put the lie to any claims that they actually valued the 
data.  As any good sysadmin can tell you, often from unhappy lessons such 
as this, if it's not backed up, by definition, your actions are placing 
its value at less than the time and resources necessary to do that backup 
(modified of course by the risk factor of actually needing it, thus 
taking care of the Nth level backup, some of which are off-site, if the 
data is really /that/ valuable, while also covering the throw-away data 
that's so trivial as to not justify even the effort of a single level of 
backup).

So hurray for you! =:^)

(FWIW, I personally have backups of most stuff here, often several 
levels, tho I don't always keep them current.  But should I be forced to 
resort to them, I'm prepared to lose the intervening updates, as I 
recognize that by failing to keep those backups current I really am 
defining the intervening data at risk as worth less than the hassle and 
resources to more regularly update the backups.  It wouldn't be pleasant 
having to resort to them, and fortunately, the twice I might have since I 
started running btrfs, btrfs restore was able to restore very close to 
the latest copies, but if it comes to it, I'm prepared to live with loss 
of the data since those somewhat dated backups, as for me, the most 
important stuff is in my head anyway, and if I end up losing /that/ 
backup, I won't be caring much about the others, will I? =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

