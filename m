Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40124 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752003AbeBHOON (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Feb 2018 09:14:13 -0500
Date: Thu, 8 Feb 2018 15:11:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs-progs: add prerequisite mkfs.btrfs for test-cli
Message-ID: <20180208141152.GD3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1518066538-16076-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518066538-16076-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 08, 2018 at 01:08:56PM +0800, Gu Jinxiang wrote:
> Since tests/cli-tests/002-balance-full-no-filters/test.sh need
> the mkfs.btrfs for prerequisite.
> So add the dependency in Makefile.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

1-3 applied, thanks.
