Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:46955 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaLER2Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 12:28:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 05 Dec 2014 18:28:13 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, chris@colorremedies.com
Subject: Re: btrfs device delete missing - Input/output error
In-Reply-To: <CAJCQCtRh7HU9yd-pxgXzXebVcjukQh6Lyhzfcd6bBJppyCxChQ@mail.gmail.com>
References: <3146bf116f41e590e8ce4fdb610def31@admin.virtall.com>
 <CAJCQCtRh7HU9yd-pxgXzXebVcjukQh6Lyhzfcd6bBJppyCxChQ@mail.gmail.com>
Message-ID: <88e897a70d1ac64a5b6b2c4b2e9e49d5@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-12-05 17:41, Chris Murphy wrote:

> You're getting a read error when writing. This is expected when
> writing 512 bytes to a 4k sector.
> 
> What do you get for
>  parted /dev/sdb u s p

Right - so we're getting these:

# parted /dev/sdb u s p
Model: ATA ST3000DM001-9YN1 (scsi)
Disk /dev/sdb: 5860533168s
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start        End          Size         File system  Name  Flags
  5      2048s        4095s        2048s                           
bios_grub
  1      4096s        67112959s    67108864s                       raid
  2      67112960s    68161535s    1048576s                        raid
  3      68161536s    2215645183s  2147483648s                     raid
  4      2215645184s  5860533134s  3644887951s  btrfs              raid


-- 
Tomasz Chmielewski
http://www.sslrack.com

