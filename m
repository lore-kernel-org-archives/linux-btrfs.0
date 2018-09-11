Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59214 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbeIKTrt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 15:47:49 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C5658ACE3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 14:48:10 +0000 (UTC)
Date: Tue, 11 Sep 2018 16:48:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Continue checking even we found something
 wrong in free space cache
Message-ID: <20180911144809.GB2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180904124128.22367-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180904124128.22367-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 04, 2018 at 08:41:28PM +0800, Qu Wenruo wrote:
> No need to abort checking, especially for RO check free space cache is
> meaningless, the errors in fs/extent tree is more interesting for
> developers.
> 
> So continue checking even something in free space cache is wrong.
> 
> Reported-by: Etienne Champetier <champetier.etienne@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  check/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/check/main.c b/check/main.c
> index b361cd7e26a0..4f720163221e 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -9885,7 +9885,6 @@ int cmd_check(int argc, char **argv)
>  			error("errors found in free space tree");
>  		else
>  			error("errors found in free space cache");

Please make it a warning and update the message so it says that it will
continue despite the errors found.

I noticed that error handling in check_space_cache is a bit fishy, some
errors are stored to 'ret' but ignored at the end of the function.
