Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34169 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaHJD6i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Aug 2014 23:58:38 -0400
Received: by mail-pd0-f172.google.com with SMTP id y13so3065618pdi.3
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Aug 2014 20:58:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev>
	<20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
	<CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com>
Date: Sat, 9 Aug 2014 22:58:37 -0500
Message-ID: <CAETJ_S8DT=yW6V8bmAJ5s-+ZbuLjnDUK_XWEFRwK_p8hoR+LWA@mail.gmail.com>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
From: Jose Ildefonso Camargo Tolosa <ildefonso.camargo@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And it is still going.... although the hung task message stopped long
ago (behavior similar to 3.15), it hasn't finished mounting, mount is
still taking 100% CPU, *and* I can't see any disk activity at all.
Last hung task message:

[21131.749759] INFO: task btrfs-transacti:7353 blocked for more than
120 seconds.
[21131.828755]       Not tainted 3.14.16-031416-generic #201408072035
[21131.868788] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[21131.947525] btrfs-transacti D ffffffff818118e0     0  7353      2 0x00000000
[21131.947530]  ffff880450afddc8 0000000000000002 ffff880450afdd68
ffff880450afdfd8
[21131.947535]  0000000000014500 0000000000014500 ffff88046985e380
ffff8804602018e0
[21131.947540]  ffff880450afddd8 ffff8808642fc000 ffff8802aa5b8800
ffff880450afde00
[21131.947544] Call Trace:
[21131.947551]  [<ffffffff8175b0c9>] schedule+0x29/0x70
[21131.947577]  [<ffffffffa01040ed>]
btrfs_commit_transaction+0x25d/0xa00 [btrfs]
[21131.947581]  [<ffffffff810b4e10>] ? __wake_up_sync+0x20/0x20
[21131.947591]  [<ffffffffa0101e45>] transaction_kthread+0x1d5/0x250 [btrfs]
[21131.947601]  [<ffffffffa0101c70>] ? open_ctree+0x20d0/0x20d0 [btrfs]
[21131.947604]  [<ffffffff8108fd89>] kthread+0xc9/0xe0
[21131.947606]  [<ffffffff8108fcc0>] ? flush_kthread_worker+0xb0/0xb0
[21131.947610]  [<ffffffff817681bc>] ret_from_fork+0x7c/0xb0
[21131.947612]  [<ffffffff8108fcc0>] ? flush_kthread_worker+0xb0/0xb0

Do you think I will have better luck with 3.16? or maybe it is that
this filesystem has so many errors (remember the btrfs check output)
that it will take a really long time to mount because it is trying to
correct this?

Thanks!

Ildefonso
