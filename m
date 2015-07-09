Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f51.google.com ([209.85.216.51]:33451 "EHLO
	mail-vn0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbGIVik (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 17:38:40 -0400
Received: by vnbf7 with SMTP id f7so24896932vnb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 14:38:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
References: <CAC8ULPYHuqsZN1Lm_2TxGMw7z6n=4zAprqYr9uoi=3kjoiSxQw@mail.gmail.com>
	<558CB0D4.8060401@cn.fujitsu.com>
	<558CB404.8050300@cn.fujitsu.com>
	<CAJCQCtTMdQG4EB8dNAYPq8H3V68TCb2YQztoXXYMkCYA3GBCXw@mail.gmail.com>
	<CAO5K3OcA1_Z4-jvv_2C0StBkOr++_vUX4kOspY8cuhnX2t3z_A@mail.gmail.com>
Date: Thu, 9 Jul 2015 15:38:39 -0600
Message-ID: <CAJCQCtQ35xzMBjcUUTzWm3CjC1r=UNgkog2YbB0X1QcZofNj0g@mail.gmail.com>
Subject: Re: btrfs partition converted from ext4 becomes read-only minutes
 after booting: WARNING: CPU: 2 PID: 2777 at ../fs/btrfs/super.c:260 __btrfs_abort_transaction+0x4b/0x120
From: Chris Murphy <lists@colorremedies.com>
To: Vytautas D <vytdau@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Robert Munteanu <robert.munteanu@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 9, 2015 at 4:52 AM, Vytautas D <vytdau@gmail.com> wrote:
> <Slightly off topic>
>
> does these bugs exist in systems that converted from ext4 to btrfs using
> kernel 3.13 and then upgraded to kernel 4.1 ?

I don't recall what btrfs-progs and kernel I last tested ext4
conversion with. I know this is a regression, I just don't know how
old it is. I think there's more than one bug here (obviously since
I've filed 4 related bugs in ~24 hours), but I really don't know the
scope of the problem. But the case where the recommended procedure not
only fails but corrupts the file system and it can't be fixed or
rolled back, is not good.

Perhaps the wiki should provide a warning that this is currently
broken, status unknown, or something?

-- 
Chris Murphy
