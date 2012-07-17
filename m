Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:59384 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2GQOLE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 10:11:04 -0400
Date: Tue, 17 Jul 2012 11:24:11 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: rename nodiscard option to K
Message-ID: <20120717092411.GA21792@mother.jarsat.pl>
References: <1342516457-20104-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1342516457-20104-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 17, 2012 at 11:14:17AM +0200, David Sterba wrote:
> The original patch named the option -T, mkfs.xfs uses -K let's keep it
> same.

  mkfs.ext2 used to have "-K" also, so one more +1 for this patch.

-- 
Tomasz Torcz                Only gods can safely risk perfection,
xmpp: zdzichubg@chrome.pl     it's a dangerous thing for a man.  -- Alia

