Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59657 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753930AbdHUPwm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 11:52:42 -0400
Date: Mon, 21 Aug 2017 17:51:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove unnecessary skip_sum
Message-ID: <20170821155118.GM2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818175804.29677-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818175804.29677-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 11:58:04AM -0600, Liu Bo wrote:
> Now that we can get inode from dip->inode, it's not necessary to pass
> skip_sum from callers.

Already there, https://patchwork.kernel.org/patch/9879029/
