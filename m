Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbaBTROd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 12:14:33 -0500
Date: Thu, 20 Feb 2014 18:14:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] Btrfs-progs: new helper to parse string to u64
 for btrfs
Message-ID: <20140220171431.GU16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1392863391-20492-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392863391-20492-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 20, 2014 at 10:29:51AM +0800, Wang Shilong wrote:
> There are many places that need parse string to u64 for btrfs commands,
> in fact, we do such things *too casually*, using atoi/atol/atoll..is not
> right at all, and even we don't check whether it is a valid string.
> 
> Let's do everything more gracefully, we introduce a new helper
> arg_strtou64() which will do all the necessary checks.If we fail to
> parse string to u64, we will output message and exit directly, this is
> something like what usage() is doing. It is ok to not return erro to
> it's caller, because this function should be called when parsing arg
> (just like usage!)
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

This version looks good to me, thanks.
