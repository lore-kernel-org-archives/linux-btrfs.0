Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50269 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaFUTMy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Jun 2014 15:12:54 -0400
Received: by mail-ob0-f176.google.com with SMTP id wm4so2494906obc.35
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Jun 2014 12:12:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2316027.LZEnVG8laK@xev>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
 <2316027.LZEnVG8laK@xev>
From: =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>
Date: Sat, 21 Jun 2014 21:12:34 +0200
Message-ID: <CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
Subject: Re: btrfs on whole disk (no partitions)
To: russell@coker.com.au
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-06-19 2:07 GMT+02:00 Russell Coker <russell@coker.com.au>:

> For boot disks I use the traditional partitioning system.  So far I don't run
> any systems that have a boot disk larger than 2TB so I haven't needed to use
> GPT.
>
> I have a BTRFS RAID-1 on 2*3TB disks which have no partition tables, when the
> filesystem is going to use the entire device and there's no boot loader there
> is no reason to have a partition table.

ok, but what about alignment? This can have a significant impact on performance.
