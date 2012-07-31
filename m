Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49585 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab2GaKmt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 06:42:49 -0400
Received: by ghrr11 with SMTP id r11so5849963ghr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 03:42:49 -0700 (PDT)
Message-ID: <1343731366.6064.28.camel@ayu>
Subject: Re: filesystem finder / fixer
From: Calvin Walton <calvin.walton@kepstin.ca>
To: serialhex@lavabit.com
Cc: linux-btrfs@vger.kernel.org
Date: Tue, 31 Jul 2012 06:42:46 -0400
In-Reply-To: <36321.99.101.148.183.1343705202.squirrel@lavabit.com>
References: <36321.99.101.148.183.1343705202.squirrel@lavabit.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2012-07-30 at 23:26 -0400, serialhex@lavabit.com wrote:
> Hi all, so I've filled out an awesome ID10T form this weekend (all
> starting with a forded update) and completely annialated my partitions...
> I was running btrfs and was wondering 2 things:
> 
> 1) is there a tool to help me recover data from my fs? I don't have a
> backup of my partition table and so I have about 500GB of space where a
> few partitionns might reside... GPT partitions mind you

One of the nice things about GPT is that it stores a backup partition
table in a second spot near the end of the disk. It may be possible to
recover it.

Try running 'gdisk' on your drive, then hit 'r' to switch to recovery
mode. Try the 'c' recovery command to load the backup partition table
from disk.
More details and some other things you might want to try are at
http://www.rodsbooks.com/gdisk/repairing.html

Do keep in mind that if you have the space, you should make an image of
your disk before trying any recovery tools. If you don't have the space,
then you should buy, say, an external USB drive to *make* the space, and
use it for backups once you're done recovering your data (if that's
possible.)

This wouldn't have been a major problem if you had backups in the first
place :)

-- 
Calvin Walton <calvin.walton@kepstin.ca>

