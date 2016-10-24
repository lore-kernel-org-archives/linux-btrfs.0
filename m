Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45239 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758054AbcJXQqr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 12:46:47 -0400
Date: Mon, 24 Oct 2016 18:46:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: imporve delayed refs iterations
Message-ID: <20161024164639.GE22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161021090507.28425-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161021090507.28425-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 21, 2016 at 05:05:07PM +0800, Wang Xiaoguang wrote:
> This issue was found when I tried to delete a heavily reflinked file,
> when deleting such files, other transaction operation will not have a
> chance to make progress, for example, start_transaction() will blocked
> in wait_current_trans(root) for long time, sometimes it even triggers
> soft lockups, and the time taken to delete such heavily reflinked file
> is also very large, often hundreds of seconds. Using perf top, it reports
> that:

> [...] With this patch, it just took about 10~15 seconds to
> delte the same file.

Great improvement! Patch looks good on a quick skim so I'll add it to
next, but proper review is still required.
