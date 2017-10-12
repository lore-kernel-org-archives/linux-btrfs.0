Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37331 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751757AbdJLC1D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 22:27:03 -0400
Message-Id: <1507775222.470249.1135998984.4D5929F4@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
References: <1507456690.745489.1131538472.25270157@webmail.messagingengine.com>
 <87o9pf7o3g.wl-satoru.takeuchi@gmail.com>
 <1507695493.605704.1134784560.530EF386@webmail.messagingengine.com>
Date: Thu, 12 Oct 2017 10:27:02 +0800
Subject: Re: USB upgrade fun
In-Reply-To: <1507695493.605704.1134784560.530EF386@webmail.messagingengine.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A guy on #btrsfs suggests:

15:09 <multicore> hendry: super_total_bytes 8001581707264 mismatch with
fs_devices total_rw_bytes 8001581710848 that one is because unaligned
partitions, 4.12 - 4.13 kernels are affected (at least some versions)


However I rebooted into 4.9.54-1-lts and I have the same issue.
super_total_bytes 8001581707264 mismatch with fs_devices total_rw_bytes
8001581710848

https://s.natalian.org/2017-10-12/1507775104_2548x1398.png

Any ideas what I can do now? I am getting rather nervous!

Btw I checked sudo btrfs check -p /dev/sd{b,c,d}1 and they are all fine.

Just can't mount my data! :(

Hope you can help me,
