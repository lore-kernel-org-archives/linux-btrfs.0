Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:49535 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928Ab2IRMkz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 08:40:55 -0400
Date: Tue, 18 Sep 2012 14:40:29 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: fix the missing error information in
 create_pending_snapshot()
Message-ID: <20120918124028.GB17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50580C26.5030803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50580C26.5030803@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2012 at 01:52:38PM +0800, Miao Xie wrote:
> The macro btrfs_abort_transaction() can get the line number of the code
> where the problem happens, so we should invoke it in the place that the
> error occurs, or we will lose the line number.

Thanks, that's it! AFAICS it's based on

  [PATCH V4 01/12] Btrfs: fix error path in create_pending_snapshot()

so I'll base my patch on top of these two.

david
