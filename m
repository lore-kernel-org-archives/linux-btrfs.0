Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35308 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdHASYD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 14:24:03 -0400
Received: by mail-wm0-f54.google.com with SMTP id m85so22272021wma.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 11:24:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
References: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 1 Aug 2017 12:24:01 -0600
Message-ID: <CAJCQCtQ=NXO_ZG0ZUnvhMZQYSrK9+LEBjhMKVYUG1gOnioKVig@mail.gmail.com>
Subject: Re: Raid0 rescue
To: Alan Brand <alan@georgiabrands.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 8:49 AM, Alan Brand <alan@georgiabrands.com> wrote:
> I know I am screwed but hope someone here can point at a possible solution.
>
> I had a pair of btrfs drives in a raid0 configuration.  One of the
> drives was pulled by mistake, put in a windows box, and a quick NTFS
> format was done.  Then much screaming occurred.
>
> I know the data is still there.  Is there anyway to rebuild the raid
> bringing in the bad disk?  I know some info is still good, for example
> metadata0 is corrupt but 1 and 2 are good.
> The trees look bad which is probably the killer.

Well the first step is to check and fix the super blocks. And then the
normal code should just discover the bad stuff, and get good copies
from the good drive, and copy them to the corrupt one, passively, and
eventually fix the file system itself. There's probably only a few
files corrupted irrecoverably.

It's probably worth testing for this explicitly. It's not a wild
scenario, and it's something Btrfs should be able to recover from
gracefully. The gotcha part of a totally automatic recovery is the
superblocks because there's no *one true right way* for the kernel to
just assume the remaining Btrfs supers are more valid than the NTFS
supers.

So then the question is, which tool should fix this up? I'd say both
'btrfs rescue super-recover' and 'btrfs check' should do this. The
difference being super-recover would fix only the supers, with kernel
code doing passive fixups as problems are encountered once the fs is
mounted. And 'check --repair' would fix supers and additionally fix
missing metadata on the corrupt drive, using user space code with an
unmounted system.

Both should work, or at least both should be fail safe.

-- 
Chris Murphy
