Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756010AbeDZNLJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 09:11:09 -0400
Date: Thu, 26 Apr 2018 15:08:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove unused fs_info parameter
Message-ID: <20180426130834.GT21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524728942-14403-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524728942-14403-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2018 at 03:49:02PM +0800, Gu Jinxiang wrote:
> Since the commit below parameter fs_info in alloc_reloc_control
> be no used. So remove it.
> commit c6100a4b4e3d ("Btrfs: replace tree->mapping with
> tree->private_data")
> 
> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>

Added to next, thanks.
