Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34905 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755699AbcIUPuA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 11:50:00 -0400
Received: by mail-oi0-f51.google.com with SMTP id w11so64800808oia.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 08:50:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8AC4324B47948D40A1031D5AB7D077820141E7CF70@mailstore.skyward.com>
References: <8AC4324B47948D40A1031D5AB7D077820141E77717@mailstore.skyward.com>
 <CAJCQCtSxcVuE_ZFNvHR=4gF5hDaYTYoav_yV_wEbdjeEfrpOTw@mail.gmail.com> <8AC4324B47948D40A1031D5AB7D077820141E7CF70@mailstore.skyward.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Sep 2016 09:49:58 -0600
Message-ID: <CAJCQCtSNT9t7dfw8MW_Bqfq4iATrF6TvVOxNMudW4h-8kBbpJw@mail.gmail.com>
Subject: Re: Filesystem will remount read-only
To: Jeffrey Michels <jeffreym@skyward.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2016 at 9:24 AM, Jeffrey Michels <jeffreym@skyward.com> wrote:
> Hello,
>
> I've booted into the latest nightly build of Fedora and run btrfs rescue super-recover -v and also btrfs check.
>
> Super-recover reports that "All supers are valid, no need to recover."  Btrfs check displays the same errors as before:
>
> Parent trasid verified failed on xxxx wanted xxxx found xxxxx
> Ignoring transid failure
> Leaf parent key incorrect xxxxxxx
> Bad block xxxxxxxxxxx
> Errors found in extend allocation tree or chunk allocation.
>
> The check eventually fails with Segmentation fault (core dumped.)
>
> Attempting to mount with -o recovery results in the error "Can't read superblock."  I am able to mount the filesystem read-only however attempting to copy all of the data off has been unsuccessful.  It appears to hit a bad area and just hangs.
>
> Is there anything else I can try?

Kinda weird that the supers are all valid with one tool but then the
kernel says it can't read the superblock?

Try btrfs-image -c9 -t4 and optionally with -s, and if the resulting
file isn't too big put it somewhere and I can try to iterate some
options on the file. You could do the same thing by imaging it,
restoring the image to an LVM LV of the same size or bigger, and then
see if there's a combination of
btrfs check --repair;
btrfs check --repair --init-extent-tree
btrfs rescue chunk-recover
btrfs rescue zero-log

That or some other order of things might fix it, and the only way to
know is to try it. And unfortunately each thing can make changes that
can cause the next thing to fail. Hence doing this on an image.

-- 
Chris Murphy
