Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:36659 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754240AbdBHAqL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 19:46:11 -0500
Received: by mail-qt0-f178.google.com with SMTP id k15so151801268qtg.3
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 16:45:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170207232818.35b6bfcb@jupiter.sol.kaishome.de>
References: <CACNDjuzntG5Saq5HHNeDUmq-=28riKAerkO=CD=zAW-QofbKSg@mail.gmail.com>
 <CACNDjuw3GqkCggUqim==Y+xj=bnL93wwdx26denvQaD4tFf7yw@mail.gmail.com>
 <20170119232340.64327c09@natsu> <6f06bd6b-67c9-533b-9bf5-89cff8b892da@gmail.com>
 <20170207232818.35b6bfcb@jupiter.sol.kaishome.de>
From: Dan Mons <dmons@cuttingedge.com.au>
Date: Wed, 8 Feb 2017 10:39:08 +1000
Message-ID: <CACa6Tycw2EOw1djakR=xfRPhxw8fzAk-UnpRk=fVfErnbPa8fw@mail.gmail.com>
Subject: Re: dup vs raid1 in single disk
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 February 2017 at 08:28, Kai Krakow <hurikhan77@gmail.com> wrote:
> I still thinks it's a myth... The overhead of managing inline
> deduplication is just way too high to implement it without jumping
> through expensive hoops. Most workloads have almost zero deduplication
> potential. And even when, their temporal occurrence is spaced so far
> that an inline deduplicator won't catch it.
>
> If it would be all so easy, btrfs would already have it working in
> mainline. I don't even remember that those patches is still being
> worked on.
>
> With this in mind, I think dup metadata is still a good think to have
> even on SSD and I would always force to enable it.
>
> Potential for deduplication is only when using snapshots (which already
> are deduplicated when taken) or when handling user data on a file
> server in a multi-user environment. Users tend to copy their files all
> over the place - multiple directories of multiple gigabytes. Potential
> is also where you're working with client machine backups or vm images.
> I regularly see deduplication efficiency of 30-60% in such scenarios -
> file servers mostly which I'm handling. But due to temporally far
> spaced occurrence of duplicate blocks, only offline or nearline
> deduplication works here.

I'm a sysadmin by trade, managing many PB of storage for a media
company.  Our primary storage are Oracle ZFS appliances, and all of
our secondary/nearline storage is Linux+BtrFS.

ZFS's inline deduplication is awful.  It consumes enormous amounts of
RAM that is orders of magnitude more valuable as ARC/Cache, and
becomes immediately useless whenever a storage node is rebooted
(necessary to apply mandatory security patches) and the in-memory
tables are lost (meaning cold data is rarely re-examined, and the
inline dedup becomes less efficient).

Conversely, I use  "dupremove" as a one-shot/offline deduplication
tool on all of our BtrFS storage.  I can be set as a cron job to be
done outside of business hours, and use an SQLite database to store
the necessary dedup hash information on disk, rather than in RAM.
>From the point of view of someone who manages large amounts of long
term centralised storage, this is a far superior way to deal with
deduplication, as it offers more flexibility and far better
space-saving ratios at a lower memory cost.

We trialled ZFS dedup for a few months, and decided to turn it off, as
there was far less benefit to ZFS using all that RAM for dedup than
there was for it to be cache.  I've been requesting Oracle offer a
similar offline dedup tool for their ZFS appliance for a very long
time, and if BtrFS ever did offer inline dedup, I wouldn't bother
using it for all of the reasons above.

-Dan
