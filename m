Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:55035 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753552AbdKFSfz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 13:35:55 -0500
Received: by mail-oi0-f47.google.com with SMTP id a132so8224744oih.11
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Nov 2017 10:35:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <78727726-c7fc-c645-d805-ef746a81b715@gmail.com>
References: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
 <20171104044916.4mpgaails24rqddz@angband.pl> <65c3c537-1e30-87ae-140a-b59bdd79a4dc@gmail.com>
 <20171104070550.lr5osyfz74axw5nl@angband.pl> <32e2df81-51c0-396b-57af-132907918935@gmail.com>
 <CAJCQCtTXR9vBhUPxzkz2RWsD3=WWzNA20w3vCdjzrrHA8eiF-g@mail.gmail.com>
 <b5e7e64a-741c-baee-bc4d-cd51ca9b3a38@gmail.com> <78727726-c7fc-c645-d805-ef746a81b715@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 6 Nov 2017 11:35:53 -0700
Message-ID: <CAJCQCtTy8FqbgJwvC86+7fZBTAgP8bnnH4rz1xpj4dAVuBWSCQ@mail.gmail.com>
Subject: Re: updatedb does not index /home when /home is Btrfs
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Adam Borowski <kilobyte@angband.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 6, 2017 at 6:51 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> This brings to mind another 'feature' of BTRFS that I came across recently,
> namely that subvolumes that aren't explicitly mounted still show up as mount
> points according to how most CLI tools differentiate what's a mount point.
>
> In particular, the st_dev field in stat() results for the subvolume differs
> from the containing directory, and the f_fsid field in statvfs() results for
> the subvolume differs from the containing directory (a side effect of the
> differing st_dev field, which is part of what's used to calculate f_fsid on
> Linux), which means the only way to know if something actually is a mount
> point is to make this check, and then verify it in /proc/mounts or
> /proc/self/mountinfo.
>
> That particular 'feature' means that GNU find, xargs, and du will never
> cross subvolume boundaries if you tell them to stay on one filesystem, and
> some other tools may misidentify where things are mounted.


Elsewhere I brought up that mountinfo gives bogus subvol= information
that conflicts with the subvolid= information, when doing bind mounts
of directories on Btrfs. Trivially reproduced in my home directory:


[chris@f26h ~]$ mkdir directory1
[chris@f26h ~]$ mkdir directory2
[chris@f26h ~]$ sudo mount -B directory2 directory1
[chris@f26h ~]$ mount:
/dev/nvme0n1p8 on /home type btrfs
(rw,relatime,seclabel,ssd,space_cache,subvolid=257,subvol=/home)
/dev/nvme0n1p8 on /home/chris/directory1 type btrfs
(rw,relatime,seclabel,ssd,space_cache,subvolid=257,subvol=/home/chris/directory2)



The first mount item is correct, there is a subvolume home with
subvolume ID of 257, mounted at /home.
The second mount item considers directory2 a subvolume (wrong), with
subvolid 257 (kinda right, it's on subvolid 257, but kinda wrong, it
is not itself a subvolume).


-- 
Chris Murphy
