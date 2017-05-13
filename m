Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:36698 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751885AbdEMJwt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 May 2017 05:52:49 -0400
Date: Sat, 13 May 2017 14:52:47 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs/SSD
Message-ID: <20170513145247.247791b7@natsu>
In-Reply-To: <20170512203644.26e068e5@jupiter.sol.kaishome.de>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
        <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
        <20170512203644.26e068e5@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 12 May 2017 20:36:44 +0200
Kai Krakow <hurikhan77@gmail.com> wrote:

> My concern is with fail scenarios of some SSDs which die unexpected and
> horribly. I found some reports of older Samsung SSDs which failed
> suddenly and unexpected, and in a way that the drive completely died:
> No more data access, everything gone. HDDs start with bad sectors and
> there's a good chance I can recover most of the data except a few
> sectors.

Just have your backups up-to-date, doesn't matter if it's SSD, HDD or any sort
of RAID.

In a way it's even better, that SSDs [are said to] fail abruptly and entirely.
You can then just restore from backups and go on. Whereas a failing HDD can
leave you puzzled on e.g. whether it's a cable or controller problem instead,
and possibly can even cause some data corruption which you won't notice until
too late.

-- 
With respect,
Roman
