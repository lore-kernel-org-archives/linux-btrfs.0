Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:34561 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754439AbdBNQH7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 11:07:59 -0500
Received: by mail-yb0-f182.google.com with SMTP id j82so37701067ybg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Feb 2017 08:07:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ea92c7c6-4b98-d683-eb66-593836bcc82a@gmail.com>
References: <ea92c7c6-4b98-d683-eb66-593836bcc82a@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 14 Feb 2017 09:07:57 -0700
Message-ID: <CAJCQCtQi56sVYccDPsVi8Av+FW=4SQjPpDskL0kJ-qY=P6rU1A@mail.gmail.com>
Subject: Re: Unexpected behavior involving file attributes and snapshots.
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2017 at 8:30 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> I was just experimenting with snapshots on 4.9.0, and came across some
> unexpected behavior.
>
> The simple explanation is that if you snapshot a subvolume, any files in the
> subvolume that have the NOCOW attribute will not have that attribute in the
> snapshot.  Some further testing indicates that this is the only file
> attribute that isn't preserved (I checked all the chattr flags that BTRFS
> supports).

Huh, I can't reproduce this with 4.9.8 or 4.10rc7. systemd sets
journal files with chattr +C, and I do manual snapshots of rootfs
periodically, and those snapshots have journal files that have +C
still set.


-- 
Chris Murphy
