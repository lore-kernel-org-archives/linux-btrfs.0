Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v1.edulibre.org ([5.39.16.54]:49547 "EHLO mail.edulibre.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbcHOKpS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 06:45:18 -0400
Received: from asus17.lairdutemps.org (did75-10-82-236-230-93.fbx.proxad.net [82.236.230.93])
	by mail.edulibre.org (Postfix) with ESMTPSA id F16BD102179D
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 12:39:29 +0200 (CEST)
Date: Mon, 15 Aug 2016 12:39:28 +0200
From: Daniel Caillibaud <ml@lairdutemps.org>
To: <linux-btrfs@vger.kernel.org>
Subject: Huge load on btrfs subvolume delete
Message-ID: <20160815123928.47bd2c03@asus17.lairdutemps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm newbie with btrfs, and I have pb with high load after each btrfs subvolume delete

I use snapshots on lxc hosts under debian jessie with
- kernel 4.6.0-0.bpo.1-amd64
- btrfs-progs 4.6.1-1~bpo8

For backup, I have each day, for each subvolume

btrfs subvolume snapshot -r $subvol $snap
# then later
ionice -c3 btrfs subvolume delete $snap

but ionice doesn't seems to have any effect here and after a few minutes the load grows up
quite high (30~40), and I don't know how to make this deletion nicer with I/O

Is there a better way to do so ?

Is it a bad idea to set ionice -c3 on the btrfs-transacti process which seems the one doing a
lot of I/O ?

Actually my io priority on btrfs process are 

ps x|awk '/[b]trfs/ {printf("%20s ", $NF); system("ionice -p" $1)}'
      [btrfs-worker] none: prio 4
   [btrfs-worker-hi] none: prio 4
    [btrfs-delalloc] none: prio 4
   [btrfs-flush_del] none: prio 4
       [btrfs-cache] none: prio 4
      [btrfs-submit] none: prio 4
       [btrfs-fixup] none: prio 4
       [btrfs-endio] none: prio 4
   [btrfs-endio-met] none: prio 4
   [btrfs-endio-met] none: prio 4
   [btrfs-endio-rai] none: prio 4
   [btrfs-endio-rep] none: prio 4
         [btrfs-rmw] none: prio 4
   [btrfs-endio-wri] none: prio 4
   [btrfs-freespace] none: prio 4
   [btrfs-delayed-m] none: prio 4
   [btrfs-readahead] none: prio 4
   [btrfs-qgroup-re] none: prio 4
   [btrfs-extent-re] none: prio 4
     [btrfs-cleaner] none: prio 0
   [btrfs-transacti] none: prio 0



Thanks

-- 
Daniel
