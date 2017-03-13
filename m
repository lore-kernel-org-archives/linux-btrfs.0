Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33911 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750925AbdCMR4P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 13:56:15 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5CF75AB5D
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 17:56:13 +0000 (UTC)
Date: Mon, 13 Mar 2017 18:55:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] qgroup: Change qgroup_meta_rsv to 64bit
Message-ID: <20170313175537.GS14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170311230326.12308-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170311230326.12308-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 11, 2017 at 05:03:26PM -0600, Goldwyn Rodrigues wrote:
> -	int reserved;
> +	long reserved;

> -	reserved = atomic_xchg(&root->qgroup_meta_rsv, 0);
> +	reserved = atomic64_xchg(&root->qgroup_meta_rsv, 0);

atomic64_xchg returns 'long long' so u64 should be used.
