Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbbJUMR3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 08:17:29 -0400
Date: Wed, 21 Oct 2015 14:16:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix a typo which causes super_copy corrupted
Message-ID: <20151021121608.GG13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1445307644-28147-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445307644-28147-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 20, 2015 at 10:20:44AM +0800, Qu Wenruo wrote:
> In btrfs_read_dev_super(), a wrong parameter for memcpy will copy wrong
> address of a stack pointer to super_copy.
> Which will cause a lot of unpredictable error.
> 
> What a stupid typo from myself!!!!!
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks.  I'd rather fold the change to the original patch as it seems to
break a few things. This would make any future bisecting hard, failing
tests etc. I'm glad you found it quickly.
