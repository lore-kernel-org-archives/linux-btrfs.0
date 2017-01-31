Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:36080 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752767AbdAaAad (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 19:30:33 -0500
Received: by mail-ua0-f193.google.com with SMTP id f2so31904904uaf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 16:30:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <161bffef-9bc8-e5da-476b-d214e2a7d69b@aei.mpg.de>
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
 <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
 <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de> <014c7da2-0129-caee-00d8-12f2af628efc@mendix.com>
 <CAP8EXU310iKo-exrYk3Hm4tyUQSL+KYEYEV4h8zifiwxmse7uA@mail.gmail.com> <161bffef-9bc8-e5da-476b-d214e2a7d69b@aei.mpg.de>
From: GWB <gwb@2realms.com>
Date: Mon, 30 Jan 2017 18:29:51 -0600
Message-ID: <CAP8EXU3-hrRSVmBzgB_ACtzxCegzvijX9oU=ZgZ_ekcO6C2-DA@mail.gmail.com>
Subject: Re: btrfs recovery
To: Michael Born <Michael.Born@aei.mpg.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Micheal,

Yes, you would certainly run the risk of doing more damage with dd, so
if you have an alternative, use that, and avoid dd.  If nothing else
works and you need the files, you might try it as a last resort.

My guess (and it is only a guess) is that if the image is close to the
same size as the root partition, the file data is there.  But that
doesn't do you much good if btrfs cannot read the "container" or the
specific partition and file system information, which btrfs send
provides.

Does someone on the list know if ext3/4 data recovery tools can also
search btrfs data?  That's another option.

Gordon

On Mon, Jan 30, 2017 at 4:37 PM, Michael Born <Michael.Born@aei.mpg.de> wrote:
> Hi Gordon,
>
> I'm quite sure this is not a good idea.
> I do understand, that dd-ing a running system will miss some changes
> done to the file system while copying. I'm surprised that I didn't end
> up with some corrupted files, but with no files at all.
> Also, I'm not interested in restoring the old Suse 13.2 system. I just
> want some configuration files from it.
>
> Cheers,
> Michael
>
> Am 30.01.2017 um 23:24 schrieb GWB:
>> <<
>> Hi btrfs experts.
>>
>> Hereby I apply for the stupidity of the month award.
>>>>
>>
>> I have no doubt that I will will mount a serious challenge to you for
>> that title, so you haven't won yet.
>>
>> Why not dd the image back onto the original partition (or another
>> partition identical in size) and see if that is readable?
>>
>> My limited experience with btrfs (I am not an expert) is that read
>> only snapshots work well in this situation, but the initial hurdle is
>> using dd to get the image back onto a partition.  So I wonder if you
>> could dd the image back onto the original media (the hd sdd), then
>> make a read only snapshot, and then send the snapshot with btrfs send
>> to another storage medium.  With any luck, the machine might boot, and
>> you might find other snapshots which you may be able to turn into read
>> only snaps for btrfs send.
>>
>> This has worked for me on Ubuntu 14 for quite some time, but luckily I
>> have not had to restore the image file sent from btrfs send yet.  I
>> say luckily, because I realise now that the image created from btrfs
>> send should be tested, but so far no catastrophic failures with my
>> root partition have occurred (knock on wood).
>>
>> dd is (like dumpfs, ddrescue, and the bsd variations) good for what it
>> tries to do, but not so great on for some file systems for more
>> intricate uses.  But why not try:
>>
>> dd if=imagefile.dd of=/dev/sdaX
>>
>> and see if it boots?  If it does not, then perhaps you have another
>> shot at the one time mount for btrfs rw if that works.
>>
>> Or is your root partition now running fine under Suse 14.2, and you
>> are just looking to recover a file files from the image?  If so, you
>> might try to dd from the image to a partition of original size as the
>> previous root, then adjust with gparted or fpart, and see if it is
>> readable.
>>
>> So instead of trying to restore a btrfs file structure, why not just
>> restore a partition with dd that happens to contain a btrfs file
>> structure, and then adjust the partition size to match the original?
>> btrfs cares about the tree structures, etc.  dd does not.
>>
>> What you did is not unusual, and can work fine with a number of file
>> structures, but the potential for disaster with dd is also great.  The
>> only thing I know of in btrfs that does a similar thing is:
>>
>> btrfs send -f btrfs-send-image-file /mount/read-write-snapshot
>>
>> Chances are, of course, good that without having current backups dd
>> could potentially ruin the rest of your file system set up, so maybe
>> transfer the image over to another machine that is expendable and test
>> this out.  I use btrfs on root and zfs for data, and make lots of
>> snapshots and send them to incremental backups (mostly zfs, but btrfs
>> works nicely with Ubuntu on root, with the occasional balance
>> problem).
>>
>> If dd did it, dd might be able to fix it.  Do that first before you
>> try to restore btrfs file structures.
>>
>> Or is this a terrible idea?  Someone else on the list should say so if
>> they know otherwise.
>>
>> Gordon
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
