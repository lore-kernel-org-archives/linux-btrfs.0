Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5.ptmail.sapo.pt ([212.55.154.25]:56472 "EHLO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751652AbcFYUK1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 16:10:27 -0400
Date: Sat, 25 Jun 2016 21:10:24 +0100
Message-ID: <20160625211024.Horde.pL6RMZNJL6tnjtpglBZjDaB@mail.sapo.pt>
From: Vasco Almeida <vascomalmeida@sapo.pt>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
References: <loom.20160623T205347-371@post.gmane.org>
 <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
 <5356822.A3RRKHDHNy@linux-omuo>
 <CAJCQCtQ-xYrERT5R4gSC1C7OkoeP2LeS9W9UL5VY5SmDBXk71w@mail.gmail.com>
 <20160625010610.Horde.tUycS31CmgVWfy3CPu7qJCD@mail.sapo.pt>
 <CAJCQCtSGZO8JVXqVOwifT84KTLCkciux+Y6A_na4AA-PxPjjbw@mail.gmail.com>
In-Reply-To: <CAJCQCtSGZO8JVXqVOwifT84KTLCkciux+Y6A_na4AA-PxPjjbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Citando Chris Murphy <lists@colorremedies.com>:

> On Fri, Jun 24, 2016 at 6:06 PM, Vasco Almeida <vascomalmeida@sapo.pt> wrote:
>> Citando Chris Murphy <lists@colorremedies.com>:
>> dmesg http://paste.fedoraproject.org/384352/80842814/
>
> [ 1837.386732] BTRFS info (device dm-9): continuing balance
> [ 1838.006038] BTRFS info (device dm-9): relocating block group
> 15799943168 flags 34
> [ 1838.684892] BTRFS info (device dm-9): relocating block group
> 10934550528 flags 36
> [ 1839.301453] ------------[ cut here ]------------
> [ 1839.301495] WARNING: CPU: 3 PID: 76 at fs/btrfs/extent-tree.c:1625
> lookup_inline_extent_backref+0x45c/0x5a0 [btrfs]()
>
> followed by
>
> [ 1839.301797] WARNING: CPU: 3 PID: 76 at fs/btrfs/extent-tree.c:2946
> btrfs_run_delayed_refs+0x29d/0x2d0 [btrfs]()
> [ 1839.301798] BTRFS: Transaction aborted (error -5)
> [...]
> [ 1839.301972] BTRFS: error (device dm-9) in
> btrfs_run_delayed_refs:2946: errno=-5 IO failure
> [ 1839.301975] BTRFS info (device dm-9): forced readonly
>
> So it looks like it was resuming a balance automatically, and while
> processing delayed references it's running into something it doesn't
> expect and doesn't have a way to fix, so it goes read only to avoid
> causing more problems.
>
> I would do a couple things in order:
> 1. Mount ro and copy off what you want in case the whole thing gets
> worse and can't ever be mounted again.
> 2. Mount with only these options: -o skip_balance,subvolid=5,nospace_cache

I have mounted with that options and was readwrite first and then it  
forces readonly. You can see a delay between first BTRFS messages and  
the "BTRFS info: forced readonly" message in dmesg.

/dev/mapper/vg_pupu-lv_opensuse_root on /mnt type btrfs  
(ro,relatime,seclabel,nospace_cache,skip_balance,subvolid=5,subvol=/)


> If it mounts rw, don't do anything with it, just see if it cleans up
> after itself. It also looks from the previous trace it was trying to
> remove a snapshot and there are complaints of problems in that
> snapshot. So hopefully just waiting 5 minutes doing nothing and it'll
> clean up after itself (you can check with top to see if there are any
> btrfs related transactions that run including the btrfs-cleaner
> process) wait until they're done.

I can see that btrfs processes including btrfs-cleaner but they may be  
not doing much since device was forced readonly after mounting it.

> Then umount. If you want you could have two other consoles ready
> first, one for 'journalctl -f' and another for sysrq+t to issue in
> case you get a hang. This doesn't fix anything but it collects more
> information for a bug report for the devs.
>
> Once you get it umounted normally or by force, the next thing to do is

I have umount it normally (umount /mnt) after more than 20 minutes  
since mounting it.

> 3. btrfs-image so that devs can see what's causing the problem that
> the current code isn't handling well enough.

btrfs-image does not create dump image:

# btrfs-image /dev/mapper/vg_pupu-lv_opensuse_root  
btrfs-lv_opensuse_root.image
checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
Csum didn't match
Error reading metadata block
Error adding block -5
checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
Csum didn't match
Error reading metadata block
Error flushing pending -5
create failed (Success)
# echo $?
1


> 4. btrfs check --repair

Did not issue this command yet.

dmesg http://paste.fedoraproject.org/384799/14668851/

Thank your for helping.

