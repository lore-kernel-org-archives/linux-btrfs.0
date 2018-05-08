Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46951 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752824AbeEHRh3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 13:37:29 -0400
Date: Tue, 8 May 2018 19:34:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, osandov@fb.com
Subject: Re: [PATCH] btrfs-progs: Use exclude_super_stripes instead of
 account_super_bytes
Message-ID: <20180508173450.GN6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525261974-844-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525261974-844-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 02, 2018 at 02:52:54PM +0300, Nikolay Borisov wrote:
> Originally commit 2681e00f00fe ("btrfs-progs: check for matchingi
> free space in cache") added the account_super_bytes function to prevent
> false negative when running btrfs check. Turns out this function is
> really copied exclude_super_stripes, excluding the calls to
> exclude_super_stripes. Later commit e4797df6a9fa ("btrfs-progs: check
> the free space tree in btrfsck") introduced proper version of
> exclude_super_stripes. Instead of duplicating the function, just remove
> account_super_bytes and use exclude_super_stripes instead of the former.
> This also has the benefit of bringing the userspace code a bit closer
> to the kernel counterpart.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.
