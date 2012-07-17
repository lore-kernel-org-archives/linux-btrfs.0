Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:39819 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab2GQNn6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 09:43:58 -0400
Date: Tue, 17 Jul 2012 15:43:42 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: kill root from btrfs_is_free_space_inode
Message-ID: <20120717134342.GF11226@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1341919719-13825-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1341919719-13825-2-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341919719-13825-2-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 10, 2012 at 07:28:39PM +0800, Liu Bo wrote:
> Since root can be fetched via BTRFS_I macro directly, we can save an args
> for btrfs_is_free_space_inode().

I see a great opportunity to rename the function :) It does not cover
just the free space inode anymore and it'll be more confusing with the
btree inode case.

I don't have a better name than btrfs_is_special_inode, but am not
completely satisfied.


david
