Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from campbell-lange.net ([178.79.140.51]:44896 "EHLO
        campbell-lange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbeIPWrU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 18:47:20 -0400
Date: Sun, 16 Sep 2018 18:23:42 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Move data and mount point to subvolume
Message-ID: <20180916172342.igaqkimdd5cqyxyc@campbell-lange.net>
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
 <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks very much for the reply, Hans. I'm just responding to your note
about mout options here.

On 16/09/18, Hans van Kranenburg (hans.van.kranenburg@mendix.com) wrote:
> > The machine is btrfs-progs v4.7.3 Linux 4.9.0-8-amd64 on Debian. The
> > coreutils version is 8.26-3.
> 
> Another note: since it seems you have about 100% more data space
> allocated (set apart for data purpose) than you're actually using, or in
> other words, having the 1GiB chunks on average just for 50% filled...
> 
>    Data, RAID1: total=2.52TiB, used=1.36TiB
> 
> ...in combination with using Linux 4.9, I suspect there's also 'ssd' in
> your mount options (not in fstab, but enabled by btrfs while mounting,
> see /proc/mounts or mount command output)?
> 
> If so, this is a nice starting point for more info about what might also
> be happening to your filesystem:
> https://www.spinics.net/lists/linux-btrfs/msg70622.html

My mount options are (according to 'mount'):

/dev/mapper/cdisk2 on /bkp type btrfs (rw,noatime,compress=lzo,space_cache,subvolid=5,subvol=/)

Perhaps I need to run a balance, as suggested in your message recorded
on spinics? mount doesn't report the ssd option though, as you suggest
it might. Perhaps the compression flag is the culprit here.

Many thanks
Rory
