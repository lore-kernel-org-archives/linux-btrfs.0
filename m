Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751607AbdAWRMM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 12:12:12 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C2C17AB49
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jan 2017 17:12:09 +0000 (UTC)
Date: Mon, 23 Jan 2017 18:11:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs-progs: sanitize - Use correct source for memcpy
Message-ID: <20170123171152.GN11951@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170120190333.17737-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170120190333.17737-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 20, 2017 at 01:03:33PM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> While performing a memcpy, we are copying from uninitialized dst
> as opposed to src->data. Though using eb->len is correct, I used
> src->len to make it more readable.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Applied, thanks.
