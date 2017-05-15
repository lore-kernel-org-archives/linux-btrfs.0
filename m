Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 185-6-29-55-rev.logitus.pl ([185.6.29.55]:39922 "EHLO
        mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932677AbdEOUL7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 16:11:59 -0400
Date: Mon, 15 May 2017 22:05:05 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs/SSD
Message-ID: <20170515200505.GB5285@mother.pipebreaker.pl>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <pan$9df5c$36e00209$7c238f6d$c2c19c0f@cox.net>
 <CAK5rZE7H_qXh7TOU=N3JTocqjVitsAMNtxMCDfbJHTNJz0jF5A@mail.gmail.com>
 <20170512203644.26e068e5@jupiter.sol.kaishome.de>
 <beb7f0b0-b84a-dfa1-12c2-256fe967af1d@gmail.com>
 <20170515214938.097b4c0b@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170515214938.097b4c0b@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 15, 2017 at 09:49:38PM +0200, Kai Krakow wrote:
> 
> > It's worth noting also that on average, COW filesystems like BTRFS
> > (or log-structured-filesystems will not benefit as much as
> > traditional filesystems from SSD caching unless the caching is built
> > into the filesystem itself, since they don't do in-place rewrites (so
> > any new write by definition has to drop other data from the cache).
> 
> Yes, I considered that, too. And when I tried, there was almost no
> perceivable performance difference between bcache-writearound and
> bcache-writeback. But the latency of performance improvement was much
> longer in writearound mode, so I sticked to writeback mode. Also,
> writing random data is faster because bcache will defer it to
> background and do writeback in sector order. Sequential access is
> passed around bcache anyway, harddisks are already good at that.

  Let me add my 2 cents.  bcache-writearound does not cache writes
on SSD, so there are less writes overall to flash.  It is said
to prolong the life of the flash drive.
  I've recently switched from bcache-writeback to bcache-writearound,
because my SSD caching drive is at the edge of it's lifetime. I'm
using bcache in following configuration: https://enotty.pipebreaker.pl/dżogstaff/2016.05.25-opcja2.svg
My SSD is Samsung SSD 850 EVO 120GB, which I bought exactly 2 years ago.

  Now, according to http://www.samsung.com/semiconductor/minisite/ssd/product/consumer/850evo.html
120GB and 250GB warranty only covers 75 TBW (terabytes written).
My drive has  # smartctl -a /dev/sda  | grep LBA
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       136025596053

which multiplied by 512 bytes gives 69.6 TB. Close to 75TB? Well…

[35354.697513] sd 0:0:0:0: [sda] tag#19 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[35354.697516] sd 0:0:0:0: [sda] tag#19 Sense Key : Medium Error [current] 
[35354.697518] sd 0:0:0:0: [sda] tag#19 Add. Sense: Unrecovered read error - auto reallocate failed
[35354.697522] sd 0:0:0:0: [sda] tag#19 CDB: Read(10) 28 00 0c 30 82 9f 00 00 48 00
[35354.697524] blk_update_request: I/O error, dev sda, sector 204505785

Above started appearing recently.  So, I was really suprised that:
- this drive is only rated for 120 TBW
- I went through this limit in only 2 years

  The workload is lightly utilised home server / media center.

-- 
Tomasz Torcz                Only gods can safely risk perfection,
xmpp: zdzichubg@chrome.pl     it's a dangerous thing for a man.  -- Alia

