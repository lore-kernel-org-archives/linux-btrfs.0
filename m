Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36793 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbbLGKDB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 05:03:01 -0500
Received: by pfdd184 with SMTP id d184so62720391pfd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 02:03:00 -0800 (PST)
Received: from localhost (114-198-89-204.dyn.iinet.net.au. [114.198.89.204])
        by smtp.gmail.com with ESMTPSA id 25sm33462383pfp.62.2015.12.07.02.02.59
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Dec 2015 02:03:00 -0800 (PST)
Date: Mon, 7 Dec 2015 21:02:56 +1100
From: Alistair Grant <akgrant0710@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Fixing recursive fault and parent transid verify failed
Message-ID: <20151207100256.GA6836@alistair-xps13>
References: <20151207015715.GA13954@alistair-xps13>
 <pan$42653$68e1a3aa$3a4c1c2c$b0e89f8@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$42653$68e1a3aa$3a4c1c2c$b0e89f8@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 07, 2015 at 08:25:01AM +0000, Duncan wrote:
> Alistair Grant posted on Mon, 07 Dec 2015 12:57:15 +1100 as excerpted:
> 
> > I've ran btrfs scrub and btrfsck on the drives, with the output included
> > below.  Based on what I've found on the web, I assume that a
> > btrfs-zero-log is required.
> > 
> > * Is this the recommended path?
> 
> [Just replying to a couple more minor points, here.]
> 
> Absolutely not.  btrfs-zero-log isn't the tool you need here.
> 
> About the btrfs log...
> 
> Unlike most journaling filesystems, btrfs is designed to be atomic and 
> consistent at commit time (every 30 seconds by default) and doesn't log 
> normal filesystem activity at all.  The only thing logged is fsyncs, 
> allowing them to deliver on their file-written-to-hardware guarantees, 
> without forcing the entire atomic filesystem sync, which would trigger a 
> normal atomic commit and thus is a far heavier weight process.  IOW, all 
> it does is log and speedup fsyncs.  The filesystem is designed to be 
> atomically consistent at commit time, with or without the log, with the 
> only thing missing if the log isn't replayed being the last few seconds 
> of fsyncs since the last atomic commit.
> 
> So the btrfs log is very limited in scope and will in many cases be 
> entirely empty, if there were no fsyncs after the last atomic filesystem 
> commit, again, every 30 seconds by default, so in human terms at least, 
> not a lot of time.
> 
> About btrfs log replay...
> 
> The kernel, meanwhile, is designed to replay the log automatically at 
> mount time.  If the mount is successful, the log has by definition been 
> replayed successfully and zeroing it wouldn't have done much of anything 
> but possibly lose you a few seconds worth of fsyncs.
> 
> Since you are able to run scrub, which requires a writable mount, the 
> mount is definitely successful, which means btrfs-zero-log is the wrong 
> tool for the job, since it addresses a problem you obviously don't have.

OK, thanks for the detailed explanation (here and below, so I don't have
to repeat myself).

The reason I thought it might be required was that the parent transid
failed errors were found even after a reboot (and obviously remounting
the filesystem) and without any user activity.

> 
> > * Is there a way to find out which files will be affected by the loss of
> >   the transactions?
> 
> I'm interpreting that question in the context of the transid wanted/found 
> listings in your linked logs, since it no longer makes sense in the 
> context of btrfs-zero-log, given the information above.
> 
> I believe so, but the most direct method requires manual use of btrfs-
> debug and similar tools, looking up addresses and tracing down the files 
> to which they belong.  Of course that's if the addresses trace to actual 
> files at all.  If they trace to metadata instead of data, then it's not 
> normally files, but the metadata (including checksums and very small 
> files of only a few KiB) about files, instead.  Of course if it's 
> metadata the problem's worse, as a single bad metadata block can affect 
> multiple actual files.
> 
> The more indirect way would be to use btrfs restore with the -t option, 
> feeding it the root address associated with the transid found (with that 
> association traced via btrfs-find-root), to restore the file from the 
> filesystem as it existed at that point, to some other mounted filesystem, 
> also using the restore metadata option.  You could then do for instance a 
> diff of the listing (or possibly a per-file checksum, say md5sum, of both 
> versions) between your current backup (or current mounted filesystem, 
> since you can still mount it) and the restored version, which would be 
> the files at the time of that transaction-id, and see which ones 
> changed.  That of course would be the affected files. =:^]
> 

I think I'll try the btrfs restore as a learning exercise, and to check
the contents of my backup (I don't trust my memory, so something could
have changed since the last backup).

Does btrfs restore require the path to be on a btrfs filesystem?  I've
got an existing ext4 drive with enough free space to do the restore, so
would prefer to use it than have to buy another drive.

My plan is:

* btrfs restore /dev/sdX /path/to/ext4/restorepoint
** Where /dev/sdX is one of the two drives that were part of the raid1
   fileystem
* hashdeep audit the restored drive and backup
* delete the existing corrupted btrfs filesystem and recreate
* rsync the merge filesystem (from backup and restore) on to the new
  filesystem

Any comments or suggestions are welcome.


> > I do have a backup of the drive (which I believe is completely up to
> > date, the btrfs volume is used for archiving media and documents, and
> > single person use of git repositories, i.e. only very light writing and
> > reading).
> 
> Of course either one of the above is going to be quite some work, and if 
> you have a current backup, simply restoring it is likely to be far 
> easier, unless of course you're interested in practicing your recovery 
> technique or the like, certainly not a valueless endeavor, if you have 
> the time and patience for it.
> 
> The *GOOD* thing is that you *DO* have a current backup.  Far *FAR* too 
> many people we see posting here, are unfortunately finding out the hard 
> way, that their actions, or more precisely, lack thereof, in failing to 
> do backups, put the lie to any claims that they actually valued the 
> data.  As any good sysadmin can tell you, often from unhappy lessons such 
> as this, if it's not backed up, by definition, your actions are placing 
> its value at less than the time and resources necessary to do that backup 
> (modified of course by the risk factor of actually needing it, thus 
> taking care of the Nth level backup, some of which are off-site, if the 
> data is really /that/ valuable, while also covering the throw-away data 
> that's so trivial as to not justify even the effort of a single level of 
> backup).
> 
> So hurray for you! =:^)
> 
> (FWIW, I personally have backups of most stuff here, often several 
> levels, tho I don't always keep them current.  But should I be forced to 
> resort to them, I'm prepared to lose the intervening updates, as I 
> recognize that by failing to keep those backups current I really am 
> defining the intervening data at risk as worth less than the hassle and 
> resources to more regularly update the backups.  It wouldn't be pleasant 
> having to resort to them, and fortunately, the twice I might have since I 
> started running btrfs, btrfs restore was able to restore very close to 
> the latest copies, but if it comes to it, I'm prepared to live with loss 
> of the data since those somewhat dated backups, as for me, the most 
> important stuff is in my head anyway, and if I end up losing /that/ 
> backup, I won't be caring much about the others, will I? =:^)
> 
> -- 
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman

Thanks again for all your help, Duncan.

Cheers,
Alistair

