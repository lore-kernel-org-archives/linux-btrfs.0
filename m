Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47841 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2G1NlT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jul 2012 09:41:19 -0400
Received: by wgbdr13 with SMTP id dr13so3559085wgb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jul 2012 06:41:18 -0700 (PDT)
From: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
To: btrfs <linux-btrfs@vger.kernel.org>
Subject: No SysRq remount because sb->s_bdev is NULL
Date: Sat, 28 Jul 2012 15:41:16 +0200
Message-ID: <1389197.DvrDHJORPI@nezir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

During a SysRq emergency remount Btrfs mounts are not remounted. I tracked the 
issue down to this line in do_emergency_remount() in fs/super.c:
if (sb->s_root && sb->s_bdev && (sb->s_flags & MS_BORN) &&
	!(sb->s_flags & MS_RDONLY))
s_bdev is NULL for Btrfs super blocks and subsequently do_remount_sb() is 
never called. I couldn't think of a solution, besides resorting to an ugly 
strcmp(sb->s_type->name, "btrfs"), without adding a field to struct super_block 
or similar changes.
Thoughts?

    Flo
