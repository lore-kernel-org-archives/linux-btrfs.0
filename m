Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35536 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753033AbdFRDJh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Jun 2017 23:09:37 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dMQaW-0008Ns-5f
        for linux-btrfs@vger.kernel.org; Sun, 18 Jun 2017 05:09:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2 2/2] btrfs: Round down values which are written for
 total_bytes_size
Date: Sun, 18 Jun 2017 03:09:14 +0000 (UTC)
Message-ID: <pan$a52a7$449ab7f0$8d4ee56f$4f139c10@cox.net>
References: <1497613160-3074-1-git-send-email-nborisov@suse.com>
        <1497613160-3074-3-git-send-email-nborisov@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nikolay Borisov posted on Fri, 16 Jun 2017 14:39:20 +0300 as excerpted:

Not a dev but I can read descriptions.  Three typos in this paragraph:

> Substracting the numbers we get a difference of less than a 4kb. Upon

Subtracting

> closer inspection it became apparent that mkfs actually rounds down the
> size of the device to a multiple of sector size. However, the same
> cannot be said for various functions which modify the total size and are
> called from btrfs_balanace as well as when adding a new device. So this

btrfs_balance

> patch ensures that values being saved into on-disk data structures are
> always rounded down to a multiple of sectorsize

Missing sentence-terminating "."

(They're likely trivial enough to be fixed at apply time if there's no 
further code changes.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

