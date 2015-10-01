Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbbJAQrp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 12:47:45 -0400
Date: Thu, 1 Oct 2015 18:46:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, stephane_btrfs@lesimple.fr
Subject: Re: [PATCH 1/2] btrfs: Add support to do stack item key operation
Message-ID: <20151001164643.GH5885@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1443148681-3015-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1443148681-3015-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443148681-3015-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2015 at 10:38:00AM +0800, Qu Wenruo wrote:
> +static inline void btrfs_stack_item_key(char *stack_leaf,
> +					struct btrfs_disk_key *disk_key,
> +					int nr)

> +static inline void btrfs_stack_item_key_to_cpu(char *stack_leaf,
> +					       struct btrfs_key *key,
> +					       int nr)

The functions do not follow the pattern of btrfs_stack_* , also passing
'char *' is not right, it should be 'struct extent_buffer *'.

IOW the manually created structure accessors must match the prototypes
that would result from BTRFS_STACK_FUNCS and BTRFS_SETGET_STACK_FUNCS.
