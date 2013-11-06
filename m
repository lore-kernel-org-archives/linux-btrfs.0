Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18841 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab3KFBit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 20:38:49 -0500
Message-ID: <52799DED.8090209@cn.fujitsu.com>
Date: Wed, 06 Nov 2013 09:39:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/7] Btrfs: remove unnecessary initialization and memory
 barrior in shrink_delalloc()
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com> <1383578006-22691-2-git-send-email-miaox@cn.fujitsu.com> <20131105114516.GG16662@twin.jikos.cz>
In-Reply-To: <20131105114516.GG16662@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 5 Nov 2013 12:45:16 +0100, David Sterba wrote:
> On Mon, Nov 04, 2013 at 11:13:20PM +0800, Miao Xie wrote:
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.cz>
> 
> Would be nice to say why it's safe to remove the barrier. The percpu
> counters do not need it, they use a spinlock. The barrier was there due
> to access to fs_info->delalloc_bytes that was removed in commit
> 963d678b0f764930 that introduced the percpu counters.
> 

Right, I'll send a new one.

Thanks for you review.
Miao
