Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33190 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbbJVFdF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 01:33:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zp8Un-00035r-Kz
	for linux-btrfs@vger.kernel.org; Thu, 22 Oct 2015 07:33:01 +0200
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 07:33:01 +0200
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 07:33:01 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: BTRFS BUG at insert_inline_extent_backref+0xe3/0xf0 while rebalancing
Date: Thu, 22 Oct 2015 08:32:40 +0300
Message-ID: <m49lhavbh8n.fsf@coffee.modeemi.fi>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Recently I added daily rebalancing to my cron.d (after finding myself in
the no-space-situation), and not long after that, I found my PC had
crashed over night. Having no sign in the logs anywhere (not even over
network even though there should be) I had nothing to go on, but this
night it crashed again after starting the rebalance, and this time there
was some information on the kernel log.

Kernel version: 4.2.3 (package linux-image-4.2.0-1-amd64 version 4.2.3-1
from Debian Unstable)

The dump is available at:

  http://www.modeemi.fi/~flux/btrfs/btrfs-BUG-2015-10-55.txt

The log is available as well (stripped some unrelated USB- and firewall
logging, showing that last evening there was some kernel task hung for
120 seconds; but it's in another btrfs filesystem and is another story):

  http://www.modeemi.fi/~flux/btrfs/btrfs-2015-10-55.txt

I'm not quite sure which of the btrfs balance commands caused the
issue. But there is my script:

#!/bin/sh
fs="$1"
if [ -z "$fs" ]; then
  echo usage: btrfs-balance / 0 1 5 10 20 50
  exit 1
fi
fs="$1"
shift
for usage in d m; do for a in "$@"; do date; /bin/btrfs balance start
"$fs" -v -${usage}usage=$a; done; done

And it was started at 07:30 with:

  /usr/local/sbin/btrfs-balance / 0 1 2 5 10 20 30 50 70

I should add that the filesystem in question is backed by MD RAID10 and
that is backed by four SSDs, so it's reasonably fast in IO, if that
affects anything. There should have been no much competing IO at the
time of the occurrence.

Before Duncan asks ;-), I only have a moderate number of subvolumes and
snapshots, ie. one subvolume for each of /, /var/log/journal and /home,
24 snapshots of / and /home plus <10 snapshots of /.

Before that balance there was another balance on a another BTRFS RAID10,
but given the time stamp I think I can easily say it wasn't the cause.

I don't really have other 'solutions' than disabling the rebalancing for
the time being, and only use it as-needed as I had earlier done..

Cheers,

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

