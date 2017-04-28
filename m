Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:36862 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S642190AbdD1RlB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 13:41:01 -0400
Received: by mail-yb0-f180.google.com with SMTP id s22so17172620ybe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 10:41:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it>
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
 <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 28 Apr 2017 11:41:00 -0600
Message-ID: <CAJCQCtQCV2DmpsEFtRVdJDMkT54bzbU66+5W873mpJAyXf5k9A@mail.gmail.com>
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 28, 2017 at 11:05 AM, Goffredo Baroncelli
<kreijack@inwind.it> wrote:

> In the past I faced the same problems; I collected some data here http://kreijack.blogspot.it/2014/06/btrfs-and-systemd-journal.html.
> Unfortunately the journald files are very bad, because first the data is written (appended), then the index fields are updated. Unfortunately these indexes are near after the last write . So fragmentation is unavoidable.
>
> After some thinking I adopted a different strategies: I used journald as collector, then I forward all the log to rsyslogd, which used a "log append" format. Journald never write on the root filesystem, only in tmp.

The gotcha though is there's a pile of data in the journal that would
never make it to rsyslogd. If you use journalctl -o verbose you can
see some of this. There's a bunch of extra metadata in the journal.
And then also filtering based on that metadata is useful rather than
being limited to grep on a syslog file. Which, you know, it's fine for
many use cases. I guess I'm just interested in whether there's an
enhancement that can be done to make journals more compatible with
Btrfs or vice versa. It's not a huge problem anyway.


>
> The think became interesting when I discovered that the searching in a rsyslog file is faster than journalctl (on a rotational media). Unfortunately I don't have any data to support this.


Yes on drives all of these scattered extents cause a lot of head
seeking. And I also suspect it's a lot of metadata spread out
everywhere too, to account for all of these extents. That's why they
moved to chattr +C to make them nocow. An idea I had on systemd list
was to automatically make the journal directory a Btrfs subvolume,
similar to how systemd already creates a /var/lib/machines subvolume
for nspawn containers. This prevents the journals from being caught up
in a snapshot of the parent subvolume that typically contains the
journals (root fs). There's no practical use I can think of for
snapshotting logs. You'd really want the logs to always be linear,
contiguous, and never get rolled back. Even if something in the system
does get rolled back, you'd want the logs to show that and continue
on, rather than being rolled back themselves.

So the super simple option would be continue with +C on journals, and
then a separate subvolume to prevent COW from ever happening
inadvertently.

The same behavior happens with NTFS in qcow2 files. They quickly end
up with 100,000+ extents unless set nocow. It's like the worst case
scenario.

-- 
Chris Murphy
