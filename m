Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f174.google.com ([74.125.82.174]:52804 "EHLO
        mail-ot0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdKKEYZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 23:24:25 -0500
Received: by mail-ot0-f174.google.com with SMTP id 18so9790325oty.9
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Nov 2017 20:24:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d8bb0868-e969-c83c-0615-838cbc52232f@gmx.com>
References: <CAJCQCtSP8r3q+j2dmOANnvGzuVwgx8asHhMROOxOjjX_fgZGcw@mail.gmail.com>
 <2f9573d7-c3d7-7e59-0754-b12e98b9c5ab@mendix.com> <db513a96-e6d3-84bc-ab39-ce0589258bdf@gmx.com>
 <bec1b500-078b-4ee7-6521-f0878c39f2e9@mendix.com> <d8bb0868-e969-c83c-0615-838cbc52232f@gmx.com>
From: Chris Murphy <chris@colorremedies.com>
Date: Fri, 10 Nov 2017 21:24:23 -0700
Message-ID: <CAJCQCtSOgufK3xXC-0ho46R=3YYtQXnYq-==wo4LoNEpk=bcjA@mail.gmail.com>
Subject: Re: discard on SSDs quickly causes backup trees to vanish
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 10, 2017 at 8:48 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> Check the original post.
> It only gives the magic number, it's not saying if it's from backup root.
>
> If it's dumped from running fs (it's completely possible) then it's the
> problem I described.

There are two methods:

1. mounted filesystem

btrfs insp dump-s /dev/sda1
copy the root tree address (line 11)
btrfs-debug-tree -b [[paste root tree address]] /dev/sda1

And then repeat btrfs-debug-tree command until it fails with the
reported checksum error message. It takes less than 30 seconds for it
to fail on an active file system (e.g. rootfs where there are files
being written most of the time like logs and such).

2. mounted or not mounted
btrfs insp dump-s -f /dev/sda1
copy any of the root trees other than the current one (three most
recent backup root trees)
btrfs-debug-tree -b [[paste tree address]]

Result, all of those backup (not current root) addresses fail. This
particular SSD I think is one that immediately reports zeros for
discarded blocks. Other SSDs report back original data, even once
discarded, until the SSD actually does garbage collection. So there's
more than one possible discard strategy that can confuse the results
people are having.


>
> Anyway, no matter what you think if it's a bug or not, I'll enhance tree
> allocator to do extra check if the result overwrites the commit root.
>
> And I strongly suspect transid related problems reported from mail list
> has something to do with it.

I think so. Sometimes we forget to ask the user for all the important
information like whether it's SSD, or what the mount options are. But
we've definitely seen cases where the user was using discard and also
had a crash or power failure, and then -o recovery/usebackuproot would
give similar messages. And it's very confusing how a working file
system just suddenly seems to fail with transid errors just because of
a crash or power fail.

I think maybe I've just been lucky with this NVMe drive, seems it has
fast commit to stable media time and is honoring expected write order.
I've definitely had crashes/forced power off, while using the discard
mount option. But no Btrfs problems or corruptions at all, in about
one year of continuous usage. But if for some reason the current root
tree were corrupt? OK no backup roots so the whole file system
probably fails now and can't be repaired?


-- 
Chris Murphy
