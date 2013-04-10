Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935235Ab3DJOwf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 10:52:35 -0400
Date: Wed, 10 Apr 2013 16:52:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org, wangsl-fnst@cn.fujitsu.com,
        list.btrfs@jan-o-sch.net
Subject: Re: [PATCH 1/2] Btrfs: remove some BUG_ONs() when walking backref
 tree
Message-ID: <20130410145233.GL18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365592971-1535-1-git-send-email-wangshilong1991@gmail.com>
 <1365592971-1535-2-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365592971-1535-2-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 10, 2013 at 07:22:50PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> The only error return value of __add_prelim_ref() is -ENOMEM,
> just return errors rather than trigger BUG_ON().
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
