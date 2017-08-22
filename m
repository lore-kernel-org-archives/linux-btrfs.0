Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932510AbdHVOIm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 10:08:42 -0400
Date: Tue, 22 Aug 2017 16:07:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Make in-place exit to a common exit block
Message-ID: <20170822140717.GW2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503380106-44682-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503380106-44682-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 22, 2017 at 01:35:06PM +0800, Gu Jinxiang wrote:
> As comment pointed out by David, make in-place exit
> to a common exit block of mkfs.
> 
> v1:
> Add some close(fd) when error occures in mkfs.
> And add close(fd) when end use it.
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Applied, thanks.
