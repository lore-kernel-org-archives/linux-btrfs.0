Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:58534 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaJZBl2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Oct 2014 21:41:28 -0400
Received: by mail-qa0-f48.google.com with SMTP id x12so2458713qac.21
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Oct 2014 18:41:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_nR-MP8VLWanvvs9dMQBi02JoCCUTYd_JwA9tmtPRGmSg@mail.gmail.com>
References: <20141009141944.GA11525@atrey.karlin.mff.cuni.cz>
	<CAGfcS_nR-MP8VLWanvvs9dMQBi02JoCCUTYd_JwA9tmtPRGmSg@mail.gmail.com>
Date: Sat, 25 Oct 2014 21:41:27 -0400
Message-ID: <CAGfcS_kFnqp5aeHMfTLJbTbVx=yobNf+Zp-ECYh1xNRFG7UjaA@mail.gmail.com>
Subject: Re: btrfs balance segfault, kernel BUG at fs/btrfs/extent-tree.c:7727
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 13, 2014 at 11:12 AM, Rich Freeman
<r-btrfs@thefreemanclan.net> wrote:
> On Thu, Oct 9, 2014 at 10:19 AM, Petr Janecek <janecek@ucw.cz> wrote:
>>
>>   I have trouble finishing btrfs balance on five disk raid10 fs.
>> I added a disk to 4x3TB raid10 fs and run "btrfs balance start
>> /mnt/b3", which segfaulted after few hours, probably because of the BUG
>> below. "btrfs check" does not find any errors, both before the balance
>> and after reboot (the fs becomes un-umountable).
>>
>> [22744.238559] WARNING: CPU: 0 PID: 4211 at fs/btrfs/extent-tree.c:876 btrfs_lookup_extent_info+0x292/0x30a [btrfs]()
>>
>> [22744.532378] kernel BUG at fs/btrfs/extent-tree.c:7727!
>
> I am running into something similar. I just added a 3TB drive to my
> raid1 btrfs and started a balance.  The balance segfaulted, and I find
> this in dmesg:

I got another one of these crashes during a balance today, and this is
on 3.17.1 with the "Btrfs: race free update of commit root for ro
snapshots" patch.  So, there is something else in 3.17.1 that causes
this problem.  I did see mention of an extent error of some kind on
the lists and I don't have that patch - I believe it is planned for
3.17.2.

After the crash the filesystem became read-only.

I didn't have any way to easily capture the logs, but I got repeated
crashes when trying to re-mount the filesystem after rebooting.  The
dmesg log showed read errors from one of the devices (bdev /dev/sdb2
errs: wr 0, rd 1361, flush 0, corrupt 0, gen 0).  When I tried to
btrfs check the filesystem with btrfs-progs 3.17 it abruptly
terminated and output an error mentioning could not find extent items
followed by root and a really large number.

I finally managed to recover by mounting the device with skip_balance
- I suspect that it was crashing due to attempts to restart the
failing balance.  Then after letting the filesystem settle down I
unmounted it cleanly and rebooted and everything was back to normal.

However, i'm still getting "bdev /dev/sdb2 errs: wr 0, rd 1361, flush
0, corrupt 0, gen 0" in my dmesg logs.  I have tried scrubbing the
device with no errors found.

--
Rich
