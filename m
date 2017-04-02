Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39435 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbdDBA7j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 20:59:39 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cuTra-0000fE-Bz
        for linux-btrfs@vger.kernel.org; Sun, 02 Apr 2017 02:59:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is btrfs-convert able to deal with sparse files in a ext4
 filesystem?
Date: Sun, 2 Apr 2017 00:59:18 +0000 (UTC)
Message-ID: <pan$df213$fa344dca$8529fcec$34b89ea9@cox.net>
References: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
        <20170401191357.GA25721@coach>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sean Greenslade posted on Sat, 01 Apr 2017 12:13:57 -0700 as excerpted:

> On Sat, Apr 01, 2017 at 11:48:50AM +0200, Kai Herlemann wrote:

>> I have on my ext4 filesystem some sparse files, mostly images from ext4
>> filesystems.
>> Is btrfs-convert (4.9.1) able to deal with sparse files or can that
>> cause any problems?
> 
> From personal experience, I would recommend not using btrfs-convert on
> ext4 partitions.

While I'd be extremely surprised if btrfs-convert didn't work on sparse 
files, since if it didn't it wouldn't be a general-purpose converter and 
thus wouldn't be suited to the purpose...

I must agree, tho on general principles, with Sean here, btrfs-convert 
isn't something I'd either use myself or recommend to others.  Consider:

1) Btrfs is considered on this list to be stabilizing, not fully stable 
and mature.  While in general (that is, even on stable and mature 
filesystems) the real value of your data can be defined by whether you 
care enough about it to have backups of that data -- if you don't, you 
self-evidently care less about that data than the time, resources and 
hassle you're saving by NOT doing the backup[1] -- on a still stabilizing 
filesystem such as btrfs, that applies even more strongly.  If you don't 
have a backup and aren't ready to use it if necessary, you really ARE 
declaring that data to be of less value than the time/hassle/resource 
cost of doing it.

2) It follows from #1 that (assuming you consider the data of reasonable 
value) you have backups, and are prepared to restore from them.  Which 
means you have the /space/ for that backup.

3) Which means there's very little reason to use a converter such as 
btrfs-convert, because you can just do a straightforward blow away the 
filesystem and restore from backup (or from the primaries or a secondary 
backup if it /is/ your backup).

4) In fact, since an in-place convert is almost certainly going to take 
more time than a blow-away and restore from backup, and the end result is 
pretty well guaranteed to be less optimally arranged in the new native 
format than a freshly created filesystem with data equally freshly copied 
over from backups or primary sources, there are pretty big reasons *NOT* 
to do an in-place convert.

5) And if you don't have current backups, then by creating a brand new 
btrfs in new space and copying over from your existing ext4, you 
"magically" create that recommended backup, since that ext4 can then be 
used as a backup for your new btrfs.  Of course you'll eventually need to 
update that backup, but meanwhile, it'll be a useful backup, should it be 
needed, while you're settling in on the new btrfs.  =:^)


Meanwhile, it can be noted that plain old cp has the -a/--archive option 
that makes using it for making and restoring backups easier, and it also 
has a --sparse option.  Back on reiserfs, I used to use the 
--sparse=always option for my backups here, without issue, tho on btrfs I 
use the compress (actually compress=lzo] mount option, which should 
compress sparse areas of files even if the files don't get created 
specifically as sparse files, so I don't worry about it on btrfs.

Tho if those ext4 images are to be actively used by VMs or are otherwise 
actively written to, on btrfs I'd consider using the nocow attribute for 
them, and it disables btrfs compression, so I'd consider sparse copying 
for them.  But that's an entirely different topic worthy of its own 
thread if your use-case requires it and you still have questions on it 
after doing your own research...

---
[1] Backup:  Note that a backup that hasn't been tested to be actually 
restorable isn't yet a backup, only a potential backup, as the job of 
making a backup isn't complete until that backup has been tested to be 
restorable.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

