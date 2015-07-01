Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36763 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbbGAPjn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jul 2015 11:39:43 -0400
Received: by oiaf66 with SMTP id f66so3134836oia.3
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2015 08:39:43 -0700 (PDT)
MIME-Version: 1.0
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Wed, 1 Jul 2015 10:39:23 -0500
Message-ID: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
Subject: Any hope of pool recovery?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

"darkling" was helping me on IRC for a while before he had to drop
off, thanks for the help darkling.

To pick up where we left off...
In summary, I have a 10 disk raid6 pool that I cannot mount.

btrfs fi show output is here ->  http://pastebin.com/aidGV20e
'tank' is the pool in question.

mounting fails with errors in dmesg with or without
recovery,degraded,ro options.

[  142.588443] BTRFS: device label tank devid 1 transid 14796 /dev/sdc
[  142.589646] BTRFS info (device sdc): enabling auto recovery
[  142.589658] BTRFS info (device sdc): allowing degraded mounts
[  142.589665] BTRFS info (device sdc): disk space caching is enabled
[  142.589669] BTRFS: has skinny extents
[  142.592199] BTRFS: failed to read chunk root on sdc
[  142.612988] BTRFS: open_ctree failed

What precipitated all this was horrible performance from the pool,
seeing that service times for /dev/sdg were ~ 3 seconds and smartctl
reported many sector issues with /dev/sdg.
I issued the commant btrfs device delete /dev/sdg  and then monitored
btrfs fi show but saw no change in allocated data to /dev/sdg for
several hours.
I then attempted wipefs -a /dev/sdg  but it was still listed in the
btrfs fi show.
I then rebooted, and am at the point where I'm at now.   I figured
it's best to stop breaking things now and ask for help, if this can be
recovered.

Thank you,
Donald (seijirou)
