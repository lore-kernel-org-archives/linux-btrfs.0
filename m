Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36175 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaKKN3E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 08:29:04 -0500
Received: by mail-wi0-f170.google.com with SMTP id r20so1773049wiv.5
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Nov 2014 05:29:03 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 11 Nov 2014 22:29:03 +0900
Message-ID: <CAGC3nLBAruRcurhu8sd6NtP6mHFaFw_eunwhqq7xuqsiQ6Mmog@mail.gmail.com>
Subject: Is it safe to refactor struct btrfs_root *root out of these functions?
From: Daniel Dressler <danieru.dressler@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I'm gearing up to tackle the "Pass fs_info instead of root " project
suggested on the wiki.

I've read through the entire codebase and made note of 102 functions
which could be refactored. Three of these do not make any use of their
root argument at all, is it safe to refactor these as well?

Namely:
btrfs_block_rsv_check :
http://lxr.free-electrons.com/source/fs/btrfs/extent-tree.c#L4743
copy_to_sk : http://lxr.free-electrons.com/source/fs/btrfs/ioctl.c#L1931
wait_for_commit :
http://lxr.free-electrons.com/source/fs/btrfs/transaction.c#L597

None of these function's users make indirect calls through function
pointers. Is it safe to refactor them? I ask because it seems strange
they would have unused arguments and I'm worried there might be a
reason I've missed.

Daniel
