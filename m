Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62260 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3AVPIR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 10:08:17 -0500
Received: by mail-ie0-f173.google.com with SMTP id e13so11825946iej.18
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 07:08:17 -0800 (PST)
Message-ID: <1358867297.5681.23.camel@cwalton-XPS-8300>
Subject: Re: Simple btrfs use case
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Pavel Vasilyev <ml@yekm.name>
Cc: linux-btrfs@vger.kernel.org
Date: Tue, 22 Jan 2013 10:08:17 -0500
In-Reply-To: <CAFCsa79Cn65gUFKT9RmCYG1WjP257n+iy0zGh_-vaX4Pc_grVA@mail.gmail.com>
References: <CAFCsa79Cn65gUFKT9RmCYG1WjP257n+iy0zGh_-vaX4Pc_grVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2013-01-22 at 16:08 +0400, Pavel Vasilyev wrote:
> Hi
> 
> For example I have a bunch of various disks. I want to use them all as
> one big storage:
> mkfs.btrfs -m raid1 -d single /dev/sda /dev/sdb /dev/sdc ...
> And someday one of my disks becomes dead. Disappears.
> However, I can still mount fs in degraded,ro mode. All files that lays
> on working disks are still available, but the only option to save
> those files is to make a new fs on a new disk and copy them to it.
> Why? Can I just drop files, whose chunks was on the dead disk?
> 
> 
> How btrfs allocates files (file chunks) on physical disks? i.e. can I
> lose all my files in -d single mode, when one of my disk becomes dead?

In "single" data mode, btrfs makes no special attempt to keep files
together on the same disk, but if a file is written linearly and never
modified there's a chance it might happen. (Each modification will COW
the file, putting the modified portion on a random disk.)

As a result, yes, you may lose a substantial number - even most - of
your files if one disk dies while in single data mode.

The failure mode you are describing would be interesting, and people
talk about it now and then, but there is no current support in btrfs for
it.

(One thing to note: small files are often stored in the metadata area
instead of data area, which would be raid1 in your setup. As a result,
those small files are more likely to be recoverable).

-- 
Calvin Walton <calvin.walton@kepstin.ca>

