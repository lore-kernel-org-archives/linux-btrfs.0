Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37040 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbcILLYr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 07:24:47 -0400
Received: by mail-it0-f50.google.com with SMTP id 186so8064922itf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 04:24:46 -0700 (PDT)
Subject: Re: Security implications of btrfs receive?
To: Chris Murphy <lists@colorremedies.com>
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <1473259316.24874.3.camel@scientia.net>
 <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
 <1473271679.24874.36.camel@scientia.net>
 <d6f659e7-25bf-c732-a7db-0cef8450b346@gmail.com>
 <CAJCQCtSmFA2iRDN33u9XF1b4nN_xA5sy44tS3n5mnA4f+go_hg@mail.gmail.com>
 <8049c767-5cf0-7abc-8e44-828a15619546@gmail.com>
 <CAJCQCtRFer9UGjqwqZS3xZnQGC6hqVRHyeaQjmy6+nnMfJUKKQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <03d03ce6-4dad-bad9-311d-a040e4122128@gmail.com>
Date: Mon, 12 Sep 2016 07:24:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRFer9UGjqwqZS3xZnQGC6hqVRHyeaQjmy6+nnMfJUKKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-09 14:58, Chris Murphy wrote:
> On Thu, Sep 8, 2016 at 5:48 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-09-07 15:34, Chris Murphy wrote:
>
>> I like the idea of matching WWN as part of the check, with a couple of
>> caveats:
>> 1. We need to keep in mind that in some environments, this can be spoofed
>> (Virtualization for example, although doing so would require source level
>> modifications to most hypervisors).
>> 2. There needs to be a way to forcibly mount in the case of a mismatch, as
>> well as a way to update the filesystem to match the current WWN's of all of
>> it's disks.  I also specifically think that these should be separate
>> options, the first is useful for debugging a filesystem using image files,
>> while the second is useful for external clones of disks.
>> 3. single device filesystems should store the WWN, and ideally keep it
>> up-to-date, but not check it.  They have no need to check it, and single
>> device is the primary use case for a traditional user, so it should be as
>> simple as possible.
>> 4. We should be matching on more than just fsuuid, devuuid, and WWN, because
>> just matching those would allow a second partition on the same device to
>> cause issues.
>
> Probably a different abstraction is necessary: WWN is appropriate
> where member devices are drives; but maybe it's an LVM UUID in other
> cases, e.g. where there's LVM snapshots. I'm not sure how drdb devices
> are uniquely identified, but that'd also be in the "one of these"
> list.
We'd need an abstracted serial identifier of some sort.  On a flat or 
partitioned device, it should include the WWN.  The same should probably 
happen for any 1:1 mapped devices (dm-crypt for example).  The 
potentially problematic part is that for this to be secure, we need to 
include info about the entire storage stack, which in turn means that if 
the storage stack changes, we need to update things.
>
>
>
>
>>> It is also kinda important to see things like udisks and storaged as
>>> user agents, ensuring they have a way to communicate with the helper
>>> so things are mounted and umounted correctly as most DE's now expect
>>> to just automount everything. I still get weird behaviors on GNOME
>>> with udisks2 and multiple device Btrfs volumes with current upstream
>>> GNOME stuff.
>>
>> DE's expect the ability to automount things as a regular user, not
>> necessarily that it has to happen.  I'm not all that worried personally
>> about automounting of multi-device filesystems, largely because the type of
>> person who automounting in the desktop primarily caters to is not likely to
>> have a multi-device filesystem to begin with.
>
> It should work better than it does because it works well for LVM and
> mdadm arrays.
>
> I think what's going on is the DE's mounter (udisksd) tries to mount
> each Btrfs device node, even though those nodes make up a single fs
> volume. It issues multiple mount and umount commands for that one
> array. This doesn't happen with LVM and mdadm because an array has one
> node. That's not true with Btrfs, it has one or many, depending on
> your point of view. There's no way to mount just an fs volume UUID as
> far as I know.
After device discovery, specify UUID=<volume UUID> instead of a device 
node.  This is actually hos a large number of Linux distros mount all of 
their statically configured filesystems, including the root filesystem.
>
>
>> For that matter, the primary
>> (only realistic?) use for multi-device filesystems on removable media is
>> backups, and the few people who are going to set things up to automatically
>> run backups when the disks get plugged in will be smart enough to get things
>> working correctly themselves, while anyone else is going to be running the
>> backup manually and can mount the FS by hand if they aren't using something
>> like autofs.
>
> Yeah I  am that person but it's the DE that's getting confused, and
> then confusing me with its confusion, so it's bad Ux. GNOME automounts
> a Btrfs raid1 by showing two disk icons with the exact same name, and
> gets confused upon ejecting either with the GUI eject button or via
> the CLI. So we can say udisks is doing something wrong, but what, and
> is there anything we can do to make it easier for it to do the right
> thing seeing as Btrfs is so different?
I personally feel it's more important that we fix the whole UUID issue 
first.  If we fix that, it is likely to at least make things better in 
this particular case as well.  The problem with trying to get this fixed 
upstream in userspace is that udisks is essentially deprecated because 
of the work on storaged (which will almost certainly depend on systemd), 
so you're almost certainly get nothing fixed until someone decides to 
fork it and maintain it themselves like happened for ConsoleKit.

As far as what udisks is doing wrong, based on what you've said and 
minimal experimentation on my systems, the issue is that it's not 
identifying the array as one filesystem.  They mount by device node to 
try and avoid the UUID issues (because they affect every filesystem to 
some degree), but because of that they see a bunch of filesystems.
>
>
> Here's some 2 to 6 year old bugs related to this:
> https://bugs.freedesktop.org/show_bug.cgi?id=87277
> https://bugzilla.gnome.org/show_bug.cgi?id=746769
> https://bugzilla.gnome.org/show_bug.cgi?id=608204
>
>

