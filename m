Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008AbaCRSS5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 14:18:57 -0400
Date: Tue, 18 Mar 2014 19:18:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] Btrfs-progs: fsck: reduce memory usage of extent
 record struct
Message-ID: <20140318181854.GI29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1395144167-775-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1395144167-775-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 18, 2014 at 08:02:46PM +0800, Wang Shilong wrote:
> @@ -2742,7 +2742,10 @@ static int add_extent_rec(struct cache_tree *extent_cache,
> -	rec->found_rec = extent_rec;
> +	if (extent_rec)
> +		rec->found_rec = 1;
> +	else
> +		rec->found_rec = 0;

I've modified this to avoid 'if'

	rec->found_rec = !!extent_rec;

