Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:51367 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751804AbdDATOB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 15:14:01 -0400
Date: Sat, 1 Apr 2017 12:13:57 -0700
From: Sean Greenslade <sean@seangreenslade.com>
To: Kai Herlemann <btrfs@linux.kai-herlemann.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is btrfs-convert able to deal with sparse files in a ext4
 filesystem?
Message-ID: <20170401191357.GA25721@coach>
References: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADN-S7MzE=6x25DK0XOPzfBGCEpTjdUSokBkuCPGhCvCURzLPg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 01, 2017 at 11:48:50AM +0200, Kai Herlemann wrote:
> Hi,
> I have on my ext4 filesystem some sparse files, mostly images from
> ext4 filesystems.
> Is btrfs-convert (4.9.1) able to deal with sparse files or can that
> cause any problems?

>From personal experience, I would recommend not using btrfs-convert on
ext4 partitions. I attempted it on a /home partition on one of my
machines, and while it did succeed in converting, the fs it produced had
weird issues that caused transation failures and thus semi-frequent
remount-ro. Btrfs-check, scrub, and balance were all unable to repair
the damage. I ended up recreating the parition from a backup.

As far as I know, there were no sparse files on this partition, either.

Just my one data point, for whatever it's worth.

--Sean

