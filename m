Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46489 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751209AbeAWJDu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 04:03:50 -0500
Subject: Re: Superblock update: Is there really any benefits of updating
 synchronously?
To: waxhead@dirtcellar.net, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <2f19aa79-b8f4-294e-5298-3a7ed7fbd67d@dirtcellar.net>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f8674469-cb64-ace6-ae08-3c3b360fb8e3@suse.com>
Date: Tue, 23 Jan 2018 11:03:44 +0200
MIME-Version: 1.0
In-Reply-To: <2f19aa79-b8f4-294e-5298-3a7ed7fbd67d@dirtcellar.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.01.2018 09:03, waxhead wrote:
> Note: This have been mentioned before, but since I see some issues
> related to superblocks I think it would be good to bring up the question
> again.
> 
> According to the information found in the wiki:
> https://btrfs.wiki.kernel.org/index.php/On-disk_Format#Superblock
> 
> The superblocks are updated synchronously on HDD's and one after each
> other on SSD's.

There is currently no distinction in the code whether we are writing to
SSD or HDD. Also what do you mean by synchronously, if you inspect the
code in write_all_supers you will see what for every device we issue
writes for every available copy of the superblock and then wait for all
of them to be finished via the 'wait_dev_supers'. In that regard sb
writeout is asynchronous.

> 
> Superblocks are also (to my knowledge) not protected by copy-on-write
> and are read-modify-update.
> 
> On a storage device with >256GB there will be three superblocks.
> 
> BTRFS will always prefer the superblock with the highest generation
> number providing that the checksum is good.

Wrong. On mount btrfs will only ever read the first superblock at 64k.
If that one is corrupted it will refuse to mount, then it's expected the
user will initiate recovery procedure with btrfs-progs which reads all
supers and replaces them with the "newest" one (as decided by the
generation number)

> 
> On the list there seem to be a few incidents where the superblocks have
> gone toast and I am pondering what (if any) benefits there is by
> updating the superblocks synchronously.
> 
> The superblock is checkpoint'ed every 30 seconds by default and if
> someone pulls the plug (poweroutage) on HDD's then a synchronous write
> depending on (the quality of) your hardware may perhaps ruin all the
> superblock copies in one go. E.g. Copy A,B and C will all be updated at
> 30s.
> 
> On SSD's, since one superblock is updated after other it would mean that
> using the default 30 second checkpoint Copy A=30s, Copy B=1m, Copy C=1m30s
As explained previously there is no notion of "SSD vs HDD" modes.

> Why is the SSD method not used on harddrives also?! If two superblocks
> are toast you would at maximum loose 1m30s by default , and if this is
> considered a problem then you can always adjust downwards the commit
> time. If this is set to 15 seconds you would still only loose 30 seconds
> of "action time" and would in my opinion be far better off from a
> reliability point of view than having to update multiple superblocks at
> the same time. I can't see why on earth updating all superblocks at the
> same time would have any benefits.
> 
> So this all boils down to the questions three (ere the other side will
> see..... :P )
> 
> 1. What are the benefits of updating all superblocks at the same time?
> (Just imagine if your memory is bad - you could risk updating all
> superblocks simultaneously with kebab'ed data).
> 
> 2. What would the negative consequences be by using the SSD scheme also
> for harddisks? Especially if the commit time is set to 15s instead of 30s
> 
> 3. In a RAID1 / 10 / 5 / 6 like setup. Would a set of corrupt
> superblocks on a single drive be recoverable from other disks or do the
> superblocks need to be intact on the (possibly) damaged drive?

According to the code in super-recover.c from btrfs-progs you needn't
have the sb intact on the broken disks, since the tool first makes a
list of all devices constituting this filesystem, then makes a list of
all valid superblocks on those disks and finally chooses the one with
the higher generation number to replace the rest

> (If the superblocks are needed then why would not SSD mode be better
> especially if the drive is partly working)
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
