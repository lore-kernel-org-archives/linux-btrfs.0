Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57743 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965000AbdIZL3H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 07:29:07 -0400
Date: Tue, 26 Sep 2017 13:27:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Resolve memory-leak in btrfs qgroup show
 when quota disabled
Message-ID: <20170926112732.GP31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506418111-26620-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506418111-26620-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 26, 2017 at 05:28:31PM +0800, Gu Jinxiang wrote:
> When quota disabled, btrfs qgroup show exit with a error message,
> but the allocated memory is not freed.
> 
> By the way, this bug marked as issue#20 in github.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Applied, thanks.
