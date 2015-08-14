Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:33688 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbbHNSb2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 14:31:28 -0400
Received: by vkbg64 with SMTP id g64so20027604vkb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 11:31:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
References: <CANCCtj=EDCU4dMRk3m7cJFPXk8D2Pse8yfqc4iaDGjPOQ5EORA@mail.gmail.com>
Date: Fri, 14 Aug 2015 12:31:27 -0600
Message-ID: <CAJCQCtTXBYg2zZH3fs3S_kbYHtkvKSjcgoujZrLeTqNW1eRzEA@mail.gmail.com>
Subject: Re: The performance is not as expected when used several disks on raid0.
From: Chris Murphy <lists@colorremedies.com>
To: Eduardo Bach <hellbach@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 9:16 AM, Eduardo Bach <hellbach@gmail.com> wrote:

> With btrfs the result approaches 3.5GB/s. When using mdadm+xfs the
> result reaches 6gb/s, which is the expected value when compared with
> parallel dd made on discs.

mdadm with what chunk (strip) size? The default for mdadm is 512KiB.
On Btrfs it's fixed at 64KiB. While testing with 64KiB chunk with XFS
on md RAID might improve its performance relative to Btrfs, at least
it's a more apples to apples comparison.

-- 
Chris Murphy
