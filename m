Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:36219 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbdA3WY7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 17:24:59 -0500
Received: by mail-vk0-f65.google.com with SMTP id n19so27644946vkd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 14:24:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <014c7da2-0129-caee-00d8-12f2af628efc@mendix.com>
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
 <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
 <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de> <014c7da2-0129-caee-00d8-12f2af628efc@mendix.com>
From: GWB <gwb@2realms.com>
Date: Mon, 30 Jan 2017 16:24:17 -0600
Message-ID: <CAP8EXU310iKo-exrYk3Hm4tyUQSL+KYEYEV4h8zifiwxmse7uA@mail.gmail.com>
Subject: Re: btrfs recovery
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Michael Born <Michael.Born@aei.mpg.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

<<
Hi btrfs experts.

Hereby I apply for the stupidity of the month award.
>>

I have no doubt that I will will mount a serious challenge to you for
that title, so you haven't won yet.

Why not dd the image back onto the original partition (or another
partition identical in size) and see if that is readable?

My limited experience with btrfs (I am not an expert) is that read
only snapshots work well in this situation, but the initial hurdle is
using dd to get the image back onto a partition.  So I wonder if you
could dd the image back onto the original media (the hd sdd), then
make a read only snapshot, and then send the snapshot with btrfs send
to another storage medium.  With any luck, the machine might boot, and
you might find other snapshots which you may be able to turn into read
only snaps for btrfs send.

This has worked for me on Ubuntu 14 for quite some time, but luckily I
have not had to restore the image file sent from btrfs send yet.  I
say luckily, because I realise now that the image created from btrfs
send should be tested, but so far no catastrophic failures with my
root partition have occurred (knock on wood).

dd is (like dumpfs, ddrescue, and the bsd variations) good for what it
tries to do, but not so great on for some file systems for more
intricate uses.  But why not try:

dd if=imagefile.dd of=/dev/sdaX

and see if it boots?  If it does not, then perhaps you have another
shot at the one time mount for btrfs rw if that works.

Or is your root partition now running fine under Suse 14.2, and you
are just looking to recover a file files from the image?  If so, you
might try to dd from the image to a partition of original size as the
previous root, then adjust with gparted or fpart, and see if it is
readable.

So instead of trying to restore a btrfs file structure, why not just
restore a partition with dd that happens to contain a btrfs file
structure, and then adjust the partition size to match the original?
btrfs cares about the tree structures, etc.  dd does not.

What you did is not unusual, and can work fine with a number of file
structures, but the potential for disaster with dd is also great.  The
only thing I know of in btrfs that does a similar thing is:

btrfs send -f btrfs-send-image-file /mount/read-write-snapshot

Chances are, of course, good that without having current backups dd
could potentially ruin the rest of your file system set up, so maybe
transfer the image over to another machine that is expendable and test
this out.  I use btrfs on root and zfs for data, and make lots of
snapshots and send them to incremental backups (mostly zfs, but btrfs
works nicely with Ubuntu on root, with the occasional balance
problem).

If dd did it, dd might be able to fix it.  Do that first before you
try to restore btrfs file structures.

Or is this a terrible idea?  Someone else on the list should say so if
they know otherwise.

Gordon


On Mon, Jan 30, 2017 at 3:16 PM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> On 01/30/2017 10:07 PM, Michael Born wrote:
>>
>>
>> Am 30.01.2017 um 21:51 schrieb Chris Murphy:
>>> On Mon, Jan 30, 2017 at 1:02 PM, Michael Born <Michael.Born@aei.mpg.de> wrote:
>>>> Hi btrfs experts.
>>>>
>>>> Hereby I apply for the stupidity of the month award.
>>>
>>> There's still another day :-D
>>>
>>>
>>>
>>>>
>>>> Before switching from Suse 13.2 to 42.2, I copied my / partition with dd
>>>> to an image file - while the system was online/running.
>>>> Now, I can't mount the image.
>>>
>>> That won't ever work for any file system. It must be unmounted.
>>
>> I could mount and copy the data out of my /home image.dd (encrypted
>> xfs). That was also online while dd-ing it.
>>
>>>> Could you give me some instructions how to repair the file system or
>>>> extract some files from it?
>>>
>>> Not possible. The file system was being modified while dd was
>>> happening, so the image you've taken is inconsistent.
>>
>> The files I'm interested in (fstab, NetworkManager.conf, ...) didn't
>> change for months. Why would they change in the moment I copy their
>> blocks with dd?
>
> The metadata of btrfs is organized in a bunch of tree structures. The
> top of the trees (the smallest parts, trees are upside-down here /\ )
> and the superblock get modified quite often. Every time a tree gets
> modified, the new modified parts are written as a modified copy in
> unused space.
>
> So even if the files themselves do not change... if you miss those new
> writes which are being done in space that your dd already left behind...
> you end up with old and new parts of trees all over the place.
>
> In other words, a big puzzle with parts that do not connect with each
> other any more.
>
> And that's exactly what you see in all the errors. E.g. "parent transid
> verify failed on 32869482496 wanted 550112 found 550121" <- a part of a
> tree points to another part, but suddenly something else is found which
> should not be there. In this case wanted 550112 found 550121 means it's
> bumping into something "from the future". Whaaa..
>
> --
> Hans van Kranenburg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
