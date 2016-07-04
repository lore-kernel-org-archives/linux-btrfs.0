Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbcGDON6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 10:13:58 -0400
Date: Mon, 4 Jul 2016 16:14:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] btrfs-progs: btrfsck: write corrected qgroup info to
 disk
Message-ID: <20160704141422.GI13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466195869-28109-1-git-send-email-mfasheh@suse.de>
 <1466195869-28109-3-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466195869-28109-3-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 17, 2016 at 01:37:49PM -0700, Mark Fasheh wrote:
> Now that we can verify all qgroups, we can write the corrected qgroups out
> to disk when '--repair' is specified. The qgroup status item is also updated
> to clear any out-of-date state. The repair_ functions were modeled after the
> inode repair code in cmds-check.c.
> 
> I also renamed the 'scan' member of qgroup_status_item to 'rescan' in order
> to keep consistency with the kernel.
> 
> Testing this was easy, I just reproduced qgroup inconsistencies via the
> usual routes and had btrfsck fix them.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Applied. I've factored out the 'repair' related code.
