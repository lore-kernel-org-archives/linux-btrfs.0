Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:34325 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754336AbdA3V3q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 16:29:46 -0500
Received: by mail-yb0-f195.google.com with SMTP id w194so27616524ybe.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 13:29:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de>
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
 <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com> <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 30 Jan 2017 14:20:19 -0700
Message-ID: <CAJCQCtSO+vUxOL6FHOdgLqOLSm6C6U4YfUga=K-h7fhBDCaXng@mail.gmail.com>
Subject: Re: btrfs recovery
To: Michael Born <Michael.Born@aei.mpg.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2017 at 2:07 PM, Michael Born <Michael.Born@aei.mpg.de> wrote:
>
>
> Am 30.01.2017 um 21:51 schrieb Chris Murphy:
>> On Mon, Jan 30, 2017 at 1:02 PM, Michael Born <Michael.Born@aei.mpg.de> wrote:
>>> Hi btrfs experts.
>>>
>>> Hereby I apply for the stupidity of the month award.
>>
>> There's still another day :-D
>>
>>
>>
>>>
>>> Before switching from Suse 13.2 to 42.2, I copied my / partition with dd
>>> to an image file - while the system was online/running.
>>> Now, I can't mount the image.
>>
>> That won't ever work for any file system. It must be unmounted.
>
> I could mount and copy the data out of my /home image.dd (encrypted
> xfs). That was also online while dd-ing it.

If there are no substantial writes happening, it's possible it'll
behave like a power failure, read the journal and continue possibly
with the most recent commits being lost. But any substantial amount of
writes means some part of the volume is changed, and the update
reflecting that change is elsewhere, meanwhile the dd is capturing the
volume at different points in time rather than exactly as it is. It's
just not workable.

What people do with huge databases, which have this same problem,
they'll take a volume snapshot. This first commits everything in
flight, freezes the fs so no more changes can happen, then takes a
snapshot, then unfreezes the original so the database can stay online.
The freeze takes maybe a second or maybe a bit longer depending on how
much stuff needs to be committed to stable media. Then backup the
snapshot as a read-only volume. Once the backups is done, delete the
snapshot.





>
>>> Could you give me some instructions how to repair the file system or
>>> extract some files from it?
>>
>> Not possible. The file system was being modified while dd was
>> happening, so the image you've taken is inconsistent.
>
> The files I'm interested in (fstab, NetworkManager.conf, ...) didn't
> change for months. Why would they change in the moment I copy their
> blocks with dd?

They didn't change. The file system changed. While dd is reading, it
might be minutes between capturing different parts of the file system,
and each superblock is in different locations on the disk,
guaranteeing that if the dd takes more than 30 seconds, your dd image
has different generation super blocks. Btrfs notices this at mount
time and will refuse to mount because the file system is inconsistent.

It is certainly possible to fix this, but it's likely to be really,
really tedious. The existing tools don't take this use case into
account.

Maybe btfs-find-root can come up with some suggestions and you can use
btrfs restore -t with the bytenr from find root, to see if you can get
this old data, ignoring the changes that don't affect the old data.

What you do with this is btrfs-find-root and see what it comes up
with. And work with the most recent (highest) generation going
backward, plugging in the bytenr into btrfs restore with -t option.
You'll also want to use the dry run to see if you're getting what you
want. It's best to use the exact path if you know it, this takes much
less time for it to search all files in a given tree. If you don't
know the exact path, but you know part of a file name, then you'll
need to use the regex option; or just let it dump everything it can
from the image and go dumpster diving...



-- 
Chris Murphy
