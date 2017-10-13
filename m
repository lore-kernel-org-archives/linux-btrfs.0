Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:49881 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdJMS3A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 14:29:00 -0400
Received: by mail-oi0-f41.google.com with SMTP id w197so15625374oif.6
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 11:29:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d8ef3dde-553e-d8b5-6d8f-8a6e4929d739@gmail.com>
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <CAJCQCtRnbz5WGqZEO3b8a+3B2gDbG_zioqWEVoJz_dD0SB=6Ww@mail.gmail.com>
 <0a3e71f7-1a8e-9a4f-7470-4c5cc2fb11a0@gmail.com> <1507858974.1236555.1137202920.267B449B@webmail.messagingengine.com>
 <d8ef3dde-553e-d8b5-6d8f-8a6e4929d739@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 13 Oct 2017 19:28:59 +0100
Message-ID: <CAJCQCtQ82=5xUKgwUFt4ETE5CLA228hkBMVaX=T4Bj-JjXvaGQ@mail.gmail.com>
Subject: Re: USB upgrade fun
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Kai Hendry <hendry@iki.fi>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 13, 2017 at 12:22 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> From a practical perspective, you're almost certainly better off creating a
> copy for cold storage without involving BTRFS.

Yeah if you want to hedge your bets, and keep it simple, rsync to XFS.
With some added risk (double) you can use mdadm linear or LVM to
concat multiple devices if necessary. In theory you're not going to
get a double failure. But really, the more backups you add, it
increasingly doesn't matter what the strategy used.


>As an alternative, I would
> suggest one of the following approaches:
>
> 1. Take a snapshot of the filesystem, and use send/receive to transfer that
> to another device which you then remove and store somewhere.

This is what I do. Primary, and two separate backup (separate volume
UUIDs), all three are Btrfs. The primary uses send/receive to the two
backups. But my organization plan allows me to have only three
subvolumes on the primary being snapshot and thus send/receive. So
it's easy. Fourth copy, a subset of important data, is in the cloud.


> 2. Use rsync to copy things to another device which you then remove and
> store somewhere.

A fifth copy, also a subset of important data is done doing this to
XFS and a big drive kept offsite. It just accumulates. I don't
consider it a backup, it's an archive, nothing is deleted. I treat it
as WORM. Maybe one day I redo it based on dm-verity so I can add error
detection and correction, the cryptographic aspects are a distant
second for me.


> Both these options are safer, less likely to screw up your existing
> filesystem, and produce copies that can safely be connected to the original
> system at the same time as the original filesystem.

Keeping it simple is the only way you use it with any regularity, and
can understand it well enough if (really when) you have to do a
restore.


-- 
Chris Murphy
