Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34240 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3CCMcw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 07:32:52 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id D2E559A069B
	for <linux-btrfs@vger.kernel.org>; Sun,  3 Mar 2013 05:32:51 -0700 (MST)
Date: Sun, 3 Mar 2013 07:32:49 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [GIT PULL] Btrfs fixup
Message-ID: <20130303123249.GB18135@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Geert and James both sent this one in, sorry guys.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Geert Uytterhoeven (1) commits (+1/-0):
    btrfs/raid56: Add missing #include <linux/vmalloc.h>

Total: (1) commits (+1/-0)

 fs/btrfs/raid56.c | 1 +
 1 file changed, 1 insertion(+)
