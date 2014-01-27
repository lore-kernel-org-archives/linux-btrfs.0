Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbaA0Qab (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 11:30:31 -0500
Date: Mon, 27 Jan 2014 17:30:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Btrfs: do not export ulist functions
Message-ID: <20140127163029.GW6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390816789-3901-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1390816789-3901-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390816789-3901-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 27, 2014 at 05:59:48PM +0800, Wang Shilong wrote:
> There are not any users that use ulist except Btrfs,don't
> export them.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Agreed,
Reviewed-by: David Sterba <dsterba@suse.cz>
