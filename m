Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:37092 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3DJI4A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 04:56:00 -0400
Message-ID: <5165291C.7050704@jan-o-sch.net>
Date: Wed, 10 Apr 2013 10:55:56 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/ctree.c:1144!
References: <CAFDW0j+XvnX4ZmP2Y=wpLen+pezAXxPL+ubigRfD-Yt_a=5c=g@mail.gmail.com>
In-Reply-To: <CAFDW0j+XvnX4ZmP2Y=wpLen+pezAXxPL+ubigRfD-Yt_a=5c=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Wed, April 10, 2013 at 09:58 (+0200), Ahmet Inan wrote:
> I got this problem since 3.8.5 + for-linus (from that time).
> Have just tried 3.8.6 + for-linus with "git merge -X theirs
> btrfs/for-linus" but still same problem.
> Going back to 3.7.4 + for-linus (from that time) doesn't give me the problem.

The stack you attached shows a function added in the snapshot aware defrag
patches (commit 38c227d8), added in 3.8.

The real problem, however, is not caused by that commit but by a tree mod log
bug. I expect that fs/btrfs/ctree.c:1144 is this BUG_ON in your kernel from
__tree_mod_log_rewind (my line numbers don't match):

1138                 switch (tm->op) {
1139                 case MOD_LOG_KEY_REMOVE_WHILE_FREEING:
1140                         BUG_ON(tm->slot < n);

I've got a fix for that I'm currently testing, expect it on the list soon.

> This is an production nfs server with 2x2TB raid1, so cant reboot it that often.
> Have seen this same problem on another system (also raid1) once, but
> rebooting helped, no problems since.
> Both systems use autodefrag, maybe that sometimes triggers it?
> I really would like to help, so i can stay on the latest kernels.
> What should i do?

For the meantime I recommend to not defrag your filesystem.

As a general remark, please send your stack traces inline, not as attachment if
possible.

Thanks,
-Jan
