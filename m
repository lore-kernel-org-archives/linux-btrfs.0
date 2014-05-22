Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50095 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaEVJJZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 05:09:25 -0400
Received: from p10053-ipngn5802marunouchi.tokyo.ocn.ne.jp ([153.163.201.53]:16094 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WnP08-000331-PF by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 02:09:25 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WnP06-0003DC-B8
	for linux-btrfs@vger.kernel.org; Thu, 22 May 2014 02:09:22 -0700
Date: Thu, 22 May 2014 02:09:21 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.15.0-rc5: btrfs and sync deadlock: call_rwsem_down_read_failed
Message-ID: <20140522090921.GA12037@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got m laptop to hang all IO to one of its devices again, this time
drive #2.
This is the 3rd time it happens, and I've already lost data as a result
since things that haven't hit disk, don't make it at this point.

I was doing balance and btrfs send/receive.
Then cron started a scrub in the background too.

IO to drive #1 was working fine, I didn't even notice that drive #2 IO
was hung.

And then I typed sync and it never returned.

legolas:~# ps -eo pid,user,args,wchan  | grep  sync
23605 root     sync                        call_rwsem_down_read_failed
31885 root     sync                        call_rwsem_down_read_failed

What does this mean when sync is stuck that way?

When I'm in that state, accessing btrfs on drive 1 still works (read and
write).
Any access on drive 2 through btrfs hangs

Both block devices still work.
legolas:~# dd if=/dev/sda of=/dev/null bs=1M 
2593128448 bytes (2.6 GB) copied, 6.47656 s, 400 MB/s

legolas:~# dd if=/dev/sdb of=/dev/null bs=1M 
148897792 bytes (149 MB) copied, 7.99576 s, 18.6 MB/s

So at least it shows that I don't have a hardware problem, right?

After reboot, most of the data to disk1 made it, so at least sync worked
there.

How can I confirm that it is btrfs deadlocking and not something else in
the kernel?
 
The state of btrfs is:
legolas:~# ps -eo pid,user,args,wchan  | grep  btrfs
  527 root     [btrfs-worker]              rescuer_thread
  528 root     [btrfs-worker-hi]           rescuer_thread
  529 root     [btrfs-delalloc]            rescuer_thread
  530 root     [btrfs-flush_del]           rescuer_thread
  531 root     [btrfs-cache]               rescuer_thread
  532 root     [btrfs-submit]              rescuer_thread
  533 root     [btrfs-fixup]               rescuer_thread
  534 root     [btrfs-endio]               rescuer_thread
  535 root     [btrfs-endio-met]           rescuer_thread
  536 root     [btrfs-endio-met]           rescuer_thread
  537 root     [btrfs-endio-rai]           rescuer_thread
  538 root     [btrfs-rmw]                 rescuer_thread
  539 root     [btrfs-endio-wri]           rescuer_thread
  540 root     [btrfs-freespace]           rescuer_thread
  541 root     [btrfs-delayed-m]           rescuer_thread
  542 root     [btrfs-readahead]           rescuer_thread
  543 root     [btrfs-qgroup-re]           rescuer_thread
  544 root     [btrfs-cleaner]             cleaner_kthread
  545 root     [btrfs-transacti]           transaction_kthread
 2111 root     [btrfs-worker]              rescuer_thread
 2112 root     [btrfs-worker-hi]           rescuer_thread
 2113 root     [btrfs-delalloc]            rescuer_thread
 2114 root     [btrfs-flush_del]           rescuer_thread
 2115 root     [btrfs-cache]               rescuer_thread
 2116 root     [btrfs-submit]              rescuer_thread
 2117 root     [btrfs-fixup]               rescuer_thread
 2119 root     [btrfs-endio]               rescuer_thread
 2120 root     [btrfs-endio-met]           rescuer_thread
 2121 root     [btrfs-endio-met]           rescuer_thread
 2122 root     [btrfs-endio-rai]           rescuer_thread
 2123 root     [btrfs-rmw]                 rescuer_thread
 2124 root     [btrfs-endio-wri]           rescuer_thread
 2125 root     [btrfs-freespace]           rescuer_thread
 2126 root     [btrfs-delayed-m]           rescuer_thread
 2127 root     [btrfs-readahead]           rescuer_thread
 2128 root     [btrfs-qgroup-re]           rescuer_thread
 3205 root     [btrfs-cleaner]             cleaner_kthread
 3206 root     [btrfs-transacti]           transaction_kthread
19156 root     gvim /etc/cron.d/btrfs_back poll_schedule_timeout
19729 root     btrfs send var_ro.20140521_ pipe_wait
19730 root     btrfs receive /mnt/btrfs_po sleep_on_page
19824 root     btrfs balance start -dusage btrfs_wait_and_free_delalloc_work
24611 root     /bin/sh -c cd /mnt/btrfs_po wait
24619 root     btrfs subvolume snapshot /m btrfs_start_delalloc_inodes
32044 root     /sbin/btrfs scrub start -Bd futex_wait_queue_me

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
