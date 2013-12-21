Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61334 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab3LUI4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Dec 2013 03:56:11 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so3585069pbc.29
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Dec 2013 00:56:11 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 2/3] Btrfs: rework qgroup accounting
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1387400849-7274-3-git-send-email-jbacik@fb.com>
Date: Sat, 21 Dec 2013 16:56:06 +0800
Cc: <linux-btrfs@vger.kernel.org>
Message-Id: <A4C427B3-2FE2-4032-A085-77117A678B0F@gmail.com>
References: <1387400849-7274-1-git-send-email-jbacik@fb.com> <1387400849-7274-3-git-send-email-jbacik@fb.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

Though i know there are still problems related to qgroup(for example removing snapshot
will beak qgroup accounting).I did a simple test about your patch..


# btrfs quota enable /mnt
# dd if=/dev/zero of=/mnt/data bs=4k count=102400 oflag=direct
# btrfs sub snapshot /mnt/ /mnt/snap1
# btrfs sub snapshot /mnt /mnt/snap2
# btrfs sub delete /mnt/snap1 /mnt/snap2
# sync
# rm -rf /mnt/data
# sync
# dmesg
# btrfs qgroup show /mnt


Firstly, qgroup accounting is wrong, this is maybe expected because efficient  fs tree removal.
However, from dmesg, i get the  WARNING:

WARNING: CPU: 1 PID: 2650 at fs/btrfs/qgroup.c:1486 btrfs_delayed_qgroup_accounting

I did not take a deep look at codes, but i think you will be interested in taking a look at this. ^_^


Thanks,
Wang