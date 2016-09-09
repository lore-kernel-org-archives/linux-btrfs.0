Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailer.moparisthebest.com ([144.76.72.168]:40717 "EHLO
        mailer.moparisthebest.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbcIIQb7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 12:31:59 -0400
From: moparisthebest <admin@moparisthebest.com>
Subject: btrfs kernel oops on mount
To: linux-btrfs@vger.kernel.org
Message-ID: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
Date: Fri, 9 Sep 2016 12:12:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm hoping to get some help with mounting my btrfs array which quit
working yesterday.  My array was in the middle of a balance, about 50%
remaining, when it hit an error and remounted itself read-only [1].
btrfs fi show output [2], btrfs df output [3].

I unmounted the array, and when I tried to mount it again, it locked up
the whole system so even alt+sysrq would not work.  I rebooted, tried to
mount again, same lockup.  This was all kernel 4.5.7.

I rebooted to kernel 4.4.0, tried to mount, crashed again, this time a
message appeared on the screen and I took a picture [4].

I rebooted into an arch live system with kernel 4.7.2, tried to mount
again, got some dmesg output before it crashed [5] and took a picture
when it crashed [6], says in part 'BUG: unable to handle kernel NULL
pointer dereference at 00000000000001f0'.

Is there anything I can do to get this in a working state again or
perhaps even recover some data?

Thanks much for any help

[1]: https://www.moparisthebest.com/btrfs/initial_crash.txt
[2]: https://www.moparisthebest.com/btrfs/btrfsfishow.txt
[3]: https://www.moparisthebest.com/btrfs/btrfsdf.txt
[4]: https://www.moparisthebest.com/btrfsoops.jpg
[5]: https://www.moparisthebest.com/btrfs/dmsgprecrash.txt
[6]: https://www.moparisthebest.com/btrfsnulldereference.jpg
