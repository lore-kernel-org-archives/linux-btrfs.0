Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42835 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756823AbdJKESO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 00:18:14 -0400
Message-Id: <1507695493.605704.1134784560.530EF386@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <87o9pf7o3g.wl-satoru.takeuchi@gmail.com>
Subject: Re: USB upgrade fun
In-Reply-To: <87o9pf7o3g.wl-satoru.takeuchi@gmail.com>
Date: Wed, 11 Oct 2017 12:18:13 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 10 Oct 2017, at 10:06 AM, Satoru Takeuchi wrote:
> Probably `btrfs device remove missing /mnt/raid1` works.

That command worked. Took a really long time, but it worked. However
when I unmounted /mnt/raid1 and tried mounting it again, it fails! :(

https://s.natalian.org/2017-10-11/btrfs.txt

mount: /mnt/raid1: wrong fs type, bad option, bad superblock on
/dev/sdb1, missing codepage or helper program, or other error.

"open_ctree failed" is back... sigh...

Any tips?

I'm going to check the disks one by one and I'll reboot the server a
little later.
