Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753914AbeGEQEs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 12:04:48 -0400
Date: Thu, 5 Jul 2018 18:04:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print bytenr of tree block in
 print_tree_block_error()
Message-ID: <20180705160443.GL3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180614024039.18229-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180614024039.18229-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 14, 2018 at 10:40:39AM +0800, Su Yue wrote:
> For easier debug, let print_tree_block_error() print bytenr of
> tree block.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Applied, thanks.
