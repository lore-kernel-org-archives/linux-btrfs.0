Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34556 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbdGPODE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Jul 2017 10:03:04 -0400
Received: by mail-wm0-f67.google.com with SMTP id p204so18696897wmg.1
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Jul 2017 07:03:03 -0700 (PDT)
From: Giuseppe Della Bianca <giusdbg@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists (since 3.4 / 2012)
Date: Sun, 16 Jul 2017 16:01:53 +0200
Message-ID: <3161165.SzVyadSXaH@exnet.gdb.it>
In-Reply-To: <20170715231245.GA28281@merlins.org>
References: <20170715004828.f4bom5wq34abe4lz@merlins.org> <20170715012216.njq6az3y34qyomtb@merlins.org> <20170715231245.GA28281@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Fri, Jul 14, 2017 at 06:22:16PM -0700, Marc MERLIN wrote:
> > Dear Chris and other developers,
]zac[
> Others on this thread with the same error: did anyone recover from this
> without wiping the filesystem?
> 
> Is there a chance a balance might work around the bug so that whatever
> layout I have, changes, and stops the bug from occuring?
]zac[

Any attempt, even just delete files, has worsened the situation.
I advise not to waste time in repairs, and directly recreate the filesystem.

My workaround is to avoid being more than one btrfs tools running.

 progResult=0

 while read proc; do
	 if [ $progResult == 0 ]; then
		 echo -e \nbtrfs tools already running

		 progResult=222
	 fi

	 echo $proc"
 done < <(ps -ef | grep -e "btrfs \{1,\}\(subvolume\|send\|receive\|delete\)")
