Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbaKUPzW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 10:55:22 -0500
Date: Fri, 21 Nov 2014 16:55:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: ctree: reduce args where only fs_info used
Message-ID: <20141121155519.GB8568@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <danieru.dressler@gmail.com>
 <1415767389-29722-1-git-send-email-danieru.dressler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415767389-29722-1-git-send-email-danieru.dressler@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 12, 2014 at 01:43:09PM +0900, Daniel Dressler wrote:
> This patch is part of a larger project to cleanup
> btrfs's internal usage of struct btrfs_root. Many
> functions take btrfs_root only to grab a pointer
> to fs_info.

Thanks for picking up the project.

A mere formality, can you please justify the paragraphs to 74 chars?

--
This patch is part of a larger project to cleanup btrfs's internal usage
of struct btrfs_root. Many functions take btrfs_root only to grab a
pointer to fs_info.
--

> This patch does not address the two functions in
> ctree.c (insert_ptr, and split_item) which only
> use root for BUG_ONs in ctree.c
> 
> This patch affects the following functions:
>   1) fixup_low_keys
>   2) btrfs_set_item_key_safe

Please send one patch per function change, unless there are more that
are somehow entangled that it would make it hard to separate.
