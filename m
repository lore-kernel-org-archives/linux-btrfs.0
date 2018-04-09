Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44385 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751662AbeDIN2J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 09:28:09 -0400
Date: Mon, 9 Apr 2018 15:25:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: let mkfs return nozero value on thin
 provision device
Message-ID: <20180409132538.GM8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180403083945.13485-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180403083945.13485-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2018 at 04:39:45PM +0800, Su Yue wrote:
> when mkfs.btrfs on a thin provision device which has very small
> backing size and big virtual size, all code works well in
> mkfs.btrfs until close_ctree() is called.
> close_ctree() fails to sync device due to small backing size
> while closing devices.
> However, mkfs returns 0 in such situation which causes failure of
> xfstests generic/405.
> 
> So, let mkfs returns nonzero value if previous steps succeeded but
> close_ctree() failed.
> Then xfstests generic/405 passes now.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Applied, thanks. Can you please write a test for that?
