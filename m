Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:33048 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaEHOWO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 10:22:14 -0400
Received: by mail-yk0-f172.google.com with SMTP id 79so2184043ykr.3
        for <linux-btrfs@vger.kernel.org>; Thu, 08 May 2014 07:22:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACHxQ2tAU15z_pUEGBuGqYFR9n_fH9BeyA8=jYryRrb3H=zCYA@mail.gmail.com>
References: <CACHxQ2tAU15z_pUEGBuGqYFR9n_fH9BeyA8=jYryRrb3H=zCYA@mail.gmail.com>
Date: Thu, 8 May 2014 16:22:13 +0200
Message-ID: <CACHxQ2sQH96Z==zqEaoEoOxc65k9TYD66yLXQzOYL1kxaPcrqw@mail.gmail.com>
Subject: Fwd: [suggestion] Add verbose notification about inode-cache rebuild
 to kernel log
From: =?UTF-8?B?VG9tw6HFoSBQcnXFvmluYQ==?= <pruzinat@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good day,
I ran into some troubles with inode-cache rebuilding on root fs after
filesystem was mounted without inode_cache, which stalls boot of my
box by several minutes.

I boot from commandline like:
root=/dev/sda4 rootfstype=btrfs
rootflags=inode_cache,space_cache,autodefrag rw ...

However when I manually remount root fs without inode_cache (for
example via kexec), it triggers cache rebuild at next mount which
takes several tens of minutes and mimick 'freeze' on boot.

Would it be possible to put some printk saying that this is happening
so users don't get confused about it??

Thanks.
