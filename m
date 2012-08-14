Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53766 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab2HNNFy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 09:05:54 -0400
Message-ID: <502A4BB2.6000404@gmail.com>
Date: Tue, 14 Aug 2012 14:59:30 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
MIME-Version: 1.0
To: liub.liubo@gmail.com
CC: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC] Btrfs: fix deadlock between sys_sync and freeze
References: <1344920474-10014-1-git-send-email-liub.liubo@gmail.com>
In-Reply-To: <1344920474-10014-1-git-send-email-liub.liubo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Il 14/08/2012 07:01, liub.liubo@gmail.com ha scritto:
> From: Liu Bo <bo.li.liu@oracle.com>
>
> I found this while testing xfstests 068, the story is
>
>      t1                                            t2
>    sys_sync                                    thaw_super
>      iterate_supers
>        down_read(sb->s_umount)                   down_write(sb->s_umount) --->wait for t1
>        sync_fs (with wait mode)
>          start_transaction
>            sb_start_intwrite --------------------> wait for t2 to set s_writers.frozen to SB_UNFROZEN
>
> In this patch, I add an helper sb_start_intwrite_trylock() and use it before we
> start_transaction in sync_fs() with wait mode so that we won't hit the deadlock.
>

IMHO, we should avoid to call the sync operation on a frozen fs. The 
freeze operation, indeed, already include a sync operation. According to 
man page, no other operation should modify the fs after the freeze. So 
for me the modification is inside sync_filesystem (and sync_one_sb).

Marco
