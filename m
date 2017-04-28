Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:53799 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1034679AbdD1RF2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 13:05:28 -0400
Reply-To: kreijack@inwind.it
Subject: Re: btrfs, journald logs, fragmentation, and fallocate
References: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <5fd31e68-0199-8935-0873-78b4e7c6eb69@inwind.it>
Date: Fri, 28 Apr 2017 19:05:21 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQk1p6rzUYaO19ei51YC+w1uj1qJ77OdLmL5JN3w1zNfw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-28 18:16, Chris Murphy wrote:
> Old news is that systemd-journald journals end up pretty heavily
> fragmented on Btrfs due to COW. While journald uses chattr +C on
> journal files now, COW still happens if the subvolume the journal is
> in gets snapshot. e.g. a week old system.journal has 19000+ extents.
> 
> The news is I started a systemd thread.
> 
> This is the start:
> https://lists.freedesktop.org/archives/systemd-devel/2017-April/038724.html
> 
> Where it gets interesting, two messages by Andrei Borzenkov: He
> evaluates existing code and does some tests on ext4 and XFS.
> https://lists.freedesktop.org/archives/systemd-devel/2017-April/038724.html
> https://lists.freedesktop.org/archives/systemd-devel/2017-April/038728.html
> 
> And then the question.
> https://lists.freedesktop.org/archives/systemd-devel/2017-April/038735.html
> 
> Given what journald is doing, is what Btrfs is doing expected? Is
> there something it could do better to be more like ext4 and XFS in the
> same situation? Or is it out of scope for Btrfs?

In the past I faced the same problems; I collected some data here http://kreijack.blogspot.it/2014/06/btrfs-and-systemd-journal.html.
Unfortunately the journald files are very bad, because first the data is written (appended), then the index fields are updated. Unfortunately these indexes are near after the last write . So fragmentation is unavoidable.

After some thinking I adopted a different strategies: I used journald as collector, then I forward all the log to rsyslogd, which used a "log append" format. Journald never write on the root filesystem, only in tmp.

The think became interesting when I discovered that the searching in a rsyslog file is faster than journalctl (on a rotational media). Unfortunately I don't have any data to support this. 
However if someone is interested I can share more details.

BR
G.Baroncelli



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
