Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:34462 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbbCPSAa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 14:00:30 -0400
Received: by ykfc206 with SMTP id c206so14562106ykf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2015 11:00:30 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 16 Mar 2015 12:00:29 -0600
Message-ID: <CAJCQCtT1dpNFj2HiV6-V3u_2SHkjbRhj=VvnRQNA==Mi19NUbQ@mail.gmail.com>
Subject: What are parents? 'print parent ID' always matches top level
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm confused by the use of parent in this context. Do we have more
than one kind of "parent"?

Example below shows four subvolumes (not snapshots), and the last one
is a snapshot of the first.

# btrfs sub list -p /mnt
ID 257 gen 1414 parent 5 top level 5 path root
ID 258 gen 1351 parent 5 top level 5 path home
ID 259 gen 139 parent 5 top level 5 path boot
ID 262 gen 1407 parent 257 top level 257 path root/var/lib/machines
ID 264 gen 1413 parent 5 top level 5 path rootsnap


If this "parent" has anything to do with snapshots, I'd expect the
last line to read:
ID 264 gen 1413 parent 257 top level 5 path rootsnap


And for that matter I don't know what I expect for the fourth line:
ID 262 gen 1407 parent ? top level 257 path root/var/lib/machines

It has no parent, none of the non-snapshot subvolumes do. I don't
think it's OK to repurpose "parent" if it has two contextual meanings.


Chris Murphy
