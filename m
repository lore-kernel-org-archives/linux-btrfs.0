Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:36657 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbHQT5n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 15:57:43 -0400
Received: by ykfw73 with SMTP id w73so83890378ykf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2015 12:57:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
 <CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
From: Eduardo Bach <hellbach@gmail.com>
Date: Mon, 17 Aug 2015 16:57:23 -0300
Message-ID: <CANCCtj=Sfnv47ECiZNF+bTGwLP+221D6StoB3qFjD0XoFFNKag@mail.gmail.com>
Subject: Re: The performance is not as expected when used several disks on raid0.
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The bether xfs performance we got was using 32 disks and 128KB mdadm chunk size.
Could the be the problem we are seen? if each disk get 4KB, 64KB will
be optimal for just 16 disks when usint raid0 with btrfs?

2015-08-14 15:31 GMT-03:00 Chris Murphy <lists@colorremedies.com>:
> On Fri, Aug 14, 2015 at 9:16 AM, Eduardo Bach <hellbach@gmail.com> wrote:
>
>> With btrfs the result approaches 3.5GB/s. When using mdadm+xfs the
>> result reaches 6gb/s, which is the expected value when compared with
>> parallel dd made on discs.
>
> mdadm with what chunk (strip) size? The default for mdadm is 512KiB.
> On Btrfs it's fixed at 64KiB. While testing with 64KiB chunk with XFS
> on md RAID might improve its performance relative to Btrfs, at least
> it's a more apples to apples comparison.
>
> --
> Chris Murphy
