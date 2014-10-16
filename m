Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPKzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Oct 2014 06:55:32 -0400
Date: Thu, 16 Oct 2014 12:55:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 4/4] btrfs-progs: fix csum root copy-n-paste error
Message-ID: <20141016105530.GB22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413414861-28097-1-git-send-email-zab@zabbo.net>
 <1413414861-28097-5-git-send-email-zab@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413414861-28097-5-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2014 at 04:14:21PM -0700, Zach Brown wrote:
> btrfs_setup_all_roots() had some copy and pasted code for trying to
> setup a root and then creating a blank node if that failed.  The copy
> for the csum_root created the blank node in the extent_root.

The cleanup is good, though I don't see the bug there. Although the passed root
is extent_root in both cases, it's only used to reach the
fs_info->extent_cache:

 131 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 132                                                  u64 bytenr, u32 blocksize)
 133 {
 134         return alloc_extent_buffer(&root->fs_info->extent_cache, bytenr,
 135                                    blocksize);
 136 }
