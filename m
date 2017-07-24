Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:33150 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdGXOIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 10:08:10 -0400
Date: Mon, 24 Jul 2017 19:08:08 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Cloud Admin <admin@cloud.haefemeier.eu>, linux-btrfs@vger.kernel.org
Subject: Re: Best Practice: Add new device to RAID1 pool
Message-ID: <20170724190808.148964a6@natsu>
In-Reply-To: <18d96f74-00a8-9bb9-dddc-f50940d0971e@gmail.com>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
        <18d96f74-00a8-9bb9-dddc-f50940d0971e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 24 Jul 2017 09:46:34 -0400
"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> > I am a little bit confused because the balance command is running since
> > 12 hours and only 3GB of data are touched. This would mean the whole
> > balance process (new disc has 8TB) would run a long, long time... and
> > is using one cpu by 100%.
> 
> Based on what you're saying, it sounds like you've either run into a 
> bug, or have a huge number of snapshots

...and possibly quotas (qgroups) enabled. (perhaps automatically by some tool,
and not by you). Try:

  btrfs quota disable <mountpoint>

With respect,
Roman
