Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33117 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbcBNLV6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 06:21:58 -0500
Received: by mail-lf0-f48.google.com with SMTP id m1so74695164lfg.0
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Feb 2016 03:21:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20160214T072657-687@post.gmane.org>
References: <20160207182841.0d749ea7@redPill>
	<CAPmG0jaRphE4jWi4aGUk_tV2OYyddVUXjwcNtuN+A97PTWtYVA@mail.gmail.com>
	<loom.20160214T072657-687@post.gmane.org>
Date: Sun, 14 Feb 2016 12:21:56 +0100
Message-ID: <CAPmG0jYL_No0JU=NuT7gZ1SVdNOmBHFZnatboORyx5kdbQ3aFg@mail.gmail.com>
Subject: Re: One disc of 3-disc btrfs-raid5 failed - files only partially readable
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> > Do you think there is still a chance to recover those files?
>>
>> You can use  btrfs restore  to get files off a damaged fs.
>
> This however does work - thank you!
> Now since I'm a bit short on disc space, can I remove the disc that
> previously disappeared (and thus doesn't have all the
> data) from the RAID, format it and run btrfs rescue on the degraded array,
> saving the rescued data to the now free disc?

In theory   btrfs restore   should be able to read files from
(unmounted) /dev/sdb (devid 2) + /dev/sdc (devid 3).
The kernel code should still be able to mount devid 2 + devid 3 in
degraded mode, but   btrfs restore  needs unmounted fs and I am not
sure if userspace tools can also decode raid5 degraded well enough.
For a single device, so non-raid profiles, it might be different.

lf you unplug /dev/sda (devid 1) you can dry-run  btrfs restore -v -D
<some_path>
and see if it would work.

If not, maybe first save the files that have csum errors with restore
(all 3 discs connected) to other storage and then delete the files
from the normally mounted 3 discs raid5 array and then do a normal
copy from degraded,ro mounted 2 disc to the newly formatted /dev/sda.
Hopefully there's enough space in total.
