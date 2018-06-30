Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from einhorn-mail.in-berlin.de ([217.197.80.20]:40218 "EHLO
        einhorn-mail.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751861AbeF3EDE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 00:03:04 -0400
Subject: Re: btrfs suddenly think's it's raid6
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <80f0c6f7-ede1-e522-551c-ec2446bb79ea@hamburg.ccc.de>
 <4f7902e3-d176-5395-55f1-72bdffab7d47@gmx.com>
 <30ad064e-99e0-4398-2af7-d97f9577ff8f@hamburg.ccc.de>
 <CAJCQCtTV8UFdQUA8xKRzfQmKABsNCYFwR9XdvbD3br_cJ-Dp2w@mail.gmail.com>
From: marble <marble@hamburg.ccc.de>
Message-ID: <28fd355a-6368-b23d-fb77-67b684c5c06d@hamburg.ccc.de>
Date: Sat, 30 Jun 2018 06:02:40 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTV8UFdQUA8xKRzfQmKABsNCYFwR9XdvbD3br_cJ-Dp2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> No log_root* in the super. So no fsyncing at the time? What was
> happening at the time of the power loss?
That I don't know.

> Pretty weird, all three supers are OK and yet two copies of the fs
> tree are corrupt. Why doesn't it fall back automatically to one of the
> other roots?
> 
> You could try 'mount -o usebackuproot,ro' and see if that's permissive
> enough to succeed.
That yields the same result
```
marble@archlinux ~ % sudo mount -o usebackuproot,ro /dev/mapper/black
/tmp/black
mount: /tmp/black: can't read superblock on /dev/mapper/black.
```
> I wonder if the drive firmware reordered things contrary to Btrfs
> expectation right at the powerfail - or even if the powerfail caused
> the drive firmware to do the writes in the wrong order?
> 
> 
