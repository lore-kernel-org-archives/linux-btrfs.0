Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33685 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbcIIS6m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 14:58:42 -0400
Received: by mail-oi0-f42.google.com with SMTP id y2so159292751oie.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Sep 2016 11:58:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8049c767-5cf0-7abc-8e44-828a15619546@gmail.com>
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com> <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <1473259316.24874.3.camel@scientia.net> <12cfbaf0-77ff-a4d2-d9d7-64c5c795ce4b@gmail.com>
 <1473271679.24874.36.camel@scientia.net> <d6f659e7-25bf-c732-a7db-0cef8450b346@gmail.com>
 <CAJCQCtSmFA2iRDN33u9XF1b4nN_xA5sy44tS3n5mnA4f+go_hg@mail.gmail.com> <8049c767-5cf0-7abc-8e44-828a15619546@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 9 Sep 2016 12:58:40 -0600
Message-ID: <CAJCQCtRFer9UGjqwqZS3xZnQGC6hqVRHyeaQjmy6+nnMfJUKKQ@mail.gmail.com>
Subject: Re: Security implications of btrfs receive?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 8, 2016 at 5:48 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-09-07 15:34, Chris Murphy wrote:

> I like the idea of matching WWN as part of the check, with a couple of
> caveats:
> 1. We need to keep in mind that in some environments, this can be spoofed
> (Virtualization for example, although doing so would require source level
> modifications to most hypervisors).
> 2. There needs to be a way to forcibly mount in the case of a mismatch, as
> well as a way to update the filesystem to match the current WWN's of all of
> it's disks.  I also specifically think that these should be separate
> options, the first is useful for debugging a filesystem using image files,
> while the second is useful for external clones of disks.
> 3. single device filesystems should store the WWN, and ideally keep it
> up-to-date, but not check it.  They have no need to check it, and single
> device is the primary use case for a traditional user, so it should be as
> simple as possible.
> 4. We should be matching on more than just fsuuid, devuuid, and WWN, because
> just matching those would allow a second partition on the same device to
> cause issues.

Probably a different abstraction is necessary: WWN is appropriate
where member devices are drives; but maybe it's an LVM UUID in other
cases, e.g. where there's LVM snapshots. I'm not sure how drdb devices
are uniquely identified, but that'd also be in the "one of these"
list.




>> It is also kinda important to see things like udisks and storaged as
>> user agents, ensuring they have a way to communicate with the helper
>> so things are mounted and umounted correctly as most DE's now expect
>> to just automount everything. I still get weird behaviors on GNOME
>> with udisks2 and multiple device Btrfs volumes with current upstream
>> GNOME stuff.
>
> DE's expect the ability to automount things as a regular user, not
> necessarily that it has to happen.  I'm not all that worried personally
> about automounting of multi-device filesystems, largely because the type of
> person who automounting in the desktop primarily caters to is not likely to
> have a multi-device filesystem to begin with.

It should work better than it does because it works well for LVM and
mdadm arrays.

I think what's going on is the DE's mounter (udisksd) tries to mount
each Btrfs device node, even though those nodes make up a single fs
volume. It issues multiple mount and umount commands for that one
array. This doesn't happen with LVM and mdadm because an array has one
node. That's not true with Btrfs, it has one or many, depending on
your point of view. There's no way to mount just an fs volume UUID as
far as I know.


>For that matter, the primary
> (only realistic?) use for multi-device filesystems on removable media is
> backups, and the few people who are going to set things up to automatically
> run backups when the disks get plugged in will be smart enough to get things
> working correctly themselves, while anyone else is going to be running the
> backup manually and can mount the FS by hand if they aren't using something
> like autofs.

Yeah I  am that person but it's the DE that's getting confused, and
then confusing me with its confusion, so it's bad Ux. GNOME automounts
a Btrfs raid1 by showing two disk icons with the exact same name, and
gets confused upon ejecting either with the GUI eject button or via
the CLI. So we can say udisks is doing something wrong, but what, and
is there anything we can do to make it easier for it to do the right
thing seeing as Btrfs is so different?


Here's some 2 to 6 year old bugs related to this:
https://bugs.freedesktop.org/show_bug.cgi?id=87277
https://bugzilla.gnome.org/show_bug.cgi?id=746769
https://bugzilla.gnome.org/show_bug.cgi?id=608204


-- 
Chris Murphy
