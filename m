Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60166 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbdBHUQA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 15:16:00 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cbYP9-0002Ae-F4
        for linux-btrfs@vger.kernel.org; Wed, 08 Feb 2017 20:59:51 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: BTRFS and cyrus mail server
Date: Wed, 8 Feb 2017 20:59:48 +0100
Message-ID: <20170208205948.69e2eb9f@jupiter.sol.kaishome.de>
References: <24389268.gAX5gEpECb@libor-nb>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 08 Feb 2017 19:38:06 +0100
schrieb Libor Klepáč <libor.klepac@bcom.cz>:

> Hello,
> inspired by recent discussion on BTRFS vs. databases i wanted to ask
> on suitability of BTRFS for hosting a Cyrus imap server spool. I
> haven't found any recent article on this topic.
> 
> I'm preparing migration of our mailserver to Debian Stretch, ie.
> kernel 4.9 for now. We are using XFS for storage now. I will migrate
> using imapsync to new server. Both are virtual machines running on
> vmware on Dell hardware. Disks are on battery backed hw raid
> controllers over vmfs.
> 
> I'm considering using BTRFS, but I'm little concerned because of
> reading this mailing list ;)
> 
> I'm interested in using:
>  - compression (emails should compress well - right?)

Not really... The small part that's compressible (headers and a few
lines of text) are already small, so a sector (maybe 4k) is still a
sector. Compression gains you no benefit here. That big parts of mails
is already compressed (images, attachments). Mail spools only compress
well if you're compressing mails to a solid archive (like 7zip or tgz).
If you're compressing each mail individually, there's almost no gain
because of file system slack.

>  - maybe deduplication (cyrus does it by hardlinking of same content
> messages now) later

It won't work that way. I'd stick to hardlinking. Only
offline/nearline deduplication will help you. And it will have a hard
time finding the duplicates. This would only properly work if Cyrus
separates mail headers and bodies (I don't know if it does, dovecot
doesn't which is what I use) because delivering to the spool usually
adds some headers like "Delivered-To". This changes the byte offsets
between similar mails so that deduplication will no longer work.
 
>  - snapshots for history

Don't do snapshots too deep. I had similar plans but instead decided it
would be better to use the following setup as a continuous backup
strategy: Deliver mails to two spools, one being the user accessible
spool, and one being the backup spool. Once per day you rename the
backup spool and let it be recreated. Then store away the old backup
store in whatever way you want (snapshots, traditional backup with
retention, ...).

>  - send/receive for offisite backup

It's not that stable that I'd use it in production...

>  - what about data inlining, should it be turned off?

How much data can be inlined? I'm not sure, I never thought about that.

> Our Cyrus pool consist of ~520GB of data in ~2,5million files, ~2000 
> mailboxes.

Similar numbers here, just more mailboxes and less space because we
take care that customers remove their mails from our servers and store
it in their own systems and backups. With a few exceptions, and those
have really big mailboxes.

> We have message size limit of ~25MB, so emails are not bigger than
> that.

50 MB raw size here... (after 3-in-4 decoding this makes around 37 MB
worth of attachments)

> There are however bigger files, these are per mailbox
> caches/index files of cyrus (some of them are around 300MB) - and
> these are also files which are most modified.
> Rest of files (messages) are usualy just writen once.

I'm still struggling if I should try btrfs or stay with xfs. Xfs has a
huge benefit of scaling very very well to parallel workloads and
accross multiple devices. Btrfs does exactly that not very well yet
(because of write-serialization etc).

> 
> -----------
> I started using btrfs on backup server as a storage for 4 backuppc
> run in containers (backups are then send away with btrbk), year ago.
> After switching off data inlining i'm satisfied, everything works
> (send/ receive is sometime slow, but i guess it's because of sata
> disks on receive side).

I've started to love borgbackup. It's very fast, efficient, and
reliable. Not sure how good it works for VM images, but for delta
backups in general it's very efficient and fast.


-- 
Regards,
Kai

Replies to list-only preferred.


