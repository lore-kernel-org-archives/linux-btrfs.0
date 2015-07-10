Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f44.google.com ([209.85.216.44]:37639 "EHLO
	mail-vn0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbbGJApb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 20:45:31 -0400
Received: by vnav203 with SMTP id v203so17603057vna.4
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 17:45:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559F131B.30206@cn.fujitsu.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
	<558CB0D4.8060401@cn.fujitsu.com>
	<558CB404.8050300@cn.fujitsu.com>
	<CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
	<CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
	<CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
	<559F131B.30206@cn.fujitsu.com>
Date: Thu, 9 Jul 2015 18:45:30 -0600
Message-ID: <CAJCQCtQ4j7hjtwmXhmxAqVv6zzQ-PZs2kP5-NsdOKhyCK5P6pg@mail.gmail.com>
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 9, 2015 at 6:34 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> One of my patch addressed a problem that a converted btrfs can't pass
> btrfsck.
>
> Not sure if that is the cause, but if you can try btrfs-progs v3.19.1, the
> one without my btrfs-progs patches and some other newer convert related
> patches, and see the result?
>
> I think this would at least provide the base for bisect the btrfs-progs if
> the bug is in btrfs-progs.

I'm happy to regression test with 3.19.1 but I'm confused. After
conversion, btrfs check (4.1) finds no problems. After ext2_saved
snapshot is deleted, btrfsck finds no problems. After defrag, again
btrfsck finds no problems. After the failed balance, btrfsck finds no
problems but crashes with "Aborted (core dump)".

Should I still test 3.19.1?


-- 
Chris Murphy
