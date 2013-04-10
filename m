Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934984Ab3DJPBM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 11:01:12 -0400
Date: Wed, 10 Apr 2013 17:01:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org, wangsl-fnst@cn.fujitsu.com,
        list.btrfs@jan-o-sch.net
Subject: Re: [PATCH 2/2] Btrfs: make some functions return type be void in
 backref.c
Message-ID: <20130410150110.GM18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365592971-1535-1-git-send-email-wangshilong1991@gmail.com>
 <1365592971-1535-3-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365592971-1535-3-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 10, 2013 at 07:22:51PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> __merge_refs() and __add_missing_keys() always return 0, it is unnecessary
> for the caller to check the return value.

ok for __merge_refs, nak for __add_missing_keys: there's unhandled
BUG_ON from read_tree_block

 422                 eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
 423                                      fs_info->tree_root->leafsize, 0);
 424                 BUG_ON(!eb);

this should become a proper error handling someday and use the int return
value. Keep the callers aware of that.

david
