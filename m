Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55991 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932231AbcIFPJq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Sep 2016 11:09:46 -0400
Date: Tue, 6 Sep 2016 17:08:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 02/13] btrfs-progs: check: introduce function to find
 dir_item
Message-ID: <20160906150813.GB16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <1469689705-26836-3-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469689705-26836-3-git-send-email-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 03:08:14PM +0800, Lu Fengqi wrote:
> +static int find_dir_item(struct btrfs_root *root, struct btrfs_key *ref_key,
> +			 struct btrfs_key *key, u64 index, char *name,
> +			 u32 namelen, u32 mode)
> +{
> +	struct btrfs_path *path;
> +	struct extent_buffer *node;
> +	struct btrfs_dir_item *di;
> +	struct btrfs_key location;
> +	char namebuf[BTRFS_NAME_LEN] = {0};
> +	u32 total;
> +	u32 cur = 0;
> +	u32 len;
> +	u32 name_len;
> +	u32 data_len;
> +	u8 filetype;
> +	int slot;
> +	int ret;
> +
> +	path = btrfs_alloc_path();

Unhandled error (and there's one more in check_root_ref). Also, the
function can return negative values, but the caller does not propagate
the falue as it rather expects the bitmask of the specific errors.

Fixing that seems to be more intrusive, as the whole callchain does not
expect that consistently.

Please fix that and resend the whole patchset.
