Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from umail2.aei.mpg.de ([194.94.224.8]:46898 "EHLO umail2.aei.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752802AbdA3WhX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 17:37:23 -0500
Received: from mailgate.aei.mpg.de (mailgate.aei.mpg.de [194.94.224.5])
        by umail2.aei.mpg.de (Postfix) with ESMTP id A50841BA6787
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 23:37:20 +0100 (CET)
Received: from mailgate.aei.mpg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 97A23406ADE
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 23:37:20 +0100 (CET)
Received: from intranet.aei.uni-hannover.de (ahin1.aei.uni-hannover.de [130.75.117.40])
        by mailgate.aei.mpg.de (Postfix) with ESMTP id 645D3406ADB
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 23:37:20 +0100 (CET)
Subject: Re: btrfs recovery
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
 <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
 <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de>
 <014c7da2-0129-caee-00d8-12f2af628efc@mendix.com>
 <CAP8EXU310iKo-exrYk3Hm4tyUQSL+KYEYEV4h8zifiwxmse7uA@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Michael Born <Michael.Born@aei.mpg.de>
Message-ID: <161bffef-9bc8-e5da-476b-d214e2a7d69b@aei.mpg.de>
Date: Mon, 30 Jan 2017 23:37:19 +0100
MIME-Version: 1.0
In-Reply-To: <CAP8EXU310iKo-exrYk3Hm4tyUQSL+KYEYEV4h8zifiwxmse7uA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gordon,

I'm quite sure this is not a good idea.
I do understand, that dd-ing a running system will miss some changes
done to the file system while copying. I'm surprised that I didn't end
up with some corrupted files, but with no files at all.
Also, I'm not interested in restoring the old Suse 13.2 system. I just
want some configuration files from it.

Cheers,
Michael

Am 30.01.2017 um 23:24 schrieb GWB:
> <<
> Hi btrfs experts.
> 
> Hereby I apply for the stupidity of the month award.
>>>
> 
> I have no doubt that I will will mount a serious challenge to you for
> that title, so you haven't won yet.
> 
> Why not dd the image back onto the original partition (or another
> partition identical in size) and see if that is readable?
> 
> My limited experience with btrfs (I am not an expert) is that read
> only snapshots work well in this situation, but the initial hurdle is
> using dd to get the image back onto a partition.  So I wonder if you
> could dd the image back onto the original media (the hd sdd), then
> make a read only snapshot, and then send the snapshot with btrfs send
> to another storage medium.  With any luck, the machine might boot, and
> you might find other snapshots which you may be able to turn into read
> only snaps for btrfs send.
> 
> This has worked for me on Ubuntu 14 for quite some time, but luckily I
> have not had to restore the image file sent from btrfs send yet.  I
> say luckily, because I realise now that the image created from btrfs
> send should be tested, but so far no catastrophic failures with my
> root partition have occurred (knock on wood).
> 
> dd is (like dumpfs, ddrescue, and the bsd variations) good for what it
> tries to do, but not so great on for some file systems for more
> intricate uses.  But why not try:
> 
> dd if=imagefile.dd of=/dev/sdaX
> 
> and see if it boots?  If it does not, then perhaps you have another
> shot at the one time mount for btrfs rw if that works.
> 
> Or is your root partition now running fine under Suse 14.2, and you
> are just looking to recover a file files from the image?  If so, you
> might try to dd from the image to a partition of original size as the
> previous root, then adjust with gparted or fpart, and see if it is
> readable.
> 
> So instead of trying to restore a btrfs file structure, why not just
> restore a partition with dd that happens to contain a btrfs file
> structure, and then adjust the partition size to match the original?
> btrfs cares about the tree structures, etc.  dd does not.
> 
> What you did is not unusual, and can work fine with a number of file
> structures, but the potential for disaster with dd is also great.  The
> only thing I know of in btrfs that does a similar thing is:
> 
> btrfs send -f btrfs-send-image-file /mount/read-write-snapshot
> 
> Chances are, of course, good that without having current backups dd
> could potentially ruin the rest of your file system set up, so maybe
> transfer the image over to another machine that is expendable and test
> this out.  I use btrfs on root and zfs for data, and make lots of
> snapshots and send them to incremental backups (mostly zfs, but btrfs
> works nicely with Ubuntu on root, with the occasional balance
> problem).
> 
> If dd did it, dd might be able to fix it.  Do that first before you
> try to restore btrfs file structures.
> 
> Or is this a terrible idea?  Someone else on the list should say so if
> they know otherwise.
> 
> Gordon

