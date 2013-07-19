Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51536 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761094Ab3GSTRn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jul 2013 15:17:43 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 03D897C035B
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jul 2013 13:17:43 -0600 (MDT)
Date: Fri, 19 Jul 2013 15:17:40 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] btrfs update
Message-ID: <20130719191740.GA2255@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm playing the role of Chris Mason this week while he's on vacation.  There are
a few critical fixes for btrfs here, all regressions and have been tested well.
Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git for-linus

I've based it off a recent pull of your tree, hopefully that's the right thing.
Thanks,

Josef Bacik (3):
      Btrfs: update drop progress before stopping snapshot dropping
      Btrfs: fix lock leak when resuming snapshot deletion
      Btrfs: re-add root to dead root list if we stop dropping it

Stefan Behrens (1):
      Btrfs: fix wrong write offset when replacing a device

 fs/btrfs/extent-tree.c |   27 +++++++++++++++++++++------
 fs/btrfs/scrub.c       |    2 +-
 2 files changed, 22 insertions(+), 7 deletions(-)
