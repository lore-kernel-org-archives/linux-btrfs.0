Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36412 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbcFYNUa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 09:20:30 -0400
Received: by mail-oi0-f49.google.com with SMTP id f189so149270210oig.3
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 06:20:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160625010610.Horde.tUycS31CmgVWfy3CPu7qJCD@mail.sapo.pt>
References: <loom.20160623T205347-371@post.gmane.org> <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
 <5356822.A3RRKHDHNy@linux-omuo> <CAJCQCtQ-xYrERT5R4gSC1C7OkoeP2LeS9W9UL5VY5SmDBXk71w@mail.gmail.com>
 <20160625010610.Horde.tUycS31CmgVWfy3CPu7qJCD@mail.sapo.pt>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 25 Jun 2016 07:20:28 -0600
Message-ID: <CAJCQCtSGZO8JVXqVOwifT84KTLCkciux+Y6A_na4AA-PxPjjbw@mail.gmail.com>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
To: Vasco Almeida <vascomalmeida@sapo.pt>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 6:06 PM, Vasco Almeida <vascomalmeida@sapo.pt> wrote:
> Citando Chris Murphy <lists@colorremedies.com>:

>> A lot of changes have happened since 4.1.2 I would still use something
>> newer and try to repair it.
>
>
> By repair do you mean issue "btrfs check --repair /device" ?

Once you have copied off the important stuff, yes. It's less likely to
make things worse now. However, there are some things to do first:




> dmesg http://paste.fedoraproject.org/384352/80842814/

[ 1837.386732] BTRFS info (device dm-9): continuing balance
[ 1838.006038] BTRFS info (device dm-9): relocating block group
15799943168 flags 34
[ 1838.684892] BTRFS info (device dm-9): relocating block group
10934550528 flags 36
[ 1839.301453] ------------[ cut here ]------------
[ 1839.301495] WARNING: CPU: 3 PID: 76 at fs/btrfs/extent-tree.c:1625
lookup_inline_extent_backref+0x45c/0x5a0 [btrfs]()

followed by

[ 1839.301797] WARNING: CPU: 3 PID: 76 at fs/btrfs/extent-tree.c:2946
btrfs_run_delayed_refs+0x29d/0x2d0 [btrfs]()
[ 1839.301798] BTRFS: Transaction aborted (error -5)
[...]
[ 1839.301972] BTRFS: error (device dm-9) in
btrfs_run_delayed_refs:2946: errno=-5 IO failure
[ 1839.301975] BTRFS info (device dm-9): forced readonly

So it looks like it was resuming a balance automatically, and while
processing delayed references it's running into something it doesn't
expect and doesn't have a way to fix, so it goes read only to avoid
causing more problems.

I would do a couple things in order:
1. Mount ro and copy off what you want in case the whole thing gets
worse and can't ever be mounted again.
2. Mount with only these options: -o skip_balance,subvolid=5,nospace_cache

If it mounts rw, don't do anything with it, just see if it cleans up
after itself. It also looks from the previous trace it was trying to
remove a snapshot and there are complaints of problems in that
snapshot. So hopefully just waiting 5 minutes doing nothing and it'll
clean up after itself (you can check with top to see if there are any
btrfs related transactions that run including the btrfs-cleaner
process) wait until they're done.

Then umount. If you want you could have two other consoles ready
first, one for 'journalctl -f' and another for sysrq+t to issue in
case you get a hang. This doesn't fix anything but it collects more
information for a bug report for the devs.

Once you get it umounted normally or by force, the next thing to do is

3. btrfs-image so that devs can see what's causing the problem that
the current code isn't handling well enough.
4. btrfs check --repair

Let's see the results of that repair. You can use 'script
btrfsrepair.txt' first and then 'btrfs check --repair' and it will log
everything. After btrfs check completes, use 'exit' to stop script
from recording and you should have a btrfsrepair.txt file you can post
somewhere. When using > not everything gets logged for some reason but
script will capture everything.

Depending on how the repair goes, there might be a couple more options left.



-- 
Chris Murphy
