Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbbDBPTd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 11:19:33 -0400
Date: Thu, 2 Apr 2015 17:19:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: Doc: Add warning and note on
 btrfs-convert.
Message-ID: <20150402151931.GK6821@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427336364-18161-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427336364-18161-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 26, 2015 at 10:19:24AM +0800, Qu Wenruo wrote:
> +WARNING: To ensure *btrfs-convert* be able to rollback btrfs, one should never
> +execute *btrfs filesystem defragment* or *btrfs balance* command on the
> +converted btrfs.

So it looks like a fundamental problem, not lack of implementation. The
original filesystem has some correspondence between physical blocks (1:1
match in ext) and btrfs blocks (where the mapping is not 1:1, though
from the beginning physical matches logical).

Once we balance data, the chunks get moved and the original phyisical
offset is lost. We'd have to remember that somewhere and restore upon
rollback.

I don't see now why defrag is harmful to rollback. The defragmented data
are written to the "ext free space", ie. where all new modifications get
written. The old data are pinned by the ext2_saved subvolume and can be
restored. Or not?
