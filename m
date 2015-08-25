Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbbHYRMN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 13:12:13 -0400
Date: Tue, 25 Aug 2015 19:11:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: unified error handle for
 print_replace_status
Message-ID: <20150825171137.GP10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8ecb18af6cff4e7f413bfeee8d66aa61dc1aa151.1440514191.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8ecb18af6cff4e7f413bfeee8d66aa61dc1aa151.1440514191.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 10:50:08PM +0800, Zhao Lei wrote:
> Current code of print_replace_status() mixed stdout and stderr in
> error case, output a error string to stderr without "\n", then
> output "\n" to stdout to end the line.
> 
> This patch fixed above problem by using unified error handle way for 3
> type of errors in print_replace_status().
> 
> Also include some small logic cleanup.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks. I've slighly reworded the error message.
