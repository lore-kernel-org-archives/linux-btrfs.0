Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f174.google.com ([209.85.208.174]:37001 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbeIPX2a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 19:28:30 -0400
Received: by mail-lj1-f174.google.com with SMTP id v9-v6so11252025ljk.4
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2018 11:04:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 16 Sep 2018 12:04:44 -0600
Message-ID: <CAJCQCtQqtmJ5mHCAutkX8YMA6BFKW0OnbNvu93Ewio4ccK0bfQ@mail.gmail.com>
Subject: Re: Move data and mount point to subvolume
To: Rory Campbell-Lange <rory@campbell-lange.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 16, 2018 at 5:14 AM, Rory Campbell-Lange
<rory@campbell-lange.net> wrote:
> Hi
>
> We have a backup machine that has been happily running its backup
> partitions on btrfs (on top of a luks encrypted disks) for a few years.
>
> Our backup partition is on /bkp which is a top level subvolume.
>     Data, RAID1: total=2.52TiB, used=1.36TiB
> There are no other subvolumes.

and

> /dev/mapper/cdisk2 on /bkp type btrfs (rw,noatime,compress=lzo,space_cache,subvolid=5,subvol=/)

I like Hans' 2nd email advice to snapshot the top level subvolume.

I would start out with:
btrfs sub snap -r /bkp /bkp/toplevel.ro

And that way I shouldn't be able to F this up irreversibly if I make a
mistake. :-D And then do another snapshot that's rw:

btrfs sub snap /bkp /bkp/bkpsnap
cd /bkp/bkpsnap

Now remove everything except "backupdir". Then move everything out of
backupdir including any hidden files. Then rmdir backupdir. Then you
can rename the snapshot/subvolume
cd ..
mv bkpsnap backup

That's less metadata writes than creating a new subvolume, and reflink
copying the backup dir, e.g. cp -a --reflink /bkp/backupdir
/bkp/backupsubvol

That could take a long time because all the metadata is fully read,
modified (new inodes) and written out.

But either way it should work.

-- 
Chris Murphy
