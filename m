Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:24925 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2JSFOE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 01:14:04 -0400
Message-ID: <5080E18F.2080101@jan-o-sch.net>
Date: Fri, 19 Oct 2012 07:13:51 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: MOD_LOG_KEY_REMOVE_WHILE_MOVING never change node's
 nritems
References: <1350545573-2544-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1350545573-2544-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, October 18, 2012 at 09:32 (+0200), Liu Bo wrote:
> Key MOD_LOG_KEY_REMOVE_WHILE_MOVING means that we're doing memmove inside
> an extent buffer node, and the node's number of items remains unchanged,
> so we don't need to increment node's number of items during rewinding,
> otherwise we may get an node larger than leafsize and cause general protection
> errors later.

This patch triggers the following bug on when running fsmark on a quota enabled
file system:

1153                 case MOD_LOG_KEY_REPLACE:
1154                         BUG_ON(tm->slot >= n);

MOD_LOG_KEY_REMOVE_WHILE_MOVING elements are added by tree_mod_log_insert_move
when dst_slot < src_slot, thus we're reducing the number of elements in the
buffer, thus replaying adds those elements.

-Jan
