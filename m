Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60207 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751039AbdIAPg3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 11:36:29 -0400
Date: Fri, 1 Sep 2017 17:35:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Move check of mixed block early.
Message-ID: <20170901153501.GT2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170725015744.12907-1-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170725015744.12907-1-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 25, 2017 at 09:57:44AM +0800, Gu Jinxiang wrote:
> Make the check of mixed block groups early.
> Reason:
> We do not support re-initing extent tree for mixed block groups.
> So it will return -EINVAL in function reinit_extent_tree.
> In this situation, we do not need to start transaction.
> We do not have a btrfs_abort_transaction like kernel now,
> so we should prevent starting transaction not necessary.

I've fixed the crash in another way, and started adding parts of the
transaction abort code. The check for mixed blockgroups IMO belongs
inside the function and not to cmd_check, as it's a lower level
implementation detail.
